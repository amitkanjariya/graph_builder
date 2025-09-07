// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graph_builder/main.dart';

void main() {
  testWidgets('Graph Builder app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GraphBuilderApp());

    // Verify that the app starts with root node "1"
    expect(find.text('Neural Graph Builder'), findsOneWidget);

    // Verify floating action buttons exist
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
