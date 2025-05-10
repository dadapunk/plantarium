import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A testing utility class that creates a test container for Riverpod providers.
/// This allows overriding providers for testing purposes without affecting the global state.
class RiverpodTestUtils {
  /// Creates a test container with the given overrides.
  ///
  /// Example usage:
  /// ```dart
  /// final container = RiverpodTestUtils.createContainer(
  ///   overrides: [
  ///     myProvider.overrideWithValue(MockValue()),
  ///   ],
  /// );
  ///
  /// final result = container.read(myProvider);
  /// expect(result, isA<MockValue>());
  /// ```
  static ProviderContainer createContainer({
    final List<Override> overrides = const [],
    final ProviderObserver? observer,
  }) {
    final container = ProviderContainer(
      overrides: overrides,
      observers: observer != null ? [observer] : [],
    );

    // Add a teardown callback to dispose the container when the test is complete
    addTearDown(container.dispose);

    return container;
  }

  /// Creates a test logger observer that logs provider changes during tests.
  static ProviderObserver createTestObserver() => _TestObserver();
}

/// A test observer that logs all provider changes during tests.
class _TestObserver implements ProviderObserver {
  @override
  void didAddProvider(
    final ProviderBase<Object?> provider,
    final Object? value,
    final ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} was initialized with $value',
    );
  }

  @override
  void didDisposeProvider(
    final ProviderBase<Object?> provider,
    final ProviderContainer container,
  ) {
    print('Provider ${provider.name ?? provider.runtimeType} was disposed');
  }

  @override
  void didUpdateProvider(
    final ProviderBase<Object?> provider,
    final Object? previousValue,
    final Object? newValue,
    final ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} updated from $previousValue to $newValue',
    );
  }

  @override
  void providerDidFail(
    final ProviderBase<Object?> provider,
    final Object error,
    final StackTrace stackTrace,
    final ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} failed with error: $error',
    );
  }
}
