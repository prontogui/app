import 'package:logger/logger.dart';

Logger get logger => _Log.instance;

// Singleton logger class.
class _Log extends Logger {
  _Log._(); // : super(printer: PrettyPrinter(printTime: true));
  static final instance = _Log._();
}
