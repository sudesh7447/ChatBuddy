// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/screens/login_screen.dart';
import 'package:chat_buddy/screens/profile_setup_screen.dart';
import 'package:chat_buddy/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kGreenShadeColor),
      title: 'ChatBuddy',
      home: SplashScreen(),
    );
  }
}
