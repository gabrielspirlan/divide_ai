import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/info_card.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group.dart';
import 'package:divide_ai/models/data/user.dart';
import 'package:divide_ai/models/data/transaction.dart';
import 'package:divide_ai/screens/transactions_group_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class HomeGroupScreen extends StatefulWidget {
  const HomeGroupScreen({super.key});

  @override
  State<HomeGroupScreen> createState() => HomeGroupScreenState();
}

class HomeGroupScreenState extends State<HomeGroupScreen> {
  double individualExpenses = 0.0;
  double sharedExpenses = 0.0;
  int userGroupsCount = 0;
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _calculateUserExpenses();
    _calculateUserGroups();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('home_group_screen', loadTime);
    AnalyticsService.trackPageLoading('home_group_screen', loadTime);
  }

  void _calculateUserExpenses() {
    if (users.isEmpty) return;

    final firstUserId = users.first.id;

    final userTransactions = transactions
        .where(
          (transaction) => transaction.participantIds.contains(firstUserId),
        )
        .toList();

    double individualTotal = 0.0;
    double sharedTotal = 0.0;

    for (final transaction in userTransactions) {
      if (transaction.participantIds.length == 1) {
        individualTotal += transaction.value;
      } else {
        sharedTotal += transaction.value / transaction.participantIds.length;
      }
    }

    setState(() {
      individualExpenses = individualTotal;
      sharedExpenses = sharedTotal;
    });
  }

  void _calculateUserExpensesNoSetState() {
    if (users.isEmpty) return;

    final firstUserId = users.first.id;

    final userTransactions = transactions
        .where(
          (transaction) => transaction.participantIds.contains(firstUserId),
        )
        .toList();

    double individualTotal = 0.0;
    double sharedTotal = 0.0;

    for (final transaction in userTransactions) {
      if (transaction.participantIds.length == 1) {
        individualTotal += transaction.value;
      } else {
        sharedTotal += transaction.value / transaction.participantIds.length;
      }
    }

    individualExpenses = individualTotal;
    sharedExpenses = sharedTotal;
  }

  void _calculateUserGroups() {
    if (users.isEmpty) return;

    final firstUserId = users.first.id;

    final userGroups = groups.where((group) =>
      group.participantIds.contains(firstUserId)
    ).length;

    setState(() {
      userGroupsCount = userGroups;
    });
  }

  void _calculateUserGroupsNoSetState() {
    if (users.isEmpty) return;

    final firstUserId = users.first.id;

    userGroupsCount = groups.where((group) =>
      group.participantIds.contains(firstUserId)
    ).length;
  }

  void _reloadState() {
    setState(() {
      _calculateUserExpensesNoSetState();
      _calculateUserGroupsNoSetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar(
        "Olá ${users.first.name.split(' ').first}",
        description: "Gerencie seus grupos de despesas",
        icon: HugeIcons.strokeRoundedSettings01,
      ),

      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpecialInfoCard(
                        "Total Geral",
                        value: formatter.format(
                          individualExpenses + sharedExpenses,
                        ),
                        description: "$userGroupsCount grupos ativos",
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
                        value: formatter.format(individualExpenses),
                        colorOption: InfoCardColor.green,
                      ),
                    ),
                    Expanded(
                      child: InfoCard(
                        icon: HugeIcons.strokeRoundedUserMultiple02,
                        title: "Compartilhados",
                        value: formatter.format(sharedExpenses),
                        colorOption: InfoCardColor.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Meus Grupos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  Button(
                    text: "Novo Grupo",
                    icon: Icons.add,
                    onPressed: () => print("Novo Grupo"),
                    size: ButtonSize.small,
                  ),
                ],
              ),
            ),
          ),

          ...groups.map((group) {
            return GroupCard(
              group,
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 300));

                if (context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionsGroupScreen(groupId: group.id),
                    ),
                  );

                  _reloadState();
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
