import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:divide_ai/models/analytics_models.dart';

class AnalyticsService {
  static const String _baseUrl = 'https://divide-ai-api-i8en.onrender.com';

  static Future<void> trackEvent({
    required String elementId,
    required String eventType,
    required String page,
    int? loading,
  }) async {
    try {
      final payload = {
        'elementId': elementId,
        'variant': 'A',
        'eventType': eventType,
        'page': page,
        'loading': loading ?? DateTime.now().millisecondsSinceEpoch,
      };

      await http.post(
        Uri.parse('$_baseUrl/event'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
    } catch (e) {
      debugPrint('Analytics tracking failed: $e');
    }
  }

  static Future<void> trackButtonClick(String buttonText, String page) async {
    final elementId = buttonText.toLowerCase().replaceAll(' ', '_');
    await trackEvent(elementId: elementId, eventType: 'CLICK', page: page);
  }

  static Future<void> trackPageView(String page, int loadingTime) async {
    await trackEvent(
      elementId: page,
      eventType: 'PAGE_VIEW',
      page: page,
      loading: loadingTime,
    );
  }
  
  static Future<void> trackPageLoading(String page, int loadingTime) async {
    await trackEvent(
      elementId: page,
      eventType: 'LOADING',
      page: page,
      loading: loadingTime,
    );
  }

  static Future<void> trackCardClick(String cardName, String page) async {
    final elementId = cardName.toLowerCase().replaceAll(' ', '_');
    await trackEvent(elementId: elementId, eventType: 'CLICK', page: page);
  }

  static Future<void> trackInputFocus(String inputLabel, String page) async {
    final elementId = inputLabel.toLowerCase().replaceAll(' ', '_');
    await trackEvent(elementId: elementId, eventType: 'CLICK', page: page);
  }

  static Future<void> trackNavigation(String fromPage, String toPage) async {
    await trackEvent(
      elementId: '${fromPage}_to_$toPage',
      eventType: 'CLICK',
      page: fromPage,
    );
  }

  Future<AnalyticsData> fetchAllAnalyticsData() async {
    try {
      final responses = await Future.wait([
        _getSummary(),
        _getSlowestPage(),
        _getMostClickedButton(),
        _getMostViewedPage(),
        _getLoadingHistory(),
        _getClickHistory(),
        _getViewHistory(),
      ]);

      return AnalyticsData(
        summary: responses[0] as SummaryData,
        slowestPage: responses[1] as InsightData,
        mostClickedButton: responses[2] as InsightData,
        mostViewedPage: responses[3] as InsightData,
        loadingHistory: responses[4] as List<HistoryEvent>,
        clickHistory: responses[5] as List<HistoryEvent>,
        viewHistory: responses[6] as List<HistoryEvent>,
      );
    } catch (e) {
      print("Erro ao buscar dados da API: $e");
      throw Exception('Falha ao carregar dados de analytics');
    }
  }

  Future<SummaryData> _getSummary() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/stats'));
    if (response.statusCode == 200) {
      return SummaryData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load summary');
    }
  }

  Future<InsightData> _getSlowestPage() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/slowest-loading-item'));
    if (response.statusCode == 200) {
      return InsightData.fromSlowestPage(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load slowest page');
    }
  }

  Future<InsightData> _getMostClickedButton() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/most-clicked-element'));
    if (response.statusCode == 200) {
      return InsightData.fromMostClicked(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load most clicked');
    }
  }

  Future<InsightData> _getMostViewedPage() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/most-accessed-page'));
    if (response.statusCode == 200) {
      return InsightData.fromMostAccessed(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load most accessed');
    }
  }

  Future<List<HistoryEvent>> _getLoadingHistory() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/loading-history'));
    if (response.statusCode == 200) {
      final List<dynamic> eventList = jsonDecode(response.body)['recentEvents'];
      return eventList.map((json) => HistoryEvent.fromLoadingHistory(json)).toList();
    } else {
      throw Exception('Failed to load loading history');
    }
  }

  Future<List<HistoryEvent>> _getClickHistory() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/click-history'));
    if (response.statusCode == 200) {
      final List<dynamic> eventList = jsonDecode(response.body)['recentEvents'];
      return eventList.map((json) => HistoryEvent.fromClickHistory(json)).toList();
    } else {
      throw Exception('Failed to load click history');
    }
  }
  
  Future<List<HistoryEvent>> _getViewHistory() async {
    final response = await http.get(Uri.parse('$_baseUrl/event/analytics/page-view-history'));
    if (response.statusCode == 200) {
      final List<dynamic> eventList = jsonDecode(response.body)['recentEvents'];
      return eventList.map((json) => HistoryEvent.fromViewHistory(json)).toList();
    } else {
      throw Exception('Failed to load view history');
    }
  }
}