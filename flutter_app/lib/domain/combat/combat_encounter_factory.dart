import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/l10n/game_messages.dart';

/// Builds runtime [CombatEncounter] snapshots from world/session state.
class CombatEncounterFactory {
  static CombatEncounter build({
    required String roomId,
    required int playerHp,
    required int playerMaxHp,
    required int playerAttack,
    required int playerDefense,
    required int playerSpeed,
    required List<CompanionState> party,
    required List<MonsterState> enemyTemplates,
    required GameMessages messages,
  }) {
    final allies = <CombatActor>[
      CombatActor(
        instanceId: 'player#0',
        templateId: 'player',
        side: CombatSide.ally,
        name: messages.playerName,
        emoji: '🧙',
        maxHp: playerMaxHp,
        hp: playerHp,
        attack: playerAttack,
        defense: playerDefense,
        speed: playerSpeed,
        isHero: true,
        commandOrder: 0,
      ),
    ];

    var order = 1;
    for (final c in party) {
      if (!c.recruited || c.hp <= 0) continue;
      allies.add(CombatActor(
        instanceId: '${c.id}#0',
        templateId: c.id,
        side: CombatSide.ally,
        name: c.name,
        emoji: c.emoji,
        maxHp: c.maxHp,
        hp: c.hp,
        attack: c.attack + (c.getBonus()['dmg'] ?? 0),
        defense: c.defense + (c.getBonus()['def'] ?? 0),
        speed: c.speed,
        role: c.role,
        commandOrder: order++,
      ));
      if (allies.length >= 4) break;
    }

    final enemies = <CombatActor>[];
    final counts = <String, int>{};
    for (final m in enemyTemplates) {
      final idx = counts[m.id] ?? 0;
      counts[m.id] = idx + 1;
      enemies.add(CombatActor(
        instanceId: '${m.id}#$idx',
        templateId: m.id,
        side: CombatSide.enemy,
        name: m.name,
        emoji: m.emoji,
        maxHp: m.maxHp,
        hp: m.hp,
        attack: m.attack,
        defense: m.defense,
        speed: m.speed,
        aiType: m.aiType,
        commandOrder: idx,
      ));
      if (enemies.length >= 4) break;
    }

    return CombatEncounter(roomId: roomId, allies: allies, enemies: enemies);
  }

  static void syncAllyHpToSession(
    CombatEncounter encounter,
    GameSessionRef session,
    Map<String, CompanionState> companions,
  ) {
    for (final ally in encounter.allies) {
      if (ally.isHero) {
        session.playerHp = ally.hp;
        continue;
      }
      final c = companions[ally.templateId];
      if (c != null) c.hp = ally.hp;
    }
  }
}
