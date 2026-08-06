/// Structured rewards from a victory settlement.
class CombatReward {
  const CombatReward({
    this.defeatedNames = const [],
    this.lootLabels = const [],
    this.gold = 0,
    this.exp = 0,
    this.notes = const [],
    this.banter,
  });

  final List<String> defeatedNames;
  final List<String> lootLabels;
  final int gold;
  final int exp;
  final List<String> notes;
  final String? banter;

  bool get hasLoot => lootLabels.isNotEmpty;
  bool get hasCurrency => gold > 0 || exp > 0;
}
