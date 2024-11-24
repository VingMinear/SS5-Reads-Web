import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/success_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../model/user_model.dart';
import '../../../utils/api_base_helper.dart';
import '../../../utils/image_picker.dart';

class AuthController extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();
  Future<void> login({
    required String name,
    required String pwd,
  }) async {
    try {
      var data = await _apiBaseHelper.onNetworkRequesting(
        url: 'login',
        methode: METHODE.post,
        body: {
          "email": name.trim(),
          "password": pwd.trim(),
        },
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        GlobalClass().user.value = UserModel.fromJson(res.data);
        router.pop();
        await LocalStorage.storeData(
          key: 'token',
          value: data['token'] ?? '',
        );

        router.go('/');
      }
    } catch (e) {
      debugPrint("error login $e");
    }
  }

  Future<void> getUser() async {
    try {
      print(LocalStorage.getStringData(key: 'token'));
      var data = await _apiBaseHelper.onNetworkRequesting(
        url: 'user',
        methode: METHODE.get,
        header: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${LocalStorage.getStringData(key: 'token')}',
        },
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        GlobalClass().user.value = UserModel.fromJson(res.data);
      } else if (res.statusCode == 404) {
        LocalStorage.removeData(key: 'token');
      }
    } catch (error) {
      debugPrint(
        'CatchError while getUser ( error message ) : >> $error',
      );
    }
  }

  var txtEmail = TextEditingController();
  var txtPass = TextEditingController();
  void onClear() {
    txtEmail.text = "";
    txtPass.text = "";
  }

  final imageCon = Get.put(ImagePickerProvider());
  static UserModel? userInformation = UserModel();
  updatePhoto() {
    imageCon.imageUrl(userInformation!.photo.image.value);
  }

  Future<void> register({
    required String userName,
    required String email,
    required String password,
    required String ph,
    required String userType,
    required bool isAdmin,
  }) async {
    try {
      bool isTypeAdmin = false;
      if (userType.isNotEmpty && isAdmin) {
        if (userType.toLowerCase() == "admin") {
          isTypeAdmin = true;
        }
      }
      var res = await _apiBaseHelper.onNetworkRequesting(
        url: 'create',
        methode: METHODE.post,
        body: {
          "name": userName.trim(),
          "email": email.trim(),
          "phone": ph.trim(),
          "is_admin": false,
          "active": true,
          "password": password.trim(),
        },
      );

      if (res['code'] == 200) {
        Future.delayed(
          const Duration(milliseconds: 250),
          () {
            if (isAdmin) {
              showTaost("Account has been created successfully 🎉✅");
            } else {
              router.pop();

              showAlertDialog(
                  content: const SuccessScreen(
                desc:
                    '''Your account has been successfully created, and we're excited to have you join our platform.\nThank you for choosing us, and we look forward to serving you!''',
              ));
            }
          },
        );
      } else {
        alertDialog(desc: res['message'] ?? 'Create account faild!');
      }
    } catch (error) {
      debugPrint(
        'CatchError when register this is error : >> $error',
      );
    }
  }
}
