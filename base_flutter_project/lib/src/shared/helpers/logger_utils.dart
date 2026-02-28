import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = MyLogger.instance;

void logInfo(String message) {
  logger.i(message);
}

class MyLogger extends Logger {
  MyLogger._()
      : super(
          filter: MyFilter(),
          printer: PrettyPrinter(
              dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
        );

  static MyLogger get instance => MyLogger._();
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
