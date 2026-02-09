import 'app_logger.dart';

extension StringLogger on String {
  void logD() {
    AppLogger().d(this);
  }

  void logI() {
    AppLogger().i(this);
  }

  void logW() {
    AppLogger().w(this);
  }

  void logE([dynamic error, StackTrace? stackTrace]) {
    AppLogger().e(this, error: error, stackTrace: stackTrace);
  }
}
