// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/get_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyUserScreen extends StatefulWidget {
  const VerifyUserScreen({Key? key}) : super(key: key);

  @override
  _VerifyUserScreenState createState() => _VerifyUserScreenState();
}

class _VerifyUserScreenState extends State<VerifyUserScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  User? user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      AuthHelper().verifyEmail(context: context);

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kGreenShadeColor,
          content: Text(
            'Email verified Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;

    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;

    return isEmailVerified
        ? GetUserData()
        : Scaffold(
            backgroundColor: _backgroundColor,
            appBar: AppBar(
              title: Text(
                'Verify Email',
                style: TextStyle(fontSize: 22),
              ),
              backgroundColor: kGreenShadeColor,
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'A verification email has been send on ${user!.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _textColor, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      AuthHelper().verifyEmail(context: context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kGreenShadeColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Resend Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await AuthHelper().signOut(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: kGreenShadeColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kGreenShadeColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
