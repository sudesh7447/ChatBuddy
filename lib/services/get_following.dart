// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/services/get_followers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetFollowing extends StatelessWidget {
  const GetFollowing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    print('GetFollowing');

    CollectionReference followerCollection =
        FirebaseFirestore.instance.collection('following');
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: followerCollection.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong, Please try again',
                  style: kSettingComponentAppBarTextStyle),
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return GetFollowers();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('done');
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            print('following list');
            print(data['following']);

            UserModel.following = data['following'];

            return GetFollowers();
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
