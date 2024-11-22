import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/admin/product/controller/adproduct_con.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';

class ProfileController extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();

  Future<void> updatePhoto({required String img}) async {
    try {
      var photo = await AdminProductController().uploadPhoto(img);
      var data = await _apiBaseHelper.onNetworkRequesting(
        header: null,
        url: 'users-photo/${GlobalClass().userId}',
        body: {
          'photo': photo,
        },
        methode: METHODE.post,
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        await Get.put(AuthController()).getUser();
        showTaost('Profile photo has been updated');
      }
    } catch (error) {
      debugPrint(
        'CatchError while updatePhoto ( error message ) : >> $error',
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      var data = await _apiBaseHelper.onNetworkRequesting(
        url: 'users/${GlobalClass().userId}',
        methode: METHODE.update,
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "is_admin": GlobalClass().user.value.isAdmin,
          "active": true,
        },
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        Get.back();
        await Get.put(AuthController()).getUser();
        showTaost('Profile has been updated');
      }
    } catch (error) {
      debugPrint(
        'CatchError while updateProfile ( error message ) : >> $error',
      );
    }
  }

  Future<void> changePwd({
    required String oldPwd,
    required String newPwd,
  }) async {
    try {
      var data = await _apiBaseHelper.onNetworkRequesting(
        url: 'change-pwd/${GlobalClass().userId}',
        methode: METHODE.post,
        body: {
          "old_password": oldPwd,
          "new_password": newPwd,
        },
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        Get.back();
        showTaost('Your password has been updated');
      }
    } catch (error) {
      debugPrint(
        'CatchError while changePwd ( error message ) : >> $error',
      );
    }
  }
}
