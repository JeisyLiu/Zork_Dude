import 'package:zork_dude/domain/combat/combat_types.dart';

class CombatActionStep {
  const CombatActionStep({
    required this.kind,
    required this.actorInstanceId,
    this.targetInstanceId,
    this.amount = 0,
    this.message = '',
    this.itemId,
    this.statusEffectId,
    this.stacks,
    this.remainingRounds,
  });

  final CombatActionKind kind;
  final String actorInstanceId;
  final String? targetInstanceId;
  final int amount;
  final String message;
  final String? itemId;
  final String? statusEffectId;
  final int? stacks;
  final int? remainingRounds;
}

class CombatRoundResult {
  const CombatRoundResult({
    required this.steps,
    this.outcome,
    this.fled = false,
  });

  final List<CombatActionStep> steps;
  final CombatOutcome? outcome;
  final bool fled;

  bool get combatEnded => outcome != null || fled;
}
