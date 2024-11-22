import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class CartItem extends StatefulWidget {
  final CartModel cartItem;
  final bool viewOnly;
  const CartItem({
    super.key,
    required this.cartItem,
    required this.viewOnly,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    if (widget.viewOnly) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomCachedNetworkImage(
                    imgUrl: widget.cartItem.product.image ?? ''),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.product.productName ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$${widget.cartItem.product.priceOut}",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'x ${widget.cartItem.quantity}',
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.only(bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffFEFEFE),
          boxShadow: AppColor.boxShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomCachedNetworkImage(
                    imgUrl: widget.cartItem.product.image ?? ''),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cartItem.product.productName ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\$${widget.cartItem.product.priceOut}",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                cartController.incrementQty(widget.cartItem);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(
                                  Iconsax.add,
                                  color: Colors.black,
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Text(
                              widget.cartItem.quantity.toString(),
                              style: const TextStyle(),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            InkWell(
                              onTap: () {
                                cartController.decrimentQty(widget.cartItem);
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(
                                  Iconsax.minus,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cartController.removeItem(widget.cartItem);
                      showTaost('Item removed', type: ToastificationType.error);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(0.07),
                      radius: 20,
                      child: const Icon(
                        Iconsax.trash,
                        color: Colors.redAccent,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 0),
          ],
        ),
      );
    }
  }
}
