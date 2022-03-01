import 'package:flutter/foundation.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider(this._isDarkMode);

  bool get getThemeMode => _isDarkMode;

  void changeMode() {
    _isDarkMode = !_isDarkMode;

    notifyListeners();
  }
}
