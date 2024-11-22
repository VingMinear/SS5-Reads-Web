import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/routes/routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/SingleTon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.logout = false});
  final bool logout;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkUser();
    });
    super.initState();
  }

  var scale = 1.0;

  checkUser() async {
    if (widget.logout) {
      GlobalClass().user.value = UserModel();
    }
    if (GlobalClass().isUserLogin) {
      await AuthController().getUser();
      scale = 0;
      setState(() {});

      router.go(GlobalClass().user.value.isAdmin ? '/admin' : '/home');
    } else {
      scale = 0;
      setState(() {});
      router.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      mainColor,
    ];
    var colorizeTextStyle = const TextStyle(
      fontSize: 23.0,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: scale,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  LoadingAnimationWidget.dotsTriangle(
                    color: mainColor,
                    size: 45,
                  ),
                  const SizedBox(height: 15),
                  FadeIn(
                    child: SizedBox(
                      height: 100,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'SS5 Reads',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                        repeatForever: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
