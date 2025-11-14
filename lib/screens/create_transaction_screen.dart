import 'package:divide_ai/components/transaction/select_members_transactions.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/card_input.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/models/data/transaction_request.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/group_service.dart';
import 'package:divide_ai/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateTransactionScreen extends StatefulWidget {
  final String groupId;
  final int? transactionId; // Adicionado para edição

  const CreateTransactionScreen({
    super.key,
    required this.groupId,
    this.transactionId,
  });

  @override
  State<CreateTransactionScreen> createState() =>
      CreateTransactionScreenState();
}

class CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  Set<int> _selectedParticipantIndexes = {};
  late final int _pageLoadStartTime;

  // ESTADOS E SERVIÇOS
  final GroupService _groupService = GroupService();
  final TransactionService _transactionService = TransactionService();

  List<User> _groupParticipants = [];
  String _groupName = '';

  bool _isEditing = false;
  bool _isLoadingParticipants = true;
  bool _isLoadingData = false;
  Transaction? _currentTransaction;


  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _isEditing = widget.transactionId != null;

    _loadGroupParticipants(); 
    
    // Se for edição, também carregamos os dados da transação
    if (_isEditing) {
      _loadTransactionData();
    } else {
      // Se for criação, tentamos pré-selecionar o primeiro (que será o usuário logado)
      _selectedParticipantIndexes.add(0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  // NOVO: Carrega os membros do grupo via API
  Future<void> _loadGroupParticipants() async {
    try {
      // Carrega os membros do grupo via API com estrutura completa
      final groupUsersResponse = await _groupService.getGroupUsersWithDetails(widget.groupId);

      if (mounted) {
        setState(() {
          _groupParticipants = groupUsersResponse.users;
          _groupName = groupUsersResponse.groupName;
          _isLoadingParticipants = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar participantes: $e');
      if (mounted) {
        setState(() {
          _isLoadingParticipants = false;
        });
      }
    }
  }
  
  // NOVO: Carrega dados da transação para edição
  Future<void> _loadTransactionData() async {
    if (widget.transactionId == null) return;

    setState(() {
      _isLoadingData = true;
    });

    try {
      final transaction = await _transactionService.getTransactionById(widget.transactionId!);

      if (mounted) {
        _nameController.text = transaction.description;
        _valueController.text = transaction.value.toString().replaceAll('.', ',');

        // CORRIGIDO: Mapeia IDs de participantes (int) para índices na lista reorganizada
        // Converte int para String para comparar com User.id
        Set<int> initialIndexes = transaction.participantIds
            .map((id) => _groupParticipants.indexWhere((u) => u.id == id.toString()))
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
        _showMessage('Falha ao carregar dados para edição.');
      }
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

  // SUBSTITUI _addTransaction por _saveTransaction (POST/PUT unificado)
  void _saveTransaction() async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? "Salvando alterações..." : "Adicionando despesa...")),
      );

    if (!mounted) return;

    if (_nameController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).hideCurrentSnackBar();
       _showMessage("Por favor, insira o nome da despesa");
       return;
    }

    double? value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showMessage("Por favor, insira um valor válido");
      return;
    }

    if (_selectedParticipantIndexes.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
       _showMessage("Selecione pelo menos um participante");
      return;
    }

    // CORRIGIDO: Pega os IDs como String, conforme o modelo User
    final List<String> participantIds = _selectedParticipantIndexes
        .map((index) => _groupParticipants[index].id)
        .toList();

    final transactionRequest = TransactionRequest(
      description: _nameController.text.trim(),
      value: value,
      participantIds: participantIds,
      groupId: widget.groupId,
    );

    try {
      if (_isEditing && widget.transactionId != null) {
        // PUT (EDIÇÃO)
        await _transactionService.updateTransaction(
          widget.transactionId!,
          transactionRequest,
        );
      } else {
        // POST (CRIAÇÃO)
        await _transactionService.createTransaction(transactionRequest);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).pop(true); 
      }
    } catch (e) {
      debugPrint('Erro ao salvar transação via API: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showMessage(_isEditing ? "Falha ao salvar. Tente novamente." : "Falha ao adicionar despesa.");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBarTitle = _isEditing ? "Editar Despesa" : "Nova Despesa";
    final appBarDescription = _isEditing ? "Atualize as informações da transação" : "Insira as informações da sua nova despesa";
    final buttonText = _isEditing ? "Salvar Alterações" : "Adicionar Despesa";
    
    // Mostra loading se estiver carregando dados da transação OU participantes
    if (_isLoadingParticipants || (_isEditing && _isLoadingData)) {
      return Scaffold(
        appBar: CustomAppBar(appBarTitle, description: appBarDescription),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Se os participantes falharem ao carregar, impede a renderização do formulário
    if (_groupParticipants.isEmpty) {
        return Scaffold(
        appBar: CustomAppBar(appBarTitle, description: "Erro ao carregar dados"),
        body: const Center(child: Text("Não foi possível carregar os participantes do grupo.", style: TextStyle(color: Colors.white70))),
      );
    }

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
            SelectMembersTransactions(
              participants: _groupParticipants,
              onSelectionChanged: _onParticipantsChanged,
              initialSelectedIndexes: _selectedParticipantIndexes,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: buttonText,
                onPressed: _saveTransaction, // MÉTODO UNIFICADO
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