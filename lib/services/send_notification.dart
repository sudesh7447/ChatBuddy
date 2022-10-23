import 'package:chat_buddy/services/get_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/constants.dart';

class SendNotification {
  void localNotifications(
      {required String receiverUid,
      required String senderName,
      required String notificationMsg,
      required String imageUrl}) async {
    String token = "";
    await FirebaseFirestore.instance
        .collection('users')
        .where(
          FieldPath.documentId,
          isEqualTo: receiverUid,
        )
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> documentData =
            event.docs.single.data(); //if it is a single document
        token = documentData['Info']['token'];
      }
    }).catchError((e) => print("error fetching data: $e"));

    print(token);
    if (token != "") {
      getToken(
          msg: notificationMsg, receiverUid: receiverUid, imageUrl: imageUrl);
    }
    print("Notification Send");

    // final allData = querySnapshot.docs.map((doc) {
    //   return doc.data();
    // }).toList();
    //
    //
    // for (int i = 0; i < allData.length; i++) {
    //   Map<String, dynamic> _data = allData[i] as Map<String, dynamic>;
    //
    //   String _noticeBranch = branches[shortBranch.indexOf(noticeBranch)];
    //   print(_noticeBranch);
    //   if (_data["Info"]["token"] != null &&
    //       _noticeBranch == _data["Info"]["branch"] &&
    //       noticeYear == _data["Info"]["year"]) {
    //     getToken(
    //       msg: notificationMsg,
    //       receiverUid: _data["Info"]["uid"],
    //     );
    //     print("Notification Send to ${_data["Info"]["name"]}");
    //   }
    // }
  }
}
