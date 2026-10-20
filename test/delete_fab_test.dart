import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:homework_tracker1/widgets/delete_fab.dart';

void main() {
  testWidgets('deleteFab renders and triggers onPressed when Tapped', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: DeleteFab(
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.delete), findsOneWidget);

    await tester.tap(find.byType(DeleteFab));
    await tester.pump();

    expect(wasPressed, isTrue);
  });
}

