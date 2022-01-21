// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/api/local_auth_api.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/login_screen.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(UserModel.username.toString()),
            Text(UserModel.email.toString()),
            Text(UserModel.password.toString()),
            user!.emailVerified
                ? Text('Verified')
                : InkWell(onTap: () async {}, child: Text('Verify User')),
            Container(
              color: Colors.red,
              height: 30,
              width: 100,
              child: Center(
                child: InkWell(
                  onTap: () async {
                    AuthHelper().signOut(context);

                    // final isAuthenticate = await LocalAuthApi.authenticate();
                    //
                    // if (isAuthenticate) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                    // }
                  },
                  child: Text('Finger Print'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
