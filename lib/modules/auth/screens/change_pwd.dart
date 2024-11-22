import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/profile/controller/profile_controller.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/primary_button.dart';

import '../../profile/screens/add_address_screen.dart';

class ChangePwdScreen extends StatefulWidget {
  const ChangePwdScreen({super.key});

  @override
  State<ChangePwdScreen> createState() => _ChangePwdScreenState();
}

class _ChangePwdScreenState extends State<ChangePwdScreen> {
  var oldPwd = TextEditingController();
  var obs1 = false.obs;
  var obs2 = false.obs;
  var obs3 = false.obs;
  var newPwd = TextEditingController();
  var newCfPwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        showNotification: false,
        title: 'Change Password',
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Obx(() {
          return Column(
            children: [
              buildField(
                title: 'Current Password :',
                hintText: 'current password',
                required: true,
                controller: oldPwd,
                obSecure: !obs1.value,
                suffixIcon: IconButton(
                  color: Colors.grey,
                  splashRadius: 1,
                  icon: SvgPicture.asset(
                    obs1.value
                        ? 'assets/icons/ic_eye.svg'
                        : 'assets/icons/ic_eye_close.svg',
                    color: Colors.grey,
                  ),
                  onPressed: () => obs1(!obs1.value),
                ),
              ),
              buildField(
                delay: 50,
                title: 'New Password :',
                hintText: 'current new password',
                required: true,
                controller: newPwd,
                obSecure: !obs2.value,
                suffixIcon: IconButton(
                  color: Colors.grey,
                  splashRadius: 1,
                  icon: SvgPicture.asset(
                    obs2.value
                        ? 'assets/icons/ic_eye.svg'
                        : 'assets/icons/ic_eye_close.svg',
                    color: Colors.grey,
                  ),
                  onPressed: () => obs2(!obs2.value),
                ),
              ),
              buildField(
                delay: 100,
                title: 'Confirm New Password:',
                hintText: 'new password',
                required: true,
                controller: newCfPwd,
                obSecure: !obs3.value,
                suffixIcon: IconButton(
                  color: Colors.grey,
                  splashRadius: 1,
                  icon: SvgPicture.asset(
                    obs3.value
                        ? 'assets/icons/ic_eye.svg'
                        : 'assets/icons/ic_eye_close.svg',
                    color: Colors.grey,
                  ),
                  onPressed: () => obs3(!obs3.value),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 190),
                from: 10,
                child: CustomPrimaryButton(
                  textValue: 'Change',
                  textColor: Colors.white,
                  onPressed: () async {
                    dismissKeyboard(context);
                    if (checkValidate()) {
                      loadingDialog();
                      await ProfileController().changePwd(
                        newPwd: newCfPwd.text.trim(),
                        oldPwd: oldPwd.text.trim(),
                      );
                      popLoadingDialog();
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  bool checkValidate() {
    var currentPwd = oldPwd.text.trim();
    var isValidate = false;
    var pwd = newPwd.text.trim();
    var cpwd = newCfPwd.text.trim();
    if (currentPwd.isEmpty || pwd.isEmpty || cpwd.isEmpty) {
      alertDialog(
        desc: 'Please input all required fields',
      );
    } else if (pwd != cpwd) {
      // if pw & cpw not match
      alertDialog(
        desc: 'Your new password and confirm password does not match',
      );
    } else {
      isValidate = true;
    }
    return isValidate;
  }
}
