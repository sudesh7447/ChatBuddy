// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/send_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  Future sendMessage(
      String msg, bool isMsg, newUid, receiverUid, context) async {
    if (msg == '' && isMsg) return;

    // AssetsAudioPlayer.defaultVolume;
    // AssetsAudioPlayer.newPlayer().open(
    //   Audio("assets/audio/send.mp3"),
    //   showNotification: false,
    //   volume: 0.5,
    // );

    var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;

    SendNotification().localNotifications(
        receiverUid: receiverUid,
        senderName: UserModel.fullName.toString(),
        notificationMsg: msg,
        imageUrl: '');

    await chatCollection.doc(newUid).collection('messages').doc().set(
      {
        "msg": msg,
        "isMsg": isMsg,
        "newUid": newUid,
        "timestamp": timestamp,
        "sendAt": DateTime.now(),
        "senderUid": UserModel.uid,
        "receiverUid": receiverUid,
      },
      SetOptions(merge: true),
    );

    await chatCollection.doc(newUid).set(
      {
        "lastMsgTime": timestamp,
      },
      SetOptions(merge: true),
    );
  }

  Future updateMessage(String msg, newUid) async {
    String _tempUid = '';

    await chatCollection
        .doc(newUid)
        .collection('messages')
        .where("msg", isEqualTo: "")
        .get()
        .then((value) {
      _tempUid = value.docs.single.id;
    });

    await chatCollection
        .doc(newUid)
        .collection('messages')
        .doc(_tempUid)
        .update(
      {"msg": msg},
    );
  }

  Future<void> deleteMsg(newUid, msg, isMsg, timestamp) async {
    // AssetsAudioPlayer.defaultVolume;
    // AssetsAudioPlayer.newPlayer().open(
    //   Audio("assets/audio/delete.mp3"),
    //   showNotification: false,
    //   volume: 0.5,
    // );

    if (!isMsg) {
      FirebaseStorageMethods().deleteImage(msg);
    }

    String _uid = '';
    await chatCollection
        .doc(newUid)
        .collection('messages')
        .where('timestamp', isEqualTo: timestamp)
        .limit(1)
        .get()
        .then((value) {
      _uid = value.docs.single.id;
    });

    chatCollection.doc(newUid).collection('messages').doc(_uid).delete();
  }
}
