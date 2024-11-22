import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/SingleTon.dart';

import '../../../widgets/CustomCachedNetworkImage.dart';
import '../../cart/controllers/cart_controller.dart';

class CardListProduct extends StatefulWidget {
  const CardListProduct({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  State<CardListProduct> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CardListProduct>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var con = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(ProductDetailsView(
        //   product: widget.product,
        // ));

        router.go(
          '/product-detail?pId=${widget.product.productId}&cateId=${widget.product.categoryId}',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffFEFEFE),
          boxShadow: shadow,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CustomCachedNetworkImage(
                    imgUrl: widget.product.image ?? '',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName ?? '',
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.product.categoryName.toString(),
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xff8F8F8F)),
                      ),
                      Text(
                        "\$ ${widget.product.priceOut}",
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.product.qty}",
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("remaning"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  if (GlobalClass().isUserLogin) {
                    Get.put(CartController()).addToCart(widget.product);
                  } else {
                    Get.to(const LoginScreen());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        offset: const Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    CupertinoIcons.cart,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
