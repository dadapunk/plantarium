import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_widget_wrapper.dart';

// Example provider for the test
final counterProvider = StateProvider<int>((ref) => 0);

// Example widget that uses the provider
class CounterWidget extends ConsumerWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $count', key: const Key('count-text')),
            ElevatedButton(
              key: const Key('increment-button'),
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('Riverpod Widget Tests', () {
    testWidgets('CounterWidget displays initial count', (
      WidgetTester tester,
    ) async {
      // Pump the widget with the TestWidgetWrapper
      await tester.pumpWidget(const TestWidgetWrapper(child: CounterWidget()));

      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);
    });

    testWidgets('CounterWidget increments count when button is pressed', (
      WidgetTester tester,
    ) async {
      // Pump the widget with the TestWidgetWrapper
      await tester.pumpWidget(const TestWidgetWrapper(child: CounterWidget()));

      // Tap the increment button
      await tester.tap(find.byKey(const Key('increment-button')));
      await tester.pump();

      // Verify updated state
      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('CounterWidget can be tested with overridden initial value', (
      WidgetTester tester,
    ) async {
      // Pump the widget with the TestWidgetWrapper and overrides
      await tester.pumpWidget(
        TestWidgetWrapper(
          overrides: [counterProvider.overrideWith((ref) => 10)],
          child: const CounterWidget(),
        ),
      );

      // Verify overridden initial state
      expect(find.text('Count: 10'), findsOneWidget);
    });
  });
}
