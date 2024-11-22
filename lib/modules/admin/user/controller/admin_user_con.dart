import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';

class AdminUserCon extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();
  var listUser = <UserModel>[].obs;
  var backuplist = <UserModel>[];
  var loading = false.obs;
  Future<void> removeUser({required String userID}) async {
    try {
      // await CloudFireStore().removeUser(docId: docId);users-delete
      var res = await _apiBaseHelper.onNetworkRequesting(
        url: 'users-delete/$userID',
        methode: METHODE.post,
        body: {},
      );
      var data = checkResponse(res);
      if (data.isSuccess) {
        await fetchCustomer();
        showTaost('User has been deleted');
      }
    } catch (error) {
      log(
        'CatchError while removeUser ( error message ) : >> $error',
      );
    }
  }

  Future<void> searchUser({required String text}) async {
    if (text.isEmpty) {
      listUser.value = backuplist.toList();
    } else {
      listUser.value = backuplist
          .where((p0) =>
              (p0.name?.toLowerCase().contains(text.toLowerCase()) ?? false) ||
              (p0.phone?.toLowerCase().contains(text.toLowerCase()) ?? false) ||
              (p0.email?.toLowerCase().contains(text.toLowerCase()) ?? false))
          .toList();
    }
  }

  Future<void> enableUser(
      {required UserModel user, required bool enable}) async {
    try {
      var res = await _apiBaseHelper.onNetworkRequesting(
        url: 'users/${user.id}',
        methode: METHODE.update,
        body: {
          "name": user.name?.trim(),
          "email": user.email?.trim(),
          "phone": user.phone?.trim(),
          "is_admin": user.isAdmin,
          "active": enable,
        },
      );
      var data = checkResponse(res);
    } catch (error) {
      log(
        'CatchError while enableUser ( error message ) : >> $error',
      );
    }
  }

  Future<List<UserModel>> fetchCustomer() async {
    loading(true);
    try {
      var data = await _apiBaseHelper.onNetworkRequesting(
        url: 'users',
        methode: METHODE.get,
      );
      var res = checkResponse(data);
      if (res.isSuccess) {
        listUser.clear();
        for (var item in res.data) {
          listUser.add(UserModel.fromJson(item));
        }
      }
      backuplist = listUser.toList();
    } catch (e) {
      debugPrint("Error fetchUser");
    }
    loading(false);
    return listUser;
  }
}
