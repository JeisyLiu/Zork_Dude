import 'package:flutter/material.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatItemPicker extends StatelessWidget {
  const CombatItemPicker({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelect,
    this.compact = false,
  });

  final List<({String id, String label, int heal, int count, String effectHint})> items;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    if (items.isEmpty) {
      return GamePanel(
        withBorder: true,
        padding: GamePanel.compactPadding,
        child: GameOutlinedText(
          '背包中没有可用战斗道具',
          fontSize: 10,
          color: d.textMuted,
          strokeWidth: 0,
        ),
      );
    }

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText('选择道具 Items', fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in items) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GameButton(
                      label: item.label,
                      subLabel: item.count > 1
                          ? 'x${item.count} ${item.effectHint}'
                          : item.effectHint.isNotEmpty
                              ? item.effectHint
                              : (item.heal > 0 ? '+${item.heal}HP' : 'use'),
                      height: compact ? 40 : 44,
                      width: compact ? 96 : 108,
                      accent: item.id == selectedId,
                      onPressed: () => onSelect(item.id),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
