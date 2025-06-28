// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:backbase/domain/repositories/book_repository.dart';

import 'package:backbase/main.dart';

class MockRepository extends Mock implements BookRepository {}

void main() {
  testWidgets('Book search app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(repository: MockRepository()));

    // Verify that the search screen is loaded by checking for a TextField
    expect(find.byType(TextField), findsOneWidget);
  });
}
