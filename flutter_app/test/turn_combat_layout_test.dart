import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/screens/turn_combat_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

late GameController sharedController;

Future<void> pumpTurnCombat(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(
    MaterialApp(
      theme: GameUiTheme.appTheme(),
      home: MediaQuery(
        data: MediaQueryData(size: size, disableAnimations: true),
        child: TurnCombatScreen(controller: sharedController),
      ),
    ),
  );
  await tester.pump();
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedController = GameController();
    await sharedController.init();
    sharedController.session!.processCommand('w');
  });

  setUp(() {
    sharedController.resetCommandGateForTest();
  });

  for (final size in const [
    Size(667, 375),
    Size(854, 480),
    Size(1280, 720),
    Size(1920, 1080),
  ]) {
    testWidgets(
      'turn combat renders landscape ${size.width.toInt()}x${size.height.toInt()} without overflow',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await pumpTurnCombat(tester, size);

        expect(find.textContaining('回合'), findsWidgets);
        expect(find.textContaining('/'), findsWidgets);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  }
}
