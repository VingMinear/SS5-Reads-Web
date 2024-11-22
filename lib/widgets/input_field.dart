import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework3/utils/style.dart';

import '../constants/Color.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool obscureText, readOnly, animate, autofocus;
  final Widget? suffixIcon;
  final int? delay, maxLines;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  const InputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.delay,
    this.animate = true,
    this.autofocus = false,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return animate
        ? FadeInDown(
            from: 20,
            delay: Duration(milliseconds: delay ?? 0),
            child: field(),
          )
        : field();
  }

  TextField field() {
    var border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(6),
    );
    return TextField(
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        // hintText: hintText,
        labelText: hintText,
        labelStyle: hintStyle(),
        filled: true,
        border: border,
        enabledBorder: border,
        focusedBorder:
            border.copyWith(borderSide: const BorderSide(color: mainColor)),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
