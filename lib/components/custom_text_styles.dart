import 'package:flutter/material.dart';
import '../constants/custom_color.dart';

class CustomTextStyles {
  static TextStyle textTitle({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: 24,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textSubTitle({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textHeading({
    Color color = CustomColor.grey,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textSubHeading({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textCommon({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textLabel({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textSubLabel({
    Color color = CustomColor.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 10,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
