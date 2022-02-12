import 'package:flutter/foundation.dart';

class FingerprintProvider extends ChangeNotifier {
  bool _isFingerprintRequire = false;

  bool get isFingerprintRequire => _isFingerprintRequire;

  void changePreference() {
    _isFingerprintRequire = !_isFingerprintRequire;
  }
}
