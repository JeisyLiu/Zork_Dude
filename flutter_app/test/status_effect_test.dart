import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_random.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';

CombatActor _actor({int hp = 30}) => CombatActor(
      instanceId: 'a#0',
      templateId: 'test',
      side: CombatSide.ally,
      name: 'Test',
      maxHp: 30,
      hp: hp,
      attack: 5,
    );

void main() {
  group('StatusEffectService', () {
    late StatusEffectRegistry registry;
    late StatusEffectService service;

    setUp(() {
      registry = StatusEffectRegistry.fromSpecs([
        const StatusEffectSpec(
          id: 'poison',
          name: '中毒',
          emoji: '☠️',
          isDebuff: true,
          defaultDuration: 3,
          stackPolicy: StatusStackPolicy.stackIntensity,
          maxStacks: 3,
          damagePerStack: 2,
        ),
        const StatusEffectSpec(
          id: 'stun',
          name: '眩晕',
          emoji: '💫',
          isDebuff: true,
          defaultDuration: 1,
          stackPolicy: StatusStackPolicy.replace,
          skipAction: true,
        ),
        const StatusEffectSpec(
          id: 'attackUp',
          name: '攻击提升',
          emoji: '⚔️',
          isDebuff: false,
          defaultDuration: 2,
          stackPolicy: StatusStackPolicy.refreshDuration,
          attackDelta: 3,
        ),
        const StatusEffectSpec(
          id: 'regen',
          name: '恢复',
          emoji: '💚',
          isDebuff: false,
          defaultDuration: 2,
          stackPolicy: StatusStackPolicy.replace,
          healPerRound: 4,
        ),
      ]);
      service = StatusEffectService(registry);
    });

    test('poison stacks intensity', () {
      final actor = _actor();
      final steps = <CombatActionStep>[];
      final random = ScriptedCombatRandom(doubles: [0.0]);
      service.applyEffect(
        target: actor,
        effectId: 'poison',
        sourceInstanceId: 'src',
        potency: 1,
        random: random,
        steps: steps,
      );
      service.applyEffect(
        target: actor,
        effectId: 'poison',
        sourceInstanceId: 'src',
        potency: 1,
        random: random,
        steps: steps,
      );
      expect(actor.statuses.first.stacks, 2);
    });

    test('poison ticks at round end', () {
      final actor = _actor();
      final steps = <CombatActionStep>[];
      final random = ScriptedCombatRandom(doubles: [0.0]);
      service.applyEffect(
        target: actor,
        effectId: 'poison',
        sourceInstanceId: 'src',
        potency: 2,
        random: random,
        steps: steps,
      );
      service.tickRoundEnd(actor, steps);
      expect(actor.hp, 26);
    });

    test('stun detected by CombatStats', () {
      final actor = _actor();
      final steps = <CombatActionStep>[];
      service.applyEffect(
        target: actor,
        effectId: 'stun',
        sourceInstanceId: 'src',
        random: ScriptedCombatRandom(doubles: [0.0]),
        steps: steps,
      );
      expect(CombatStats.isStunned(actor, registry), isTrue);
    });

    test('attackUp increases effective attack', () {
      final actor = _actor();
      final steps = <CombatActionStep>[];
      service.applyEffect(
        target: actor,
        effectId: 'attackUp',
        sourceInstanceId: 'src',
        random: ScriptedCombatRandom(doubles: [0.0]),
        steps: steps,
      );
      expect(CombatStats.effectiveAttack(actor, registry), 8);
    });

    test('regen heals at round end', () {
      final actor = _actor(hp: 20);
      final steps = <CombatActionStep>[];
      service.applyEffect(
        target: actor,
        effectId: 'regen',
        sourceInstanceId: 'src',
        random: ScriptedCombatRandom(doubles: [0.0]),
        steps: steps,
      );
      service.tickRoundEnd(actor, steps);
      expect(actor.hp, 24);
    });
  });
}
