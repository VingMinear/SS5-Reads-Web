import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

OverlayEntry? _overlayEntry;

void showFilterOverlay({
  required BuildContext context,
  required Widget widget,
  Offset? offset, // Optional offset to position the overlay
}) {
  if (_overlayEntry != null) return; // Prevent showing multiple overlays

  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
  final Size widgetSize = renderBox.size;

  final Offset finalOffset = offset ?? widgetPosition;

  _overlayEntry = createOverlayEntry(
    context: context,
    widget: widget,
    position: finalOffset,
    widgetSize: widgetSize,
  );
  Overlay.of(context).insert(_overlayEntry!);
}

OverlayEntry createOverlayEntry({
  required BuildContext context,
  required Widget widget,
  required Offset position,
  required Size widgetSize,
}) {
  return OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Fullscreen GestureDetector to close the overlay when tapping outside
        GestureDetector(
          onTap: removeOverlay,
          child: Container(
            color: Colors.transparent, // Transparent background to detect taps
          ),
        ),
        // Positioned overlay widget
        Positioned(
          right: position.dx,
          top: position.dy + widgetSize.height, // Position it below the widget
          child: Material(
            color: Colors.transparent,
            child: FadeInDown(
              from: 10,
              duration: const Duration(milliseconds: 200),
              child: widget,
            ),
          ),
        ),
      ],
    ),
  );
}

void removeOverlay() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}
