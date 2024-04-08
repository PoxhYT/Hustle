import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hustle/screens/main_screen.dart';

void main() {
  testWidgets('Find todo textfield', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await tester.pumpWidget(
        MaterialApp(home: MainScreen(firebaseFirestore: firestore)));

    final todoTextField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration!.hintText == 'Add a new todo item');
    expect(todoTextField, findsOneWidget);
  });

  testWidgets('Find todo textfield', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();
    await tester.pumpWidget(
        MaterialApp(home: MainScreen(firebaseFirestore: firestore)));

    final todoTextField = find.byWidgetPredicate((widget) =>
        widget is TextField &&
        widget.decoration!.hintText == 'Add a new todo item');
    expect(todoTextField, findsOneWidget);
  });

  /* testWidgets('Test create new todo', (WidgetTester tester) async {
    // Populate the fake database.
    final firestore = FakeFirebaseFirestore();

    // Render the widget.
    await tester.pumpWidget(
        MaterialApp(home: MainScreen(firebaseFirestore: firestore)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();


  }); */
}
