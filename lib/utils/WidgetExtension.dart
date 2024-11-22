import 'package:flutter/material.dart';

extension ResponsiveExt on Widget {
  Widget expanded({int flex = 1, bool expanded = true}) {
    if (!expanded) return this;
    return Expanded(flex: flex, child: this);
  }

  Widget listen({
    Function(BuildContext, BoxConstraints)? listen,
  }) {
    return LayoutBuilder(
      builder: (ctx, _) {
        if (listen != null) listen(ctx, _);
        return this;
      },
    );
  }
}
