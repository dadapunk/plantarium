import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantarium/main.dart';
import '../test_config.dart';

void main() {
  group('MyHomePage Widget Tests', () {
    testWidgets('Counter increments when button is tapped', (tester) async {
      await tester.pumpWidget(const MyHomePage(title: 'Test Home Page'));

      // Verify initial counter value
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Tap the increment button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify counter was incremented
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('App bar shows correct title', (tester) async {
      const title = 'Test Title';
      await tester.pumpWidget(testableWidget(const MyHomePage(title: title)));

      expect(find.text(title), findsOneWidget);
    });

    testWidgets('Counter text is displayed', (tester) async {
      await tester.pumpWidget(testableWidget(const MyHomePage(title: 'Test')));

      expect(
        find.text('You have pushed the button this many times:'),
        findsOneWidget,
      );
    });
  });
}
