import 'package:firebase_analytics/firebase_analytics.dart';

import 'experiment_service.dart';

class AnalyticsService {
  // 🔥 Singleton instance
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // =========================
  // GENERIC LOGGER
  // =========================
  static Future<void> logEvent(
      String name, {
        Map<String, Object>? params,
      }) async {
    try {
      final updatedParams = {
        ...?params,
        "experiment_group": ExperimentService.getGroup(),
      };

      await _analytics.logEvent(
        name: name,
        parameters: updatedParams,
      );
    } catch (e) {
      print("Analytics Error: $e");
    }
  }

  // =========================
  // SPECIFIC EVENTS (CLEAN)
  // =========================

  static Future<void> logUrlSubmitted(String url) async {
    await logEvent(
      "url_submitted",
      params: {
        "url_length": url.length,
      },
    );
  }

  static Future<void> logWarningShown() async {
    await logEvent("warning_shown");
  }

  static Future<void> logContinueAfterWarning() async {
    await logEvent("continued_after_warning");
  }

  static Future<void> logCancelAfterWarning() async {
    await logEvent("cancelled_after_warning");
  }

  static Future<void> logResultViewed(int prediction) async {
    await logEvent(
      "result_viewed",
      params: {
        "prediction": prediction,
      },
    );
  }
}