import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/modules/auth/screens/register_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/ListExtension.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/logo.dart';
import 'package:homework3/widgets/primary_button.dart';

import '../../../utils/Utilty.dart';
import '../../../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  var authCon = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: shadow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: appHeight(percent: 0.8),
        ),
        child: Stack(
          children: [
            _rightSide(),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  router.pop();
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSplit() {
    return appWidth() >= BreakPoint.md;
  }

  Widget _rightSide() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Logo()),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'SS5 Reads',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Email',
                      autofocus: false,
                      suffixIcon: const SizedBox(),
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InputField(
                      delay: 100,
                      autofocus: false,
                      hintText: 'Password',
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      onSubmitted: (p0) async {
                        await _onClickLogin(context);
                      },
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        splashRadius: 1,
                        icon: SvgPicture.asset(
                          passwordVisible
                              ? 'assets/icons/ic_eye.svg'
                              : 'assets/icons/ic_eye_close.svg',
                          color: Colors.grey,
                        ),
                        onPressed: togglePassword,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FadeInDown(
                from: 19,
                child: CustomPrimaryButton(
                  textValue: 'Login',
                  textColor: Colors.white,
                  onPressed: () async {
                    await _onClickLogin(context);
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                  ),
                  InkWell(
                    onTap: () {
                      router.pop();
                      showAlertDialog(
                        context: context,
                        content: const RegisterScreen(),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _onClickLogin(BuildContext context) async {
    var email = emailController.text.trim();
    var pwd = passwordController.text.trim();
    if (email.isEmpty || pwd.isEmpty) {
      if (email.isEmpty) {
        alertDialog(desc: 'Please enter your email.', context: context);
      } else {
        alertDialog(desc: 'Please enter your password.', context: context);
      }
    } else {
      loadingDialog();
      await authCon.login(
        name: email,
        pwd: pwd,
      );
      popLoadingDialog();
    }
  }

  Widget _leftSide() {
    return Container(
      width: appWidth() >= BreakPoint.sm
          ? appWidth(percent: 0.35)
          : double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: gredient,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Back !",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const Text(
            "Nice to meet you again",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const Text(
            "Please input email and password fields to login into systems.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ].gap(3),
      ),
    );
  }
}
