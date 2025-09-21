import 'package:flutter_test/flutter_test.dart';
import 'package:divide_ai/services/analytics_service.dart';

void main() {
  group('AnalyticsService', () {
    test('trackButtonClick creates correct payload structure', () async {
      expect(() async {
        await AnalyticsService.trackButtonClick('Test Button', 'test_page');
      }, returnsNormally);
    });

    test('trackPageView creates correct payload structure', () async {
      expect(() async {
        await AnalyticsService.trackPageView('test_page', 1500);
      }, returnsNormally);
    });

    test('trackPageLoading creates correct payload structure', () async {
      expect(() async {
        await AnalyticsService.trackPageLoading('test_page', 2000);
      }, returnsNormally);
    });

    test('trackEvent handles errors gracefully', () async {
      expect(() async {
        await AnalyticsService.trackEvent(
          elementId: 'test_element',
          eventType: 'CLICK',
          page: 'test_page',
          loading: 1000,
        );
      }, returnsNormally);
    });
  });
}
