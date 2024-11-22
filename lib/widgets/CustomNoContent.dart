import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/style.dart';

class CustomNoContent extends StatelessWidget {
  const CustomNoContent({
    super.key,
    this.isScroll = false,
    this.title,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.alignment,
    this.iconOnTop = true,
  });
  final bool iconOnTop;
  final String? title;
  final bool isScroll;
  final double paddingTop, paddingBottom;
  final AlignmentGeometry? alignment;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, boxCon) {
      return Container(
        alignment: Alignment.center,
        child: FadeIn(
          child: isScroll
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Container(
                    height: boxCon.maxHeight,
                    alignment: alignment ?? Alignment.center,
                    padding: EdgeInsets.only(
                      top: paddingTop,
                      bottom: paddingBottom,
                    ),
                    child: _content(),
                  ),
                )
              : _content(),
        ),
      );
    });
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: iconOnTop,
          child: SizedBox(
            width: (60),
            height: (60),
            child: Image.asset('assets/no-content.png'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !iconOnTop,
              child: SizedBox(
                width: (60),
                height: (60),
                child: Image.asset('assets/no-content.png'),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title ?? 'No record found!',
              style: AppText.txt16.copyWith(color: AppColor.cardDarkColor),
            ),
          ],
        ),
      ],
    );
  }
}
