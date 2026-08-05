import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
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
      expect(session.activeEncounter, isNotNull);
      final result = session.resolveEncounterVictory();
      expect(session.inCombat, isFalse);
      expect(session.monsters['giant_rat']!.alive, isFalse);
      expect(result.events.any((e) => e.type == GameEventType.battleEnded), isTrue);
    });

    test('round number increments after full round', () {
      final enc = session.activeEncounter!;
      final hero = enc.allies.firstWhere((a) => a.isHero);
      final startRound = enc.roundNumber;
      session.submitCombatCommand(hero.instanceId, const CombatCommand.defend());
      session.resolveCombatRound();
      expect(enc.roundNumber, startRound + 1);
    });

    test('defeat sets game over', () {
      final result = session.resolveCombatDefeat();
      expect(session.gameOver, isTrue);
      expect(session.activeEncounter, isNull);
      expect(result.text, isNotEmpty);
    });

    test('flee returns a result while in combat', () {
      expect(session.inCombat, isTrue);
      final result = session.doFlee();
      expect(result.text, isNotEmpty);
    });

    test('companion hp syncs after round', () {
      final enc = session.activeEncounter!;
      final hero = enc.allies.firstWhere((a) => a.isHero);
      session.submitCombatCommand(hero.instanceId, const CombatCommand.defend());
      session.resolveCombatRound();
      expect(session.playerHp, enc.allies.firstWhere((a) => a.isHero).hp);
    });

    test('multi enemy encounter builds from monster_ids', () async {
      final s = await GameSession.create(WorldRepository());
      s.currentRoomId = 'goblin_cave';
      final msg = s.checkCombat();
      expect(msg, isNotNull);
      expect(s.activeEncounter!.enemies.length, 2);
    });

    test('battleEnded fires once on encounter victory', () {
      final enc = session.activeEncounter!;
      for (final e in enc.enemies) {
        e.hp = 0;
        e.alive = false;
        enc.markEnemyDefeated(e.instanceId);
      }
      final result = session.resolveEncounterVictory();
      expect(
        result.events.where((e) => e.type == GameEventType.battleEnded).length,
        1,
      );
    });

    test('flee success clears combat', () {
      final result = session.finishEncounter(CombatOutcome.fled);
      expect(session.inCombat, isFalse);
      expect(session.activeEncounter, isNull);
      expect(result.events.any((e) => e.type == GameEventType.battleEnded), isTrue);
    });
  });
}
