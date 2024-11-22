import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/bottom_navigation_bar/bottom_controller.dart';
import 'package:homework3/modules/bottom_navigation_bar/main_layout.dart';
import 'package:homework3/modules/profile/controller/order_controller.dart';
import 'package:homework3/modules/profile/models/order_model.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../widgets/EmptyProduct.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key, this.isFromSuccess = false});
  final bool isFromSuccess;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var con = Get.put(OrderController());
    con.getOrders();
    return Obx(
      () => Scaffold(
        appBar: customAppBar(
          title: 'Order',
          showNotification: false,
          useLeadingCustom: false,
          leading: IconButton(
            onPressed: () {
              if (isFromSuccess) {
                // Get.put(BottomController()).selectedIndex(0);
                // Get.offAll(const MainLayout());
              } else {
                // Get.back();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
            color: Colors.black,
          ),
        ),
        body: con.loading.value
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: mainColor,
                ),
              )
            : con.listOrder.isEmpty
                ? const EmptyProduct(desc: 'No Orders')
                : RefreshIndicator(
                    onRefresh: () async {
                      con.getOrders();
                    },
                    child: AnimationLimiter(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: con.listOrder.length,
                        itemBuilder: (context, index) {
                          var item = con.listOrder[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: FadeInAnimation(
                              child: SlideAnimation(
                                child: cardOrder(size, item),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                      ),
                    ),
                  ),
      ),
    );
  }

  Container cardOrder(Size size, OrderModel data) {
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
                'Order Date: ${data.date}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
                child: Text(
                  '${data.status}',
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
          Visibility(
            child: Column(
              children: List.generate(data.products!.length, (index) {
                var product = data.products![index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.15,
                          height: size.width * 0.15,
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
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }),
            ),
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
                  "Total : \$${data.totalAmount}",
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
}
