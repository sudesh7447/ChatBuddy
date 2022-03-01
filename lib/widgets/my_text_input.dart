// ignore_for_file: prefer_const_constructors

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTextInput extends StatefulWidget {
  const MyTextInput({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final TextInputAction textInputAction;

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Stack(
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: isDark
                  ? Colors.grey.shade700.withOpacity(0.3)
                  : Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : kBlueShadeColor,
              fontSize: 16,
            ),
            decoration: kTextFormFieldAuthDec.copyWith(
              hintText: widget.hintText,
              prefixIcon: Icon(
                widget.icon,
                color: kGreenShadeColor,
              ),
              errorStyle: TextStyle(color: kGreenShadeColor),
            ),
            textInputAction: widget.textInputAction,
            cursorColor: isDark ? Colors.grey.shade200 : kBlueShadeColor,
            controller: widget.controller,
            onSaved: (value) {
              widget.controller.value =
                  widget.controller.value.copyWith(text: value);
            },
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

class MyTextInputChat extends StatefulWidget {
  const MyTextInputChat({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.onImage,
    this.onSend,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final Function? onImage, onSend;

  @override
  State<MyTextInputChat> createState() => _MyTextInputChatState();
}

class _MyTextInputChatState extends State<MyTextInputChat> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark
                  ? Colors.grey.shade700.withOpacity(0.3)
                  : Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade700.withOpacity(0.15)),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.black,
              fontSize: 16,
            ),
            decoration: kTextFormFieldAuthDec.copyWith(
              hintText: widget.hintText,
              prefixIcon: InkWell(
                  onTap: () {
                    widget.onImage!();
                  },
                  child: Icon(widget.icon, color: kGreenShadeColor)),
              prefixIconColor: Colors.red,
              suffixIcon: InkWell(
                onTap: () {
                  widget.onSend!();
                },
                child: Icon(
                  Icons.send,
                  color: kGreenShadeColor,
                  size: 30,
                ),
              ),
              errorStyle: TextStyle(color: kGreenShadeColor),
              hintStyle: TextStyle(
                color: isDark ? Colors.white.withOpacity(0.5) : Colors.black45,
              ),
            ),
            textInputAction: TextInputAction.done,
            // maxLines: null,
            // expands: true,
            cursorColor: isDark ? Colors.grey.shade200 : Colors.black,
            controller: widget.controller,
            onSaved: (value) {
              widget.controller.value =
                  widget.controller.value.copyWith(text: value);
            },
          ),
        ],
      ),
    );
  }
}
