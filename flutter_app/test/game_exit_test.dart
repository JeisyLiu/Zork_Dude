import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('quit / return to title', () {
    test('quit command emits returnToTitle without gameOver', () async {
      final session = await GameSession.create(WorldRepository());
      final result = session.processCommand('quit');

      expect(
        result.events.any((e) => e.type == GameEventType.returnToTitle),
        isTrue,
      );
      expect(session.gameOver, isFalse);
    });

    test('controller quit sets pendingReturnToTitle not gameOver', () async {
      final controller = GameController();
      await controller.init();
      await controller.startNewGame();

      await controller.executeCommand('quit');

      expect(controller.pendingReturnToTitle, isTrue);
      expect(controller.session!.gameOver, isFalse);
      controller.dispose();
    });

    test('controller exit alias sets pendingReturnToTitle', () async {
      final controller = GameController();
      await controller.init();
      await controller.startNewGame();

      await controller.executeCommand('exit');

      expect(controller.pendingReturnToTitle, isTrue);
      expect(controller.session!.gameOver, isFalse);
      controller.dispose();
    });
  });
}
