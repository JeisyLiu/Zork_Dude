import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
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
  final List<ActiveStatusEffect> statuses = [];

  String get label => emoji.isNotEmpty ? '$emoji $name' : name;

  bool get isAlly => side == CombatSide.ally;
  bool get isEnemy => side == CombatSide.enemy;

  int effectiveAttack(StatusEffectRegistry registry) =>
      CombatStats.effectiveAttack(this, registry);

  int effectiveDefense(StatusEffectRegistry registry) =>
      CombatStats.effectiveDefense(this, registry);

  int effectiveSpeed(StatusEffectRegistry registry) =>
      CombatStats.effectiveSpeed(this, registry);

  bool isStunned(StatusEffectRegistry registry) =>
      CombatStats.isStunned(this, registry);

  CombatActor copyWith({
    int? hp,
    bool? defending,
    bool? alive,
    List<ActiveStatusEffect>? statuses,
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
    if (statuses != null) {
      copy.statuses.addAll(statuses);
    } else {
      for (final s in this.statuses) {
        copy.statuses.add(ActiveStatusEffect(
          specId: s.specId,
          sourceInstanceId: s.sourceInstanceId,
          remainingRounds: s.remainingRounds,
          stacks: s.stacks,
        ));
      }
    }
    return copy;
  }
}
