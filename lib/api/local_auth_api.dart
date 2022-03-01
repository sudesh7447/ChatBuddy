// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate(bool isFingerAvailable) async {
    if (isFingerAvailable) {
      final isAvailable = await hasBiometrics();
      if (!isAvailable) return false;

      try {
        return await _auth.authenticateWithBiometrics(
          localizedReason: 'Scan Fingerprint to Authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        if (e.code == 'LockedOut') {
          Fluttertoast.showToast(
              msg: 'Too many attempts. Try again after 30 seconds.');
        }
        return false;
      }
    }
    return false;
  }
}

class ShowTimer extends StatefulWidget {
  const ShowTimer({Key? key}) : super(key: key);

  @override
  _ShowTimerState createState() => _ShowTimerState();
}

class _ShowTimerState extends State<ShowTimer> {
  late Timer _timer;
  int _start = 45;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text('$_start'),
    );
  }
}
