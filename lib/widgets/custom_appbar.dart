import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/routes/routes.dart';

AppBar customAppBar({
  String title = '',
  bool showNotification = true,
  double? elevation,
  Color? backgroundColor,
  Color? foregroundColor,
  double? toolbarHeight,
  double? leadingWidth,
  bool automaticallyImplyLeading = true,
  double spaceLeft = 10,
  Widget? leading,
  bool useLeadingCustom = true,
  Color? txtColor,
  Color? iconColor,
  Widget? action,
  PreferredSizeWidget? bottom,
  Function()? onPress,
}) {
  return AppBar(
    leading: useLeadingCustom
        ? IconButton(
            onPressed: () {
              router.pop();
              if (onPress != null) {
                onPress();
              }
            },
            icon: const Icon(
              Icons.clear_rounded,
            ),
            color: Colors.black,
          )
        : leading,
    automaticallyImplyLeading: automaticallyImplyLeading,
    toolbarHeight: toolbarHeight,
    leadingWidth: leadingWidth,
    elevation: elevation,
    backgroundColor: backgroundColor,
    bottom: bottom,
    title: Text(
      title,
      style: TextStyle(
        color: txtColor,
      ),
    ),
    actions: [
      action ?? const SizedBox.shrink(),
      SizedBox(width: spaceLeft),
    ],
  );
}
