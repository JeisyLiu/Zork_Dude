import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
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
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return GamePanel(
        withBorder: true,
        padding: GamePanel.compactPadding,
        child: GameOutlinedText(
          l10n.combatNoItems,
          fontSize: 12,
          color: d.textMuted,
          strokeWidth: 0,
        ),
      );
    }

    final btnW = compact ? 100.0 : 112.0;
    final btnH = CombatLayoutConstants.commandButtonHeightForWidth(btnW);

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText(
            l10n.combatPickItem,
            fontSize: 12,
            color: d.textMuted,
            strokeWidth: 0,
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in items) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GameButton(
                      label: item.label,
                      subLabel: item.count > 1
                          ? 'x${item.count} ${item.effectHint}'
                          : item.effectHint.isNotEmpty
                              ? item.effectHint
                              : (item.heal > 0 ? '+${item.heal}HP' : 'use'),
                      height: btnH,
                      width: btnW,
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
