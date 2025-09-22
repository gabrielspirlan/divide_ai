import 'package:divide_ai/components/group/select_members_group.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/card_input.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CreateTransactionScreen extends StatefulWidget {
  final int groupId;

  const CreateTransactionScreen({super.key, required this.groupId});

  @override
  State<CreateTransactionScreen> createState() =>
      CreateTransactionScreenState();
}

class CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  Set<int> _selectedParticipantIndexes = {0};
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
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

  void _addTransaction() async {
    await Future.delayed(Duration(milliseconds: 200));

    if (!mounted) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira o nome da despesa")),
      );
      return;
    }

    if (_valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira o valor da despesa")),
      );
      return;
    }

    if (_selectedParticipantIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, selecione pelo menos um participante"),
        ),
      );
      return;
    }

    double? value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira um valor válido")),
      );
      return;
    }

    List<int> participantIds = _selectedParticipantIndexes
        .map((index) => users[index].id)
        .toList();

    Transaction newTransaction = Transaction(
      _nameController.text.trim(),
      value: value,
      participantIds: participantIds,
      groupId: widget.groupId,
    );

    transactions.add(newTransaction);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Nova despesa",
        description: "Insira as informações da sua nova despesa",
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 12,
          children: [
            CardInput(
              "Nome da despesa",
              hint: "Ex: Coca-Cola 2 litros",
              icon: HugeIcons.strokeRoundedNoteEdit,
              controller: _nameController,
            ),
            CardInput(
              "Valor",
              hint: "R\$ 0.00",
              icon: HugeIcons.strokeRoundedMoney04,
              keyboardType: TextInputType.number,
              controller: _valueController,
            ),
            SelectMembersGroup(
              participants: users,
              mainUser: users.first,
              canDeselectMainUser: true,
              onSelectionChanged: _onParticipantsChanged,
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Button(
          text: "Adicionar Despesa",
          onPressed: _addTransaction,
          size: ButtonSize.large,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
