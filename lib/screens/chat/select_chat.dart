// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/methods/generate_uid.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/chat_screen.dart';
import 'package:chat_buddy/screens/users_screen/all_users_screen.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class SelectChatScreen extends StatefulWidget {
  const SelectChatScreen({Key? key}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<SelectChatScreen> {
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');

  String lastMessage = '';
  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    if (arr[index]['Info']['uid'] == UserModel.uid) return false;

    String name = arr[index]['Info']['fullName'];

    name = name.toLowerCase();
    _key = _key.toLowerCase();

    if (name.contains(_key)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlueShadeColor,
      appBar: AppBar(
        backgroundColor: kBlueShadeColor,
        title: Text('Select Chat', style: kSettingComponentAppBarTextStyle),
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
            child: (UserModel.following.isEmpty ||
                    (UserModel.following.length == 1 &&
                        UserModel.following[0] == UserModel.uid))
                ? SizedBox(
                    height: size.height * 0.7,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.07),
                        Center(
                          child: Text(
                            "You don't have any friend",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.4,
                          child: Lottie.asset('assets/lottie/robot.json'),
                        ),
                        SizedBox(height: size.height * 0.08),
                        Center(
                          child: Text(
                            "Follow users to chat with them",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllUsersScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: kGreenShadeColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'All Users',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: kGreenShadeColor),
                        );
                      }

                      if (snapshot.hasData) {
                        final userList = snapshot.data!.docs;
                        if (userList.isEmpty) {
                          return Text(
                            "You don't follow any user.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          if (UserModel.following.isEmpty) {
                            return Center(
                              child: Text(
                                "You don't follow any user",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              if (UserModel.following
                                  .contains(userList[index]['Info']['uid'])) {
                                if (resultData(userList, index, searchKey)) {
                                  String fUid =
                                      userList[index]['Info']['uid'].toString();

                                  String _newUid = GenerateUid()
                                      .newUid(UserModel.uid.toString(), fUid);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    child: FutureBuilder<QuerySnapshot>(
                                      future: chatCollection
                                          .doc(_newUid)
                                          .collection('messages')
                                          .orderBy('sendAt', descending: true)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          Center(
                                            child: Text(
                                              'Something went wrong',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
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
                                          return MyChatContainer(
                                            imageUrl: userList[index]['Info']
                                                ['imageUrl'],
                                            name: userList[index]['Info']
                                                ['fullName'],
                                            friendUid: userList[index]['Info']
                                                ['uid'],
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
                                                    friendUid: userList[index]
                                                        ['Info']['uid'],
                                                    imageUrl: userList[index]
                                                        ['Info']['imageUrl'],
                                                    fullName: userList[index]
                                                        ['Info']['fullName'],
                                                  ),
                                                ),
                                              );
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
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      }
                      return Container(
                        color: Colors.red,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
