// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/helpers/validators.dart';
import 'package:chat_buddy/screens/register_screen.dart';
import 'package:chat_buddy/services/auth_helper.dart';
import 'package:chat_buddy/services/get_user_data.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.dispose();
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: ModalProgressHUD(
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
                          SizedBox(height: size.height * 0.15),
                          Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Log in using your existing register email id.',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 30),
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
                            validator: passwordRequireValidator,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: 'Reset Your password');
                                  },
                                  child: Text(
                                    'Forget Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.07),
                          InkWell(
                              onTap: () async {
                                if (_formFieldKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await AuthHelper()
                                      .signIn(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((result) {
                                    if (result == null) {
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
                              child: MyButton(text: 'SIGN IN')),
                          SizedBox(height: size.height * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have any account?",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                child: Text(
                                  ' SIGN UP',
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
