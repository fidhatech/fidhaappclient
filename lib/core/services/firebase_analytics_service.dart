import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  static Future<void> init() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    await _analytics.logAppOpen();
  }

  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
