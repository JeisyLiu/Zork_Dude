import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
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
    final allies = encounter.livingAllies()..sort((a, b) => a.commandOrder.compareTo(b.commandOrder));

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText('指令队列 Commands', fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
          const SizedBox(height: 4),
          if (compact)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final ally in allies) _entry(context, ally, d),
                ],
              ),
            )
          else
            ...allies.map((ally) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: _entry(context, ally, d),
                )),
        ],
      ),
    );
  }

  Widget _entry(BuildContext context, ally, GameUiSkinData d) {
    final cmd = encounter.pendingAllyCommands[ally.instanceId];
    final waiting = ally.instanceId == activeActorId;
    final text = cmd == null
        ? (waiting ? '待选…' : '—')
        : CombatCommandLabels.summarize(cmd, encounter);

    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text(ally.emoji.isNotEmpty ? ally.emoji : '🧙', style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Flexible(
          child: GameOutlinedText(
            '${ally.name}: $text',
            fontSize: compact ? 8 : 9,
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
