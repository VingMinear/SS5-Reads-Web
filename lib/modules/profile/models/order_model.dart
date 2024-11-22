import 'package:flutter/material.dart';
import 'package:homework3/model/product_model.dart';

class OrderModel {
  int? ordId;
  double? totalAmount;
  String? status;
  String? date;
  String? time;
  Color color = const Color.fromARGB(255, 242, 216, 87);
  List<ProductModel>? products = [];

  OrderModel(
      {this.ordId,
      this.totalAmount,
      this.status,
      this.date,
      this.time,
      this.products});

  OrderModel.fromJson(Map<String, dynamic> json) {
    ordId = json['ord_id'];
    totalAmount = json['total_amount'].toDouble();
    status = json['status'];
    date = json['date'] ?? '';
    if (json['products'] != null) {
      products = <ProductModel>[];
      json['products'].forEach((v) {
        products!.add(ProductModel.fromJson(v));
      });
    }
    switch (status) {
      case 'Processing':
        color = Colors.deepOrange.shade300;
        break;
      case 'Delivering':
        color = Colors.blue.shade200;
        {}
        break;
      case 'Completed':
        color = Colors.green.shade300;
        break;
      case 'Cancelled':
        color = Colors.red.shade400;
        break;
      default:
        break;
    }
  }
}
