import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/game_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Melee mode', () {
    late GameSession session;

    setUp(() async {
      session = await GameSession.create(WorldRepository());
      session.processCommand('w');
      expect(session.inCombat, isTrue);
      expect(session.activeEncounter, isNotNull);
    });

    test('heroBelowMeleeThreshold is strict below 1/4', () {
      final hero = session.activeEncounter!.hero!;
      // Use existing maxHp; set hp to floor(max/4) and floor(max/4)-1.
      final quarter = hero.maxHp ~/ 4;
      hero.hp = quarter;
      expect(CombatEncounter.heroBelowMeleeThreshold(hero), isFalse);
      if (quarter > 0) {
        hero.hp = quarter - 1;
        expect(CombatEncounter.heroBelowMeleeThreshold(hero), isTrue);
      }
    });

    test('beginMelee unavailable when hero below quarter HP', () {
      final enc = session.activeEncounter!;
      final hero = enc.hero!;
      hero.hp = (hero.maxHp ~/ 4) - 1;
      if (hero.hp < 1) hero.hp = 0;
      expect(enc.canUseMelee, isFalse);
      expect(session.beginMelee(), isFalse);
      expect(enc.meleeActive, isFalse);
    });

    test('beginMelee fills ally attacks and sets flag', () {
      final enc = session.activeEncounter!;
      final hero = enc.hero!;
      hero.hp = hero.maxHp;
      expect(session.beginMelee(), isTrue);
      expect(enc.meleeActive, isTrue);
      expect(enc.allAlliesCommanded, isTrue);
      for (final ally in enc.livingAllies()) {
        final cmd = enc.pendingAllyCommands[ally.instanceId];
        expect(cmd, isNotNull);
        expect(cmd!.type.name, 'attack');
      }
    });

    test('melee stops after round when hero drops below quarter', () {
      final enc = session.activeEncounter!;
      final hero = enc.hero!;
      hero.hp = hero.maxHp;
      expect(session.beginMelee(), isTrue);

      enc.pendingAllyCommands.clear();
      for (final a in enc.livingAllies()) {
        session.submitCombatCommand(a.instanceId, const CombatCommand.defend());
      }
      final quarter = hero.maxHp ~/ 4;
      hero.hp = quarter > 0 ? quarter - 1 : 0;
      final result = session.resolveCombatRound();
      expect(result, isNotNull);
      expect(enc.shouldStopMelee, isTrue);
      expect(enc.meleeActive, isFalse);
      expect(session.prepareNextMeleeRound(), isFalse);
    });
  });
}
