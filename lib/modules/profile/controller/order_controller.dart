import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/profile/models/order_model.dart';

import '../../../utils/SingleTon.dart';
import '../../../utils/api_base_helper.dart';

class OrderController extends GetxController {
  var loading = false.obs;
  final _apiBaseHelper = ApiBaseHelper();
  var listOrder = <OrderModel>[].obs;
  Future<void> getOrders() async {
    try {
      loading(true);
      listOrder.clear();
      await _apiBaseHelper
          .onNetworkRequesting(url: 'order', methode: METHODE.post, body: {
        "customer_id": GlobalClass().userId,
      }).then((value) {
        if (value['code'] == 200) {
          for (var i in value['data']) {
            listOrder.add(OrderModel.fromJson(i));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getOrders this is error : >> $error',
      );
    }
    loading(false);
  }
}
