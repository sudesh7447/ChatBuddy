// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/helpers/validators.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/firebase_upload.dart';
import 'package:chat_buddy/services/get_user_data.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as path;
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formFieldKey = GlobalKey<FormState>();

  // image source
  File? _image;

  DateTime? date;

  // upload task
  UploadTask? task;

  String urlDownload =
      'https://thumbs.dreamstime.com/b/solid-purple-gradient-user-icon-web-mobile-design-interface-ui-ux-developer-app-137467998.jpg';

  late TextEditingController fullNameController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    bioController = TextEditingController();

    print(auth.currentUser?.email.toString());
  }

  @override
  void dispose() {
    fullNameController = TextEditingController();
    bioController = TextEditingController();
    super.dispose();
  }

  String? dob;

  String getDOB() {
    if (date == null) {
      return 'Date of Birth';
    } else {
      String? day = date?.day.toString();
      String? month = date?.month.toString();
      String? year = date?.year.toString();

      if (month?.length == 1 && day?.length == 1) {
        day = '0$day';
        month = '0$month';
      }
      if (day?.length == 1) {
        day = '0$day';
      }
      if (month?.length == 1) {
        month = '0$month';
      }

      setState(() {
        dob = '$day/$month/$year';
      });
      return dob ?? 'Date of Birth';
    }
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;

    Color _backgroundColor = isDark ? kBlueShadeColor : Colors.white;
    Color _textColor = isDark ? Colors.white : kBlueShadeColor;

    String name = UserModel.username.toString();

    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          color: kGreenShadeColor,
        ),
        child: WillPopScope(
          onWillPop: () async {
            await AuthHelper().signOut(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
            return Future.value(true);
          },
          child: Scaffold(
            backgroundColor: _backgroundColor,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/chat_logo.png'),
                        width: 60,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Profile Setup',
                        style: TextStyle(
                          color: kGreenShadeColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Stack(
                  children: [
                    _image == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Image(
                              image: AssetImage('assets/images/profile.png'),
                              alignment: Alignment.center,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Image.file(
                              _image!,
                              alignment: Alignment.center,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      right: 8,
                      bottom: 15,
                      child: InkWell(
                        onTap: () {
                          buildShowModalBottomSheet(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: kGreenShadeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formFieldKey,
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          MyTextInput(
                            hintText: 'Full Name',
                            icon: FontAwesomeIcons.user,
                            controller: fullNameController,
                            validator: fullNameValidator,
                          ),
                          MyTextInput(
                            hintText: 'About yourself',
                            icon: FontAwesomeIcons.handPeace,
                            controller: bioController,
                            validator: bioValidator,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 32),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  height: 54,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    color: isDark
                                        ? Colors.grey.shade700.withOpacity(0.3)
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: Colors.grey.shade700
                                          .withOpacity(0.15),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: InkWell(
                                    onTap: () {
                                      pickDate(context);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.calendar,
                                          color: kGreenShadeColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          getDOB(),
                                          style: TextStyle(
                                            color: getDOB() == 'Date of Birth'
                                                ? Colors.grey.shade700
                                                : isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: InkWell(
                                onTap: () async {
                                  print(dob);

                                  if (_formFieldKey.currentState!.validate() &&
                                      date != null) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    await uploadImage();
                                    await MyUserInfo().updateUserDetails(
                                      fullNameController.text,
                                      urlDownload,
                                      bioController.text,
                                      dob,
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GetUserData(),
                                      ),
                                    );
                                  } else if (date == null) {
                                    Fluttertoast.showToast(
                                        msg: 'Select date of birth');
                                  }
                                },
                                child: MyButton(text: 'Done')),
                          ),
                        ],
                      ),
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

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
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

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    // print('image $_image');
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'files/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    // print('urlDownload $urlDownload');
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
