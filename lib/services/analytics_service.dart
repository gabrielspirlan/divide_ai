import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AnalyticsService {
  static const String _baseUrl =
      'https://divide-ai-api-i8en.onrender.com/event';

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
        Uri.parse(_baseUrl),
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
}
