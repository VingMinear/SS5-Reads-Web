import 'package:animate_do/animate_do.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/cart/controllers/cart_controller.dart';
import 'package:homework3/modules/cart/screens/check_out_screen.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/widgets/primary_button.dart';

import '../components/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.back = false});
  final bool back;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: AppColor.boxShadow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        constraints: const BoxConstraints(
          maxWidth: BreakPoint.lg,
        ),
        height: appHeight(percent: 0.7),
        margin: const EdgeInsets.all(15),
        child: GetBuilder(
            init: cartController,
            builder: (context) {
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: cardSide(),
                  ),
                  Visibility(
                    visible: cartController.shoppingCart.isNotEmpty,
                    child: Expanded(
                      child: orderSummary(),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget cardSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15).copyWith(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shoping Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${cartController.shoppingCart.length} items",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 25,
          color: Colors.grey.shade200,
        ),
        Expanded(
          child: cartController.shoppingCart.isEmpty
              ? emptyCart()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: cartController.shoppingCart
                        .map(
                          (cartItem) => CartItem(
                            cartItem: cartItem,
                            viewOnly: false,
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget orderSummary() {
    return Container(
        decoration: DottedDecoration(
          linePosition: LinePosition.left,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 25,
              color: Colors.grey.shade300,
            ),
            buildPaymentInfo(cartController),
            const SizedBox(
              height: 10,
            ),
            CustomPrimaryButton(
              onPressed: () {
                showAlertDialog(
                  content: CheckOutScreen(
                    listPro: cartController.shoppingCart,
                    total: cartController.cartSubTotal.formatCurrency,
                    subTotal: cartController.cartTotal.formatCurrency,
                  ),
                );
              },
              textValue:
                  "Checkout (\$${cartController.cartTotal.formatCurrency})",
              textColor: Colors.white,
            ),
          ],
        ));
  }

  Widget emptyCart() {
    return Expanded(
      child: Center(
        child: FadeInUp(
          from: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/cart.png',
                width: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              const Text(
                "Your cart is empty!",
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentInfo(CartController cartController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sub Total",
                style: TextStyle(),
              ),
              Text(
                "\$${cartController.cartSubTotal.formatCurrency}",
                style: const TextStyle(),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shipping",
                style: TextStyle(),
              ),
              Text(
                "+\$${cartController.shippingCharge}",
                style: const TextStyle(),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tax ",
                style: TextStyle(),
              ),
              Text(
                "0%",
                style: TextStyle(),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: DottedDecoration(
              dash: const [4],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "\$${cartController.cartTotal.formatCurrency}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
