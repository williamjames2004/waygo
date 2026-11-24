import 'package:flutter/material.dart';

class Responsive {
  static const double mobileWidth = 600;
  static const double desktopWidth = 900;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= mobileWidth && width < desktopWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopWidth;
  }
}