import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

const Color mainColor = Color(0xff41497A);
Color primaryColor = const Color(0xFFF7F7F7);
Color deepGrey = HexColor('#4E4E4E');
Color scaffoldColor = const Color(0xFFF7F7F7);
Color redColor = HexColor('#D11A2A');
Color inProgressColor = HexColor('#BC0606');
Color grey = const Color(0xFFE8E8E8);
Color gray6 = HexColor('#FAFAFA');
Color textColor = HexColor('#444444');
Color warningColor = Colors.amber;
Color bgColor = HexColor('#F5F5F5');
Color whiteColor = Colors.white;

LinearGradient get gredient => const LinearGradient(
      colors: [
        Color(0xff41497A),
        Color(0xff333B7A),
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomRight,
    );
var gradientBtn = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff41497A),
    Color(0xff333B7A),
  ],
);
var shadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    spreadRadius: -1,
    blurRadius: 4,
  ),
];
