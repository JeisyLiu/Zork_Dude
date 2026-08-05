import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';

class CombatActor {
  CombatActor({
    required this.instanceId,
    required this.templateId,
    required this.side,
    required this.name,
    this.emoji = '',
    required this.maxHp,
    required this.hp,
    required this.attack,
    this.defense = 0,
    this.speed = 5,
    this.isHero = false,
    this.role,
    this.aiType = EnemyAiType.normal,
    this.commandOrder = 0,
  });

  final String instanceId;
  final String templateId;
  final CombatSide side;
  final String name;
  final String emoji;
  final int maxHp;
  int hp;
  final int attack;
  final int defense;
  final int speed;
  final bool isHero;
  final CompanionRole? role;
  final EnemyAiType aiType;

  /// Ally command submission order (lower = earlier).
  final int commandOrder;

  bool defending = false;
  bool alive = true;

  String get label => emoji.isNotEmpty ? '$emoji $name' : name;

  bool get isAlly => side == CombatSide.ally;
  bool get isEnemy => side == CombatSide.enemy;

  CombatActor copyWith({
    int? hp,
    bool? defending,
    bool? alive,
  }) {
    final copy = CombatActor(
      instanceId: instanceId,
      templateId: templateId,
      side: side,
      name: name,
      emoji: emoji,
      maxHp: maxHp,
      hp: hp ?? this.hp,
      attack: attack,
      defense: defense,
      speed: speed,
      isHero: isHero,
      role: role,
      aiType: aiType,
      commandOrder: commandOrder,
    );
    copy.defending = defending ?? this.defending;
    copy.alive = alive ?? this.alive;
    return copy;
  }
}
