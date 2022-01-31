import 'package:chat_buddy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Future sendMessage(String msg, bool isMsg, newUid) async {
    if (msg == '' && isMsg) return;

    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');

    await chatCollection.doc(newUid).set({
      'messages': FieldValue.arrayUnion(
        [
          {
            "timeStamp": DateTime.now().toUtc().millisecondsSinceEpoch,
            "createdAt": DateTime.now(),
            "isMsg": isMsg,
            "msg": msg,
            "senderUid": UserModel.uid,
            "newUid": newUid,
          }
        ],
      ),
    }, SetOptions(merge: true));
  }
}
