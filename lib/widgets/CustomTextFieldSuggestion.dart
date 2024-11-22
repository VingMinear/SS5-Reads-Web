import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/style.dart';

class CustomTextFildSuggestion extends StatelessWidget {
  CustomTextFildSuggestion({
    super.key,
    required this.onChanged,
    required this.suggestionsCallback,
    required this.listReasons,
    required this.value,
  });
  final void Function(String?) onChanged;
  final String? value;
  final FutureOr<Iterable<String>> Function(String) suggestionsCallback;

  final isSuggesOpened = false.obs;
  final List<String> listReasons;
  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 0,
        color: Colors.grey[200]!,
      ),
    );
    var style = AppText.txt14;
    var controller = TextEditingController();
    var isNotEmpty = false.obs;
    return Obx(
      () => TypeAheadField<String>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controller,
          onTap: () {
            isSuggesOpened(true);
          },
          onTapOutside: (a) {
            isSuggesOpened(false);
            onChanged(controller.text);
          },
          onSubmitted: (value) {
            isSuggesOpened(false);
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              isNotEmpty(true);
            } else {
              isNotEmpty(false);
            }
          },
          decoration: InputDecoration(
            hintText: 'Reason',
            labelStyle: style,
            hintStyle: style,
            floatingLabelStyle: style,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: isNotEmpty.value || controller.text.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      controller.clear();
                      isNotEmpty(false);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/order/ic_clear.svg',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    isSuggesOpened.value
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            fillColor: AppColor.txtFieldColor,
            filled: true,
          ),
        ),
        hideOnLoading: true,
        animationDuration: Duration.zero,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        suggestionsBoxVerticalOffset: 7,
        noItemsFoundBuilder: (context) {
          return ListTile(
            title: Text(
              controller.text,
              style: style,
            ),
          );
        },
        itemBuilder: (context, itemData) {
          return ListTile(
            title: Text(
              itemData,
              style: style,
            ),
          );
        },
        suggestionsCallback: suggestionsCallback,
        onSuggestionSelected: (suggestion) {
          controller.text = suggestion;
          isNotEmpty(true);
          onChanged(controller.text);
        },
      ),
    );
  }
}
