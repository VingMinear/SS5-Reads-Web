import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../constants/Color.dart';

Widget cardContact(
    {required String title, required String icon, void Function()? onTap}) {
  return Builder(
    builder: (context) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: mainColor.withOpacity(0.8),
                  child: SvgPicture.asset(icon),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: context.textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
