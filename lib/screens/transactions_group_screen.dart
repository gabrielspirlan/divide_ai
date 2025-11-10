import 'package:divide_ai/components/transaction/transaction_card.dart' as card;
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/info_card.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/screens/create_transaction_screen.dart';
import 'package:divide_ai/screens/bill_group_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class TransactionsGroupScreen extends StatefulWidget {
  final int groupId;

  const TransactionsGroupScreen({super.key, required this.groupId});

  @override
  State<TransactionsGroupScreen> createState() =>
      TransactionsGroupScreenState();
}

class TransactionsGroupScreenState extends State<TransactionsGroupScreen> {
  late final int _pageLoadStartTime;
  
  // NOVO ESTADO E SERVIÇO
  final TransactionService _transactionService = TransactionService();
  List<Transaction> _groupTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    
    _fetchTransactions(); // INICIA A BUSCA NA API
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  // NOVO MÉTODO: BUSCAR DADOS DA API
  Future<void> _fetchTransactions() async {
    try {
      final transactions = await _transactionService.getGroupTransactions(widget.groupId);
      if (mounted) {
        setState(() {
          _groupTransactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar transações do grupo: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // MÉTODO PARA RECARREGAR O ESTADO
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
        builder: (context) => BillGroupScreen(groupId: widget.groupId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = groups.firstWhere((g) => g.id == widget.groupId);

    final groupTransactions = _groupTransactions; // USANDO DADOS DO ESTADO

    double individualTotal = 0.0;
    double sharedTotal = 0.0;
    int totalItems = groupTransactions.length;

    for (final transaction in groupTransactions) {
      if (transaction.participantIds.length == 1) {
        individualTotal += transaction.value;
      } else {
        sharedTotal += transaction.value;
      }
    }

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar(
        group.name,
        description: group.description,
        icon: HugeIcons.strokeRoundedAnalytics01,
        tapIcon: _navigateToBillScreen,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // INDICADOR DE CARREGAMENTO
          : ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Column(
              // spacing: 5, // assumindo a extensão de Column com spacing
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpecialInfoCard(
                        "Total da Comanda",
                        value: formatter.format(individualTotal + sharedTotal),
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

          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gastos do Grupo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Button(
                  text: "Adicionar gasto",
                  icon: Icons.add,
                  onPressed: () async {
                    await Future.delayed(Duration(milliseconds: 200));

                    if (!mounted) return;

                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateTransactionScreen(groupId: widget.groupId),
                      ),
                    );

                    if (mounted && result == true) {
                      _reloadState(); // CHAMA O RECARREGAMENTO VIA API
                    }
                  },
                  size: ButtonSize.small,
                ),
              ],
            ),
          ),

          if (groupTransactions.isEmpty)
            SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  // spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
            ...groupTransactions.map((transaction) {
              return card.TransactionCard(transaction);
            }),
        ],
      ),
    );
  }
}