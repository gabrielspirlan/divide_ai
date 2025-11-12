import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:divide_ai/components/group/group_card.dart';
import 'package:divide_ai/components/ui/button.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/info_card.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group_api_model.dart';
import 'package:divide_ai/screens/transactions_group_screen.dart';
import 'package:divide_ai/screens/settings_screen.dart';
import 'package:divide_ai/screens/create_group_screen.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/group_service.dart';
import 'package:divide_ai/services/session_service.dart';

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
  List<GroupApiModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadGroups();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  Future<void> _loadGroups() async {
    try {
      // ✅ Pega o ID do usuário logado
      final userId = await SessionService.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception("Usuário não encontrado na sessão");
      }

      // ✅ Chama a API com o userId
      final groups = await GroupService.getGroupsByUser(userId);

      setState(() {
        _groups = groups;
        userGroupsCount = groups.length;
      });
      _calculateUserExpenses();
    } catch (e) {
      debugPrint('❌ Erro ao carregar grupos: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar grupos: $e')),
        );
      }
    }
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('home_group_screen');
    AnalyticsService.trackPageLoading('home_group_screen', loadTime);
  }

  void _calculateUserExpenses() {
    double individualTotal = 0.0;
    double sharedTotal = 0.0;

    for (final group in _groups) {
      if (group.totalTransactions != null) {
        sharedTotal += group.totalTransactions!;
      }
    }

    setState(() {
      individualExpenses = individualTotal;
      sharedExpenses = sharedTotal;
    });
  }

  void _reloadState() async {
    await _loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar(
        "Olá!",
        description: "Gerencie seus grupos de despesas",
        icon: HugeIcons.strokeRoundedSettings01,
        tapIcon: () async {
          // 🔥 mantém o mesmo tempo de animação das outras telas
          await Future.delayed(const Duration(milliseconds: 300));
          if (context.mounted) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
            _reloadState();
          }
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpecialInfoCard(
                        "Total Geral",
                        value: formatter.format(individualExpenses + sharedExpenses),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Meus Grupos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  Button(
                    text: "Novo Grupo",
                    icon: Icons.add,
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateGroupScreen(),
                          ),
                        );
                        _reloadState();
                      }
                    },
                    size: ButtonSize.small,
                  ),
                ],
              ),
            ),
          ),
          if (_groups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Nenhum grupo encontrado.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            ..._groups.map((group) {
              return GroupCard(
                group,
                onTap: () async {
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsGroupScreen(
                          groupId: int.tryParse(group.id ?? '0') ?? 0,
                        ),
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
