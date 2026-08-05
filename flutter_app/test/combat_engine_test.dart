import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_encounter_factory.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/combat_random.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';

MonsterState _monster({
  required String id,
  int hp = 20,
  int atk = 5,
  int def = 1,
  int speed = 4,
  EnemyAiType ai = EnemyAiType.normal,
}) {
  return MonsterState(
    id: id,
    name: id,
    desc: '',
    maxHp: hp,
    hp: hp,
    attack: atk,
    defense: def,
    speed: speed,
    aiType: ai,
  );
}

CombatEncounter _basicEncounter({
  int playerHp = 50,
  int playerAtk = 10,
  List<MonsterState>? enemies,
}) {
  return CombatEncounterFactory.build(
    roomId: 'test',
    playerHp: playerHp,
    playerMaxHp: 50,
    playerAttack: playerAtk,
    playerDefense: 2,
    playerSpeed: 6,
    party: const [],
    enemyTemplates: enemies ?? [_monster(id: 'rat', hp: 10, atk: 3)],
  );
}

void main() {
  group('CombatEngine', () {
    test('requires all ally commands before resolving', () {
      final encounter = _basicEncounter();
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [2]));
      expect(() => engine.resolveRound(encounter), throwsStateError);
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.attack('rat#0'));
      final result = engine.resolveRound(encounter);
      expect(result.steps, isNotEmpty);
    });

    test('attack deals damage using attack and dice', () {
      final encounter = _basicEncounter(playerAtk: 10);
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [3]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.attack('rat#0'));
      engine.resolveRound(encounter);
      final rat = encounter.actorById('rat#0')!;
      expect(rat.hp, lessThan(10));
    });

    test('defend reduces incoming damage', () {
      final encounter = CombatEncounter(
        roomId: 't',
        allies: [
          CombatActor(
            instanceId: 'player#0',
            templateId: 'player',
            side: CombatSide.ally,
            name: 'Hero',
            maxHp: 50,
            hp: 50,
            attack: 5,
            defense: 0,
            speed: 15,
            isHero: true,
          ),
        ],
        enemies: [
          CombatActor(
            instanceId: 'rat#0',
            templateId: 'rat',
            side: CombatSide.enemy,
            name: 'Rat',
            maxHp: 50,
            hp: 50,
            attack: 20,
            defense: 0,
            speed: 10,
          ),
        ],
      );
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [4, 4]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.defend());
      engine.resolveRound(encounter);
      final hero = encounter.actorById('player#0')!;
      expect(hero.hp, greaterThan(35));
    });

    test('flee success ends combat', () {
      final encounter = _basicEncounter();
      final engine = CombatEngine(
        random: ScriptedCombatRandom(doubles: [0.1]),
      );
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.flee());
      final result = engine.resolveRound(encounter);
      expect(result.fled, isTrue);
      expect(encounter.outcome, CombatOutcome.fled);
    });

    test('flee fail continues round', () {
      final encounter = _basicEncounter();
      final engine = CombatEngine(
        random: ScriptedCombatRandom(diceRolls: [1, 1], doubles: [0.9, 0.0]),
      );
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.flee());
      final result = engine.resolveRound(encounter);
      expect(result.fled, isFalse);
      expect(result.steps.any((s) => s.kind == CombatActionKind.fleeFail), isTrue);
    });

    test('victory when all enemies defeated', () {
      final encounter = _basicEncounter(
        playerAtk: 50,
        enemies: [_monster(id: 'rat', hp: 1, atk: 1)],
      );
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [4, 1]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.attack('rat#0'));
      final result = engine.resolveRound(encounter);
      expect(result.outcome, CombatOutcome.victory);
      expect(encounter.livingEnemies(), isEmpty);
    });

    test('defeat when hero falls', () {
      final encounter = CombatEncounter(
        roomId: 't',
        allies: [
          CombatActor(
            instanceId: 'player#0',
            templateId: 'player',
            side: CombatSide.ally,
            name: 'Hero',
            maxHp: 5,
            hp: 1,
            attack: 1,
            speed: 1,
            isHero: true,
          ),
        ],
        enemies: [
          CombatActor(
            instanceId: 'rat#0',
            templateId: 'rat',
            side: CombatSide.enemy,
            name: 'Rat',
            maxHp: 50,
            hp: 50,
            attack: 30,
            defense: 0,
            speed: 10,
          ),
        ],
      );
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [4, 4]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.defend());
      final result = engine.resolveRound(encounter);
      expect(result.outcome, CombatOutcome.defeat);
    });

    test('speed orders actions with allies breaking ties', () {
      final encounter = CombatEncounter(
        roomId: 't',
        allies: [
          CombatActor(
            instanceId: 'player#0',
            templateId: 'player',
            side: CombatSide.ally,
            name: 'Hero',
            maxHp: 50,
            hp: 50,
            attack: 1,
            speed: 5,
            isHero: true,
            commandOrder: 0,
          ),
          CombatActor(
            instanceId: 'comp#0',
            templateId: 'comp',
            side: CombatSide.ally,
            name: 'Ally',
            maxHp: 50,
            hp: 50,
            attack: 1,
            speed: 5,
            commandOrder: 1,
          ),
        ],
        enemies: [
          CombatActor(
            instanceId: 'rat#0',
            templateId: 'rat',
            side: CombatSide.enemy,
            name: 'Rat',
            maxHp: 50,
            hp: 50,
            attack: 1,
            speed: 5,
            commandOrder: 0,
          ),
        ],
      );
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [1, 1, 1, 1, 1, 1]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.attack('rat#0'));
      engine.submitAllyCommand(encounter, 'comp#0', const CombatCommand.attack('rat#0'));
      final result = engine.resolveRound(encounter);
      final attackSteps = result.steps.where((s) => s.kind == CombatActionKind.attack).toList();
      expect(attackSteps.first.actorInstanceId, 'player#0');
    });

    test('healer skill heals lowest ally', () {
      final encounter = CombatEncounterFactory.build(
        roomId: 't',
        playerHp: 10,
        playerMaxHp: 50,
        playerAttack: 5,
        playerDefense: 0,
        playerSpeed: 5,
        party: [
          CompanionState(
            id: 'healer',
            name: 'Healer',
            maxHp: 40,
            hp: 40,
            attack: 5,
            role: CompanionRole.healer,
            recruited: true,
          ),
        ],
        enemyTemplates: [_monster(id: 'rat', hp: 50, atk: 1)],
      );
      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: [3, 3, 1]));
      engine.submitAllyCommand(encounter, 'player#0', const CombatCommand.defend());
      engine.submitAllyCommand(
        encounter,
        'healer#0',
        CombatCommand.skill('player#0'),
      );
      engine.resolveRound(encounter);
      expect(encounter.actorById('player#0')!.hp, greaterThan(10));
    });

    test('4v4 encounter resolves full round', () {
      final party = List.generate(
        3,
        (i) => CompanionState(
          id: 'c$i',
          name: 'C$i',
          maxHp: 30,
          hp: 30,
          attack: 5,
          recruited: true,
        ),
      );
      final enemies = List.generate(4, (i) => _monster(id: 'm$i', hp: 20, atk: 3));
      final encounter = CombatEncounterFactory.build(
        roomId: 'big',
        playerHp: 40,
        playerMaxHp: 40,
        playerAttack: 8,
        playerDefense: 2,
        playerSpeed: 6,
        party: party,
        enemyTemplates: enemies,
      );
      expect(encounter.allies.length, 4);
      expect(encounter.enemies.length, 4);

      final engine = CombatEngine(random: ScriptedCombatRandom(diceRolls: List.filled(40, 2)));
      for (final ally in encounter.livingAllies()) {
        final target = encounter.livingEnemies().first.instanceId;
        engine.submitAllyCommand(encounter, ally.instanceId, CombatCommand.attack(target));
      }
      final result = engine.resolveRound(encounter);
      expect(result.steps, isNotEmpty);
    });
  });
}
