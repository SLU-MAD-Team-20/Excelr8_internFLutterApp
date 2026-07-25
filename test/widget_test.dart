import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/program_model.dart';
import 'package:first_app/screens/program_details_screen.dart';

void main() {
  testWidgets('Landing screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelerateApp());

    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Program details screen shows program information', (WidgetTester tester) async {
    final program = ProgramModel(
      id: '1',
      title: 'Flutter Basics',
      status: 'Active',
      registeredCount: 25,
      progress: '70%',
      description: 'A hands-on Flutter course.',
      duration: '6 Weeks',
      startDate: 'Aug 2026',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProgramDetailsScreen(program: program),
      ),
    );

    expect(find.text('Flutter Basics'), findsOneWidget);
    expect(find.text('A hands-on Flutter course.'), findsOneWidget);
    expect(find.text('Duration: 6 Weeks'), findsOneWidget);
  });
}