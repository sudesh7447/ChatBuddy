import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUserInfo {
  //Store User Details
  Future<void> storeUserDetails(username, email, password) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection.doc(uid).set({
      "Info": {
        "username": username,
        "email": email,
        "password": password,
        "uid": uid,
        "isAdmin": false,
        "fullName": '',
        "imageUrl": '',
        "bio": '',
        "dob": '',
        "timeStamp": Timestamp.now(),
      }
    }, SetOptions(merge: true)).then((value) async {
      print("User Details Added");
      await storeNumberOfUsers();
    }).catchError((error) {
      print("Failed to add user: $error");
    });

    return;
  }

  // Store number of users
  Future<void> storeNumberOfUsers() async {
    final CollectionReference appTotalUsersCollection =
        FirebaseFirestore.instance.collection('appTotalUsers');

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    appTotalUsersCollection
        .doc('countUser')
        .set({
          "userTrack": {
            "count": FieldValue.increment(1),
            "emails": {uid: auth.currentUser!.email}
          }
        }, SetOptions(merge: true))
        .then((value) => print("AppTotalUser updated"))
        .catchError((error) => print("Failed to update AppTotalUser $error"));
  }

  // Update UserDetails
  Future<void> updateUserDetails(fullName, imageUrl, bio, dob) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
          "Info": {
            "fullName": fullName,
            "imageUrl": imageUrl,
            "bio": bio,
            "dob": dob,
          }
        }, SetOptions(merge: true))
        .then((value) => print("User Details Updated"))
        .catchError((error) => print("Failed to Update user: $error"));

    return;
  }
}
