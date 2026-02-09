import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal();

  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  final Logger _logger = Logger(
    level: kReleaseMode ? Level.warning : Level.trace,
    printer: PrettyPrinter(methodCount: 1, errorMethodCount: 5, lineLength: 120, colors: true, printEmojis: true),
  );

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, {dynamic error, StackTrace? stackTrace}) => _logger.e(message, error: error, stackTrace: stackTrace);
}
