import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/firebase_options.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/theme/Theme.dart';
import 'package:homework3/utils/DismissKeyboard.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_test_51PVAzHLRxnMedF0lJIyzjwMxm4VbYhbNQTIag4V8jcRP3cZyC0VwADRMvFbEsXY34gGpDvQ6Eln56qv60l68ZfaO00npQFRFMF';

  await LocalStorage.init();
  setPathUrlStrategy();
  if (!kDebugMode) {
    await CloudFireStore.getServerURl().then((value) {
      if (value.isNotEmpty) {
        baseurl = value;
      }
    });
  }
  if (GlobalClass().isUserLogin) {
    await AuthController().getUser();
  }
  runApp(const MyApp());
}

BuildContext? get globalContext =>
    router.routerDelegate.navigatorKey.currentContext;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: ToastificationWrapper(
        child: GetMaterialApp.router(
          scrollBehavior: const MaterialScrollBehavior().copyWith(),
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          theme: theme(),
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          routerDelegate: router.routerDelegate,
          builder: (context, child) {
            return LoaderOverlay(
              overlayWidgetBuilder: (progress) {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: shadow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FittedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: mainColor,
                      ),
                    ),
                  ),
                );
              },
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: txtScale,
                ),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CloudFireStore extends GetxController {
  static final CollectionReference _server =
      FirebaseFirestore.instance.collection("serverurl");

  static Future<String> getServerURl() async {
    var result = '';
    try {
      await _server.doc('url').get().then((value) {
        result = value['serverUrl'];
      });
    } catch (e) {
      print("error in get User :$e");
    }
    return result;
  }
}
