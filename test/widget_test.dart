import 'package:flutter_test/flutter_test.dart';
import 'package:bondeal_app/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const BonDealApp());
    await tester.pump();
  });
}
