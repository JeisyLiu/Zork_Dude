import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_command_labels.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatTurnOrderBar extends StatelessWidget {
  const CombatTurnOrderBar({
    super.key,
    required this.entries,
    this.highlightActorId,
    this.compact = false,
  });

  final List<TurnOrderEntry> entries;
  final String? highlightActorId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    if (entries.isEmpty) return const SizedBox.shrink();

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText(
            '行动顺序 Initiative',
            fontSize: compact ? 12 : 14,
            color: d.textMuted,
            strokeWidth: 0.8,
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  _slot(context, entries[i], i + 1, d),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slot(BuildContext context, TurnOrderEntry entry, int index, GameUiSkinData d) {
    final highlighted = entry.actorId == highlightActorId;
    return Semantics(
      label: '第 $index 位 ${entry.actorName} 速度 ${entry.speed}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: highlighted ? const Color(0xFFE8B84A) : Colors.transparent,
            width: 2,
          ),
          color: highlighted ? const Color(0x22E8B84A) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GameOutlinedText(
              '#$index',
              fontSize: compact ? 9 : 10,
              color: d.textMuted,
              strokeWidth: 0,
            ),
            Text(
              entry.emoji.isNotEmpty ? entry.emoji : '👤',
              style: TextStyle(fontSize: compact ? 16 : 20),
            ),
            GameOutlinedText(
              entry.actorName,
              fontSize: compact ? 10 : 12,
              color: d.textPrimary,
              strokeWidth: 0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            GameOutlinedText(
              '💨${entry.speed} ${CombatCommandLabels.shortLabel(entry.command.type)}',
              fontSize: compact ? 9 : 11,
              color: d.textMuted,
              strokeWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}
