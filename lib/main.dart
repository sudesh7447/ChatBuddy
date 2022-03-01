// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/api/preferences.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/follower_provider.dart';
import 'package:chat_buddy/providers/following_provider.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/screens/splash_screen.dart';
import 'package:chat_buddy/screens/auth_screen/verify_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

User? user = FirebaseAuth.instance.currentUser;

bool isAuthenticated = false;
bool _theme = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemePreferences.init();

  _theme = ThemePreferences.getTheme() ?? false;

  print('_theme');
  print(_theme);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
        ChangeNotifierProvider(create: (_) => FollowingProvider()),
        ChangeNotifierProvider(create: (_) => FollowerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(_theme)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kGreenShadeColor),
      title: 'ChatBuddy',
      home: user == null ? SplashScreen() : VerifyUserScreen(),
    );
  }
}
