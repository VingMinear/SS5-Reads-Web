import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/NumExtension.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/widgets/CustomTextField.dart';
import 'package:homework3/widgets/ModifyRow.dart';

class TemplateUI extends StatelessWidget {
  const TemplateUI({
    super.key,
    this.title,
    this.subTitle,
    this.action,
    required this.content,
    this.onChanged,
    this.spaceTitle,
    this.spaceContent,
    this.showSearch = true,
    this.txtSearch,
    this.showBackBtn = false,
    this.isScroll = false,
    this.filter,
    this.padding,
  });
  final bool showBackBtn, isScroll;

  final TextEditingController? txtSearch;
  final String? title;
  final String? subTitle;
  final List<Widget>? action, filter;
  final Widget content;
  final double? spaceTitle, spaceContent;
  final bool showSearch;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191826),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: isScroll
            ? SingleChildScrollView(
                padding: padding ?? EdgeInsets.all(20.scale),
                child: _content(),
              )
            : Padding(
                padding: padding ?? EdgeInsets.all(20.scale),
                child: _content(),
              ),
      ),
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showBackBtn,
          child: SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                router.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                elevation: 0,
                overlayColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const ModifyRow(
                mainAxisSize: MainAxisSize.min,
                left: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.deepPurple,
                ),
                right: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subTitle ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.txtDarkColor,
                  ),
                ),
              ],
            ),
            if (action != null) ...action!,
          ],
        ),
        SizedBox(height: spaceTitle ?? 25),
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 10,
          children: [
            if (filter != null) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                children: filter!,
              ),
              const SizedBox(width: 20),
            },
            Visibility(
              visible: showSearch,
              child: StatefulBuilder(builder: (context, setState) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 230),
                  width: 290,
                  height: 43,
                  child: CustomTextField(
                    borderRadius: 50,
                    controller: txtSearch,
                    textStyle: const TextStyle(color: Colors.white),
                    onChange: (text) {
                      if (onChanged == null) return;
                      onChanged!(text);
                      setState(() {});
                    },
                    prefixIcon: IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        if (txtSearch == null) return;
                        setState(() {
                          txtSearch!.clear();
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                    ),
                    suffixIcon: (txtSearch?.text ?? "").isNotEmpty
                        ? IconButton(
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                txtSearch!.clear();
                                onChanged!("");
                              });
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: Colors.white70,
                            ),
                          ).paddingOnly(right: 3)
                        : null,
                    hint: "Search...",
                    showBorder: true,
                  ),
                );
              }),
            ),
          ],
        ),
        SizedBox(height: spaceContent ?? 15),
        content,
      ],
    );
  }
}
