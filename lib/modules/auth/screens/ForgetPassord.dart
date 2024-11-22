import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
  final bool isChanged;
  const ForgetPasswordScreen({
    super.key,
    required this.isChanged,
  });
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController(text: '');

  var authCon = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: customAppBar(
        showNotification: false,
        title: widget.isChanged ? 'Change Password' : 'Forget Password',
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 22,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 120),
                from: 10,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/images/logo2.jpg',
                    ),
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 120),
                from: 10,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter your email to reset your password.\nWe will send you a link to your account.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    InputField(
                      hintText: 'Email',
                      autofocus: false,
                      controller: emailController,
                      suffixIcon: const SizedBox(),
                      onChanged: (p0) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 190),
                from: 10,
                child: CustomPrimaryButton(
                  textValue: 'Send',
                  textColor: Colors.white,
                  onPressed: () async {
                    dismissKeyboard(context);
                    if (emailController.text.isNotEmpty) {
                      // loadingDialog();
                      // await Authentication()
                      //     .resetPassword(
                      //   email: emailController.text.trim(),
                      // )
                      //     .then((value) {
                      //   if (value) {
                      //     Get.back();
                      //     Get.to(
                      //       SuccessScreen(
                      //         desc:
                      //             'We had already sent you a link for reset your password.\nPlease check in your mail',
                      //         titleBtn: widget.isChanged ? 'Back' : null,
                      //       ),
                      //     );
                      //   }
                      // });
                    } else {
                      alertDialog(desc: 'Please enter your email address');
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
