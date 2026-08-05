import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/turn_combat_screen.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('turn combat renders landscape 16:9 sizes without overflow', (tester) async {
    final sizes = [
      const Size(667, 375),
      const Size(854, 480),
      const Size(1280, 720),
      const Size(1920, 1080),
    ];

    for (final size in sizes) {
      final controller = GameController();
      await controller.init();
      controller.session!.processCommand('w');

      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(home: TurnCombatScreen(controller: controller)),
      );
      await tester.pump();
      expect(find.textContaining('回合'), findsWidgets);
      expect(find.textContaining('/'), findsWidgets);
      expect(tester.takeException(), isNull, reason: 'overflow at $size');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    }
  });
}
