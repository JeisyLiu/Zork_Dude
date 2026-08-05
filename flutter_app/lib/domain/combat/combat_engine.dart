import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_ai.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_random.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';

class CombatEngine {
  CombatEngine({CombatAi? ai, CombatRandom? random})
      : _ai = ai ?? CombatAi(),
        _random = random ?? DefaultCombatRandom();

  final CombatAi _ai;
  final CombatRandom _random;

  static const fleeSuccessChance = 0.5;
  static const defendDamageMultiplier = 0.5;

  void submitAllyCommand(CombatEncounter encounter, String actorId, CombatCommand command) {
    final actor = encounter.actorById(actorId);
    if (actor == null || !actor.alive || !actor.isAlly) return;
    if (encounter.phase != CombatPhase.command) return;
    encounter.pendingAllyCommands[actorId] = command;
  }

  void generateEnemyCommands(CombatEncounter encounter) {
    encounter.pendingEnemyCommands.clear();
    for (final enemy in encounter.livingEnemies()) {
      encounter.pendingEnemyCommands[enemy.instanceId] = _ai.pickCommand(
        actor: enemy,
        encounter: encounter,
        random: _random,
      );
    }
  }

  CombatRoundResult resolveRound(CombatEncounter encounter) {
    if (!encounter.allAlliesCommanded) {
      throw StateError('Not all allies have submitted commands');
    }

    encounter.phase = CombatPhase.resolving;

    final steps = <CombatActionStep>[];

    final fleeCommand = encounter.pendingAllyCommands.values
        .any((c) => c.type == CombatCommandType.flee);
    if (fleeCommand) {
      final hero = encounter.allies.firstWhere((a) => a.isHero, orElse: () => encounter.allies.first);
      steps.add(CombatActionStep(
        kind: CombatActionKind.fleeAttempt,
        actorInstanceId: hero.instanceId,
        message: '队伍尝试逃跑……',
      ));
      if (_random.nextDouble() < fleeSuccessChance) {
        encounter.outcome = CombatOutcome.fled;
        encounter.phase = CombatPhase.finished;
        steps.add(CombatActionStep(
          kind: CombatActionKind.fleeSuccess,
          actorInstanceId: hero.instanceId,
          message: '逃跑成功！',
        ));
        encounter.clearRoundCommands();
        return CombatRoundResult(steps: steps, outcome: CombatOutcome.fled, fled: true);
      }
      steps.add(CombatActionStep(
        kind: CombatActionKind.fleeFail,
        actorInstanceId: hero.instanceId,
        message: '逃跑失败！',
      ));
    }

    generateEnemyCommands(encounter);

    final ordered = _orderActions(encounter);

    for (final entry in ordered) {
      final actor = encounter.actorById(entry.actorId);
      if (actor == null || !actor.alive) continue;

      final command = entry.command;
      switch (command.type) {
        case CombatCommandType.attack:
          _resolveAttack(encounter, actor, command, steps);
        case CombatCommandType.skill:
          _resolveSkill(encounter, actor, command, steps);
        case CombatCommandType.item:
          _resolveItem(encounter, actor, command, steps);
        case CombatCommandType.defend:
          actor.defending = true;
          steps.add(CombatActionStep(
            kind: CombatActionKind.defend,
            actorInstanceId: actor.instanceId,
            message: '${actor.name} 进入防御姿态。',
          ));
        case CombatCommandType.flee:
          break;
      }

      _checkDeaths(encounter, steps);
      final outcome = _checkOutcome(encounter);
      if (outcome != null) {
        encounter.outcome = outcome;
        encounter.phase = CombatPhase.finished;
        encounter.clearRoundCommands();
        return CombatRoundResult(steps: steps, outcome: outcome);
      }
    }

    encounter.clearRoundCommands();
    encounter.phase = CombatPhase.command;
    return CombatRoundResult(steps: steps);
  }

  List<({String actorId, CombatCommand command, int speed, int order, CombatSide side})> _orderActions(
    CombatEncounter encounter,
  ) {
    final entries = <({String actorId, CombatCommand command, int speed, int order, CombatSide side})>[];

    void addFrom(Map<String, CombatCommand> map, CombatSide side) {
      for (final e in map.entries) {
        final actor = encounter.actorById(e.key);
        if (actor == null || !actor.alive) continue;
        if (e.value.type == CombatCommandType.flee) continue;
        entries.add((
          actorId: e.key,
          command: e.value,
          speed: actor.speed,
          order: actor.commandOrder,
          side: side,
        ));
      }
    }

    addFrom(encounter.pendingAllyCommands, CombatSide.ally);
    addFrom(encounter.pendingEnemyCommands, CombatSide.enemy);

    entries.sort((a, b) {
      final speedCmp = b.speed.compareTo(a.speed);
      if (speedCmp != 0) return speedCmp;
      if (a.side != b.side) {
        return a.side == CombatSide.ally ? -1 : 1;
      }
      return a.order.compareTo(b.order);
    });

    return entries;
  }

  void _resolveAttack(
    CombatEncounter encounter,
    CombatActor actor,
    CombatCommand command,
    List<CombatActionStep> steps,
  ) {
    final targetId = command.targetInstanceId;
    if (targetId == null) return;
    final target = encounter.actorById(targetId);
    if (target == null || !target.alive) return;

    final raw = actor.attack + _random.rollDice(4);
    final mitigated = _applyDefense(raw, target);
    target.hp = (target.hp - mitigated).clamp(0, target.maxHp);
    if (target.hp <= 0) target.alive = false;

    steps.add(CombatActionStep(
      kind: CombatActionKind.attack,
      actorInstanceId: actor.instanceId,
      targetInstanceId: target.instanceId,
      amount: mitigated,
      message: '${actor.name} 攻击 ${target.name}，造成 $mitigated 点伤害！',
    ));
  }

  void _resolveSkill(
    CombatEncounter encounter,
    CombatActor actor,
    CombatCommand command,
    List<CombatActionStep> steps,
  ) {
    if (actor.isAlly && actor.role == CompanionRole.healer) {
      final targetId = command.targetInstanceId ?? actor.instanceId;
      final target = encounter.actorById(targetId);
      if (target == null || !target.alive) return;
      final heal = _random.rollDice(6, 2);
      final before = target.hp;
      target.hp = (target.hp + heal).clamp(0, target.maxHp);
      final actual = target.hp - before;
      steps.add(CombatActionStep(
        kind: CombatActionKind.heal,
        actorInstanceId: actor.instanceId,
        targetInstanceId: target.instanceId,
        amount: actual,
        message: '${actor.name} 治疗 ${target.name}，恢复 $actual 点 HP！',
      ));
      return;
    }

    final targetId = command.targetInstanceId;
    if (targetId == null) return;
    final target = encounter.actorById(targetId);
    if (target == null || !target.alive) return;

    var raw = actor.attack + _random.rollDice(6);
    if (actor.role == CompanionRole.mage) raw += 3;
    if (actor.role == CompanionRole.rogue && _random.nextDouble() < 0.4) {
      raw = (raw * 1.5).round();
    }
    final mitigated = _applyDefense(raw, target);
    target.hp = (target.hp - mitigated).clamp(0, target.maxHp);
    if (target.hp <= 0) target.alive = false;

    steps.add(CombatActionStep(
      kind: CombatActionKind.skill,
      actorInstanceId: actor.instanceId,
      targetInstanceId: target.instanceId,
      amount: mitigated,
      message: '${actor.name} 释放技能，对 ${target.name} 造成 $mitigated 点伤害！',
    ));
  }

  void _resolveItem(
    CombatEncounter encounter,
    CombatActor actor,
    CombatCommand command,
    List<CombatActionStep> steps,
  ) {
    final targetId = command.targetInstanceId ?? actor.instanceId;
    final target = encounter.actorById(targetId);
    if (target == null || !target.alive) return;
    final heal = command.itemId == null ? 0 : _itemHealAmount(command.itemId!);
    if (heal <= 0) return;
    final before = target.hp;
    target.hp = (target.hp + heal).clamp(0, target.maxHp);
    final actual = target.hp - before;
    steps.add(CombatActionStep(
      kind: CombatActionKind.heal,
      actorInstanceId: actor.instanceId,
      targetInstanceId: target.instanceId,
      amount: actual,
      itemId: command.itemId,
      message: '${actor.name} 使用道具，${target.name} 恢复 $actual 点 HP！',
    ));
  }

  int _itemHealAmount(String itemId) {
    if (itemId.contains('greater')) return 30;
    if (itemId.contains('potion')) return 15;
    if (itemId.contains('bread') || itemId.contains('meat')) return 8;
    return 10;
  }

  int _applyDefense(int rawDamage, CombatActor target) {
    var dmg = (rawDamage - target.defense).clamp(1, 999);
    if (target.defending) {
      dmg = (dmg * defendDamageMultiplier).round().clamp(1, 999);
    }
    return dmg;
  }

  void _checkDeaths(CombatEncounter encounter, List<CombatActionStep> steps) {
    for (final actor in encounter.allActors) {
      if (!actor.alive && actor.isEnemy) {
        encounter.markEnemyDefeated(actor.instanceId);
      }
      if (actor.hp <= 0 && actor.alive) {
        actor.alive = false;
        if (actor.isEnemy) encounter.markEnemyDefeated(actor.instanceId);
        steps.add(CombatActionStep(
          kind: CombatActionKind.death,
          actorInstanceId: actor.instanceId,
          message: '${actor.name} 倒下了！',
        ));
      }
    }
  }

  CombatOutcome? _checkOutcome(CombatEncounter encounter) {
    if (encounter.livingEnemies().isEmpty) return CombatOutcome.victory;
    if (encounter.livingAllies().isEmpty) return CombatOutcome.defeat;
    final hero = encounter.allies.where((a) => a.isHero).firstOrNull;
    if (hero != null && !hero.alive) return CombatOutcome.defeat;
    return null;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
