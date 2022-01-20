import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfo {
  //Store User Details
  Future<void> storeUserDetails(username, email, password) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
          "Info": {
            "username": username,
            "email": email,
            "password": password,
            "uid": uid,
            "isAdmin": false,
          }
        }, SetOptions(merge: true))
        .then((value) => print("User Details Added"))
        .catchError((error) => print("Failed to add user: $error"));

    return;
  }

  // Update UserDetails
  Future<void> updateUserDetails(
      username, email, password, imageUrl, bio) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
          "Info": {
            "username": username,
            "email": email,
            "password": password,
            "imageUrl": imageUrl,
            "bio": bio,
          }
        }, SetOptions(merge: true))
        .then((value) => print("User Details Updated"))
        .catchError((error) => print("Failed to Update user: $error"));

    return;
  }
}
