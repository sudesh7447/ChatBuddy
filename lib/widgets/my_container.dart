// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/follower_provider.dart';
import 'package:chat_buddy/providers/following_provider.dart';
import 'package:chat_buddy/screens/auth_screen/verify_user_screen.dart';
import 'package:chat_buddy/screens/chat/chat_screen.dart';
import 'package:chat_buddy/services/follow_helper.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

User? user = FirebaseAuth.instance.currentUser!;

class MyContainer1 extends StatelessWidget {
  const MyContainer1({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
    this.totalUsers,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function? onTap;
  final int? totalUsers;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String tpUser = text == "Following"
        ? "following"
        : text == "Followers"
            ? "followers"
            : "Users";

    return Container(
      alignment: Alignment.centerLeft,
      width: size.width,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade500.withOpacity(0.3),
        border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: kGreenShadeColor),
                SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$totalUsers  $tpUser",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyContainer2 extends StatelessWidget {
  const MyContainer2({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
    this.isEditable = true,
    this.isEmail = false,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Function? onTap;
  final bool isEditable, isEmail;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.centerLeft,
      width: size.width,
      // height: 55,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade500.withOpacity(0.3),
        border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: kGreenShadeColor),
                SizedBox(width: 15),
                SizedBox(
                  width: isEmail
                      ? MediaQuery.of(context).size.width * 0.55
                      : MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              ],
            ),
            if (isEditable)
              InkWell(
                onTap: () {
                  onTap!();
                },
                child: Icon(
                  Icons.edit,
                  color: kGreenShadeColor,
                  size: 20,
                ),
              ),
            if (isEmail)
              user!.emailVerified
                  ? InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: kGreenShadeColor,
                            content: Text(
                              'Email is already verified',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: kLightBlueShadeColor,
                        size: 26,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          context: context,
                          builder: (_) {
                            return Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Please verify your email',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VerifyUserScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: kLightBlueShadeColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          'Verify',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Colors.red,
                        size: 26,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class MyContainer3 extends StatefulWidget {
  const MyContainer3({
    Key? key,
    required this.text,
    this.onTap,
    required this.imageUrl,
    required this.friendUid,
    this.isFollowStatusRequire = false,
  }) : super(key: key);

  final String text, imageUrl, friendUid;
  final Function? onTap;
  final bool isFollowStatusRequire;

  @override
  State<MyContainer3> createState() => _MyContainer3State();
}

class _MyContainer3State extends State<MyContainer3> {
  bool _isFollow = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isFollowStatusRequire) {
      _isFollow =
          Provider.of<FollowerProvider>(context).isFollowing(widget.friendUid);
    }

    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.centerLeft,
      width: size.width,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade500.withOpacity(0.3),
        border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                widget.onTap!();
              },
              child: SizedBox(
                width: size.width - 160,
                child: Row(
                  children: [
                    ImageViewer2(
                        width: 45, height: 45, imageUrl: widget.imageUrl),
                    SizedBox(width: 15),
                    Text(
                      widget.text,
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  _isFollow = !_isFollow;
                });

                if (_isFollow) {
                  await FollowHelper().followingUser(widget.friendUid, context);
                  Provider.of<FollowingProvider>(context, listen: false)
                      .addFollowing(widget.friendUid);

                  await FollowHelper().followerUser(widget.friendUid, context);
                } else {
                  await FollowHelper()
                      .deleteFollowing(widget.friendUid, context);
                  Provider.of<FollowingProvider>(context, listen: false)
                      .deleteFollowing(widget.friendUid);

                  await FollowHelper()
                      .deleteFollower(widget.friendUid, context);
                }
              },
              child: Text(
                _isFollow ? 'Following' : 'Follow',
                style: TextStyle(
                  color: _isFollow ? kLightBlueShadeColor : kGreenShadeColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyContainer4 extends StatefulWidget {
  const MyContainer4({Key? key, required this.friendUid}) : super(key: key);

  final String friendUid;

  @override
  State<MyContainer4> createState() => _MyContainer4State();
}

class _MyContainer4State extends State<MyContainer4> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  String name = '',
      imageUrl =
          'https://thumbs.dreamstime.com/b/solid-purple-gradient-user-icon-web-mobile-design-interface-ui-ux-developer-app-137467998.jpg',
      lastMessage = 'Last message';

  Future<void> getChatterData() async {
    var _doc =
        userCollection.doc(widget.friendUid).get().then((snapshot) async {
      // print(snapshot.data());
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        name = data['Info']['fullName'];
        imageUrl = data['Info']['imageUrl'];
      });
    });
  }

  @override
  void initState() {
    getChatterData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                friendUid: widget.friendUid,
                imageUrl: imageUrl,
                fullName: name,
                isFromChatBuddyPage: true,
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.centerLeft,
          width: size.width,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade500.withOpacity(0.3),
            border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width - 160,
                  child: Row(
                    children: [
                      ImageViewer2(width: 45, height: 45, imageUrl: imageUrl),
                      SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          if (lastMessage != "")
                            Text(
                              lastMessage,
                              style: TextStyle(color: Colors.white),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.message_outlined,
                  color: kLightBlueShadeColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyChatContainer extends StatefulWidget {
  const MyChatContainer({
    Key? key,
    required this.name,
    this.onTap,
    required this.imageUrl,
    required this.friendUid,
    required this.lastMsg,
  }) : super(key: key);

  final String name, imageUrl, friendUid, lastMsg;
  final Function? onTap;

  @override
  State<MyChatContainer> createState() => _MyChatContainerState();
}

class _MyChatContainerState extends State<MyChatContainer> {
  @override
  Widget build(BuildContext context) {
    String lastMsg = widget.lastMsg;
    int lastMsgLen = widget.lastMsg.length;

    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        widget.onTap!();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: size.width,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade500.withOpacity(0.3),
          border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width - 160,
                child: Row(
                  children: [
                    ImageViewer2(
                        width: 45, height: 45, imageUrl: widget.imageUrl),
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                        SizedBox(height: 5),
                        if (widget.lastMsg != "")
                          Text(
                            lastMsgLen > 30
                                ? lastMsg.substring(0, 20) + '...'
                                : lastMsg,
                            style: TextStyle(color: Colors.grey.shade400),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.message_outlined,
                color: kLightBlueShadeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyChatSkeleton extends StatelessWidget {
  const MyChatSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.centerLeft,
      width: size.width,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade500.withOpacity(0.3),
        border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
      ),
    );
  }
}
