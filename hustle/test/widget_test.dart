import 'package:flutter_test/flutter_test.dart';
import 'package:hustle/screens/main_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainScreen());
  });
}
