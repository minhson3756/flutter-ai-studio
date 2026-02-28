import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKeys {
  adNetwork,
  isFirstPermissionShown,
}

enum PremiumType { isPremium, isWeeklyPremium, isMonthlyPremium }

class SharedPreferencesManager {
  SharedPreferencesManager._();

  static final instance = SharedPreferencesManager._();
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Đánh đấu là màn Permission đã được hiển thị
  Future<void> markFirstPermissionAsShown() async {
    await _prefs?.setBool(PreferenceKeys.isFirstPermissionShown.name, false);
  }

  /// Kiểm tra xem có hiển thị màn permission không
  bool shouldShowPermissionScreen() {
    final bool? showScreen =
        _prefs?.getBool(PreferenceKeys.isFirstPermissionShown.name);
    return showScreen ?? true;
  }

  Future<void> setPremiumStatus(PremiumType type, bool status) async {
    await _prefs?.setBool(type.name, status);
  }

  bool getPremiumStatus(PremiumType type) {
    return _prefs?.getBool(type.name) ?? false;
  }
}
