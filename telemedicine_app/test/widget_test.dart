// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:telemedicine_app/main.dart';

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app renders without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Home screen should show main features', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that main features are present
    expect(find.text('Symptom Analysis'), findsOneWidget);
    expect(find.text('Find Doctors'), findsOneWidget);
    expect(find.text('Health Records'), findsOneWidget);
  });

  testWidgets('Symptom analysis screen should show input field', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to symptom analysis screen
    await tester.tap(find.text('Symptom Analysis'));
    await tester.pumpAndSettle();

    // Verify that the input field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Describe your symptoms'), findsOneWidget);
  });

  testWidgets('Doctor search screen should show search field', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to doctor search screen
    await tester.tap(find.text('Find Doctors'));
    await tester.pumpAndSettle();

    // Verify that the search field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search doctors'), findsOneWidget);
  });
}
