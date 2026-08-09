import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatHeaderBar extends StatelessWidget {
  const CombatHeaderBar({
    super.key,
    required this.encounter,
    required this.phase,
    this.activeActorName,
    this.compact = false,
  });

  final CombatEncounter encounter;
  final CombatUiPhase phase;
  final String? activeActorName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final phaseText = switch (phase) {
      CombatUiPhase.pickingCommand => activeActorName != null
          ? l10n.combatPhasePickCommandNamed(activeActorName!)
          : l10n.combatPhasePickCommand,
      CombatUiPhase.pickingTarget => l10n.combatPhasePickTarget,
      CombatUiPhase.pickingItem => l10n.combatPhasePickItem,
      CombatUiPhase.readyToExecute => l10n.combatPhaseReady,
      CombatUiPhase.animating => l10n.combatPhaseAnimating,
    };

    return ConstrainedBox(
      // Nine-patch panel borders need ≥32px; keep a readable header height.
      constraints: BoxConstraints(minHeight: compact ? 36 : 40),
      child: GamePanel(
        withBorder: true,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 8 : 10,
        ),
        child: Row(
          children: [
            GameOutlinedText(
              l10n.combatRound(encounter.roundNumber),
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.bold,
              color: d.textPrimary,
              strokeWidth: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GameOutlinedText(
                phaseText,
                fontSize: compact ? 9 : 10,
                color: d.textMuted,
                strokeWidth: 0,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
