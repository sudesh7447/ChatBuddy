// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/select_chat.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    if (arr[index]['Info']['uid'] == UserModel.uid) return false;

    String name = arr[index]['Info']['fullName'];

    name = name.toLowerCase();
    _key = _key.toLowerCase();

    if (name.contains(_key)) return true;
    return false;
  }

  Map<String, String> map = {};
  List<String> allChatterUids = [];
  bool showSpinner = false;

  Future<List<String>> getChatList() async {
    await chatCollection.get().then(
      (snapshot) {
        for (var element in snapshot.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;

          String uid1 = data['uid1'].toString();
          String uid2 = data['uid2'].toString();
          List arr = data['messages'];
          if (arr.isNotEmpty) {
            print('arr');
            print(arr[arr.length - 1]);
            String localUid = '';
            if (uid1 == UserModel.uid.toString()) {
              localUid = uid2;
            } else if (uid2 == UserModel.uid.toString()) {
              localUid = uid1;
            }
            setState(() {
              allChatterUids.add(localUid);
            });
          }
        }
      },
    );

    return allChatterUids;
  }

  Future<Map<String, dynamic>> getData(String data) async {
    Map<String, dynamic> userData = {};

    return userData;
  }

  @override
  void initState() {
    // getChatList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
        body: Container(),
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(color: kGreenShadeColor),
        //       );
        //     } else if (snapshot.hasData) {
        //       final userList = snapshot.data!.docs;
        //       print('userList');
        //       print(userList[0]['messages']);
        //
        //       if (userList.isEmpty) {
        //         return Container();
        //       } else {
        //         if (UserModel.following.isEmpty) {
        //           return Center(
        //             child: Text(
        //               "You don't follow any user",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 28,
        //               ),
        //             ),
        //           );
        //         }
        //
        //         return Container();
        //         //   ListView.builder(
        //         //   physics: BouncingScrollPhysics(),
        //         //   itemCount: userList.length,
        //         //   itemBuilder: (context, index) {
        //         //     if (UserModel.following
        //         //         .contains(userList[index]['Info']['uid'])) {
        //         //       if (resultData(userList, index, searchKey)) {
        //         //         String fUid =
        //         //             userList[index]['Info']['uid'].toString();
        //         //
        //         //         return Padding(
        //         //           padding: const EdgeInsets.symmetric(
        //         //               horizontal: 24, vertical: 12),
        //         //           child: FutureBuilder(
        //         //             future: chatCollection.doc(newUid).get(),
        //         //             builder: (BuildContext context,
        //         //                 AsyncSnapshot<dynamic> snapshot) {
        //         //               if (snapshot.hasError) {
        //         //                 Center(
        //         //                   child: Text(
        //         //                     'Something went wrong',
        //         //                     style: TextStyle(color: Colors.white),
        //         //                   ),
        //         //                 );
        //         //               }
        //         //               if (!snapshot.hasData ||
        //         //                   !snapshot.data.exists) {
        //         //                 return MyChatContainer(
        //         //                   imageUrl: userList[index]['Info']
        //         //                       ['imageUrl'],
        //         //                   name: userList[index]['Info']['fullName'],
        //         //                   friendUid: userList[index]['Info']['uid'],
        //         //                   lastMsg: '',
        //         //                   onTap: () {
        //         //                     Navigator.pushReplacement(
        //         //                       context,
        //         //                       MaterialPageRoute(
        //         //                         builder: (context) => ChatScreen(
        //         //                           friendUid: userList[index]['Info']
        //         //                               ['uid'],
        //         //                           imageUrl: userList[index]['Info']
        //         //                               ['imageUrl'],
        //         //                           fullName: userList[index]['Info']
        //         //                               ['fullName'],
        //         //                         ),
        //         //                       ),
        //         //                     );
        //         //                   },
        //         //                 );
        //         //               }
        //         //               if (snapshot.hasData) {
        //         //                 if (snapshot.data
        //         //                     .data()
        //         //                     .containsKey('messages')) {
        //         //                   List<dynamic> data = snapshot
        //         //                       .data['messages'] as List<dynamic>;
        //         //
        //         //                   bool isMsg = true;
        //         //                   if (data.isEmpty) {
        //         //                     lastMessage = '';
        //         //                   } else {
        //         //                     isMsg = data[data.length - 1]['isMsg'];
        //         //                     lastMessage =
        //         //                         data[data.length - 1]['msg'];
        //         //                   }
        //         //
        //         //                   return MyChatContainer(
        //         //                     imageUrl: userList[index]['Info']
        //         //                         ['imageUrl'],
        //         //                     name: userList[index]['Info']['fullName'],
        //         //                     friendUid: userList[index]['Info']['uid'],
        //         //                     lastMsg: isMsg ? lastMessage : "Photo",
        //         //                     onTap: () {
        //         //                       Navigator.push(
        //         //                         context,
        //         //                         MaterialPageRoute(
        //         //                           builder: (context) => ChatScreen(
        //         //                             friendUid: userList[index]['Info']
        //         //                                 ['uid'],
        //         //                             imageUrl: userList[index]['Info']
        //         //                                 ['imageUrl'],
        //         //                             fullName: userList[index]['Info']
        //         //                                 ['fullName'],
        //         //                           ),
        //         //                         ),
        //         //                       );
        //         //                     },
        //         //                   );
        //         //                 } else {
        //         //                   return MyChatContainer(
        //         //                     imageUrl: userList[index]['Info']
        //         //                         ['imageUrl'],
        //         //                     name: userList[index]['Info']['fullName'],
        //         //                     friendUid: userList[index]['Info']['uid'],
        //         //                     lastMsg: '',
        //         //                     onTap: () {
        //         //                       Navigator.push(
        //         //                         context,
        //         //                         MaterialPageRoute(
        //         //                           builder: (context) => ChatScreen(
        //         //                             friendUid: userList[index]['Info']
        //         //                                 ['uid'],
        //         //                             imageUrl: userList[index]['Info']
        //         //                                 ['imageUrl'],
        //         //                             fullName: userList[index]['Info']
        //         //                                 ['fullName'],
        //         //                           ),
        //         //                         ),
        //         //                       );
        //         //                     },
        //         //                   );
        //         //                 }
        //         //               }
        //         //               return Container();
        //         //             },
        //         //           ),
        //         //         );
        //         //       } else {
        //         //         return SizedBox();
        //         //       }
        //         //     } else {
        //         //       return Container();
        //         //     }
        //         //   },
        //         // );
        //       }
        //     }
        //     return Container();
        //   },
        // ),
      ),
    );
  }
}
