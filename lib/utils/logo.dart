import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.width, this.height});
  final double? width, height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 120,
      child: Image.asset(
        'assets/images/logo_title.png',
      ),
    );
  }
}
