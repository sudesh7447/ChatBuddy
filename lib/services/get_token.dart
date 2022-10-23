import 'dart:convert';

import 'package:chat_buddy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> getToken(
    {required String msg,
    required String imageUrl,
    required String receiverUid}) async {
  var _doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(receiverUid)
      .get();

  bool docStatus = _doc.exists;

  if (docStatus == true) {
    callOnFcmApiSendPushNotifications([_doc['Info']['token']],
        msg != '' ? msg : 'Photo', UserModel.username.toString(), imageUrl);
    // sender token, description, title

  }
}

callOnFcmApiSendPushNotifications(
    List<String> userToken, String msg, String name, String imageUrl) async {
  // print("Notification : ${userToken[0]} $msg - $name");
  print("hello");
  print(msg);
  print(imageUrl);
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "registration_ids": userToken,
    "collapse_key": "type_a",
    "notification": {
      "title": name,
      "body": msg,
      "imageUrl":
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/330px-Image_created_with_a_mobile_phone.png',
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'Bearer 	${dotenv.env['FIREBASENOTIFICATION']}'
  };

  try {
    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      // print('test ok push CFM');
      return true;
    } else {
      // print(' CFM error${response.reasonPhrase}');
      // on failure do sth
      return false;
    }
  } catch (e) {
    // print('exception$e');
  }
}
