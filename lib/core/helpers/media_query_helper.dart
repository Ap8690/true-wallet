import 'package:flutter/material.dart';

class MediaQueryHelper {
  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }
}