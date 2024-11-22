import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/Color.dart';
import 'list_card_shimmer.dart';

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key, required this.isAdmin});
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(15));
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: whiteColor,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 130,
              color: Colors.amber,
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(9).copyWith(left: 12, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        line(
                          width: 150,
                        ),
                        const SizedBox(height: 5),
                        line(
                          width: 80,
                        ),
                        const SizedBox(height: 5),
                        line(width: 50),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !isAdmin,
                    child: Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'images/cart.png',
                          width: 22,
                          color: Colors.white,
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
    );
  }
}
