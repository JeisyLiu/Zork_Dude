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
