import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plantarium/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Test', () {
    testWidgets('Complete app flow test', (final tester) async {
      // Start the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Plantarium Home'), findsOneWidget);

      // Interact with the counter
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Add more interactions as we develop more features
      // Example:
      // - Navigate to different screens
      // - Interact with garden layout
      // - Add/remove plants
      // - Check weather integration
    });
  });
}
