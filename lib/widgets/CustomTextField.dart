import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/utils/style.dart';

class CustomTextField extends StatelessWidget {
  final double? borderRadius, borderWidth;
  final TextEditingController? controller;
  final String? hint, validatText, labelText;
  final TextInputType? textInputType;
  final bool enable, readOnly, validator;
  final bool? autoFocus;

  final EdgeInsetsGeometry? containPadding;
  final TextInputAction? textInputAction;
  final double? height, heightError;
  final int? maxLine;
  final Widget? prefixIcon, suffixIcon, prefix, label;
  final TextStyle? hintTextStyle, textStyle;
  final Color? borderWidthColor, backGroundColor;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;

  final TextAlignVertical? textAlignVertical;
  final Function(String text)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool isObsecured, showBorder;

  const CustomTextField({
    super.key,
    this.borderRadius,
    this.borderWidth,
    this.hint,
    this.hintTextStyle,
    this.textStyle,
    this.borderWidthColor,
    this.backGroundColor,
    this.onChange,
    this.controller,
    this.enable = true,
    this.textInputType,
    this.maxLine,
    this.height,
    this.autoFocus,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.containPadding,
    this.prefix,
    this.textAlignVertical,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.inputFormatters,
    this.focusNode,
    this.validator = false,
    this.maxLength,
    this.validatText,
    this.isObsecured = false,
    this.labelText,
    this.label,
    this.showBorder = false,
    this.heightError,
  });

  @override
  Widget build(BuildContext context) {
    var defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 5),
      borderSide: showBorder
          ? BorderSide(
              width: borderWidth ?? 1,
              color: borderWidthColor ?? Colors.grey[200]!,
            )
          : BorderSide.none,
    );
    return TextFormField(
      enableSuggestions: true,
      autocorrect: false,
      style: textStyle ?? normalText(color: Colors.white),
      textInputAction: textInputAction ?? TextInputAction.done,
      controller: controller,
      obscureText: isObsecured,
      obscuringCharacter: '*',
      enabled: enable,
      autofocus: autoFocus ?? false,
      readOnly: readOnly,
      buildCounter: (context,
          {required currentLength, required isFocused, maxLength}) {
        return maxLength != null
            ? Text(
                "$currentLength/$maxLength",
                style: TextStyle(
                  color: AppColor.cardDarkColor,
                ),
              )
            : null;
      },
      maxLength: maxLength,
      validator: validator
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return validatText ?? 'Please fill this field';
              }
              return null;
            }
          : null,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      maxLines: maxLine ?? 1,
      focusNode: focusNode,
      textAlignVertical: textAlignVertical,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintTextStyle ?? hintStyle(),
        prefixIcon: prefixIcon,
        prefix: prefix,
        labelText: labelText,
        label: label,
        labelStyle: hintTextStyle ?? hintStyle(),
        prefixStyle: normalText(),
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: defaultBorder,
        suffixIcon: suffixIcon,
        disabledBorder: defaultBorder,
        fillColor: backGroundColor ?? Colors.transparent,
        filled: true,
        errorStyle: errorStyle(fontSize: heightError ?? 0),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          borderSide: BorderSide(
            width: borderWidth ?? 1,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          borderSide: BorderSide(
            width: borderWidth ?? 1,
            color: Colors.red,
          ),
        ),
        contentPadding:
            containPadding ?? const EdgeInsets.symmetric(horizontal: 15),
      ),
      onChanged: onChange,
    );
  }
}
