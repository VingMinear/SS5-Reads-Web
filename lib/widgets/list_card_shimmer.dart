import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key, this.height});
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: shadow,
      ),
      padding: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Stack(
          children: [
            Row(
              children: [
                line(
                  width: height ?? 100,
                  height: height ?? 100,
                  raduis: 10,
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: height ?? 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      line(),
                      const SizedBox(height: 10),
                      line(width: 100),
                      const SizedBox(height: 10),
                      line(width: 80),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    boxShadow: [],
                  ),
                  width: 45,
                  height: 45,
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'images/cart.png',
                    width: 13,
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

Container line({
  double? width,
  double? height,
  double? raduis,
}) {
  return Container(
    width: width ?? 170,
    height: height ?? 14,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(raduis ?? 5),
    ),
  );
}
