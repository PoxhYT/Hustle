import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hustle/main.dart';
import 'package:hustle/screens/MainScreen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainScreen());
  });
}
