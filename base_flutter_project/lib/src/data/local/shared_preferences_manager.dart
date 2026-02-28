import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKeys { adNetwork, isFirstPermissionShown }

enum PremiumType { isPremium, isWeeklyPremium, isMonthlyPremium }

class SharedPreferencesManager {
  SharedPreferencesManager._();

  static final instance = SharedPreferencesManager._();
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> markScreenAsShown(String screenName) async {
    await _prefs?.setBool(screenName, false);
  }

  bool shouldShowScreen(String screenName, {bool defaultValue = true}) {
    final bool? showScreen = _prefs?.getBool(screenName);
    return showScreen ?? defaultValue;
  }

  Future<void> setPremiumStatus(PremiumType type, bool status) async {
    await _prefs?.setBool(type.name, status);
  }

  bool getPremiumStatus(PremiumType type) {
    return _prefs?.getBool(type.name) ?? false;
  }
}
