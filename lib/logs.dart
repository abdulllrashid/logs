import 'package:logs/src/logging_service.dart';

/// Enable (or disable) logging for all events on the given [channel].
void enableLogging(String channel, [bool enable = true]) {
  LoggingService.instance.enableLogging(channel, enable);
}

/// Register a logging channel with the given [name] and optional [description].
void registerLoggingChannel(String name, {String description}) {
  LoggingService.instance.registerChannel(name, description: description);
}

/// Returns true if events on the given event [channel] should be logged.
bool shouldLog(String channel) => LoggingService.instance.shouldLog(channel);
