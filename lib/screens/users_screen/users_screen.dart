// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/users_screen/all_users_screen.dart';
import 'package:chat_buddy/screens/users_screen/following_screen.dart';
import 'package:chat_buddy/services/get_followers.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int totalUsers = 0;

  Future appTotalUsers() async {
    CollectionReference appTotalUsersCollection =
        FirebaseFirestore.instance.collection('appTotalUsers');

    await appTotalUsersCollection.get().then((value) {
      Map<String, dynamic> data = value.docs[0].data() as Map<String, dynamic>;
      setState(() {
        totalUsers = data['userTrack']['count'];
      });
    });
  }

  @override
  void initState() {
    appTotalUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      appBar: AppBar(
        backgroundColor: kBlueShadeColor,
        title: Text('Users', style: kSettingComponentAppBarTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllUsersScreen(),
                  ),
                );
              },
              child: MyContainer1(
                icon: FontAwesomeIcons.users,
                text: 'All Users',
                totalUsers: totalUsers,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetFollowers(isRequire: true),
                  ),
                );
              },
              child: MyContainer1(
                icon: FontAwesomeIcons.userPlus,
                text: 'Followers',
                totalUsers: UserModel.followers.length,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FollowingScreen(),
                  ),
                );
              },
              child: MyContainer1(
                icon: FontAwesomeIcons.userFriends,
                text: 'Following',
                totalUsers: UserModel.following.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
