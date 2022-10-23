// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/all_chat_main_screen.dart';
import 'package:chat_buddy/screens/setting_details/setting_screen.dart';
import 'package:chat_buddy/screens/users_screen/users_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key, this.idx = -1}) : super(key: key);

  final int idx;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _index = 1;
  List<Widget> screens = [
    UsersScreen(),
    AllChatMainScreen(),
    SettingScreen(),
  ];

  void onItemTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  void initState() {
    if (widget.idx != -1) _index = widget.idx;
    FirebaseMessaging.instance.getToken().then((value) {
      AuthHelper().storeToken(token: value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;
    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;
    Color _iconColor = isDark ? Colors.white : kBlueShadeColor.withOpacity(0.7);
    Color _color = isDark ? Colors.grey.withOpacity(0.3) : Colors.grey.shade200;

    print("Current User:${UserModel.fullName} : ${UserModel.uid}");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: _backgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        color: _color,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: _backgroundColor,
        key: _bottomNavigationKey,
        index: _index,
        height: 65,
        items: [
          Icon(
            FontAwesomeIcons.users,
            color: _index == 0 ? kLightBlueShadeColor : _iconColor,
            size: 32,
          ),
          Icon(
            Icons.chat_outlined,
            color: _index == 1 ? kLightBlueShadeColor : _iconColor,
            size: 32,
          ),
          Icon(
            Icons.settings,
            color: _index == 2 ? kLightBlueShadeColor : _iconColor,
            size: 32,
          ),
        ],
        onTap: (index) => setState(() {
          onItemTap(index);
        }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: screens[_index],
      ),
    );
  }
}
