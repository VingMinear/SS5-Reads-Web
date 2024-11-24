import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/primary_button.dart';

class SuccessScreenOrder extends StatelessWidget {
  const SuccessScreenOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      constraints: BoxConstraints(maxHeight: appHeight(percent: 0.7)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
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
                      router.pop();
                      router.go('/home');
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
                      router.pop();

                      router.go('/my-order');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
