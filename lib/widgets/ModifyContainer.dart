import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';

class ModifyContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRaduis;
  final BoxShape? boxShape;
  final Color? backgroundColor;
  final DecorationImage? image;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;
  const ModifyContainer({
    super.key,
    this.width,
    this.height,
    this.borderRaduis,
    this.boxShape,
    this.backgroundColor,
    this.image,
    this.child,
    this.clipBehavior = Clip.antiAliasWithSaveLayer,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor ?? whiteColor,
        shape: boxShape ?? BoxShape.rectangle,
        borderRadius: boxShape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRaduis ?? 10),
        image: image,
      ),
      width: width ?? 100,
      height: height ?? 20,
      child: child,
    );
  }
}
