import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A test widget wrapper that provides a [ProviderScope] for testing widgets
/// that depend on Riverpod providers.
class TestWidgetWrapper extends StatelessWidget {
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

  /// The child widget to wrap.
  final Widget child;

  /// Optional overrides for providers.
  final List<Override> overrides;

  @override
  Widget build(final BuildContext context) => ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child, debugShowCheckedModeBanner: false),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Override>('overrides', overrides));
  }
}
