import 'package:shared_preferences/shared_preferences.dart';

import 'prefs.dart';

class SharedPreferencesHelper {
  final SharedPreferences _preferences;

  SharedPreferencesHelper({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  Future<void> clear() async => await _preferences.clear();

  // Is first app launch
  bool get isFirstAppLaunch => _preferences.getBool(Prefs.isFirstAppLaunch) ?? true;

  Future<bool> setIsFirstAppLaunch(value) async => await _preferences.setBool(Prefs.isFirstAppLaunch, value);

  // IsLoggedIn
  bool get isLoggedIn => _preferences.getBool(Prefs.isLoggedIn) ?? true;

  Future<bool> setIsLoggedIn(value) async => await _preferences.setBool(Prefs.isLoggedIn, value);

  // Locale
  String? get locale => _preferences.getString(Prefs.languageCode);

  Future<void> setLocale(String value) async => await _preferences.setString(Prefs.languageCode, value);

  // Theme Mode
  int? get themeModeIdx => _preferences.getInt(Prefs.themeModeIdx);

  Future<void> setThemeModeIdx(int value) async => await _preferences.setInt(Prefs.themeModeIdx, value);
}
