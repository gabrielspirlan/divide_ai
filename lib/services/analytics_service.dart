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
      final payload = <String, dynamic>{
        'elementId': elementId,
        'variant': 'A',
        'eventType': eventType,
        'page': page,
      };

      
      if (eventType == 'LOADING') {
        payload['loading'] = loading ?? DateTime.now().millisecondsSinceEpoch;
      }

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

  static Future<void> trackPageView(String page) async {
    await trackEvent(
      elementId: page,
      eventType: 'PAGE_VIEW',
      page: page,
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


  static Future<bool> testConnectivity() async {
    try {
      debugPrint('Testando conectividade com: $_baseUrl');
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5));

      debugPrint('Teste de conectividade - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Teste de conectividade falhou: $e');
      return false;
    }
  }

  Future<AnalyticsData> fetchAllAnalyticsData() async {
    try {
      debugPrint('Iniciando busca de dados de analytics...');

      final isConnected = await testConnectivity();
      if (!isConnected) {
        throw Exception('Não foi possível conectar com a API');
      }

      final responses = await Future.wait([
        _getSummary(),
        _getSlowestPage(),
        _getMostClickedButton(),
        _getMostViewedPage(),
        _getLoadingHistory(),
        _getClickHistory(),
        _getViewHistory(),
      ]);

      debugPrint('Todos os dados foram carregados com sucesso');
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
      debugPrint("Erro ao buscar dados da API: $e");
      throw Exception('Falha ao carregar dados de analytics: $e');
    }
  }

  Future<SummaryData> _getSummary() async {
    try {
      debugPrint('Fazendo requisição para: $_baseUrl/event/analytics/stats');
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      debugPrint('Status da resposta: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Dados recebidos com sucesso');
        return SummaryData.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Erro HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load summary: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar summary: $e');
      rethrow;
    }
  }

  Future<InsightData> _getSlowestPage() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/slowest-loading-item'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return InsightData.fromSlowestPage(jsonDecode(response.body));
      } else {
        debugPrint('Erro ao buscar slowest page: ${response.statusCode}');
        throw Exception('Failed to load slowest page: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar slowest page: $e');
      rethrow;
    }
  }

  Future<InsightData> _getMostClickedButton() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/most-clicked-element'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return InsightData.fromMostClicked(jsonDecode(response.body));
      } else {
        debugPrint('Erro ao buscar most clicked: ${response.statusCode}');
        throw Exception('Failed to load most clicked: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar most clicked: $e');
      rethrow;
    }
  }

  Future<InsightData> _getMostViewedPage() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/most-accessed-page'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return InsightData.fromMostAccessed(jsonDecode(response.body));
      } else {
        debugPrint('Erro ao buscar most accessed: ${response.statusCode}');
        throw Exception('Failed to load most accessed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar most accessed: $e');
      rethrow;
    }
  }

  Future<List<HistoryEvent>> _getLoadingHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/loading-history'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> eventList = responseData['recentEvents'] ?? [];
        return eventList.map((json) => HistoryEvent.fromLoadingHistory(json)).toList();
      } else {
        debugPrint('Erro ao buscar loading history: ${response.statusCode}');
        throw Exception('Failed to load loading history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar loading history: $e');
      rethrow;
    }
  }

  Future<List<HistoryEvent>> _getClickHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/click-history'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> eventList = responseData['recentEvents'] ?? [];
        return eventList.map((json) => HistoryEvent.fromClickHistory(json)).toList();
      } else {
        debugPrint('Erro ao buscar click history: ${response.statusCode}');
        throw Exception('Failed to load click history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar click history: $e');
      rethrow;
    }
  }
  
  Future<List<HistoryEvent>> _getViewHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/event/analytics/page-view-history'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> eventList = responseData['recentEvents'] ?? [];
        return eventList.map((json) => HistoryEvent.fromViewHistory(json)).toList();
      } else {
        debugPrint('Erro ao buscar view history: ${response.statusCode}');
        throw Exception('Failed to load view history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar view history: $e');
      rethrow;
    }
  }
}