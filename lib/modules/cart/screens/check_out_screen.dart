import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/cart/screens/success_order.dart';
import 'package:homework3/modules/profile/screens/address_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/StripeHandler.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/colors.dart';

import '../../../model/address_model.dart';
import '../../../utils/Utilty.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../components/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(
      {super.key,
      required this.listPro,
      required this.total,
      required this.subTotal});
  final List<CartModel> listPro;
  final String total;
  final String subTotal;
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

List<String> pymOptions = [
  'Cash On Delivery',
  'Credit / Debit Card',
].obs;

class _CheckOutScreenState extends State<CheckOutScreen> {
  var currentOpt = pymOptions[0].obs;
  var cartController = Get.put(CartController());
  var address = AddressModel().obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: shadow,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    buildAddress(),
                    const SizedBox(height: 10),
                    buildListProduct(),
                    const SizedBox(height: 10),
                    buildPaymentMethod(),
                    const SizedBox(height: 10),
                    buildPaymentInfo(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: appWidth(percent: 0.2),
                      child: CustomPrimaryButton(
                        buttonColor:
                            address.value.id == null ? Colors.grey : mainColor,
                        textValue: 'Place Order',
                        textColor: Colors.white,
                        onPressed: () async {
                          if (address.value.id != null) {
                            router.pop();
                            if (currentOpt.value == 'Credit / Debit Card') {
                              showAlertDialog(
                                  content: const SuccessScreenOrder());
                              // var isSuccess = await StripePaymentHandle()
                              //     .stripeMakePayment(amount: widget.total);
                              if (false) {
                                loadingDialog();
                                await cartController.checkOutOrder(
                                  pymType: currentOpt.value,
                                  addressId: address.value.id ?? 0,
                                  total: cartController.cartTotal,
                                  products: cartController.shoppingCart,
                                );
                                popLoadingDialog();
                              }
                            } else {
                              loadingDialog();
                              await cartController.checkOutOrder(
                                pymType: currentOpt.value,
                                addressId: address.value.id ?? 0,
                                total: cartController.cartTotal,
                                products: cartController.shoppingCart,
                              );
                              popLoadingDialog();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    router.pop();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddress() {
    var txtAddress =
        "${address.value.house},${address.value.commune},${address.value.district},${address.value.province}";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/profile/location@2x.png',
                width: 25,
              ),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'Deliver address',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              showAlertDialog(
                content: AddressScreen(
                  selectAddress: true,
                ),
              ).then((value) {
                if (value != null) {
                  var add = value as AddressModel;
                  address.value = add;
                }
                print(value.toString());
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  address.value.id == null
                      ? const SizedBox()
                      : Image.asset(
                          'assets/icons/map.png',
                          width: 30,
                        ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      address.value.id == null
                          ? 'Select your address'
                          : txtAddress,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListProduct() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Order Details",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Column(
            children: widget.listPro
                .map(
                  (cartItem) => CartItem(
                    cartItem: cartItem,
                    viewOnly: true,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
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
            Column(
              children: List.generate(pymOptions.length, (index) {
                return RadioListTile<String>(
                  value: pymOptions[index],
                  groupValue: currentOpt.value,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(
                        pymOptions[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        index == 0
                            ? 'assets/icons/cash.png'
                            : 'assets/icons/credit.png',
                        width: index == 0 ? 40 : 50,
                      )
                    ],
                  ),
                  onChanged: (value) {
                    debugPrint('My DebugPrint : ${currentOpt.value}');
                    currentOpt.value = value!;
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPaymentInfo() {
    return SizedBox(
      child: widget.listPro.isNotEmpty
          ? Container(
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
                        "\$${widget.subTotal}",
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
                        "+\$${cartController.shippingCharge.formatCurrency}",
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
                        "\$${widget.total}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
