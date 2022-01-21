// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:chat_buddy/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: kBlueShadeColor,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Setting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Hero(
                                    tag: kHeroTag1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(300),
                                      child: Image(
                                        image: NetworkImage(
                                          UserModel.imageUrl.toString(),
                                        ),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        UserModel.fullName.toString(),
                                        style: TextStyle(
                                          color: kGreenShadeColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        UserModel.bio.toString(),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 10),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 10),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 10),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 10),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 10),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
