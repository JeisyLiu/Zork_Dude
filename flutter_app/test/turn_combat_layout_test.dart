import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/turn_combat_screen.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('turn combat renders common sizes without overflow', (tester) async {
    final sizes = [
      const Size(390, 844),
      const Size(320, 568),
      const Size(1024, 576),
      const Size(1280, 720),
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
      expect(tester.takeException(), isNull, reason: 'overflow at $size');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    }
  });
}
