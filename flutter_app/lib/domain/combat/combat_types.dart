enum CombatSide { ally, enemy }

enum CombatPhase {
  /// Collecting commands from living allies.
  command,

  /// Animating / applying resolved round steps in UI.
  resolving,

  /// Combat finished (victory, defeat, or fled).
  finished,
}

enum CombatOutcome { victory, defeat, fled }

enum CombatCommandType { attack, skill, item, defend, flee }

enum EnemyAiType { normal, lowHpTarget, boss }

/// Visual / log step emitted after a round is resolved.
enum CombatActionKind {
  attack,
  skill,
  heal,
  defend,
  fleeAttempt,
  fleeSuccess,
  fleeFail,
  miss,
  death,
}
