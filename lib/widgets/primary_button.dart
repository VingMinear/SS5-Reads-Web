import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Color? buttonColor;
  final String? textValue;
  final Color? textColor;
  final Function() onPressed;
  final double? space;
  final Widget? prefix;
  const CustomPrimaryButton({super.key, 
    this.buttonColor,
    this.textValue,
    this.textColor,
    required this.onPressed,
    this.space,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 0,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: buttonColor ?? mainColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix ?? const SizedBox(),
                  SizedBox(width: space),
                  Text(
                    textValue ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
