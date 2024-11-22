import 'dart:developer' as developer;

class Log {
  // Blue text
  static void info(Object msg) {
    developer.log('\x1B[37m📝 $msg\x1B[37m');
  }

// Green text
  static void success(Object msg) {
    developer.log('\x1B[32m🎉✅ $msg\x1B[0m 🎉✅ ');
  }

// Yellow text
  static void warning(Object msg) {
    developer.log('\x1B[33m⚠️ $msg\x1B[0m');
  }

  static String _getFrame(StackTrace stackTrace, int level) {
    final frames = stackTrace.toString().split('\n');
    return frames[level + 1];
  }

  static final stackTrace = StackTrace.current;
// Red text
  static void error(Object msg) {
    final frame = _getFrame(stackTrace, 2);

    developer.log(
      '\x1B[31m ---------------⛔️ error ⛔️--------------- \x1B[31m',
      name: "-",
    );
    developer.log('\x1B[31m $frame \x1B[31m', name: "Error");
    developer.log('\x1B[31m $msg \x1B[31m', name: "Error");
    developer.log(
      '\x1B[31m x-----------------end----------------x \x1B[31m',
      name: "-",
    );
  }
}
