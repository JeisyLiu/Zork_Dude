import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_command_labels.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatCommandQueue extends StatelessWidget {
  const CombatCommandQueue({
    super.key,
    required this.encounter,
    this.activeActorId,
    this.compact = false,
  });

  final CombatEncounter encounter;
  final String? activeActorId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final allies = encounter.livingAllies()
      ..sort((a, b) => a.commandOrder.compareTo(b.commandOrder));

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText(
            l10n.combatQueueTitle,
            fontSize: compact ? 12 : 14,
            color: d.textMuted,
            strokeWidth: 0,
          ),
          const SizedBox(height: 6),
          if (compact)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final ally in allies) _entry(context, ally, d, l10n),
                ],
              ),
            )
          else
            ...allies.map(
              (ally) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: _entry(context, ally, d, l10n),
              ),
            ),
        ],
      ),
    );
  }

  Widget _entry(
    BuildContext context,
    ally,
    GameUiSkinData d,
    AppLocalizations l10n,
  ) {
    final cmd = encounter.pendingAllyCommands[ally.instanceId];
    final waiting = ally.instanceId == activeActorId;
    final text = cmd == null
        ? (waiting ? l10n.combatQueuePending : '—')
        : CombatCommandLabels.summarize(l10n, cmd, encounter);

    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text(
          ally.emoji.isNotEmpty ? ally.emoji : '🧙',
          style: TextStyle(fontSize: compact ? 14 : 16),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: GameOutlinedText(
            '${ally.name}: $text',
            fontSize: compact ? 11 : 13,
            color: waiting ? const Color(0xFFE8B84A) : d.textPrimary,
            strokeWidth: 0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
