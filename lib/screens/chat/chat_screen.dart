// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/methods/generate_uid.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/bottom_navigation.dart';
import 'package:chat_buddy/screens/chat/chat_bubble.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/chat_service.dart';
import 'package:chat_buddy/widgets/chat_screen_app_bar.dart';
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:chat_buddy/providers/theme_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.friendUid,
    required this.imageUrl,
    required this.fullName,
    this.isFromChatBuddyPage = false,
  }) : super(key: key);

  final String friendUid, imageUrl, fullName;
  final bool isFromChatBuddyPage;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  String newUid = '';

  late TextEditingController textEditingController;

  // image source
  File? _image;

  DateTime? date;

  // upload task
  UploadTask? task;

  String urlDownload = '';

  bool showSpinner = false;

  Future<void> setUids() async {
    await chatCollection.doc(newUid).set({
      "uid1": UserModel.uid,
      "uid2": widget.friendUid,
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    newUid = GenerateUid()
        .newUid(UserModel.uid.toString(), widget.friendUid.toString());

    setUids();
  }

  @override
  Widget build(BuildContext context) {

    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BottomNavigation(),
              ),
              (Route<dynamic> route) => false);

          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: _backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    ChatScreenAppBar(
                      uid: widget.friendUid,
                      imageUrl: widget.imageUrl,
                      fullName: widget.fullName,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: chatCollection
                          .doc(newUid)
                          .collection('messages')
                          .orderBy('sendAt', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        print("snapshot");
                        // print(snapshot.data!.docs.length);
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: kGreenShadeColor,
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.data != null && snapshot.hasData) {
                          return Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;

                                  String sendAt = data['sendAt']
                                      .toDate()
                                      .toString()
                                      .substring(11, 16);

                                  var timestamp = data['timestamp'];

                                  return ChatBubble(
                                    sendAt: sendAt,
                                    message: data['msg'],
                                    isMsg: data['isMsg'],
                                    isSender: data['senderUid'].toString() ==
                                        UserModel.uid,
                                    newUid: newUid,
                                    timestamp: timestamp,
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
              MyTextInputChat(
                hintText: 'Type a message',
                icon: FontAwesomeIcons.camera,
                controller: textEditingController,
                onImage: () async {
                  await buildShowModalBottomSheet(context);
                },
                onSend: () {
                  ChatService().sendMessage(textEditingController.text, true,
                      newUid, widget.friendUid, context);
                  textEditingController.text = '';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    bool isDark =
        Provider.of<ThemeProvider>(context, listen: false).getThemeMode;
    Color _backgroundColor = isDark
        ? kBlueShadeColor.withOpacity(0.7)
        : Colors.grey.withOpacity(0.1);
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;

    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          color: _backgroundColor,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose an option to send an image',
                style: TextStyle(
                  fontSize: 22,
                  color: kLightBlueShadeColor,
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera,
                        color: kLightBlueShadeColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 18,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: InkWell(
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.image,
                        color: kLightBlueShadeColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Pick image
  Future getImage(ImageSource imageSource) async {
    try {
      final image =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 25);

      if (image == null) return;

      final imgTemp = File(image.path);

      ChatService().sendMessage('', false, newUid, widget.friendUid, context);
      setState(() {
        _image = imgTemp;
      });
      await uploadImage();

      await ChatService().updateMessage(urlDownload, newUid);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

// Upload image
  Future uploadImage() async {
    if (_image == null) return;
    final imageName = path.basename(_image!.path);
    final destination = 'chatImages/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
  }
}
