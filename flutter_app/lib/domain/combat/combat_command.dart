import 'package:zork_dude/domain/combat/combat_types.dart';

class CombatCommand {
  const CombatCommand({
    required this.type,
    this.targetInstanceId,
    this.itemId,
  });

  final CombatCommandType type;
  final String? targetInstanceId;
  final String? itemId;

  const CombatCommand.attack(this.targetInstanceId)
      : type = CombatCommandType.attack,
        itemId = null;

  const CombatCommand.skill(this.targetInstanceId)
      : type = CombatCommandType.skill,
        itemId = null;

  const CombatCommand.item(this.itemId, this.targetInstanceId)
      : type = CombatCommandType.item;

  const CombatCommand.defend()
      : type = CombatCommandType.defend,
        targetInstanceId = null,
        itemId = null;

  const CombatCommand.flee()
      : type = CombatCommandType.flee,
        targetInstanceId = null,
        itemId = null;
}
