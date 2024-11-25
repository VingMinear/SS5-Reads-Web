import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/modules/admin/product/controller/adproduct_con.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';

class ProfileController extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();

  Future<void> updatePhoto({required ImageModel img}) async {
    try {
      var photo = '';
      if (img.photoViewBy == PhotoViewBy.file && img.image.value.isNotEmpty ||
          img.bytes != null) {
        photo = await AdminProductController().uploadPhoto(img);
      }

      var data = await _apiBaseHelper.onNetworkRequesting(
        header: null,
        url: 'users-photo/${GlobalClass().userId}',
        body: {
          'photo': photo,
        },
        methode: METHODE.post,
      );
      checkResponse(data);
    } catch (error) {
      debugPrint(
        'CatchError while updatePhoto ( error message ) : >> $error',
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required ImageModel img,
    required String phone,
  }) async {
    try {
      if (img.photoViewBy != PhotoViewBy.network) {
        await updatePhoto(img: img);
      }

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
        router.pop();
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
        router.pop();
        showTaost('Your password has been updated');
      }
    } catch (error) {
      debugPrint(
        'CatchError while changePwd ( error message ) : >> $error',
      );
    }
  }
}
