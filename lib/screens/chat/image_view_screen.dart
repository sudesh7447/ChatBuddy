// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/screens/chat/chat_screen.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/send_message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as path;

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({
    Key? key,
    required this.path,
    required this.uid,
    required this.imageUrl,
    required this.fullName,
    required this.newUid,
    this.image,
  }) : super(key: key);

  final String path, uid, imageUrl, fullName, newUid;
  final File? image;

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CircularProgressIndicator(color: kGreenShadeColor),
      child: Scaffold(
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: kBlueShadeColor,
          title: Text(
            'Send image',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 30),
                Image.file(
                  File(widget.path),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        await uploadImage(widget.image);
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                uid: widget.uid,
                                imageUrl: widget.imageUrl,
                                fullName: widget.fullName),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        decoration: BoxDecoration(
                          color: kGreenShadeColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? date;

  // upload task
  UploadTask? task;

  String urlDownload = '';

  Future uploadImage(_image) async {
    if (_image == null) return;
    final imageName = path.basename(_image!.path);
    final destination = 'chatImages/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    await ChatService().sendMessage(urlDownload, false, widget.newUid);
  }
}
