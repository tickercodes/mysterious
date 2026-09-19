import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterious/main.dart';
import 'package:mysterious/screens/phone_shell.dart';
import 'package:mysterious/state/game_controller.dart';
import 'package:mysterious/theme/night_desk_theme.dart';
import 'package:provider/provider.dart';

void main() {
  Future<void> pumpPhone(WidgetTester tester, GameController game) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: game,
        child: MaterialApp(
          theme: NightDeskTheme.dark,
          home: const PhoneShell(),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  }

  testWidgets('phone home grid does not overflow', (tester) async {
    final game = GameController(instant: true)..start();
    await pumpPhone(tester, game);
    expect(find.text('Messages'), findsOneWidget);
  });

  testWidgets('lock screen does not overflow', (tester) async {
    final game = GameController(instant: true)..start();
    game.switchPhone();
    await pumpPhone(tester, game);
    expect(find.text('Enter passcode'), findsOneWidget);
  });

  testWidgets('title screen does not overflow', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const NightDeskApp());
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('The Desk'), findsOneWidget);
  });
}
