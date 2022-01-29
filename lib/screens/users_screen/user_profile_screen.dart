// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/follower_provider.dart';
import 'package:chat_buddy/providers/following_provider.dart';
import 'package:chat_buddy/screens/users_screen/users_screen.dart';
import 'package:chat_buddy/services/follow_helper.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.userUid}) : super(key: key);
  final String userUid;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String imageUrl = '', fullName = '', dob = '', bio = '', email = '';
  Timestamp? createdAt;

  Future getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUid)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        fullName = snapshot['Info']['fullName'];
        imageUrl = snapshot['Info']['imageUrl'];
        createdAt = snapshot['Info']['createdAt'];
        dob = snapshot['Info']['dob'];
        bio = snapshot['Info']['bio'];
        email = snapshot['Info']['email'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool _isFollow = false;

  @override
  Widget build(BuildContext context) {
    _isFollow =
        Provider.of<FollowerProvider>(context).isFollowing(widget.userUid);

    Size size = MediaQuery.of(context).size;

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    String getCreatedOn() {
      DateTime dateTime = createdAt!.toDate();

      String since =
          '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';

      return since;
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UsersScreen()),
            (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: _isFollow ? kLightBlueShadeColor : kGreenShadeColor,
          title: Text(
            "$fullName Profile",
            style: kSettingComponentAppBarTextStyle,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                ImageViewer(
                  width: 160,
                  height: 160,
                  finalWidth: size.width,
                  finalHeight: 500,
                  urlDownload: imageUrl,
                ),
                SizedBox(height: 20),
                Text(
                  fullName,
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 10),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _isFollow = !_isFollow;
                    });

                    if (_isFollow) {
                      await FollowHelper()
                          .followingUser(widget.userUid, context);
                      Provider.of<FollowingProvider>(context, listen: false)
                          .addFollowing(widget.userUid);

                      await FollowHelper()
                          .followerUser(widget.userUid, context);
                      Provider.of<FollowerProvider>(context, listen: false)
                          .addFollower(widget.userUid);
                    } else {
                      await FollowHelper()
                          .deleteFollowing(widget.userUid, context);
                      Provider.of<FollowingProvider>(context, listen: false)
                          .deleteFollowing(widget.userUid);

                      await FollowHelper()
                          .deleteFollower(widget.userUid, context);
                      Provider.of<FollowingProvider>(context, listen: false)
                          .deleteFollowing(widget.userUid);
                    }
                  },
                  child: MyButton1(
                    text: _isFollow ? 'Following' : 'Follow',
                    borderRadius: 10,
                    color: _isFollow ? kLightBlueShadeColor : kGreenShadeColor,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade500),
                      SizedBox(height: 10),
                      NewRow(
                        property: bio,
                        icon: FontAwesomeIcons.handPeace,
                        color:
                            _isFollow ? kLightBlueShadeColor : kGreenShadeColor,
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey.shade500),
                      SizedBox(height: 10),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NewRow(
                              property: dob,
                              icon: Icons.cake,
                              color: _isFollow
                                  ? kLightBlueShadeColor
                                  : kGreenShadeColor,
                            ),
                            SizedBox(height: 15),
                            NewRow(
                              property:
                                  'User Since ${createdAt != null ? getCreatedOn() : ''}',
                              icon: Icons.verified,
                              color: _isFollow
                                  ? kLightBlueShadeColor
                                  : kGreenShadeColor,
                            ),
                            SizedBox(height: 15),
                            NewRow(
                              property: "xx Followers",
                              icon: FontAwesomeIcons.userPlus,
                              color: _isFollow
                                  ? kLightBlueShadeColor
                                  : kGreenShadeColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  const NewRow({
    Key? key,
    required this.property,
    required this.icon,
    this.color = kLightBlueShadeColor,
  }) : super(key: key);

  final String property;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              property,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
