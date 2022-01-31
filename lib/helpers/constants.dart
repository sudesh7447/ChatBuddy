// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

const kHeroTag = 'logo';
const kHeroTag1 = 'dp';
const kHeroTag2 = 'allUsers';
const kChatHero = 'kChatHero';

const Color kGreenShadeColor = Color(0xff05C764);
const Color kBlueShadeColor = Color(0xff0f090a);
const Color kLightBlueShadeColor = Color(0xff60EEFB);

const kSettingComponentAppBarTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 26,
  fontWeight: FontWeight.w500,
);

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

var kInputDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kGreenShadeColor),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kGreenShadeColor),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: kGreenShadeColor),
  ),
);
