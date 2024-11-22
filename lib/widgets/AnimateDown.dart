import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AnimateDown extends StatelessWidget {
  const AnimateDown(
      {super.key, this.delay, required this.child, this.animate = true});
  final int? delay;
  final Widget child;
  final bool animate;
  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      from: 20,
      animate: animate,
      delay: Duration(milliseconds: delay ?? 0),
      child: child,
    );
  }
}
