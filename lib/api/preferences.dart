import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static SharedPreferences? _preferences;

  static const _keyTheme = "theme";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setTheme(bool mode) async =>
      await _preferences!.setBool(_keyTheme, mode);

  static bool? getTheme() => _preferences!.getBool(_keyTheme);
}
