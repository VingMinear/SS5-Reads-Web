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
    var border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(6),
    );
    return DropdownButtonFormField<Category>(
      borderRadius: BorderRadius.circular(15),
      isDense: true,
      isExpanded: false,
      hint: Text(hint ?? ''),
      decoration: InputDecoration(
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: hintStyle,
        label: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        labelText: labelText,
        isDense: true,
        labelStyle: hintStyle,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
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
