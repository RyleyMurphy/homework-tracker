import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:homework_tracker1/widgets/add_fab.dart';

void main() {
  testWidgets('AddFAB renders and triggers onPressed when Tapped', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: AddFab(
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byType(AddFab));
    await tester.pump();

    expect(wasPressed, isTrue);
  });
}
