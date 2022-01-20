// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

const kHeroTag = 'logo';

const Color kGreenShadeColor = Color(0xff05C764);
const Color kBlueShadeColor = Color(0xff0f090a);

var kTextFormFieldAuthDec = InputDecoration(
  contentPadding: EdgeInsets.only(top: 18, bottom: 18),
  hintStyle: TextStyle(color: Colors.grey.shade700),
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  errorStyle: TextStyle(color: kGreenShadeColor),
);
