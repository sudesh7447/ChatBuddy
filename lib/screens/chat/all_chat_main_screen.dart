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
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/theme_provider.dart';

class AllChatMainScreen extends StatefulWidget {
  const AllChatMainScreen({Key? key}) : super(key: key);

  @override
  _AllChatMainScreenState createState() => _AllChatMainScreenState();
}

class _AllChatMainScreenState extends State<AllChatMainScreen> {
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

  Future getChatsOfCurrentUser() async {
    await chatCollection
        .where('uid1', isEqualTo: UserModel.uid.toString())
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        print(value.docs[0].data());
        setState(() {
          UserModel.isChatAvailable = true;
        });
      }
    });

    if (!UserModel.isChatAvailable) {
      await chatCollection
          .where('uid2', isEqualTo: UserModel.uid.toString())
          .limit(1)
          .get()
          .then((value) {
        print(value.docs[0].data());

        setState(() {
          UserModel.isChatAvailable = true;
        });
      });
    }
  }

  bool showSpinner = false;

  @override
  void initState() {
    getChatsOfCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;
    print("chatAvailable ${UserModel.isChatAvailable}");
    Size size = MediaQuery.of(context).size;

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
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: kGreenShadeColor,
          title: Text(
            'ChatBuddy',
            style: TextStyle(fontSize: 26),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: chatCollection
                      .orderBy('lastMsgTime', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox(
                        height: size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: kGreenShadeColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty &&
                        !UserModel.isChatAvailable) {
                      return NoChatWidget();
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                          if (!UserModel.isChatAvailable) {
                            return NoChatWidget();
                          } else {
                            return FutureBuilder<Map<String, dynamic>>(
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
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
                                          child: MyChatContainer(
                                            name: userSnap['Info']['fullName']
                                                .toString(),
                                            imageUrl: userSnap['Info']
                                                ['imageUrl'],
                                            friendUid: fUid,
                                            lastMsg:
                                                snapshot.data!.docs.isNotEmpty
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
                            );
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
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;
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
                  color: _textColor,
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
