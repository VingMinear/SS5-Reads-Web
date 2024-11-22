import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_detail.dart';
import 'package:homework3/modules/profile/screens/add_address_screen.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';
import 'package:homework3/utils/image_picker.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';

class EditAdminUser extends StatefulWidget {
  const EditAdminUser({super.key, required this.user});
  final UserModel user;
  @override
  State<EditAdminUser> createState() => _EditAdminUserState();
}

class _EditAdminUserState extends State<EditAdminUser> {
  var nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var phCon = TextEditingController();
  var user = UserModel().obs;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user.value = widget.user;
      userType = user.value.isAdmin ? listType.first : listType.last;
      nameCon.text = user.value.name ?? '';
      emailCon.text = user.value.email ?? '';
      phCon.text = user.value.phone ?? '';
    });
    super.initState();
  }

  var userType = listType.first;
  static var listType = ["Admin", "Customer"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Edit User',
        showNotification: false,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  FadeIn(
                    child: GestureDetector(
                      onTap: () {
                        dismissKeyboard(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return cupertinoModal(context, (index) async {
                              Get.back();

                              await ImagePickerProvider()
                                  .pickImage(
                                source: index == 0
                                    ? ImageSource.gallery
                                    : ImageSource.camera,
                                updateProfile: true,
                                userId: user.value.id ?? '',
                              )
                                  .then((value) {
                                user.value.photo = value;
                              });
                            });
                          },
                        );
                      },
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CustomCachedNetworkImage(
                          imgUrl: user.value.photo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Tap to update profile user here.")
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
                  Row(
                    children: [
                      Expanded(
                        child: buildField(
                          title: 'Name :',
                          hintText: 'Name',
                          required: false,
                          controller: nameCon,
                        ),
                      ),
                      Expanded(
                        child: FadeInLeft(
                          from: 20,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeInLeft(
                                      from: 10,
                                      child: const Row(
                                        children: [
                                          Text("User Type :"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      borderRadius: BorderRadius.circular(15),
                                      isDense: true,
                                      isExpanded: true,
                                      value: userType,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: grey.withOpacity(0.4),
                                        hintText: "User Type",
                                        hintStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        userType = value!;
                                      },
                                      items: List.generate(listType.length,
                                          (index) {
                                        return DropdownMenuItem<String>(
                                          value: listType[index],
                                          child: Text(
                                            listType[index].trim(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildField(
                          delay: 50,
                          title: 'Email :',
                          hintText: 'Email',
                          readOnly: true,
                          required: false,
                          controller: emailCon,
                        ),
                      ),
                    ],
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
                    await updateProfile(
                      email,
                      name,
                      phone,
                      useId: widget.user.id!,
                    );
                  } else {
                    alertDialog(desc: 'Invalid Email please try again');
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

  final _apiBaseHelper = ApiBaseHelper();
  Future<void> updateProfile(
    String email,
    String name,
    String phone, {
    required String useId,
  }) async {
    try {
      bool isTypeAdmin = false;
      if (userType.isNotEmpty) {
        if (userType.toLowerCase() == "admin") {
          isTypeAdmin = true;
        }
      }
      var res = await _apiBaseHelper.onNetworkRequesting(
        url: 'users/$useId',
        methode: METHODE.update,
        body: {
          "name": name.trim(),
          "email": email.trim(),
          "phone": phone.trim(),
          "is_admin": isTypeAdmin,
          "active": true,
        },
      );
      var data = checkResponse(res);
      if (data.isSuccess) {
        Get.back();
        showTaost('User has been updated');
      }
    } catch (error) {
      log(
        'CatchError while enableUser ( error message ) : >> $error',
      );
    }
  }
}
