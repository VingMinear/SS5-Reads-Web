import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/bottom_navigation_bar/main_layout.dart';
import 'package:homework3/modules/profile/screens/order_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/primary_button.dart';
import '../../bottom_navigation_bar/bottom_controller.dart';

class SuccessScreenOrder extends StatelessWidget {
  const SuccessScreenOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'images/success.json',
                  repeat: false,
                  width: 130,
                  fit: BoxFit.cover,
                  height: 130,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'ORDER PLACED',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Your order are in pending reviewed by the merchant. You will receive a notification and email confirmation toshortly.\nThank you!',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: CustomPrimaryButton(
                        textColor: Colors.white,
                        buttonColor: Colors.grey,
                        textValue: 'Home',
                        onPressed: () {
                          // Get.put(BottomController()).selectedIndex(0);
                          // Get.offAll(const MainLayout());
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomPrimaryButton(
                        textColor: Colors.white,
                        buttonColor: Colors.green,
                        textValue: 'My Orders',
                        onPressed: () {
                          Get.off(const OrderScreen(
                            isFromSuccess: true,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
