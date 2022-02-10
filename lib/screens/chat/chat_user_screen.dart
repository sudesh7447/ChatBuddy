// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/methods/generate_uid.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/chat_screen.dart';
import 'package:chat_buddy/screens/chat/select_chat.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shimmer/shimmer.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    if (arr[index]['Info']['uid'] == UserModel.uid) return false;

    String name = arr[index]['Info']['fullName'];

    name = name.toLowerCase();
    _key = _key.toLowerCase();

    if (name.contains(_key)) return true;
    return false;
  }

  Map<String, dynamic> userData = {};

  Future<Map<String, dynamic>> getUserData(givenUid) async {
    await userCollection.doc(givenUid).get().then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      userData = data;
    });
    return userData;
  }

  void showDialogBoxToDeleteChat(fNewUid) {
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
            'Delete Chat',
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
                    await chatCollection.doc(fNewUid).delete();
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

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: FloatingActionButton(
            backgroundColor: kLightBlueShadeColor,
            child: Icon(Icons.message, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectChatScreen(),
                ),
              );
            },
          ),
        ),
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: kBlueShadeColor,
          title: Text(
            'ChatBuddy',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Stack(
                children: [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.grey.shade700.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.grey.shade700.withOpacity(0.15),
                      ),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                    ),
                    decoration: kTextFormFieldAuthDec.copyWith(
                      hintText: 'Search User',
                      prefixIcon: Icon(Icons.search, color: kGreenShadeColor),
                      prefixIconColor: Colors.red,
                      errorStyle: TextStyle(color: kGreenShadeColor),
                    ),
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.grey.shade200,
                    onChanged: (val) {
                      setState(() {
                        searchKey = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: chatCollection
                      .orderBy('lastMsgTime', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return NoChatWidget();
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return NoChatWidget();
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          String uid1 = data['uid1'].toString();
                          String uid2 = data['uid2'].toString();
                          String fNewUid = '', fUid = '';
                          if (uid1 == UserModel.uid) {
                            fNewUid = GenerateUid().newUid(uid1, uid2);
                            fUid = uid2;
                          } else if (uid2 == UserModel.uid) {
                            fNewUid = GenerateUid().newUid(uid1, uid2);
                            fUid = uid1;
                          }
                          if (fUid != '') {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: getUserData(fUid),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey,
                                      highlightColor: Colors.grey.shade100,
                                      child: MyChatSkeleton(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> userSnap =
                                        snapshot.data as Map<String, dynamic>;

                                    return FutureBuilder(
                                      future: chatCollection
                                          .doc(fNewUid)
                                          .collection('messages')
                                          .orderBy('sendAt', descending: true)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: MyChatSkeleton(),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          return InkWell(
                                            onLongPress: () {
                                              showDialogBoxToDeleteChat(
                                                  fNewUid);
                                            },
                                            child: MyChatContainer(
                                              name: userSnap['Info']
                                                  ['fullName'],
                                              imageUrl: userSnap['Info']
                                                  ['imageUrl'],
                                              friendUid: fUid,
                                              lastMsg: snapshot
                                                      .data!.docs.isNotEmpty
                                                  ? (snapshot.data!.docs[0]
                                                          ['isMsg']
                                                      ? snapshot.data!.docs[0]
                                                          ['msg']
                                                      : "Photo")
                                                  : '',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                      friendUid: fUid,
                                                      imageUrl: userSnap['Info']
                                                          ['imageUrl'],
                                                      fullName: userSnap['Info']
                                                          ['fullName'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoChatWidget extends StatelessWidget {
  const NoChatWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
              child: Text(
                'Start chat with your friends',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.4,
              child: Lottie.asset('assets/lottie/empty_chat.json'),
            ),
          ],
        ),
      ),
    );
  }
}
