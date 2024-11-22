import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/Color.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/custom_appbar.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key, required this.desc, this.titleBtn, this.onPress});
  final String desc;
  final String? titleBtn;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints: BoxConstraints(
        maxWidth: 900,
        maxHeight: appHeight(percent: 0.6),
      ),
      child: Stack(
        children: [
          Column(
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
                  desc,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 20),
            ],
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
    );
  }
}
