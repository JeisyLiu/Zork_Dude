class CombatEffectApplication {
  const CombatEffectApplication({
    required this.effectId,
    this.duration,
    this.potency = 1,
    this.chance = 1.0,
    this.cleanse,
  });

  final String effectId;
  final int? duration;
  final int potency;
  final double chance;
  final List<String>? cleanse;

  factory CombatEffectApplication.fromJson(Map<String, dynamic> json) {
    final cleanseRaw = json['cleanse'];
    return CombatEffectApplication(
      effectId: json['effect'] as String? ?? json['effect_id'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt(),
      potency: (json['potency'] as num?)?.toInt() ?? 1,
      chance: (json['chance'] as num?)?.toDouble() ?? 1.0,
      cleanse: cleanseRaw is List
          ? cleanseRaw.map((e) => e.toString()).toList()
          : null,
    );
  }

  static List<CombatEffectApplication> listFromJson(dynamic raw) {
    if (raw == null) return const [];
    if (raw is! List) return const [];
    return raw
        .map((e) => CombatEffectApplication.fromJson(e as Map<String, dynamic>))
        .where((e) => e.effectId.isNotEmpty || (e.cleanse != null && e.cleanse!.isNotEmpty))
        .toList();
  }
}
