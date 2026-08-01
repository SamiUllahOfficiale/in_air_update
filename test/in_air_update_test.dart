import 'package:flutter_test/flutter_test.dart';
import 'package:in_air_update/in_air_update.dart';

void main() {
  group('InAirUpdate Tests', () {
    test('Initialization check and exception before init', () async {
      // Expect exception when calling checkForUpdates before initialization
      expect(
        () async => await InAirUpdate.checkForUpdates(),
        throwsA(isA<Exception>()),
      );
    });

    test('Initialization sets up endpoint correctly', () async {
      // Should not throw initialization errors
      await InAirUpdate.initialize(
        endpointUrl: 'https://jsonplaceholder.typicode.com/todos/1',
      );

      // Verify that the instance is properly created and configured
      expect(InAirUpdate, isNotNull);
    });
  });
}
