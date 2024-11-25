import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';

import '../modules/cart/controllers/cart_controller.dart';
import 'CustomCachedNetworkImage.dart';

typedef ProductCardOnTaped = void Function(ProductModel data);

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key, required this.data, this.ontap, required this.isAdmin});

  final ProductModel data;
  final ProductCardOnTaped? ontap;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    // final data = datas[index % datas.length];
    const borderRadius = BorderRadius.all(Radius.circular(15));
    var con = Get.put(CartController());
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => ontap?.call(data),
        hoverColor: Colors.grey.withOpacity(0.07),
        hoverDuration: const Duration(milliseconds: 250),
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            boxShadow: shadow,
            color: whiteColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                      child: CustomCachedNetworkImage(
                        imgUrl: data.image ?? '',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(9).copyWith(left: 12, top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              data.categoryName ?? '',
                              style: const TextStyle(
                                color: mainColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.productName ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                '\$${data.priceOut?.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${data.qty}",
                                style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("remaning"),
                            ],
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !isAdmin,
                      child: Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            if (GlobalClass().isUserLogin) {
                              con.addToCart(
                                data,
                              );
                            } else {
                              showAlertDialog(
                                context: context,
                                content: const LoginScreen(),
                              );
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                              ),
                              color: mainColor,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              CupertinoIcons.cart,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoldPoint(double star, int sold) {
    return Row(
      children: [
        Image.asset('assets/icons/start@2x.png', width: 20, height: 20),
        const SizedBox(width: 8),
        Text(
          '$star',
          style: const TextStyle(
            color: Color(0xFF616161),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '|',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF616161),
              fontSize: 14),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: const Color(0xFF101010).withOpacity(0.08),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            '$sold sold',
            style: const TextStyle(
              color: Color(0xFF35383F),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
