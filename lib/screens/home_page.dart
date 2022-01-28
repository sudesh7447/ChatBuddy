// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/api/local_auth_api.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? user = FirebaseAuth.instance.currentUser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      body: Center(
        child: Text('Coming Soon', style: kSettingComponentAppBarTextStyle),
      ),
    );
  }
}
