import 'package:flutter_test/flutter_test.dart';
import 'package:mysterious/main.dart';

void main() {
  testWidgets('title screen loads The Desk masthead', (tester) async {
    await tester.pumpWidget(const NightDeskApp());
    await tester.pump();
    expect(find.text('The Desk'), findsOneWidget);
    expect(find.text('MYSTERIOUS'), findsOneWidget);
  });
}
