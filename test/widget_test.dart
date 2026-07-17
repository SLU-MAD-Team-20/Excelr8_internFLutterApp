import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/main.dart';

void main() {
  testWidgets('Landing screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelerateApp());

    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}