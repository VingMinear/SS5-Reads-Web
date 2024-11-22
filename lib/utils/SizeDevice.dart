import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeDevice {
  final _screen = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.single,
  );

  bool get isXtraSmallScreen {
    return _screen.size.width < 330;
  }

  bool get isSmallScreen {
    return _screen.size.width < 380;
  }

  bool get isNormalScreen {
    return _screen.size.height < 600 ||
        _screen.size.width >= 380 && _screen.size.width < 550;
  }

  bool get isMediumScreen {
    return _screen.size.width >= 550 && _screen.size.width < 800;
  }

  bool get isLargeScreen {
    return _screen.size.width >= 1000;
  }

  bool isIpad() {
    final data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return data.size.shortestSide > 550 ? true : false;
  }

  bool isWeb() {
    final data = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return data.size.width > 800;
  }
}
