import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/utils/api_base_helper.dart';

import '../../../../constants/Enum.dart';

class AdminOrderModel {
  String orderCode = '';
  int orderId = 0;
  double totalAmount = 0;
  Color colorStatus = Colors.red;
  OrderStatus status = OrderStatus.pending;
  String date = '';
  String phoneNumber = '';
  String receiverName = '';
  String province = '';
  String commune = '';
  String district = '';
  String paymentType = '';
  String house = '';
  LatLng? latLng;
  bool enabledConfirm = false;
  List<ProductModel> products = [];

  AdminOrderModel();

  AdminOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = (json['ord_id'] ?? 0);
    String formattedNumber = orderId.toString().padLeft(5, '0');

    orderCode = "#$formattedNumber";
    totalAmount = (json['total_amount'] ?? 0).toDouble();

    switch (json['status'] ?? '') {
      case 'Pending':
        enabledConfirm = true;
        status = OrderStatus.pending;
        break;
      case 'Processing':
        status = OrderStatus.processing;
        break;
      case 'Delivering':
        status = OrderStatus.delivering;
        break;
      case 'Completed':
        status = OrderStatus.completed;
        break;
      default:
        status = OrderStatus.cancelled;
        break;
    }
    switch (status) {
      case OrderStatus.pending:
        colorStatus = const Color.fromARGB(255, 242, 216, 87);

        break;
      case OrderStatus.processing:
        colorStatus = Colors.deepOrange.shade300;
        break;
      case OrderStatus.delivering:
        colorStatus = Colors.blue.shade200;
        break;

      case OrderStatus.completed:
        colorStatus = Colors.green.shade300;
        break;
      case OrderStatus.cancelled:
        colorStatus = Colors.red.shade400;
        break;
    }
    date = json['date'] ?? '';
    phoneNumber = json['phone_number'] ?? '';
    receiverName = json['receiver_name'] ?? '';
    paymentType = json['payment_type'] ?? '';
    province = json['province'] ?? '';
    commune = json['commune'] ?? '';
    district = json['district'] ?? '';
    house = json['house'] ?? '';
    if (json['products'] != null) {
      products = <ProductModel>[];
      json['products'].forEach((v) {
        products.add(ProductModel.fromJson(v));
      });
    }
    if (json['latlng'] != null) {
      latLng = parseLatLng(json['latlng']);
    }
  }
  LatLng parseLatLng(String latlng) {
    // Remove parentheses and split by comma
    latlng = latlng.replaceAll('(', '').replaceAll(')', '');
    var latLngParts = latlng.split(',');

    if (latLngParts.length != 2) {
      throw const FormatException("Invalid latlng format");
    }

    // Convert each part to a double
    double latitude = double.parse(latLngParts[0]);
    double longitude = double.parse(latLngParts[1]);

    return LatLng(latitude, longitude);
  }
}

class OrderStatusModel {
  String title = '';
  int id = 0;
  OrderStatusModel({required this.id, required this.title});
}

class AdOrderController extends GetxController {
  var lsTabOrder = [
    OrderStatusModel(
      id: 1,
      title: 'Pending',
    ),
    OrderStatusModel(
      id: 2,
      title: 'Processing',
    ),
    OrderStatusModel(
      id: 3,
      title: 'Delivering',
    ),
    OrderStatusModel(
      id: 4,
      title: 'Completed',
    ),
    OrderStatusModel(
      id: 5,
      title: 'Cancelled',
    ),
  ];
  OrderStatusModel status(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return lsTabOrder[0];
      case OrderStatus.processing:
        return lsTabOrder[1];
      case OrderStatus.delivering:
        return lsTabOrder[2];

      case OrderStatus.completed:
        return lsTabOrder[3];
      case OrderStatus.cancelled:
        return lsTabOrder[4];
    }
  }

  final _apiBaseHelper = ApiBaseHelper();
  var loading = true.obs;
  var loadingOrderDetail = false.obs;
  var isEmptyOrder = false.obs;
  var selected = 0.obs;
  var isSomethingWrong = false.obs;
  var loadingPagination = false.obs;
  int get statusOrder => lsTabOrder[selected.value].id;
  onRefresh() async {
    await fetchOrder();
  }

  onRefreshDetail() async {
    await fetchOrder();
  }

  Future<void> fetchOrderDetail(int orderId) async {
    try {
      var res = await _apiBaseHelper.onNetworkRequesting(
          url: 'admin-order',
          methode: METHODE.post,
          body: {
            'order_id': orderId,
          });
      if (res['code'] == 200) {
        orderDetail.value = AdminOrderModel.fromJson(res['data'][0]);
      }
    } catch (error) {
      log(
        'CatchError while fetchOrderDetail ( error message ) : >> $error',
      );
    }
  }

  var orderDetail = AdminOrderModel().obs;
  var listOrders = <AdminOrderModel>[].obs;
  Future<bool> updateOrder(
      {required OrderStatusModel status, required int ordID}) async {
    bool isSuccess = false;
    try {
      loading(true);
      var res = await _apiBaseHelper.onNetworkRequesting(
          url: 'admin-update-order',
          methode: METHODE.post,
          body: {
            'status_id': status.id,
            'order_id': ordID,
          });
      if (res['code'] == 200) {
        isSuccess = true;
      }
    } catch (e) {
      log(
        'CatchError while updateOrder ( error message ) : >> $e',
      );
    }
    loading(false);
    return isSuccess;
  }

  Future<void> fetchOrder() async {
    loading(true);
    try {
      var res = await _apiBaseHelper.onNetworkRequesting(
          url: 'admin-order',
          methode: METHODE.post,
          body: {
            'status_id': statusOrder,
          });
      log("Result $res");
      listOrders.clear();
      if (res['code'] == 200) {
        for (var item in res['data']) {
          listOrders.add(AdminOrderModel.fromJson(item));
        }
      }

      isEmptyOrder(listOrders.isEmpty);
    } catch (error) {
      log(
        'CatchError while fetchOrder ( error message ) : >> $error',
      );
    }
    loading(false);
  }
}
