import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod_test_utils.dart';

// Example provider to test
final counterProvider = StateProvider<int>((final ref) => 0);

void main() {
  group('Riverpod Container Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Create a fresh container for each test
      container = RiverpodTestUtils.createContainer(
        observer: RiverpodTestUtils.createTestObserver(),
      );
    });

    test('Provider has initial value', () {
      // Read the value from the container
      final initialValue = container.read(counterProvider);

      // Test initial value
      expect(initialValue, 0);
    });

    test('Provider can be updated', () {
      // Update the state
      container.read(counterProvider.notifier).state = 5;

      // Read the updated value
      final updatedValue = container.read(counterProvider);

      // Test updated value
      expect(updatedValue, 5);
    });

    test('Provider can be overridden', () {
      // Create a container with overrides
      final overriddenContainer = RiverpodTestUtils.createContainer(
        overrides: [counterProvider.overrideWith((final ref) => 10)],
      );

      // Read the value from the overridden container
      final value = overriddenContainer.read(counterProvider);

      // Test the overridden value
      expect(value, 10);
    });
  });
}
