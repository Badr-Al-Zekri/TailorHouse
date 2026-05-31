import 'package:flutter_test/flutter_test.dart';
import 'package:tailorhouse/main.dart';

void main() {
  testWidgets('TailorHouse app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TailorHouseApp());

    // Verify that splash screen appears
    expect(find.text('TailorHouse'), findsOneWidget);
  });
}
