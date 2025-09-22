import 'package:flutter/material.dart';
import 'package:divide_ai/models/analytics_models.dart';
import 'package:divide_ai/services/analytics_service.dart';
import '../../models/enums/stats_type_enum.dart';
import 'package:divide_ai/components/analytics/stats_card.dart';
import 'package:divide_ai/components/analytics/insights_card.dart';
import 'package:divide_ai/components/analytics/describe_stats_card.dart';
import 'package:divide_ai/components/ui/custom_app_bar.dart'; 

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AnalyticsService _analyticsService = AnalyticsService();
  AnalyticsData? _analyticsData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await _analyticsService.fetchAllAnalyticsData();
      if (mounted) {
        setState(() {
          _analyticsData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Erro ao buscar dados: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Analytics Dashboard",
        description: "Métricas de uso do app",
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analyticsData == null
              ? const Center(child: Text('Não foi possível carregar os dados.', style: TextStyle(color: Colors.white)))
              : buildDashboard(),
    );
  }

  Widget buildDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StatsCard(
                value: _analyticsData!.summary.averageLoadingTime,
                type: StatsTypeEnum.loading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                value: _analyticsData!.summary.totalClicks.toDouble(),
                type: StatsTypeEnum.click,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                value: _analyticsData!.summary.totalPageViews.toDouble(),
                type: StatsTypeEnum.visualization,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (index) {
            setState(() {});
          },
          tabs: const [
            Tab(text: 'Carregamento'),
            Tab(text: 'Cliques'),
            Tab(text: 'Páginas'),
          ],
        ),
        const SizedBox(height: 16),
        _buildCurrentInsight(),
        const SizedBox(height: 24),
        _buildCurrentHistoryTitle(),
        const SizedBox(height: 12),
        ..._buildCurrentHistoryList(),
      ],
    );
  }

  Widget _buildCurrentInsight() {
    switch (_tabController.index) {
      case 0:
        return InsightsCard(
          type: StatsTypeEnum.loading,
          insightTargetName: _analyticsData!.slowestPage.targetName,
          actionCount: _analyticsData!.slowestPage.value,
        );
      case 1:
        return InsightsCard(
          type: StatsTypeEnum.click,
          insightTargetName: _analyticsData!.mostClickedButton.targetName,
          actionCount: _analyticsData!.mostClickedButton.value,
        );
      case 2:
      default:
        return InsightsCard(
          type: StatsTypeEnum.visualization,
          insightTargetName: _analyticsData!.mostViewedPage.targetName,
          actionCount: _analyticsData!.mostViewedPage.value,
        );
    }
  }

  Widget _buildCurrentHistoryTitle() {
     String title;
    switch (_tabController.index) {
      case 0:
        title = 'Histórico de Carregamento';
        break;
      case 1:
        title = 'Histórico de Cliques';
        break;
      case 2:
      default:
        title = 'Histórico de Visualizações';
        break;
    }
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildCurrentHistoryList() {
    List<HistoryEvent> events;
    switch (_tabController.index) {
      case 0:
        events = _analyticsData!.loadingHistory;
        break;
      case 1:
        events = _analyticsData!.clickHistory;
        break;
      case 2:
      default:
        events = _analyticsData!.viewHistory;
        break;
    }
    return events.map((event) => Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DescribeStatsCard(
        eventName: event.eventName,
        eventDate: event.date,
        type: event.type,
        loadingTime: event.type == StatsTypeEnum.loading ? event.value : null,
      ),
    )).toList();
  }
}