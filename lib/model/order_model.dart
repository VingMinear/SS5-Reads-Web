import 'package:homework3/constants/Enum.dart';

class OrderModel {
  double amount = 0;
  String ordercode = "";
  OrderStatus orderStatus = OrderStatus.processing;
  bool enabledConfirm = false;
  String customerName = "";
}
