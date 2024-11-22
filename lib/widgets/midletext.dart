import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/routes/routes.dart';

class MidleText extends StatelessWidget {
  const MidleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text(
              "I",
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Text(
              " RECOMMEND",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
        InkWell(
          // ignore: avoid_returning_null_for_void
          onTap: () {
            // Get.to(() => const ListProducts(title: 'All Products'));
            router.go('/list-products');
          },
          child: const Row(
            children: [
              Text(
                "See all",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 20,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ],
    );
  }
}
