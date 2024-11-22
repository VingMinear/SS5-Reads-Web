import 'package:flutter/material.dart';

class MenuIcons extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final double? size;
  const MenuIcons({
    super.key,
    this.icon,
    this.label,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          // ignore: avoid_returning_null_for_void
          onPressed: (() => null),
          icon: Icon(
            icon,
            size: size,
            color: const Color(0xFFF9CA26),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label!,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
