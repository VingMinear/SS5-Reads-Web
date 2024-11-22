import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/model/product_model.dart';

import '../../../utils/SingleTon.dart';
import '../../../utils/api_base_helper.dart';

class FavoriteController extends GetxController {
  var loading = false.obs;
  @override
  void onInit() {
    getProductFavorite();
    super.onInit();
  }

  var listFav = <ProductModel>[].obs;
  final _apiBaseHelper = ApiBaseHelper();
  Future<void> getProductFavorite() async {
    try {
      loading(true);
      listFav.clear();
      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'get-favorite',
        body: {"customer_id": GlobalClass().userId},
        methode: METHODE.post,
      )
          .then((value) {
        log("data :$value");
        if (value['code'] == 200) {
          for (var item in value['data']) {
            listFav.add(ProductModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getFavorite this is error : >> $error',
      );
    }
    loading(false);
    update();
  }
}
