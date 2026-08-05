import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/data/world_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Combat bridge', () {
    late GameSession session;

    setUp(() async {
      session = await GameSession.create(WorldRepository());
      session.processCommand('w');
    });

    test('victory resolves combat once', () {
      expect(session.inCombat, isTrue);
      final result = session.resolveCombatVictory(remainingPlayerHp: 40);
      expect(session.inCombat, isFalse);
      expect(session.monsters['giant_rat']!.alive, isFalse);
      expect(result.events.any((e) => e.type == GameEventType.battleEnded), isTrue);
    });

    test('defeat sets game over', () {
      final result = session.resolveCombatDefeat();
      expect(session.gameOver, isTrue);
      expect(result.text, isNotEmpty);
    });

    test('flee returns a result while in combat', () {
      expect(session.inCombat, isTrue);
      final result = session.doFlee();
      expect(result.text, isNotEmpty);
    });
  });
}
