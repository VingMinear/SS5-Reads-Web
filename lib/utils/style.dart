import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/utils/colors.dart';

import '../constants/Color.dart';

TextStyle appBarTextStyle(
    {Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSized = 17}) {
  return TextStyle(
    fontSize: fontSized,
    fontWeight: weight,
    color: color ?? Colors.black,
  );
}

TextStyle normalText(
    {Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSized = 15}) {
  return TextStyle(
    fontSize: (fontSized),
    fontWeight: weight,
    color: color ?? Colors.black,
  );
}

TextStyle btnTextStyle(
    {Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double fontSized = 15}) {
  return TextStyle(
    fontSize: (fontSized),
    fontWeight: fontWeight,
    color: color ?? Colors.black,
  );
}

BoxDecoration cardBoxDecoration({
  double? raduis,
  Color? color,
  List<BoxShadow>? boxShadow,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(raduis ?? 8),
    color: color ?? Colors.white,
    boxShadow: boxShadow ?? AppColor.cardShadow,
  );
}

BoxDecoration cardDecoration(
    {double? raduis,
    Color? color,
    List<BoxShadow>? boxShadow,
    Gradient? gradient}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(raduis ?? 12),
    boxShadow: boxShadow ?? AppColor.boxShadow,
    color: color ?? whiteColor,
    gradient: gradient,
  );
}

TextStyle hintStyle(
    {Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSized = 15}) {
  return TextStyle(
    fontSize: (fontSized),
    fontWeight: weight,
    color: color ?? Colors.grey,
  );
}

TextStyle errorStyle(
    {Color? color,
    FontWeight weight = FontWeight.w400,
    double fontSized = 13}) {
  return TextStyle(
    fontSize: (fontSized),
    fontWeight: weight,
    color: color ?? Colors.red,
  );
}

class AppText {
  static TextTheme get _txtTheme => Get.context!.textTheme;
  static ThemeData get theme => Get.context!.theme;
  static TextStyle get txt36 => _txtTheme.headlineLarge!; // font size (36),
  static TextStyle get txt25 => _txtTheme.headlineMedium!; // font size (25),
  static TextStyle get txt22 => _txtTheme.headlineSmall!; // font size (22),
  static TextStyle get txt17 => _txtTheme.displayMedium!; // font size (17),
  static TextStyle get txt20 => _txtTheme.titleLarge!; // font size (20),
  static TextStyle get txt18 => _txtTheme.titleMedium!; // font size (18),
  static TextStyle get txt11 => _txtTheme.titleSmall!; // font size (11),
  static TextStyle get txt15 => _txtTheme.bodyMedium!; // font size (15),
  static TextStyle get txt14 => _txtTheme.bodySmall!; // font size (14),
  static TextStyle get txt13 =>
      const TextStyle(fontSize: 14, color: Colors.black); // font size (13),
  static TextStyle get txt16 => _txtTheme.bodyLarge!; // font size (16),
  static TextStyle get txt12 => _txtTheme.displaySmall!; // font size (12),
  static TextStyle get txt21 => _txtTheme.displayLarge!; // font size (21),
}
