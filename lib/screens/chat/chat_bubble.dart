// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/services/chat_service.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSender,
    required this.isMsg,
    required this.sendAt,
    required this.newUid,
    required this.timestamp,
  }) : super(key: key);

  final String message, sendAt, newUid;
  final bool isSender, isMsg;
  final int timestamp;

  @override
  Widget build(BuildContext context) {
    void showDialogBoxToDeleteMessage() {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actionsPadding: EdgeInsets.only(bottom: 10),
            title: Text(
              'Delete message',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      ChatService()
                          .deleteMsg(newUid, message, isMsg, timestamp);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  InkWell(
                    onLongPress: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (isSender) {
                        showDialogBoxToDeleteMessage();
                      }
                    },
                    child: isMsg
                        ? BubbleText(
                            msg: message,
                            isSender: isSender,
                            color1: isSender
                                ? kGreenShadeColor.withRed(10)
                                : Colors.white,
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: isSender ? Colors.white : Colors.black,
                            ),
                            createdAt: sendAt,
                          )
                        : BubbleImage(
                            isSender: isSender,
                            image: message,
                            color: isSender ? kGreenShadeColor : Colors.white,
                            createdAt: sendAt,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BubbleText extends StatelessWidget {
  const BubbleText({
    Key? key,
    required this.msg,
    required this.isSender,
    required this.color1,
    required this.textStyle,
    required this.createdAt,
  }) : super(key: key);

  final String msg, createdAt;
  final bool isSender;
  final Color color1;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 4.0, left: 8).copyWith(right: 50),
            child: Text(msg, style: textStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 4),
            child: Text(
              createdAt,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleImage extends StatelessWidget {
  const BubbleImage({
    Key? key,
    required this.image,
    required this.createdAt,
    required this.isSender,
    required this.color,
  }) : super(key: key);

  final String image, createdAt;
  final bool isSender;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ImageViewer1(
        urlDownload: image,
        finalWidth: size.width,
        finalHeight: size.height * 0.6,
      ),
      // child: Image(
      //   image: NetworkImage(image),
      // ),
    );
  }
}
