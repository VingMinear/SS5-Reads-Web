import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class CardDecoration extends StatelessWidget {
  const CardDecoration({
    super.key,
    required this.child,
    this.isPromotion = false,
  });
  final Widget child;
  final bool isPromotion;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: isPromotion
            ? DottedDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.darkGrey,
                dash: const [4],
                shape: Shape.box,
              )
            : null,
        child: child,
      ),
    );
  }
}
