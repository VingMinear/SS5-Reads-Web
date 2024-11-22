import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
    required this.child,
    required this.loading,
    this.bgColor,
    this.loadingAdaptive = false,
  });
  final Color? bgColor;
  final Widget child;
  final RxBool loading;
  final bool loadingAdaptive;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        alignment: Alignment.center,
        children: [
          child,
          Visibility(
            visible: loading.value,
            child: Container(
              color: bgColor ?? AppColor.scaffoldBackgroundColor,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 23),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(10),
                child: FadeIn(
                    child: loadingAdaptive
                        ? Platform.isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator()
                        : const SizedBox()),
              ),
            ),
          ),
        ],
      );
    });
  }
}
