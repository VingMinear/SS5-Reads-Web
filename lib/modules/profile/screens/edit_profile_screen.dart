import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/modules/admin/product/controller/CardPhoto.dart';
import 'package:homework3/modules/profile/controller/profile_controller.dart';

import '../../../utils/SingleTon.dart';
import '../../../utils/Utilty.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import 'add_address_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var phCon = TextEditingController();
  var user = UserModel();
  var con = Get.put(ProfileController());
  @override
  void initState() {
    user = UserModel.copy(GlobalClass().user.value);
    nameCon.text = user.name ?? '';
    emailCon.text = user.email ?? '';
    phCon.text = user.phone ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        appBar: customAppBar(
          title: 'Edit Profile',
          showNotification: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  FadeIn(
                    child: StatefulBuilder(builder: (context, rebuild) {
                      return CardPhoto(
                        onPhotoPicker: (path) {
                          user.photo = ImageModel.uploadImageWeb(path!);
                          rebuild(() {});
                        },
                        image: user.photo,
                        onClear: () {
                          user.photo = ImageModel.instance;
                          rebuild(() {});
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  const Text("Tap to update your profile here.")
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  buildField(
                    title: 'Name :',
                    hintText: 'Name',
                    required: false,
                    controller: nameCon,
                  ),
                  buildField(
                    delay: 50,
                    title: 'Email :',
                    hintText: 'Email',
                    required: false,
                    controller: emailCon,
                  ),
                  buildField(
                    delay: 100,
                    title: 'Phone number:',
                    hintText: 'Phone number',
                    required: false,
                    controller: phCon,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomPrimaryButton(
              textValue: 'Update',
              textColor: Colors.white,
              onPressed: () async {
                var name = nameCon.text.trim();
                var phone = phCon.text.trim();
                var email = emailCon.text.trim();
                if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
                  if (email.isEmail) {
                    loadingDialog();
                    await con.updateProfile(
                      name: name,
                      email: email,
                      phone: phone,
                      img: user.photo,
                    );
                    popLoadingDialog();
                  } else {
                    alertDialog(desc: 'Invalid email please try again');
                  }
                } else {
                  alertDialog(desc: 'Please input all fields !');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
