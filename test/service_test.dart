import 'package:logs/src/logging_service.dart';
import 'package:test/test.dart';

void main() {
  group('service tests', () {
    LoggingService service;
    String loggedMessage;
    String loggedChannel;
    Object loggedData;

    setUp(() {
      service = LoggingService()
        ..addListener((message, channel, data) {
          loggedMessage = message;
          loggedChannel = channel;
          loggedData = data;
        });
    });

    test('register', () {
      expect(service.channelDescriptions.containsKey('foo'), isFalse);
      service.registerChannel('foo');
      expect(service.channelDescriptions.containsKey('foo'), isTrue);
    });

    test('register twice', () {
      expect(service.channelDescriptions.containsKey('foo'), isFalse);
      service.registerChannel('foo');
      expect(service.channelDescriptions.containsKey('foo'), isTrue);
      expect(() => service.registerChannel('foo'), throwsException);
    });

    test('enable', () {
      service.registerChannel('foo');
      expect(service.shouldLog('foo'), isFalse);
      service.enableLogging('foo', true);
      expect(service.shouldLog('foo'), isTrue);
    });

    test('enable (unregistered)', () {
      expect(service.shouldLog('foo'), isFalse);
      expect(() => service.enableLogging('foo', true), throwsException);
    });

    test('disable', () {
      service.registerChannel('foo');
      expect(service.shouldLog('foo'), isFalse);
      service.enableLogging('foo', true);
      expect(service.shouldLog('foo'), isTrue);
      service.enableLogging('foo', false);
      expect(service.shouldLog('foo'), isFalse);
    });

    test('description', () {
      service.registerChannel('foo', description: 'a channel for foos');
      expect(service.channelDescriptions['foo'], 'a channel for foos');
    });

    test('channels', () {
      service.registerChannel('foo');
      service.registerChannel('bar');
      service.registerChannel('baz');
      expect(
          service.channelDescriptions.keys, containsAll(['foo', 'bar', 'baz']));
    });

    test('log', () {
      service.registerChannel('foo');
      service.enableLogging('foo', true);
      service.log('foo', () => 'bar',
          data: () => {
                'x': 1,
                'y': 2,
                'z': 3,
              });
      expect(loggedMessage, 'bar');
      expect(loggedData, '{"x":1,"y":2,"z":3}');
    });
  });
}
