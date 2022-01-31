// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:collection';
import 'dart:io';

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/methods/generate_uid.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/chat_bubble.dart';
import 'package:chat_buddy/screens/chat/image_view_screen.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/send_message.dart';
import 'package:chat_buddy/widgets/chat_screen_app_bar.dart';
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.uid,
    required this.imageUrl,
    required this.fullName,
  }) : super(key: key);

  final String uid, imageUrl, fullName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String newUid = '';

  late TextEditingController textEditingController;

  // image source
  File? _image;

  DateTime? date;

  // upload task
  UploadTask? task;

  String urlDownload =
      'https://thumbs.dreamstime.com/b/solid-purple-gradient-user-icon-web-mobile-design-interface-ui-ux-developer-app-137467998.jpg';

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    newUid =
        GenerateUid().newUid(UserModel.uid.toString(), widget.uid.toString());
  }

  // Send Message
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  ChatScreenAppBar(
                    uid: widget.uid,
                    imageUrl: widget.imageUrl,
                    fullName: widget.fullName,
                  ),
                  StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: chatCollection.doc(newUid).snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kGreenShadeColor,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        // dynamic data;

                        Map<String, dynamic>? data =
                            snapshot.data!.data() as Map<String, dynamic>?;

                        List allMsg = [];
                        if (data == null) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text('Start Chat with your friend'),
                          );
                        } else {
                          allMsg = data['messages'];
                          if (allMsg.isNotEmpty) {
                            print(allMsg[0]['msg']);
                          }

                          // return Container();
                          return Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: allMsg.length,
                                itemBuilder: (context, index) {
                                  int i = allMsg.length - index - 1;

                                  print(allMsg[i]['senderUid']);
                                  print(UserModel.uid);

                                  return ChatBubble(
                                    newUid: newUid,
                                    index: i,
                                    allMsg: allMsg,
                                    image: _image,
                                  );
                                },
                              ),
                            ),
                          );
                        }
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
              onSend: () async {
                await ChatService()
                    .sendMessage(textEditingController.text, true, newUid);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          color: kBlueShadeColor.withOpacity(0.7),
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
              Divider(),
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
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
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
                          color: Colors.white,
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
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);

      if (image == null) return;

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
      // await uploadImage();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewScreen(
            path: _image!.path,
            imageUrl: widget.imageUrl,
            uid: widget.uid,
            fullName: widget.fullName,
            newUid: newUid,
            image: _image,
          ),
        ),
      );
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

    await ChatService().sendMessage(urlDownload, false, newUid);
  }
}
