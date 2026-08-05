import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_random.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/combat_effects.dart';

enum StatusStackPolicy {
  replace,
  refreshDuration,
  stackIntensity,
}

class StatusEffectSpec {
  const StatusEffectSpec({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isDebuff,
    required this.defaultDuration,
    required this.stackPolicy,
    this.maxStacks = 1,
    this.damagePerStack = 0,
    this.healPerRound = 0,
    this.attackDelta = 0,
    this.defenseDelta = 0,
    this.skipAction = false,
  });

  final String id;
  final String name;
  final String emoji;
  final bool isDebuff;
  final int defaultDuration;
  final StatusStackPolicy stackPolicy;
  final int maxStacks;
  final int damagePerStack;
  final int healPerRound;
  final int attackDelta;
  final int defenseDelta;
  final bool skipAction;

  factory StatusEffectSpec.fromJson(Map<String, dynamic> json) {
    return StatusEffectSpec(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
      emoji: json['emoji'] as String? ?? '✨',
      isDebuff: json['debuff'] as bool? ?? false,
      defaultDuration: (json['duration'] as num?)?.toInt() ?? 1,
      stackPolicy: _parseStack(json['stack'] as String?),
      maxStacks: (json['max_stacks'] as num?)?.toInt() ?? 1,
      damagePerStack: (json['damage_per_stack'] as num?)?.toInt() ?? 0,
      healPerRound: (json['heal_per_round'] as num?)?.toInt() ?? 0,
      attackDelta: (json['attack_delta'] as num?)?.toInt() ?? 0,
      defenseDelta: (json['defense_delta'] as num?)?.toInt() ?? 0,
      skipAction: json['skip_action'] as bool? ?? false,
    );
  }

  static StatusStackPolicy _parseStack(String? raw) {
    switch (raw) {
      case 'stackIntensity':
        return StatusStackPolicy.stackIntensity;
      case 'refreshDuration':
        return StatusStackPolicy.refreshDuration;
      case 'replace':
      default:
        return StatusStackPolicy.replace;
    }
  }
}

class ActiveStatusEffect {
  ActiveStatusEffect({
    required this.specId,
    required this.sourceInstanceId,
    required this.remainingRounds,
    this.stacks = 1,
  });

  final String specId;
  final String sourceInstanceId;
  int remainingRounds;
  int stacks;
}

class StatusEffectRegistry {
  StatusEffectRegistry(this._specs);

  final Map<String, StatusEffectSpec> _specs;

  StatusEffectSpec? spec(String id) => _specs[id];

  static Future<StatusEffectRegistry> loadFromAssets() async {
    final raw = await rootBundle.loadString('assets/data/status_effects.json');
    final list = jsonDecode(raw) as List<dynamic>;
    final specs = <String, StatusEffectSpec>{};
    for (final entry in list) {
      final spec = StatusEffectSpec.fromJson(entry as Map<String, dynamic>);
      specs[spec.id] = spec;
    }
    return StatusEffectRegistry(specs);
  }

  static StatusEffectRegistry fromSpecs(List<StatusEffectSpec> specs) {
    return StatusEffectRegistry({for (final s in specs) s.id: s});
  }
}

abstract final class CombatStats {
  static int effectiveAttack(CombatActor actor, StatusEffectRegistry registry) {
    var bonus = 0;
    for (final active in actor.statuses) {
      final spec = registry.spec(active.specId);
      if (spec != null) bonus += spec.attackDelta * active.stacks;
    }
    return actor.attack + bonus;
  }

  static int effectiveDefense(CombatActor actor, StatusEffectRegistry registry) {
    var bonus = 0;
    for (final active in actor.statuses) {
      final spec = registry.spec(active.specId);
      if (spec != null) bonus += spec.defenseDelta * active.stacks;
    }
    return actor.defense + bonus;
  }

  static int effectiveSpeed(CombatActor actor, StatusEffectRegistry registry) {
    return actor.speed;
  }

  static bool isStunned(CombatActor actor, StatusEffectRegistry registry) {
    for (final active in actor.statuses) {
      final spec = registry.spec(active.specId);
      if (spec != null && spec.skipAction) return true;
    }
    return false;
  }
}

class StatusEffectService {
  StatusEffectService(this.registry);

  final StatusEffectRegistry registry;

  bool applyEffect({
    required CombatActor target,
    required String effectId,
    required String sourceInstanceId,
    int? duration,
    int potency = 1,
    double chance = 1.0,
    required CombatRandom random,
    required List<CombatActionStep> steps,
  }) {
    final spec = registry.spec(effectId);
    if (spec == null) return false;
    if (chance < 1.0 && random.nextDouble() > chance) {
      steps.add(CombatActionStep(
        kind: CombatActionKind.statusResist,
        actorInstanceId: sourceInstanceId,
        targetInstanceId: target.instanceId,
        statusEffectId: effectId,
        message: '${target.name} 抵抗了 ${spec.name}！',
      ));
      return false;
    }

    final dur = duration ?? spec.defaultDuration;
    final existing = target.statuses.where((s) => s.specId == effectId).firstOrNull;

    if (existing != null) {
      switch (spec.stackPolicy) {
        case StatusStackPolicy.replace:
          existing.remainingRounds = dur > existing.remainingRounds ? dur : existing.remainingRounds;
        case StatusStackPolicy.refreshDuration:
          existing.remainingRounds = dur;
        case StatusStackPolicy.stackIntensity:
          existing.stacks = (existing.stacks + potency).clamp(1, spec.maxStacks);
          existing.remainingRounds = dur;
      }
    } else {
      target.statuses.add(ActiveStatusEffect(
        specId: effectId,
        sourceInstanceId: sourceInstanceId,
        remainingRounds: dur,
        stacks: potency.clamp(1, spec.maxStacks),
      ));
    }

    steps.add(CombatActionStep(
      kind: CombatActionKind.statusApply,
      actorInstanceId: sourceInstanceId,
      targetInstanceId: target.instanceId,
      statusEffectId: effectId,
      stacks: target.statuses.lastWhere((s) => s.specId == effectId).stacks,
      remainingRounds: dur,
      message: '${target.name} 获得 ${spec.emoji} ${spec.name}！',
    ));
    return true;
  }

  void applyFromList({
    required CombatActor target,
    required String sourceInstanceId,
    required List<CombatEffectApplication> effects,
    required CombatRandom random,
    required List<CombatActionStep> steps,
  }) {
    for (final effect in effects) {
      if (effect.cleanse != null) {
        cleanse(target, effect.cleanse!, steps);
        continue;
      }
      applyEffect(
        target: target,
        effectId: effect.effectId,
        sourceInstanceId: sourceInstanceId,
        duration: effect.duration,
        potency: effect.potency,
        chance: effect.chance,
        random: random,
        steps: steps,
      );
    }
  }

  void cleanse(CombatActor target, List<String> effectIds, List<CombatActionStep> steps) {
    final removed = <String>[];
    target.statuses.removeWhere((s) {
      if (effectIds.contains(s.specId)) {
        removed.add(s.specId);
        return true;
      }
      return false;
    });
    for (final id in removed) {
      final spec = registry.spec(id);
      steps.add(CombatActionStep(
        kind: CombatActionKind.statusExpire,
        actorInstanceId: target.instanceId,
        targetInstanceId: target.instanceId,
        statusEffectId: id,
        message: '${target.name} 的 ${spec?.name ?? id} 被解除了。',
      ));
    }
  }

  void tickRoundEnd(CombatActor actor, List<CombatActionStep> steps) {
    final toRemove = <ActiveStatusEffect>[];
    for (final active in actor.statuses) {
      final spec = registry.spec(active.specId);
      if (spec == null) {
        toRemove.add(active);
        continue;
      }

      if (spec.damagePerStack > 0 && actor.alive) {
        final dmg = spec.damagePerStack * active.stacks;
        actor.hp = (actor.hp - dmg).clamp(0, actor.maxHp);
        if (actor.hp <= 0) actor.alive = false;
        steps.add(CombatActionStep(
          kind: CombatActionKind.statusTick,
          actorInstanceId: actor.instanceId,
          targetInstanceId: actor.instanceId,
          amount: dmg,
          statusEffectId: active.specId,
          stacks: active.stacks,
          message: '${actor.name} 受到 ${spec.emoji} ${spec.name} $dmg 点伤害！',
        ));
      }

      if (spec.healPerRound > 0 && actor.alive) {
        final before = actor.hp;
        actor.hp = (actor.hp + spec.healPerRound).clamp(0, actor.maxHp);
        final actual = actor.hp - before;
        if (actual > 0) {
          steps.add(CombatActionStep(
            kind: CombatActionKind.statusTick,
            actorInstanceId: actor.instanceId,
            targetInstanceId: actor.instanceId,
            amount: actual,
            statusEffectId: active.specId,
            message: '${actor.name} 的 ${spec.emoji} ${spec.name} 恢复 $actual 点 HP！',
          ));
        }
      }

      active.remainingRounds -= 1;
      if (active.remainingRounds <= 0) {
        toRemove.add(active);
        steps.add(CombatActionStep(
          kind: CombatActionKind.statusExpire,
          actorInstanceId: actor.instanceId,
          targetInstanceId: actor.instanceId,
          statusEffectId: active.specId,
          message: '${actor.name} 的 ${spec.emoji} ${spec.name} 消失了。',
        ));
      }
    }
    for (final r in toRemove) {
      actor.statuses.remove(r);
    }
  }

  void clearAll(CombatActor actor) {
    actor.statuses.clear();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
