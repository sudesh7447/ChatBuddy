// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/screens/setting_details/account_detail_screen.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:chat_buddy/screens/setting_details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
                                    child: ImageViewer2(
                                      height: 80,
                                      width: 80,
                                      imageUrl: Provider.of<UserModelProvider>(
                                              context)
                                          .imageUrl,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<UserModelProvider>(context)
                                            .fullName,
                                        style: TextStyle(
                                          color: kGreenShadeColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          Provider.of<UserModelProvider>(
                                                  context)
                                              .bio,
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 16,
                                          ),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountDetailScreen(),
                              ),
                            );
                          },
                          child: MyContainer1(
                            icon: FontAwesomeIcons.solidUser,
                            text: 'Account',
                          ),
                        ),
                        SizedBox(height: 15),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 15),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 15),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 15),
                        MyContainer1(
                            icon: FontAwesomeIcons.userShield, text: 'Profile'),
                        SizedBox(height: 15),
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
