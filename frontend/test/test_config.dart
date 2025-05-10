import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Wraps a widget in a MaterialApp for testing
Widget testableWidget(final Widget widget) => MaterialApp(home: widget);

/// Base class for mock creation to avoid type errors with Null Safety
abstract class MockBase<T> extends Mock implements T {}

/// Common test setup function
void testSetup() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Helper to load test assets
Future<void> loadTestAssets() async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(
        'flutter/assets',
        (final message) async => Uint8List(0).buffer.asByteData(),
      );
}

/// Helper to pump and settle widgets
Future<void> pumpAndSettle(final WidgetTester tester) async {
  await tester.pump();
  await tester.pumpAndSettle();
}
