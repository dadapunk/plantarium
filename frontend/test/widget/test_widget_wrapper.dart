import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A test widget wrapper that provides a [ProviderScope] for testing widgets
/// that depend on Riverpod providers.
class TestWidgetWrapper extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Optional overrides for providers.
  final List<Override> overrides;

  /// Creates a new test widget wrapper.
  ///
  /// Example usage:
  /// ```dart
  /// await tester.pumpWidget(
  ///   TestWidgetWrapper(
  ///     overrides: [
  ///       myProvider.overrideWithValue(MockValue()),
  ///     ],
  ///     child: MyWidget(),
  ///   ),
  /// );
  /// ```
  const TestWidgetWrapper({
    Key? key,
    required this.child,
    this.overrides = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: child, debugShowCheckedModeBanner: false),
    );
  }
}
