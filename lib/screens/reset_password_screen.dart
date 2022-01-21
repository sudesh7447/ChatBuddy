// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/helpers/validators.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool showSpinner = false;
    final GlobalKey<FormState> _formFieldKey = GlobalKey();

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: kBlueShadeColor,
        appBar: AppBar(
          backgroundColor: kGreenShadeColor,
          title: Text('Reset Password'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter email address',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formFieldKey,
                child: MyTextInput(
                  hintText: 'Email Id',
                  icon: Icons.email,
                  controller: emailController,
                  validator: emailValidator,
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                  onTap: () async {
                    if (_formFieldKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      await _auth
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: kGreenShadeColor,
                            content: Text(
                              'Reset Link is sent to ${emailController.text}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                        setState(() {
                          showSpinner = false;
                        });
                      }).catchError(
                        (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Email ${emailController.text} is not registered',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: MyButton(text: 'Send Request'))
            ],
          ),
        ),
      ),
    );
  }
}
