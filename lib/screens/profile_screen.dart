// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/helpers/validators.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditName = false;
  bool isEditBio = false;

  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  late TextEditingController fullNameController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController = TextEditingController();
    bioController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueShadeColor,
      appBar: AppBar(
        backgroundColor: kBlueShadeColor,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Hero(
                          tag: kHeroTag1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Image(
                              image: NetworkImage(
                                UserModel.imageUrl.toString(),
                              ),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: kGreenShadeColor,
                                  borderRadius: BorderRadius.circular(300),
                                ),
                              ),
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              SubName(subName: 'Name'),
                              if (isEditName)
                                generateTextField(
                                  hintText: 'Update Name',
                                  controller: fullNameController,
                                  isBio: false,
                                )
                              else
                                MyContainer2(
                                  icon: FontAwesomeIcons.user,
                                  mainText: UserModel.fullName.toString(),
                                  onTap: () {
                                    setState(() {
                                      isEditName = !isEditName;
                                    });
                                  },
                                  isEditOn: isEditName,
                                ),
                              SubName(subName: 'Bio'),
                              if (isEditBio)
                                generateTextField(
                                  hintText: 'Update bio',
                                  controller: bioController,
                                  isBio: true,
                                )
                              else
                                MyContainer2(
                                  icon: FontAwesomeIcons.handPeace,
                                  mainText: UserModel.bio.toString(),
                                  onTap: () {
                                    setState(() {
                                      isEditBio = !isEditBio;
                                    });
                                  },
                                  isEditOn: isEditBio,
                                ),
                              SubName(subName: 'Date of Birth'),
                              MyContainer2(
                                icon: FontAwesomeIcons.calendarAlt,
                                mainText: UserModel.dob.toString(),
                                isEdited: false,
                              ),
                              SubName(subName: 'Email'),
                              MyContainer2(
                                icon: Icons.email,
                                mainText: UserModel.email.toString(),
                                isEdited: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateTextField(
      {required controller, required hintText, required isBio}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: EdgeInsets.only(left: 24, right: 12),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade500.withOpacity(0.3),
            border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                FontAwesomeIcons.handPeace,
                color: kGreenShadeColor,
              ),
              InkWell(
                onTap: () {
                  if (_formFieldKey.currentState!.validate()) {
                    isBio
                        ? (setState(() {
                            isEditBio = !isEditBio;
                            UserModel.bio = bioController.text;

                            MyUserInfo().updateUserDetails(
                              UserModel.fullName,
                              UserModel.imageUrl,
                              bioController.text,
                              UserModel.dob,
                            );
                            bioController.text = '';
                          }))
                        : setState(() {
                            isEditName = !isEditName;
                            UserModel.fullName = fullNameController.text;
                            MyUserInfo().updateUserDetails(
                              fullNameController.text,
                              UserModel.imageUrl,
                              UserModel.bio,
                              UserModel.dob,
                            );
                          });
                  }
                },
                child: Icon(
                  Icons.done,
                  color: kGreenShadeColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 64.0).copyWith(top: 3),
          child: Form(
            key: _formFieldKey,
            child: TextFormField(
              controller: controller,
              cursorColor: kGreenShadeColor,
              cursorHeight: 19,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorStyle: TextStyle(color: kGreenShadeColor),
              ),
              onSaved: (value) {
                controller.value = controller.value.copyWith(text: value);
              },
              validator: (val) {
                if (val == '') {
                  return isBio ? "Bio is Required" : "Name is Required";
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SubName extends StatelessWidget {
  const SubName({
    Key? key,
    required this.subName,
  }) : super(key: key);

  final String subName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            subName,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
