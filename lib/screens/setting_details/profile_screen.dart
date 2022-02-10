// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/methods/get_dob.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:chat_buddy/screens/update_info_bottom_sheet.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:chat_buddy/widgets/image_viewer.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // image source
  File? _image;

  DateTime? date;

  // upload task
  UploadTask? task;

  String urlDownload =
      'https://thumbs.dreamstime.com/b/solid-purple-gradient-user-icon-web-mobile-design-interface-ui-ux-developer-app-137467998.jpg';

  bool isEditOn = false;
  bool isEditName = false;
  bool isEditBio = false;
  bool isDisable = false;

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

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CircularProgressIndicator(
        color: kGreenShadeColor,
      ),
      child: Scaffold(
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: kBlueShadeColor,
          title: Text('Profile', style: kSettingComponentAppBarTextStyle),
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
                            child: ImageViewer(
                              urlDownload:
                                  Provider.of<UserModelProvider>(context)
                                      .imageUrl,
                              finalWidth: MediaQuery.of(context).size.width,
                              finalHeight: 500,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isEditOn = true;
                                });
                                buildShowModalBottomSheet(context);
                              },
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
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Form(
                              key: _formFieldKey,
                              child: Column(
                                children: [
                                  SubName(subName: 'Name'),
                                  MyContainer2(
                                    icon: FontAwesomeIcons.user,
                                    text:
                                        Provider.of<UserModelProvider>(context)
                                            .fullName,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: UpdateInfoBottomSheet(
                                                header: 'Enter Name',
                                                initialText: Provider.of<
                                                            UserModelProvider>(
                                                        context)
                                                    .fullName,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SubName(subName: 'Bio'),
                                  MyContainer2(
                                    icon: FontAwesomeIcons.handPeace,
                                    text:
                                        Provider.of<UserModelProvider>(context)
                                            .bio,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: UpdateInfoBottomSheet(
                                                header: 'Enter Bio',
                                                initialText: Provider.of<
                                                            UserModelProvider>(
                                                        context)
                                                    .bio,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SubName(subName: 'Date of Birth'),
                                  MyContainer2(
                                    icon: FontAwesomeIcons.calendarAlt,
                                    text: DOB().getDOB(date),
                                    onTap: () async {
                                      await pickDate(context);

                                      Provider.of<UserModelProvider>(context,
                                              listen: false)
                                          .updateDob(DOB().getDOB(date));

                                      await MyUserInfo().updateUserDetails(
                                          UserModel.fullName,
                                          UserModel.imageUrl,
                                          UserModel.bio,
                                          DOB().getDOB(date));
                                    },
                                  ),
                                  SubName(subName: 'Email'),
                                  MyContainer2(
                                    icon: Icons.email,
                                    text: UserModel.email.toString(),
                                    isEditable: false,
                                    isEmail: true,
                                  ),
                                  SizedBox(height: 30),
                                  InkWell(
                                      onTap: () async {
                                        await AuthHelper().signOut(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: kGreenShadeColor,
                                            content: Text(
                                              'Logout Successfully',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: MyButton1(
                                          text: 'Logout', color: Colors.red))
                                ],
                              ),
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
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            setState(() {
              isEditOn = false;
            });
            return Future.value(true);
          },
          child: Container(
            color: kBlueShadeColor.withOpacity(0.7),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose an option to upload image',
                  style: TextStyle(
                    fontSize: 22,
                    color: kLightBlueShadeColor,
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.camera,
                          color: kLightBlueShadeColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.image,
                          color: kLightBlueShadeColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pick image
  Future getImage(ImageSource imageSource) async {
    try {
      final image =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);

      if (image == null) return;

      FirebaseStorageMethods().deleteImage(
          Provider.of<UserModelProvider>(context, listen: false).imageUrl);

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });

      setState(() {
        showSpinner = true;
      });

      await uploadImage();
      await MyUserInfo()
          .updateUserDetails(
            UserModel.fullName,
            Provider.of<UserModelProvider>(context, listen: false).imageUrl,
            UserModel.bio,
            UserModel.dob,
          )
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kGreenShadeColor,
                content: Text(
                  'Profile picture updated successfully',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
      setState(() {
        showSpinner = false;
        isEditOn = false;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    // print('image $_image');
    setState(() {
      showSpinner = true;
    });
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'files/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    Provider.of<UserModelProvider>(context, listen: false)
        .updateImageUrl(urlDownload);
    // print('urlDownload $urlDownload');
    setState(() {
      showSpinner = false;
    });
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kGreenShadeColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: kGreenShadeColor,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: initialDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    setState(() {
      date = newDate;
    });
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
