import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';

class CombatEncounter {
  CombatEncounter({
    required this.roomId,
    required List<CombatActor> allies,
    required List<CombatActor> enemies,
  })  : allies = List<CombatActor>.from(allies),
        enemies = List<CombatActor>.from(enemies);

  final String roomId;
  final List<CombatActor> allies;
  final List<CombatActor> enemies;

  CombatPhase phase = CombatPhase.command;
  CombatOutcome? outcome;
  int roundNumber = 1;
  final Map<String, CombatCommand> pendingAllyCommands = {};
  final Map<String, CombatCommand> pendingEnemyCommands = {};
  final List<String> defeatedEnemyInstances = [];

  /// Destiny-of-an-Emperor style free melee auto-battle.
  bool meleeActive = false;

  /// Melee stops / locks when hero HP is strictly below 1/4 max.
  static bool heroBelowMeleeThreshold(CombatActor hero) =>
      hero.hp * 4 < hero.maxHp;

  CombatActor? get hero {
    for (final a in allies) {
      if (a.isHero) return a;
    }
    return allies.isEmpty ? null : allies.first;
  }

  bool get canUseMelee {
    final h = hero;
    if (h == null || !h.alive) return false;
    return !heroBelowMeleeThreshold(h);
  }

  bool get shouldStopMelee {
    final h = hero;
    if (h == null || !h.alive) return true;
    return heroBelowMeleeThreshold(h);
  }

  List<CombatActor> get allActors => [...allies, ...enemies];

  CombatActor? actorById(String id) {
    for (final a in allActors) {
      if (a.instanceId == id) return a;
    }
    return null;
  }

  List<CombatActor> livingAllies() =>
      allies.where((a) => a.alive).toList(growable: false);

  List<CombatActor> livingEnemies() =>
      enemies.where((a) => a.alive).toList(growable: false);

  bool get allAlliesCommanded {
    final living = livingAllies();
    if (living.isEmpty) return false;
    for (final a in living) {
      if (!pendingAllyCommands.containsKey(a.instanceId)) return false;
    }
    return true;
  }

  CombatActor? nextAllyNeedingCommand() {
    final living = livingAllies()..sort((a, b) => a.commandOrder.compareTo(b.commandOrder));
    for (final a in living) {
      if (!pendingAllyCommands.containsKey(a.instanceId)) return a;
    }
    return null;
  }

  void clearRoundCommands() {
    pendingAllyCommands.clear();
    pendingEnemyCommands.clear();
    for (final a in allActors) {
      a.defending = false;
    }
  }

  void markEnemyDefeated(String instanceId) {
    if (!defeatedEnemyInstances.contains(instanceId)) {
      defeatedEnemyInstances.add(instanceId);
    }
  }

  List<CombatActor> defeatedEnemies() {
    return enemies.where((e) => defeatedEnemyInstances.contains(e.instanceId)).toList();
  }
}
