import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../../constants/Color.dart';
import '../../../../constants/Enum.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomCachedNetworkImage.dart';
import '../../../../widgets/CustomTextFieldSuggestion.dart';
import '../controller/adorder_controller.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key, required this.data});
  final AdminOrderModel data;
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  var mapShow = true.obs;
  var loading = true.obs;
  late Marker marker;
  @override
  void dispose() {
    mapShow(false);

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await con.fetchOrderDetail(widget.data.orderId);
      loading(false);
    });

    super.initState();
  }

  BitmapDescriptor appMarker = BitmapDescriptor.defaultMarker;

  var con = Get.put(AdOrderController());

  @override
  Widget build(BuildContext context) {
    return GetX<AdOrderController>(
      init: AdOrderController(),
      builder: (con) => Container(
        decoration: BoxDecoration(
          boxShadow: shadow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        child: Scaffold(
          appBar: customAppBar(
            title: "Order Detail",
            onPress: () {
              mapShow(false);
              log("Back");
            },
          ),
          body: loading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      cardAddress(con.orderDetail.value),
                      const SizedBox(height: 20),
                      buildPaymentMethod(),
                      const SizedBox(height: 20),
                      cardOrder(),
                    ],
                  ),
                ),
          bottomNavigationBar:
              loading.value ? const SizedBox.shrink() : button(),
        ),
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Container(
      decoration: cardDecoration(),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/profile/wallet@2x.png',
                scale: 1.5,
              ),
              const SizedBox(width: 15),
              const Text(
                "Payment Methods",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                widget.data.paymentType,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Image.asset(
                widget.data.paymentType == 'Credit / Debit Card'
                    ? 'assets/icons/credit.png'
                    : 'assets/icons/cash.png',
                width:
                    widget.data.paymentType == 'Credit / Debit Card' ? 50 : 40,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget button() {
    var status = con.orderDetail.value.status;
    if (status == OrderStatus.pending || status == OrderStatus.processing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15)
            .copyWith(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                backgroundColor: AppColor.errorColor,
                onPress: () {
                  showDialogReject();
                },
                title: status == OrderStatus.processing
                    ? 'Cancel'
                    : 'Reject'.tr.toUpperCase(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                onPress: () async {
                  loading(true);
                  if (status == OrderStatus.processing) {
                    // ----------- change this
                    await con.updateOrder(
                      status: con.status(OrderStatus.delivering),
                      ordID: con.orderDetail.value.orderId,
                    );
                  } else {
                    await con
                        .updateOrder(
                      status: con.status(OrderStatus.processing),
                      ordID: con.orderDetail.value.orderId,
                    )
                        .then((value) async {
                      await con.onRefreshDetail();
                    });
                  }
                  await con.fetchOrderDetail(widget.data.orderId);
                  loading(false);
                },
                backgroundColor: Colors.green,
                title: status == OrderStatus.processing
                    ? 'Mark as Shipped'
                    : 'Confirm',
              ),
            ),
          ],
        ),
      );
    } else if (status == OrderStatus.delivering) {
      return InkWell(
        onTap: () async {
          loading(true);
          await con.updateOrder(
            ordID: widget.data.orderId,
            status: con.status(OrderStatus.completed),
          );
          await con.fetchOrderDetail(widget.data.orderId);
          loading(false);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Mark as Deliverd',
                style: AppText.txt15.copyWith(color: Colors.white),
              ),
              Positioned(
                right: 25,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.whiteColor,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  showDialogReject() {
    String? reasonCon;

    var isValidate = false.obs;
    customalertDialogConfirmation(
      title: 'Cancel Reason',
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFildSuggestion(
              onChanged: (p0) {
                reasonCon = p0 ?? '';
              },
              value: reasonCon,
              suggestionsCallback: (p0) {
                return ['Not Availible'];
              },
              listReasons: const ['Not Availible'],
            ),
            if (isValidate.value) ...[
              const SizedBox(height: 8),
              FadeInDown(
                from: 5,
                duration: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Please input reason",
                    style: errorStyle(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      paddingBody: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
      paddingButton: const EdgeInsets.symmetric(vertical: 20),
      onConfirm: () async {
        if (reasonCon != null) {
          if (reasonCon!.trim().isNotEmpty) {
            router.pop();
            loading(true);
            await con.updateOrder(
              ordID: widget.data.orderId,
              status: con.status(OrderStatus.cancelled),
            );
            await con.fetchOrderDetail(widget.data.orderId);
            loading(false);
          } else {
            isValidate(true);
          }
        } else {
          isValidate(true);
        }
      },
      txtBtnCfn: 'reject'.tr.toUpperCase(),
      txtBtnCancel: 'cancel'.tr.toUpperCase(),
    );
  }

  Container cardOrder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: shadow,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order Date: ${con.orderDetail.value.date}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: con.orderDetail.value.colorStatus,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
                child: Text(
                  '${con.orderDetail.value.status.name.capitalizeFirst}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          Column(
            children:
                List.generate(con.orderDetail.value.products.length, (index) {
              var product = con.orderDetail.value.products[index];
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: CustomCachedNetworkImage(
                              imgUrl: product.image ?? ''),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.productName}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Qty : x ${product.qty}",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Price : \$${product.amount}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: mainColor,
                ),
                padding: const EdgeInsets.all(5).copyWith(left: 15, right: 15),
                child: Text(
                  "Total : \$${con.orderDetail.value.totalAmount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardAddress(AdminOrderModel item) {
    return Container(
      decoration: cardDecoration(),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: SvgPicture.asset('assets/icons/order/ic_map.svg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: AppText.txt14.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  child: Row(
                    children: [
                      Text(item.receiverName),
                      const Text(' . '),
                      Text(
                        (item.phoneNumber.toString()),
                        style: AppText.txt14.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: AppText.txt13.copyWith(),
                    text: 'Shipping Address :',
                    children: [
                      TextSpan(
                        style: AppText.txt13
                            .copyWith(fontWeight: FontWeight.w600, height: 1.3),
                        text:
                            ' ${item.province} ${item.district} ${item.commune} ${item.house}',
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
