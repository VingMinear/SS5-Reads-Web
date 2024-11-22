import 'package:flutter/material.dart';

import '../model/category.dart';

class CustomDropdownFormField extends StatelessWidget {
  const CustomDropdownFormField({
    super.key,
    this.radius,
    this.padding,
    this.backgroundColor = Colors.white,
    this.label,
    this.suffixIcon,
    this.labelText,
    this.hint,
    required this.onChanged,
    required this.list,
    required this.cate,
  });
  final Category? cate;
  final List<Category> list;
  final double? radius, padding;
  final Color backgroundColor;
  final Widget? label;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hint;
  final void Function(Category?) onChanged;
  @override
  Widget build(BuildContext context) {
    var hintStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
    return DropdownButtonFormField<Category>(
      borderRadius: BorderRadius.circular(15),
      isDense: true,
      isExpanded: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor,
        hintText: hint,
        suffixIcon: suffixIcon,
        hintStyle: hintStyle,
        label: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        labelText: labelText,
        isDense: true,
        labelStyle: hintStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: cate,
      onChanged: onChanged,
      items: List.generate(list.length, (index) {
        return DropdownMenuItem<Category>(
          value: list[index],
          child: Text(
            list[index].title.trim(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }),
    );
  }
}
