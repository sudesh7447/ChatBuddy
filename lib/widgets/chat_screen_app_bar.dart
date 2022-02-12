// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/screens/bottom_navigation.dart';
import 'package:chat_buddy/screens/users_screen/user_profile_screen.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ChatScreenAppBar extends StatelessWidget {
  const ChatScreenAppBar({
    Key? key,
    required this.uid,
    required this.imageUrl,
    required this.fullName,
  }) : super(key: key);

  final String uid, imageUrl, fullName;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;
    Color _textColor2 =
        isDark ? Colors.grey.shade700 : Colors.grey.withOpacity(0.25);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0).copyWith(top: 40),
      decoration: BoxDecoration(
        color: _textColor2,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => BottomNavigation(),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: Icon(Icons.arrow_back_ios_sharp, color: _textColor),
            ),
            SizedBox(width: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(userUid: uid),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightGreenAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: ImageViewer2(
                              width: 40,
                              height: 40,
                              imageUrl: imageUrl,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          fullName,
                          style: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CallScreen(),
                          //   ),
                          // );
                        },
                        child: Icon(
                          Icons.phone,
                          size: 32,
                          color: kGreenShadeColor,
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.video_call_outlined,
                          size: 32,
                          color: kGreenShadeColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
