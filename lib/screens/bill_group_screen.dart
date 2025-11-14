import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:divide_ai/components/transaction/user_bill_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart';
import 'package:divide_ai/components/ui/special_info_card.dart';
import 'package:divide_ai/models/data/group_bill_response.dart';
import 'package:divide_ai/services/analytics_service.dart';
import 'package:divide_ai/services/group_service.dart';

class BillGroupScreen extends StatefulWidget {
  final String groupId;

  const BillGroupScreen({super.key, required this.groupId});

  @override
  State<BillGroupScreen> createState() => _BillGroupScreenState();
}

class _BillGroupScreenState extends State<BillGroupScreen> {
  late final int _pageLoadStartTime;
  final GroupService _groupService = GroupService();
  GroupBillResponse? _billData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    _loadBillData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('bill_group_screen');
    AnalyticsService.trackPageLoading('bill_group_screen', loadTime);
  }

  Future<void> _loadBillData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final billData = await _groupService.getGroupBill(widget.groupId);

      if (mounted) {
        setState(() {
          _billData = billData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar divisão da comanda: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar divisão da comanda: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: CustomAppBar(
        "Divisão da comanda",
        description: _billData?.groupName ?? "Carregando...",
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadBillData,
                          child: const Text("Tentar novamente"),
                        ),
                      ],
                    ),
                  ),
                )
              : _billData == null
                  ? const Center(
                      child: Text("Nenhum dado disponível"),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        SpecialInfoCard(
                          "Total da comanda",
                          value: formatter.format(_billData!.totalExpenses),
                          description:
                              "Individual: ${formatter.format(_billData!.totalIndividualExpenses)} - Compartilhado: ${formatter.format(_billData!.totalSharedExpenses)}",
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Text(
                            "Quanto cada um deve pagar",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                        ..._billData!.userBills.map((userBill) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: UserBillCard(userBill),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
    );
  }
}
