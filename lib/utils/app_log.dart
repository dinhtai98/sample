import 'package:logger/logger.dart';

class AppLog {
  static final _logger = Logger(
    ///Initial logger printer
    ///Show time
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
      noBoxingByDefault: true,
    ),
  );

  static void _log(Level level, dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.log(level, "$tag: $message", stackTrace: stackTrace, error: error);
  }

  /// Log a message at level [Level.verbose].
  static v(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.verbose, tag, message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  static d(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.debug, tag, message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  static i(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.info, tag, message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.warning, tag, message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  static e(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.error, tag, message, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  static wtf(dynamic tag, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _log(Level.wtf, tag, message, error, stackTrace);
  }
}
