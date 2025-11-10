import 'package:divide_ai/components/group/select_members_group.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/card_input.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/transaction_request.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateTransactionScreen extends StatefulWidget {
  final int groupId;
  final int? transactionId; // NOVO: ID da transação se for edição

  const CreateTransactionScreen({
    super.key,
    required this.groupId,
    this.transactionId, // NOVO: Campo opcional
  });

  @override
  State<CreateTransactionScreen> createState() =>
      CreateTransactionScreenState();
}

class CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  Set<int> _selectedParticipantIndexes = {}; // Inicializado vazio para controle
  late final int _pageLoadStartTime;
  late List<User> _groupParticipants;
  late User _currentUser;

  // NOVOS ESTADOS
  bool _isEditing = false;
  bool _isLoadingData = false;
  Transaction? _currentTransaction;

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;

    _isEditing = widget.transactionId != null;

    _initializeGroupParticipants();

    if (_isEditing) {
      _loadTransactionData(); // CARREGA DADOS SE FOR EDIÇÃO
    } else {
      // Configurações padrão para criação: o usuário principal é o primeiro selecionado
      _selectedParticipantIndexes.add(0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  // MÉTODO PARA CARREGAR DADOS DE EDIÇÃO
  Future<void> _loadTransactionData() async {
    if (widget.transactionId == null) return;
    
    setState(() {
      _isLoadingData = true;
    });

    try {
      final transaction = await _transactionService.getTransactionById(widget.transactionId!);
      
      if (mounted) {
        // Pré-preenche campos
        _nameController.text = transaction.description;
        // Formata o valor com vírgula para exibir corretamente no input
        _valueController.text = transaction.value.toString().replaceAll('.', ',');
        
        // Mapeia IDs de participantes da transação para índices na lista local
        Set<int> initialIndexes = transaction.participantIds
            .map((id) => _groupParticipants.indexWhere((u) => u.id == id))
            .where((index) => index != -1)
            .toSet();

        setState(() {
          _currentTransaction = transaction;
          _selectedParticipantIndexes = initialIndexes;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar transação: $e');
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha ao carregar dados para edição.")),
        );
      }
    }
  }

  void _initializeGroupParticipants() {
    final group = groups.firstWhere((g) => g.id == widget.groupId);

    _groupParticipants = group.participantIds
        .map((id) => users.firstWhere((u) => u.id == id))
        .toList();

    _currentUser = users.first;

    // Garante que o usuário atual esteja na posição 0
    if (_groupParticipants.any((u) => u.id == _currentUser.id)) {
      _groupParticipants.removeWhere((u) => u.id == _currentUser.id);
      _groupParticipants.insert(0, _currentUser);
    } else {
      _groupParticipants.insert(0, _currentUser);
    }
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('create_transaction_screen');
    AnalyticsService.trackPageLoading('create_transaction_screen', loadTime);
  }

  void _onParticipantsChanged(Set<int> selectedIndexes) {
    setState(() {
      _selectedParticipantIndexes = selectedIndexes;
    });
  }

  // MÉTODO UNIFICADO: LIDA COM POST (CRIAÇÃO) E PUT (EDIÇÃO)
  void _saveTransaction() async {
    // 1. Validações
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? "Salvando alterações..." : "Adicionando despesa...")),
      );

    if (!mounted) return;

    if (_nameController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).hideCurrentSnackBar();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, insira o nome da despesa")),);
       return;
    }

    double? value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, insira um valor válido")),);
      return;
    }

    if (_selectedParticipantIndexes.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selecione pelo menos um participante")),);
      return;
    }

    List<int> participantIds = _selectedParticipantIndexes
        .map((index) => _groupParticipants[index].id)
        .toList();

    // 2. Criar objeto de Requisição
    final transactionRequest = TransactionRequest(
      description: _nameController.text.trim(),
      value: value,
      participantIds: participantIds,
      groupId: widget.groupId,
    );

    // 3. Chamada à API (POST ou PUT)
    try {
      if (_isEditing && widget.transactionId != null) {
        // EDIÇÃO (PUT)
        await _transactionService.updateTransaction(
          widget.transactionId!,
          transactionRequest,
        );
      } else {
        // CRIAÇÃO (POST)
        await _transactionService.createTransaction(transactionRequest);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Retorna true para sinalizar à tela anterior que houve mudança
        Navigator.of(context).pop(true); 
      }
    } catch (e) {
      debugPrint('Erro ao salvar transação via API: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? "Falha ao salvar. Tente novamente." : "Falha ao adicionar despesa."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. Gerenciamento do Título e Botão
    final appBarTitle = _isEditing ? "Editar Despesa" : "Nova Despesa";
    final appBarDescription = _isEditing ? "Atualize as informações da transação" : "Insira as informações da sua nova despesa";
    final buttonText = _isEditing ? "Salvar Alterações" : "Adicionar Despesa";

    // 5. Tela de Carregamento para Edição
    if (_isEditing && _isLoadingData) {
      return Scaffold(
        appBar: CustomAppBar(appBarTitle, description: appBarDescription),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    // 6. Layout principal
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle,
        description: appBarDescription,
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            CardInput(
              "Nome da despesa",
              hint: "Ex: Coca-Cola 2 litros",
              icon: HugeIcons.strokeRoundedNoteEdit,
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            CardInput(
              "Valor",
              hint: "R\$ 0.00",
              icon: HugeIcons.strokeRoundedMoney04,
              keyboardType: TextInputType.number,
              controller: _valueController,
            ),
            const SizedBox(height: 20),
            SelectMembersGroup(
              participants: _groupParticipants,
              mainUser: _currentUser,
              canDeselectMainUser: true,
              onSelectionChanged: _onParticipantsChanged,
              // INICIALIZA A SELEÇÃO SE JÁ HOUVER DADOS CARREGADOS
              initialSelectedIndexes: _selectedParticipantIndexes, 
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: buttonText,
                onPressed: _saveTransaction, // CHAMA O MÉTODO UNIFICADO
                size: ButtonSize.large,
              ),
            ),
              const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}