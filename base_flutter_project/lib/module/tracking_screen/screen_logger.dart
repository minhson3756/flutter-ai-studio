import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticLogger {
  AnalyticLogger._();

  static final AnalyticLogger instance = AnalyticLogger._();

  Future<void> logScreen(String name) async {
    await FirebaseAnalytics.instance
        .logScreenView(screenName: name, screenClass: name);
  }
}
