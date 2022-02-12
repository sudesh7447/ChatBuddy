// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:chat_buddy/screens/auth_screen/verify_user_screen.dart';
import 'package:chat_buddy/screens/auth_screen/profile_setup_screen.dart';
import 'package:chat_buddy/services/get_following.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetUserData extends StatelessWidget {
  const GetUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String documentId = uid;
    print(auth.currentUser?.email);
    print('GetUserData');

    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;

    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong, Please try again',
                  style: kSettingComponentAppBarTextStyle),
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(
              child: CircularProgressIndicator(
                color: kGreenShadeColor,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            UserModel.username = data['Info']['username'].toString();
            UserModel.email = data['Info']['email'].toString();
            UserModel.password = data['Info']['password'].toString();
            UserModel.fullName = data['Info']['fullName'].toString();
            UserModel.imageUrl = data['Info']['imageUrl'].toString();
            UserModel.bio = data['Info']['bio'].toString();
            UserModel.dob = data['Info']['dob'].toString();
            UserModel.uid = data['Info']['uid'].toString();

            if (auth.currentUser!.emailVerified) {
              if (UserModel.fullName == '') {
                return ProfileSetupScreen();
              } else {
                return GetFollowing();
              }
            } else {
              return VerifyUserScreen();
            }
          }
          return Center(
            child: CircularProgressIndicator(
              color: kGreenShadeColor,
            ),
          );
        },
      ),
    );
  }
}
