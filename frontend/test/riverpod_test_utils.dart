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
    List<Override> overrides = const [],
    ProviderObserver? observer,
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
  static ProviderObserver createTestObserver() {
    return _TestObserver();
  }
}

/// A test observer that logs all provider changes during tests.
class _TestObserver implements ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} was initialized with $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    print('Provider ${provider.name ?? provider.runtimeType} was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} updated from $previousValue to $newValue',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print(
      'Provider ${provider.name ?? provider.runtimeType} failed with error: $error',
    );
  }
}
