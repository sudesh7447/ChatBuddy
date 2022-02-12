// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final CollectionReference followingCollection =
    FirebaseFirestore.instance.collection('following');

final CollectionReference followerCollection =
    FirebaseFirestore.instance.collection('follower');

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser!.uid.toString();

class FollowHelper {
  Future<void> followingUser(friendUid, context) async {
    followingCollection.doc(uid).set(
      {
        "following": FieldValue.arrayUnion([friendUid]),
      },
      SetOptions(merge: true),
    ).then((value) {
      print('Following added');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Future<void> followerUser(friendUid, context) async {
    followerCollection.doc(friendUid).set(
      {
        "follower": FieldValue.arrayUnion([uid]),
      },
      SetOptions(merge: true),
    ).then((value) {
      print('Follower added');
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteFollowing(friendUid, context) async {
    followingCollection.doc(uid).set(
      {
        "following": FieldValue.arrayRemove([friendUid]),
      },
      SetOptions(merge: true),
    ).then((value) {
      print('Following removed');
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteFollower(friendUid, context) async {
    followerCollection.doc(friendUid).set(
      {
        "follower": FieldValue.arrayRemove([uid]),
      },
      SetOptions(merge: true),
    ).then((value) {
      print('Follower removed');
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
