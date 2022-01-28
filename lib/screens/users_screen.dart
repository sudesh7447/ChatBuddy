// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/screens/all_users_screen.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
              ),
            ),
            SizedBox(height: 20),
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
                icon: FontAwesomeIcons.userPlus,
                text: 'Followers',
              ),
            ),
            SizedBox(height: 20),
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
                icon: FontAwesomeIcons.userFriends,
                text: 'Following',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
