// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/helpers/validators.dart';
import 'package:chat_buddy/screens/auth_screen/login_screen.dart';
import 'package:chat_buddy/screens/auth_screen/verify_user_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/get_user_data.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController cPasswordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    cPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    cPasswordController = TextEditingController();
    super.dispose();
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.white,
        ),
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: kBlueShadeColor,
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: kHeroTag,
                        child: Image(
                          image: AssetImage('assets/images/chat_logo.png'),
                          width: 70,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'ChatBuddy',
                        style: TextStyle(color: kGreenShadeColor, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formFieldKey,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.08),
                          Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Create new account on ChatBuddy',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 30),
                          MyTextInput(
                            hintText: 'Username',
                            icon: FontAwesomeIcons.solidUserCircle,
                            controller: usernameController,
                            validator: userNameValidator,
                          ),
                          MyTextInput(
                            hintText: 'Email id',
                            icon: Icons.email,
                            controller: emailController,
                            validator: emailValidator,
                          ),
                          MyTextInput(
                            hintText: 'Password',
                            icon: Icons.lock,
                            controller: passwordController,
                            validator: passwordValidator,
                          ),
                          MyTextInput(
                            hintText: 'Confirm Password',
                            icon: Icons.lock,
                            controller: cPasswordController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return "Confirm password and password doesn't match";
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'By signing up you agree to our ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(
                                      msg: 'Terms and Conditions of ChatBuddy');
                                },
                                child: Text(
                                  'Terms of use',
                                  style: TextStyle(color: kGreenShadeColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.03),
                          InkWell(
                              onTap: () async {
                                if (_formFieldKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await AuthHelper()
                                      .signUp(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((result) async {
                                    if (result == null) {
                                      await MyUserInfo().storeUserDetails(
                                          usernameController.text,
                                          emailController.text,
                                          passwordController.text);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GetUserData(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      Fluttertoast.showToast(msg: result);
                                    }
                                  });
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              },
                              child: MyButton(text: 'SIGN UP')),
                          SizedBox(height: size.height * 0.08),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' SIGN IN',
                                  style: TextStyle(color: kGreenShadeColor),
                                ),
                              ),
                            ],
                          )
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
}
