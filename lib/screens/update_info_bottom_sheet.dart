// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/providers/user_model_provider.dart';
import 'package:chat_buddy/services/my_user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateInfoBottomSheet extends StatelessWidget {
  const UpdateInfoBottomSheet({
    Key? key,
    required this.header,
    required this.initialText,
  }) : super(key: key);

  final String header, initialText;

  @override
  Widget build(BuildContext context) {
    String updatedValue = initialText;

    return Container(
      color: kBlueShadeColor.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(
                color: kGreenShadeColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  updatedValue = value;
                },
                keyboardType: TextInputType.name,
                onSaved: (val) {
                  print("submitted $val");
                },
                initialValue: initialText,
                style: TextStyle(color: Colors.white, fontSize: 18),
                cursorHeight: 20,
                cursorColor: kGreenShadeColor,
                autofocus: true,
                textAlign: TextAlign.left,
                decoration: kInputDecoration,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 45),
                  InkWell(
                    onTap: () async {
                      String imageUrl =
                          Provider.of<UserModelProvider>(context, listen: false)
                              .imageUrl;

                      String name =
                          Provider.of<UserModelProvider>(context, listen: false)
                              .fullName;

                      String bio =
                          Provider.of<UserModelProvider>(context, listen: false)
                              .bio;

                      if (header == 'Enter Name') {
                        Provider.of<UserModelProvider>(context, listen: false)
                            .updateName(updatedValue);

                        await MyUserInfo().updateUserDetails(
                            updatedValue, imageUrl, bio, UserModel.dob);
                      } else {
                        Provider.of<UserModelProvider>(context, listen: false)
                            .updateBio(updatedValue);

                        await MyUserInfo().updateUserDetails(
                            name, imageUrl, updatedValue, UserModel.dob);
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
