import 'package:logger/logger.dart';

/// [LoggingLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum LoggingLevel {
  /// Designates finer-grained "trace" informational events than the [debug] level.
  trace,

  /// Designates fine-grained informational events that are most useful to debug
  /// an application.
  debug,

  /// Designates informational messages that highlight the state of the application
  /// or special conditions.
  info,

  /// Designates potentially harmful situations.
  warning,

  /// Designates error events that might still allow the application to continue.
  error,

  /// Designates very severe error events that will presumably end the application.
  fatal,

  /// All log messages are disabled.
  off;
}

/// Access the Logger singleton instance.
Logger get logger => _Log.instance;

/// Set the logging level for the Logger.
set loggingLevel(LoggingLevel loggingLevel) {
  late Level level;
  switch (loggingLevel) {
    case LoggingLevel.trace:
      level = Level.trace;
    case LoggingLevel.debug:
      level = Level.debug;
    case LoggingLevel.info:
      level = Level.info;
    case LoggingLevel.warning:
      level = Level.warning;
    case LoggingLevel.error:
      level = Level.error;
    case LoggingLevel.fatal:
      level = Level.fatal;
    case LoggingLevel.off:
      level = Level.off;
  }
  Logger.level = level;
}

/// Singleton logger class.
class _Log extends Logger {
  _Log._() : super(printer: PrettyPrinter());
  static final instance = _Log._();
}
