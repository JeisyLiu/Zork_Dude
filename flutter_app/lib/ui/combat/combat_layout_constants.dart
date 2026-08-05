class CombatLayoutConstants {
  static const narrowWidth = 600.0;
  static const unitSlotWidth = 72.0;
  static const unitSlotHeight = 88.0;
  static const unitSlotCompact = 60.0;
  static const commandButtonHeight = 34.0;
  static const logMaxLines = 6;
}

enum CombatUiPhase {
  pickingCommand,
  pickingTarget,
  pickingItem,
  readyToExecute,
  animating,
}

enum CombatCommandOption {
  attack,
  skill,
  item,
  defend,
  flee,
}
