import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hustle/screens/main_screen.dart';

void main() {
  testWidgets('Test create new todo', (WidgetTester tester) async {
    // Populate the fake database.
    final firestore = FakeFirebaseFirestore();

    // Render the widget.
    await tester.pumpWidget(
        MaterialApp(home: MainScreen(firebaseFirestore: firestore)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
  });
}
