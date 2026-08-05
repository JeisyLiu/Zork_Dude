import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';

abstract final class CombatCommandLabels {
  static String typeLabel(CombatCommandType type) {
    return switch (type) {
      CombatCommandType.attack => '攻击',
      CombatCommandType.skill => '技能',
      CombatCommandType.item => '道具',
      CombatCommandType.defend => '防御',
      CombatCommandType.flee => '逃跑',
    };
  }

  static String shortLabel(CombatCommandType type) {
    return switch (type) {
      CombatCommandType.attack => '攻',
      CombatCommandType.skill => '技',
      CombatCommandType.item => '道',
      CombatCommandType.defend => '防',
      CombatCommandType.flee => '逃',
    };
  }

  static String summarize(CombatCommand command, CombatEncounter encounter) {
    final base = typeLabel(command.type);
    final targetId = command.targetInstanceId;
    if (targetId == null) return base;
    final target = encounter.actorById(targetId);
    return '$base → ${target?.name ?? targetId}';
  }
}
