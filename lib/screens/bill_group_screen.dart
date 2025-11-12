import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:divide_ai/components/transaction/bill_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/components/bill.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/services/analytics_service.dart';

class BillGroupScreen extends StatefulWidget {
  final int groupId;

  const BillGroupScreen({super.key, required this.groupId});

  @override
  State<BillGroupScreen> createState() => _BillGroupScreenState();
}

class _BillGroupScreenState extends State<BillGroupScreen> {
  late final int _pageLoadStartTime;
  List<Bill> participantBills = [];

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _calculateParticipantBills();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('bill_group_screen');
    AnalyticsService.trackPageLoading('bill_group_screen', loadTime);
  }

  void _calculateParticipantBills() {
    // ✅ Proteção caso o grupo não seja encontrado
    final group = groups.firstWhere(
      (g) => g.id == widget.groupId,
      orElse: () => Group(
        "Grupo não encontrado",
        description: "Erro ao carregar dados do grupo",
        participantIds: [],
        value: 0.0,
        backgroundIconColor: Colors.grey,
      ),
    );

    final groupTransactions = transactions
        .where((t) => t.groupId == widget.groupId)
        .toList();

    final participants = group.participantIds
        .map((id) => users.firstWhere((u) => u.id == id))
        .toList();

    List<Bill> bills = [];

    for (final participant in participants) {
      double individualTotal = 0.0;
      double sharedTotal = 0.0;

      for (final transaction in groupTransactions) {
        if (transaction.participantIds.contains(participant.id)) {
          if (transaction.participantIds.length == 1) {
            individualTotal += transaction.value;
          } else {
            sharedTotal += transaction.value / transaction.participantIds.length;
          }
        }
      }

      bills.add(
        Bill(
          participant.name,
          valueIndividual: individualTotal,
          valueCompartilhado: sharedTotal,
        ),
      );
    }

    setState(() {
      participantBills = bills;
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = groups.firstWhere(
      (g) => g.id == widget.groupId,
      orElse: () => Group(
        "Grupo não encontrado",
        description: "",
        participantIds: [],
        value: 0.0,
        backgroundIconColor: Colors.grey,
      ),
    );

    final groupTransactions = transactions
        .where((t) => t.groupId == widget.groupId)
        .toList();

    double totalValue = 0.0;
    double totalIndividual = 0.0;
    double totalShared = 0.0;

    for (final transaction in groupTransactions) {
      totalValue += transaction.value;
      if (transaction.participantIds.length == 1) {
        totalIndividual += transaction.value;
      } else {
        totalShared += transaction.value;
      }
    }

    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar("Divisão da comanda", description: group.name),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SpecialInfoCard(
            "Total da comanda",
            value: formatter.format(totalValue),
            description:
                "Individual: ${formatter.format(totalIndividual)} - Compartilhado: ${formatter.format(totalShared)}",
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Quanto cada um deve pagar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          ...participantBills.map((bill) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: BillCard(bill),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
