// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/api/preferences.dart';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:chat_buddy/widgets/my_box.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:chat_buddy/screens/setting_details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: kGreenShadeColor,
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
                                    imageUrl:
                                        Provider.of<UserModelProvider>(context)
                                            .imageUrl,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Text(
                                        Provider.of<UserModelProvider>(context)
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
                      ThemeContainer(
                        text: 'Theme',
                        icon: FontAwesomeIcons.moon,
                        action: 'Light',
                      ),
                      SizedBox(height: 15),
                      MyContainer5(
                        text: 'Developer Info',
                        icon: Icons.person_rounded,
                        color1: Color(0xffECAF1F).withOpacity(0.2),
                        color2: Color(0xffECAF1F),
                        onTap: () {},
                      ),
                      SizedBox(height: 35),
                      InkWell(
                        onTap: () async {
                          await AuthHelper().signOut(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: kGreenShadeColor,
                              content: Text(
                                'Logout Successfully',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeContainer extends StatefulWidget {
  const ThemeContainer({
    Key? key,
    required this.text,
    required this.icon,
    this.action = '',
  }) : super(key: key);

  final String text;
  final IconData icon;
  final String action;

  @override
  State<ThemeContainer> createState() => _ThemeContainerState();
}

class _ThemeContainerState extends State<ThemeContainer> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        await ThemePreferences.setTheme(!isDark);
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: size.width,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark
              ? Colors.grey.shade500.withOpacity(0.3)
              : Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyBox(
                    color1: Color(0xffE8547C).withOpacity(0.2),
                    color2: Color(0xffE8547C),
                    icon: !isDark
                        ? Icons.wb_sunny_outlined
                        : FontAwesomeIcons.moon,
                    iconSize: isDark ? 24 : 28,
                  ),
                  SizedBox(width: 15),
                  Text(
                    widget.text,
                    style: TextStyle(color: _textColor, fontSize: 19),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    isDark ? 'Dark' : 'Light',
                    style: TextStyle(color: kLightBlueShadeColor, fontSize: 18),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
