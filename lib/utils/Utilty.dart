import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homework3/main.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/SizeDevice.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/style.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color.dart';
import '../widgets/CustomButton.dart';
import '../widgets/primary_button.dart';
import 'LocalStorage.dart';

const String kIconPath = 'assets/icons';
const String myImgUrl =
    'https://lh3.googleusercontent.com/a/ACg8ocIH_3zFamOQ46B_GgvHZ3lCBAsxHiuje4ku9RDe-7Wgf3A=s360-c-no';
dismissKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

showTaost(String desc, {ToastificationType? type}) {
  toastification.show(
    context: globalContext!, // optional if you use ToastificationWrapper
    title: Text(desc),
    autoCloseDuration: const Duration(seconds: 2),
    style: ToastificationStyle.minimal,
    animationDuration: const Duration(milliseconds: 330),
    pauseOnHover: false,
    type: type ?? ToastificationType.success,
    alignment: Alignment.bottomRight, borderRadius: BorderRadius.circular(8),
  );
}

//----------prefix---------------
// url > https:
// email to > mailto:
// call > tel:
// message > sms:
Future<bool> callLaunchUrl({
  required String url,
  LaunchMode mode = LaunchMode.externalApplication,
  WebViewConfiguration? webViewConfiguration,
}) async {
  try {
    if (!await launchUrl(
      Uri.parse(url),
      mode: mode,
    )) {
      debugPrint('Could not launch : $url');
      return false;
    } else {
      return true;
    }
  } on Exception catch (e) {
    debugPrint('Erorr: $e');
    return false;
  }
}

extension Context on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension Format on double {
  String get formatCurrency {
    final result = NumberFormat("#,##0.00", "en_US");
    return result.format(this);
  }
}

loadingDialog() async {
  print('loading');
  globalContext!.loaderOverlay.show();
}

popLoadingDialog() {
  print('off');
  globalContext!.loaderOverlay.hide();
}

double appHeight({double percent = 1}) {
  return MediaQuery.of(globalContext!).size.height * percent;
}

double appWidth({double percent = 1}) {
  return MediaQuery.of(globalContext!).size.width * percent;
}

Future pushScreenWidget(
  Widget Function() screen, {
  dynamic arguments,
  Transition? transition,
}) async {
  await Get.to(
    screen,
    arguments: arguments,
    transition: transition,
    preventDuplicates: true,
  );
}

alertDialogConfirmation({
  String? title,
  String? desc,
  String? txtBtnCfn,
  String? txtBtnCancel,
  Color? btnCancelColor,
  void Function()? onConfirm,
}) {
  showDialog(
    context: globalContext!,
    barrierColor: LoaderOverlay.defaultOverlayColor,
    builder: (context) {
      return Builder(
        builder: (context) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Dialog(
                surfaceTintColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title ?? "",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        desc ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              borderSide: BorderSide(
                                  color: btnCancelColor ?? mainColor),
                              backgroundColor: Colors.transparent,
                              textStyle: TextStyle(
                                color: btnCancelColor ?? mainColor,
                                fontSize: 17,
                              ),
                              title: txtBtnCancel ?? 'Cancel',
                              onPress: () {
                                router.pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButton(
                              title: txtBtnCfn ?? 'Confirm',
                              onPress: () {
                                onConfirm!();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

TextScaler get txtScale {
  var sizeDevice = SizeDevice();
  var scale = 1.2;
  if (sizeDevice.isXtraSmallScreen) {
    debugPrint("Screen is isXtraSmallScreen");
    scale = 0.8;
  } else if (sizeDevice.isSmallScreen) {
    debugPrint("Screen is isSmallScreen");
    scale = 0.8;
  } else if (sizeDevice.isNormalScreen) {
    debugPrint("Screen is isNormalScreen");
    scale = 0.85;
  } else if (sizeDevice.isMediumScreen) {
    debugPrint("Screen is isMediumScreen");
    scale = 0.9;
  } else {
    debugPrint("Screen is Large");
    scale = 1;
  }
  return TextScaler.linear(scale);
}

int gridCount(double width) {
  if (width <= 300) {
    return 1;
  } else if (width <= 580) {
    return 2;
  } else if (width <= 800) {
    return 3;
  } else if (width <= 1100) {
    return 4;
  } else {
    return 5;
  }
}

void logOut() async {
  LocalStorage.removeData(key: "token");
  router.go('/');
}

Future showAlertDialog({
  BuildContext? context,
  required Widget content,
  Color? barrierColor,
}) async {
  return await showDialog(
    context: context ?? globalContext!,
    barrierColor: barrierColor ?? LoaderOverlay.defaultOverlayColor,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: BreakPoint.sm),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: content,
          ),
        ),
      ),
    ),
  );
}

Future<void> alertDialog({
  BuildContext? context,
  String? title,
  required String desc,
  String? txtBtn,
  void Function()? onCf,
  bool barrierDismissible = true,
  bool showBarrierColor = true,
}) async {
  await showDialog(
    context: context ?? globalContext!,
    barrierColor: LoaderOverlay.defaultOverlayColor,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return barrierDismissible ? true : false;
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25).copyWith(
                      top: 40,
                      bottom: 25,
                    ),
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title ?? 'Ops',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          desc,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: appWidth() / 3,
                            child: CustomPrimaryButton(
                              textValue: 'Ok',
                              textColor: Colors.white,
                              onPressed: onCf ??
                                  () {
                                    router.pop();
                                  },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'images/warning.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

customalertDialogConfirmation({
  String? title,
  String? desc,
  String? txtBtnCfn,
  String? txtBtnCancel,
  Widget? child,
  void Function()? onConfirm,
  EdgeInsetsGeometry? paddingBody,
  EdgeInsetsGeometry? paddingButton,
  bool barrierDismissible = true,
}) async {
  await showDialog(
    context: globalContext!,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return barrierDismissible;
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Dialog(
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((14)),
                ),
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title ?? '',
                              style: AppText.txt16.copyWith(),
                            ),
                            IconButton(
                              onPressed: () {
                                router.pop();
                              },
                              icon: const Icon(
                                Icons.clear_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: paddingBody ??
                            const EdgeInsets.all(20.0).copyWith(top: 10),
                        child: Column(
                          children: [
                            child ?? const SizedBox.shrink(),
                            Padding(
                              padding: paddingButton ??
                                  const EdgeInsets.all(20.0).copyWith(top: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      backgroundColor: Colors.transparent,
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                      textStyle: btnTextStyle(
                                        color: Colors.red,
                                      ),
                                      title: txtBtnCancel ?? 'cancel'.tr,
                                      onPress: () {
                                        router.pop();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomButton(
                                      title: txtBtnCfn ?? 'cf'.tr,
                                      onPress: onConfirm ?? () {},
                                      textStyle: btnTextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
