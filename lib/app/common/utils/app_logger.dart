import 'package:flutter/foundation.dart';

/// A utility class for logging that only prints in debug mode.
/// This prevents sensitive data leakage and performance issues in production.
class AppLogger {
  static void log(Object? message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void debug(Object? message) {
    if (kDebugMode) {
      debugPrint(message?.toString());
    }
  }

  static void error(Object? message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: $message');
      if (error != null) debugPrint('Details: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }
}
