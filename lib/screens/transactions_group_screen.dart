import 'package:divide_ai/components/transaction/transaction_card.dart' as card;
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/info_card.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/screens/create_transaction_screen.dart';
import 'package:divide_ai/screens/create_group_screen.dart';
import 'package:divide_ai/screens/bill_group_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class TransactionsGroupScreen extends StatefulWidget {
  final GroupApiModel group; // <-- Recebe o grupo inteiro no construtor

  const TransactionsGroupScreen({
    super.key,
    required this.group,
  });

  @override
  State<TransactionsGroupScreen> createState() =>
      TransactionsGroupScreenState();
}

class TransactionsGroupScreenState extends State<TransactionsGroupScreen> {
  late final int _pageLoadStartTime;

  final TransactionService _transactionService = TransactionService();
  List<Transaction> _groupTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _fetchTransactions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  Future<void> _fetchTransactions() async {
    try {
      final transactions =
          await _transactionService.getGroupTransactions(widget.group.id!);
      if (mounted) {
        setState(() {
          _groupTransactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar transações do grupo: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _reloadState() {
    setState(() {
      _isLoading = true;
      _groupTransactions = [];
    });
    _fetchTransactions();
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('transactions_group_screen');
    AnalyticsService.trackPageLoading('transactions_group_screen', loadTime);
  }

  void _navigateToBillScreen() async {
    AnalyticsService.trackEvent(
      elementId: 'analytics_button',
      eventType: 'CLICK',
      page: 'transactions_group_screen',
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BillGroupScreen(groupId: widget.group.id!),
      ),
    );
  }

  void _navigateToEditGroup() async {
    AnalyticsService.trackEvent(
      elementId: 'edit_group_button',
      eventType: 'CLICK',
      page: 'transactions_group_screen',
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateGroupScreen(groupId: widget.group.id),
      ),
    );

    // Se houve alteração, recarrega a tela
    if (result == true && mounted) {
      // Aqui você pode adicionar lógica para recarregar os dados do grupo
      // Por enquanto, apenas volta para a tela anterior
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    double individualTotal = 0.0;
    double sharedTotal = 0.0;
    int totalItems = _groupTransactions.length;

    for (final transaction in _groupTransactions) {
      if (transaction.participants.length == 1) {
        individualTotal += transaction.value;
      } else {
        sharedTotal += transaction.value;
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        group.name,
        description: group.description,
        icon: HugeIcons.strokeRoundedAnalytics01,
        tapIcon: _navigateToBillScreen,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SpecialInfoCard(
                              "Total da Comanda",
                              value: formatter
                                  .format(individualTotal + sharedTotal),
                              description: "$totalItems itens",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InfoCard(
                              icon: HugeIcons.strokeRoundedUser02,
                              title: "Individuais",
                              value: formatter.format(individualTotal),
                              colorOption: InfoCardColor.green,
                            ),
                          ),
                          Expanded(
                            child: InfoCard(
                              icon: HugeIcons.strokeRoundedUserMultiple02,
                              title: "Compartilhados",
                              value: formatter.format(sharedTotal),
                              colorOption: InfoCardColor.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botão de editar grupo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: "Editar Grupo",
                      icon: HugeIcons.strokeRoundedPencilEdit02,
                      onPressed: _navigateToEditGroup,
                      size: ButtonSize.medium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Gastos do Grupo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      Button(
                        text: "Adicionar gasto",
                        icon: Icons.add,
                        onPressed: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 200));

                          if (!mounted) return;

                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateTransactionScreen(
                                groupId: widget.group.id!,
                              ),
                            ),
                          );

                          if (mounted && result == true) {
                            _reloadState();
                          }
                        },
                        size: ButtonSize.small,
                      ),
                    ],
                  ),
                ),
                if (_groupTransactions.isEmpty)
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            HugeIcons.strokeRoundedInvoice01,
                            size: 64,
                            color: Colors.grey,
                          ),
                          Text(
                            "Nenhuma transação encontrada",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._groupTransactions.map((transaction) {
                    return InkWell(
                      onTap: () async {
                        AnalyticsService.trackEvent(
                          elementId: 'edit_transaction_${transaction.id}',
                          eventType: 'CLICK',
                          page: 'transactions_group_screen',
                        );

                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateTransactionScreen(
                              groupId: widget.group.id!,
                              transaction: transaction, // Passa o objeto completo
                            ),
                          ),
                        );

                        if (mounted && result == true) {
                          _reloadState();
                        }
                      },
                      child: card.TransactionCard(transaction),
                    );
                  }),
              ],
            ),
    );
  }
}
