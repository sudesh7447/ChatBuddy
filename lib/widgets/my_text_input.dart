// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:flutter/material.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Stack(
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: Colors.grey.shade700.withOpacity(0.3),
              border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
            ),
            decoration: kTextFormFieldAuthDec.copyWith(
              hintText: hintText,
              prefixIcon: Icon(icon, color: kGreenShadeColor),
              prefixIconColor: Colors.red,
              errorStyle: TextStyle(color: kGreenShadeColor),
            ),
            cursorColor: Colors.grey.shade200,
            controller: controller,
            onSaved: (value) {
              controller.value = controller.value.copyWith(text: value);
            },
            validator: validator,
          ),
        ],
      ),
    );
  }
}
