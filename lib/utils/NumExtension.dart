import 'package:homework3/utils/SizeDevice.dart';

extension Numeric on num {
  double get scale {
    /// scale depend on screen normally use with icon
    return _resize(this);
  }

  double _resize(num size) {
    var sizeDevice = SizeDevice();
    var resize = 1.0;
    if (sizeDevice.isXtraSmallScreen) {
      resize = 0.8;
    } else if (sizeDevice.isSmallScreen) {
      resize = 0.95;
    } else if (sizeDevice.isNormalScreen) {
      resize = 1;
    } else if (sizeDevice.isMediumScreen) {
      resize = 1.2;
    } else {
      resize = 1.3;
    }
    return size * resize;
  }
}
