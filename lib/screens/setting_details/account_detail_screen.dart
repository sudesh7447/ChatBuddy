// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:flutter/material.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({Key? key}) : super(key: key);

  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      appBar: AppBar(
        backgroundColor: kBlueShadeColor,
        title: Text('Account', style: kSettingComponentAppBarTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: 24),
        child: Column(
          children: [
            // Text(
            //   'User of ChatBuddy from',
            //   style: TextStyle(color: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}
