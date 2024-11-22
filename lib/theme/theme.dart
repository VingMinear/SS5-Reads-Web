import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/Color.dart';

ThemeData theme() {
  return ThemeData(
    fontFamily: 'Urbanist',
    scrollbarTheme: const ScrollbarThemeData(
      radius: Radius.zero,
      thickness: WidgetStatePropertyAll(15),
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldColor,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      surfaceTintColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      backgroundColor: primaryColor,
      shadowColor: Colors.black38,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    primaryColor: primaryColor,
    textTheme: TextTheme(
      displaySmall: TextStyle(
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: mainColor,
    ).copyWith(secondary: mainColor),
  );
}
