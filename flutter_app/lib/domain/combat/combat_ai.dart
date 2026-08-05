import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_random.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';

class CombatAi {
  CombatCommand pickCommand({
    required CombatActor actor,
    required CombatEncounter encounter,
    required CombatRandom random,
  }) {
    final allies = encounter.livingAllies();
    final enemies = encounter.livingEnemies();
    if (allies.isEmpty || enemies.isEmpty) {
      return const CombatCommand.defend();
    }

    switch (actor.aiType) {
      case EnemyAiType.boss:
        return _bossCommand(actor, allies, random);
      case EnemyAiType.lowHpTarget:
        return _lowHpTargetCommand(actor, allies, random);
      case EnemyAiType.normal:
        return _normalCommand(actor, allies, random);
    }
  }

  CombatCommand _normalCommand(
    CombatActor actor,
    List<CombatActor> allies,
    CombatRandom random,
  ) {
    final idx = random.nextDouble() >= 0.5 ? 0 : (random.nextDouble() * allies.length).floor();
    final target = allies[idx.clamp(0, allies.length - 1)];
    return CombatCommand.attack(target.instanceId);
  }

  CombatCommand _lowHpTargetCommand(
    CombatActor actor,
    List<CombatActor> allies,
    CombatRandom random,
  ) {
    final sorted = List<CombatActor>.from(allies)
      ..sort((a, b) => a.hp.compareTo(b.hp));
    final target = sorted.first;
    return CombatCommand.attack(target.instanceId);
  }

  CombatCommand _bossCommand(
    CombatActor actor,
    List<CombatActor> allies,
    CombatRandom random,
  ) {
    if (actor.hp < actor.maxHp * 0.35 && random.nextDouble() < 0.35) {
      return const CombatCommand.defend();
    }
    final heroes = allies.where((a) => a.isHero).toList();
    final target = heroes.isNotEmpty ? heroes.first : allies.first;
    return CombatCommand.attack(target.instanceId);
  }

  /// Companion skill command when player selects "skill".
  static CombatCommand defaultAllySkill(CombatActor actor, CombatEncounter encounter) {
    switch (actor.role) {
      case CompanionRole.healer:
        final wounded = encounter.livingAllies()
          ..sort((a, b) => (a.hp / a.maxHp).compareTo(b.hp / b.maxHp));
        return CombatCommand.skill(wounded.first.instanceId);
      case CompanionRole.mage:
      case CompanionRole.rogue:
      case CompanionRole.warrior:
      case CompanionRole.scout:
      case null:
        final enemies = encounter.livingEnemies();
        if (enemies.isEmpty) return const CombatCommand.defend();
        return CombatCommand.skill(enemies.first.instanceId);
    }
  }
}
