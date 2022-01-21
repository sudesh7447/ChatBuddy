// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: kBlueShadeColor, body: SplashTp());
  }
}

class SplashTp extends StatelessWidget {
  const SplashTp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: kHeroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: AssetImage('assets/images/chat_logo.jpg'),
              ),
            ),
          ),
          SizedBox(height: 19),
          DefaultTextStyle(
            style: TextStyle(
              color: kGreenShadeColor,
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'ChatBuddy',
                  speed: const Duration(milliseconds: 150),
                )
              ],
              totalRepeatCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
