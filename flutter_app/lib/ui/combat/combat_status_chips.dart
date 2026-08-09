import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatStatusChips extends StatelessWidget {
  const CombatStatusChips({
    super.key,
    required this.actor,
    required this.registry,
    this.compact = false,
  });

  final CombatActor actor;
  final StatusEffectRegistry registry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final chips = <Widget>[];

    if (actor.defending) {
      chips.add(
        _chip(AppLocalizations.of(context).combatDefendShort, d.textMuted, compact),
      );
    }

    for (final active in actor.statuses) {
      final spec = registry.spec(active.specId);
      if (spec == null) continue;
      final label = active.stacks > 1
          ? '${spec.emoji}${active.stacks}'
          : spec.emoji;
      chips.add(_chip(label, spec.isDebuff ? const Color(0xFFFF8888) : const Color(0xFF88FFAA), compact));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 2,
      runSpacing: 2,
      children: chips,
    );
  }

  Widget _chip(String text, Color color, bool compact) {
    return GameOutlinedText(
      text,
      fontSize: compact ? 7 : 8,
      color: color,
      strokeWidth: 0,
      height: 1.0,
    );
  }
}
