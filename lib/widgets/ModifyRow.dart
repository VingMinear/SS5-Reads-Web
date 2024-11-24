import 'package:flutter/material.dart';

class ModifyRow extends StatelessWidget {
  const ModifyRow({
    super.key,
    required this.left,
    required this.right,
    this.mainAxisAlignment,
    this.spacing,
    this.crossAxisAlignment,
    this.padding,
    this.mainAxisSize = MainAxisSize.max,
  });
  final Widget left;
  final double? spacing;
  final Widget right;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final MainAxisSize mainAxisSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          left,
          SizedBox(
            width: spacing ?? 5,
          ),
          right,
        ],
      ),
    );
  }
}
