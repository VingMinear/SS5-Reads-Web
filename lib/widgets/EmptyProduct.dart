import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({super.key, required this.desc});
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        from: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/out-of-stock.png',
              width: 80,
              height: 90,
            ),
            Text(
              desc,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
