// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/users_screen/user_profile_screen.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowingScreen> {
  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    print(UserModel.uid);

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
        title: Text('Following', style: kSettingComponentAppBarTextStyle),
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
                        color: Colors.grey.shade700.withOpacity(0.15)),
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
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: kGreenShadeColor));
                } else if (snapshot.hasData) {
                  final userList = snapshot.data!.docs;
                  if (userList.isEmpty) {
                    return Container();
                  } else {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        if (UserModel.following.isEmpty) {
                          return Container(
                            child: Text(
                              'No following',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          );
                        }
                        if (UserModel.following
                            .contains(userList[index]['Info']['uid'])) {
                          if (resultData(userList, index, searchKey)) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: MyContainer3(
                                imageUrl: userList[index]['Info']['imageUrl'],
                                text: userList[index]['Info']['fullName'],
                                friendUid: userList[index]['Info']['uid'],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                        userUid: userList[index]['Info']['uid'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
