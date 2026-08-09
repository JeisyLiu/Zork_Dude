import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/l10n/app_localizations.dart';

abstract final class CombatCommandLabels {
  static String typeLabel(AppLocalizations l10n, CombatCommandType type) {
    return switch (type) {
      CombatCommandType.attack => l10n.combatAttack,
      CombatCommandType.skill => l10n.combatSkill,
      CombatCommandType.item => l10n.combatItem,
      CombatCommandType.defend => l10n.combatDefend,
      CombatCommandType.flee => l10n.combatFlee,
    };
  }

  static String shortLabel(AppLocalizations l10n, CombatCommandType type) {
    return switch (type) {
      CombatCommandType.attack => l10n.combatAttackShort,
      CombatCommandType.skill => l10n.combatSkillShort,
      CombatCommandType.item => l10n.combatItemShort,
      CombatCommandType.defend => l10n.combatDefendShort,
      CombatCommandType.flee => l10n.combatFleeShort,
    };
  }

  static String summarize(
    AppLocalizations l10n,
    CombatCommand command,
    CombatEncounter encounter,
  ) {
    final base = typeLabel(l10n, command.type);
    final targetId = command.targetInstanceId;
    if (targetId == null) return base;
    final target = encounter.actorById(targetId);
    return '$base → ${target?.name ?? targetId}';
  }
}
