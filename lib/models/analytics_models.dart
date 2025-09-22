import '../../models/enums/stats_type_enum.dart';

// Modelo para /event/analytics/stats
class SummaryData {
  final double averageLoadingTime;
  final int totalClicks;
  final int totalPageViews;

  SummaryData({
    required this.averageLoadingTime,
    required this.totalClicks,
    required this.totalPageViews,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      averageLoadingTime: (json['averageLoadingTime'] as num).toDouble(),
      totalClicks: json['totalClicks'],
      totalPageViews: json['totalPageViews'],
    );
  }
}

// Modelo para os 3 endpoints de "insight"
class InsightData {
  final String targetName;
  final double value;

  InsightData({required this.targetName, required this.value});

  // factory customizado para cada tipo de insight
  factory InsightData.fromSlowestPage(Map<String, dynamic> json) {
    return InsightData(
      targetName: json['page'] ?? 'N/A',
      value: (json['loadingTime'] as num).toDouble(),
    );
  }

  factory InsightData.fromMostClicked(Map<String, dynamic> json) {
    return InsightData(
      targetName: json['elementId'] ?? 'N/A',
      value: (json['clickCount'] as num).toDouble(),
    );
  }

  factory InsightData.fromMostAccessed(Map<String, dynamic> json) {
    return InsightData(
      targetName: json['page'] ?? 'N/A',
      value: (json['accessCount'] as num).toDouble(),
    );
  }
}

// Modelo para os 3 endpoints de "history"
class HistoryEvent {
  final String eventName;
  final DateTime date;
  final double value;
  final StatsTypeEnum type;

  HistoryEvent({
    required this.eventName,
    required this.date,
    required this.value,
    required this.type,
  });

  factory HistoryEvent.fromLoadingHistory(Map<String, dynamic> json) {
    return HistoryEvent(
      eventName: json['page'] ?? 'N/A',
      date: DateTime.parse(json['created_at']),
      value: (json['loading'] as num).toDouble(),
      type: StatsTypeEnum.loading,
    );
  }

  factory HistoryEvent.fromClickHistory(Map<String, dynamic> json) {
    return HistoryEvent(
      eventName: json['elementId'] ?? 'N/A',
      date: DateTime.parse(json['created_at']),
      value: 0, // Click não tem um valor de tempo
      type: StatsTypeEnum.click,
    );
  }

  factory HistoryEvent.fromViewHistory(Map<String, dynamic> json) {
    return HistoryEvent(
      eventName: json['page'] ?? 'N/A',
      date: DateTime.parse(json['created_at']),
      value: 0, // View não tem um valor de tempo
      type: StatsTypeEnum.visualization,
    );
  }
}

// Modelo principal para agrupar todos os dados da tela
class AnalyticsData {
  final SummaryData summary;
  final InsightData slowestPage;
  final InsightData mostClickedButton;
  final InsightData mostViewedPage;
  final List<HistoryEvent> loadingHistory;
  final List<HistoryEvent> clickHistory;
  final List<HistoryEvent> viewHistory;

  AnalyticsData({
    required this.summary,
    required this.slowestPage,
    required this.mostClickedButton,
    required this.mostViewedPage,
    required this.loadingHistory,
    required this.clickHistory,
    required this.viewHistory,
  });
}