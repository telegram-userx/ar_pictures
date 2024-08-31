import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../service_locator/sl.dart';

class Logger {
  /// Helper static method to log a flutter error [FlutterError.onError]
  /// like widget overflow, etc.
  static void logFlutterError(
    FlutterErrorDetails details,
  ) =>
      sl<Talker>().error(
        details.toStringShort(),
        details.exception,
        details.stack,
      );

  /// Helper static method to log a platform dispatcher error
  /// like native code errors
  static bool logPlatformDispatcherError(Object exception, StackTrace stackTrace) {
    sl<Talker>().error(
      exception.toString(),
      exception,
      stackTrace,
    );

    return true;
  }

  /// Helper static method to log a zone error
  ///
  /// later, it would be send to the sentry
  static void logZoneError(
    Object? e,
    StackTrace s,
  ) =>
      sl<Talker>().critical('Top level error', e, s);

  /// Formats the time to have [_timeLength] digits
  static String timeFormat(int input) => input.toString().padLeft(timeLength, '0');

  /// How much digits there should be in the time
  static const int timeLength = 2;

  static void i(Object message) => sl<Talker>().info(message);

  static void w(Object message, [StackTrace? stackTrace]) => sl<Talker>().warning(message, stackTrace);

  static void e(Object message, [StackTrace? stackTrace]) => sl<Talker>().error(message, stackTrace);

  static void d(Object message) => sl<Talker>().debug(message);
}
