import 'package:flutter/material.dart';
import 'package:homework3/utils/Utilty.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      //color: Colors.pink,
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -80,
            child: Container(
              width: appWidth() * 0.50,
              height: appWidth() * 0.50,
              decoration: BoxDecoration(
                color: const Color(0xFFF9CA26).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 20,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
