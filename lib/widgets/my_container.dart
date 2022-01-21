// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/main.dart';
import 'package:flutter/material.dart';

class MyContainer1 extends StatelessWidget {
  const MyContainer1({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
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
    required this.mainText,
    this.isEdited = true,
    this.onTap,
    this.isEditOn = false,
  }) : super(key: key);

  final String mainText;
  final IconData icon;
  final bool isEdited, isEditOn;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                  mainText,
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ],
            ),
            Row(
              children: [
                isEdited
                    ? InkWell(
                        onTap: () {
                          onTap!();
                        },
                        child: !isEditOn
                            ? Icon(
                                Icons.edit,
                                color: kGreenShadeColor,
                                size: 20,
                              )
                            : Icon(
                                Icons.done,
                                color: kGreenShadeColor,
                                size: 20,
                              ),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
