import 'package:flutter/material.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatCommandMenu extends StatelessWidget {
  const CombatCommandMenu({
    super.key,
    required this.highlightIndex,
    required this.onSelect,
    this.enabled = true,
    this.hasItems = false,
    this.compact = false,
    this.showTitle = false,
  });

  final int highlightIndex;
  final void Function(CombatCommandOption option) onSelect;
  final bool enabled;
  final bool hasItems;
  final bool compact;
  final bool showTitle;

  static const options = [
    (CombatCommandOption.attack, '攻击', 'Atk'),
    (CombatCommandOption.skill, '技能', 'Skill'),
    (CombatCommandOption.item, '道具', 'Item'),
    (CombatCommandOption.defend, '防御', 'Def'),
    (CombatCommandOption.flee, '逃跑', 'Flee'),
  ];

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final btnW = compact
        ? CombatLayoutConstants.commandButtonWidthShort
        : CombatLayoutConstants.commandButtonWidth;
    final btnH = CombatLayoutConstants.commandButtonHeightForWidth(btnW);

    return GamePanel(
      withBorder: true,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTitle) ...[
            GameOutlinedText('指令 Commands', fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < options.length; i++)
                _optionButton(
                  context,
                  index: i,
                  option: options[i].$1,
                  label: options[i].$2,
                  sub: options[i].$3,
                  width: btnW,
                  height: btnH,
                  highlighted: i == highlightIndex,
                  disabled: !enabled ||
                      (options[i].$1 == CombatCommandOption.item && !hasItems),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _optionButton(
    BuildContext context, {
    required int index,
    required CombatCommandOption option,
    required String label,
    required String sub,
    required double width,
    required double height,
    required bool highlighted,
    required bool disabled,
  }) {
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: DecoratedBox(
        decoration: highlighted
            ? BoxDecoration(
                border: Border.all(color: const Color(0xFFE8B84A), width: 2),
                borderRadius: BorderRadius.circular(4),
              )
            : const BoxDecoration(),
        child: GameButton(
          label: label,
          subLabel: sub,
          height: height,
          width: width,
          onPressed: disabled ? null : () => onSelect(option),
          semanticLabel: label,
        ),
      ),
    );
  }
}

class CombatExecuteBar extends StatelessWidget {
  const CombatExecuteBar({
    super.key,
    required this.ready,
    required this.onExecute,
    this.highlighted = false,
    this.compact = false,
    this.width,
  });

  final bool ready;
  final VoidCallback? onExecute;
  final bool highlighted;
  final bool compact;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final w = width ??
        (compact
            ? CombatLayoutConstants.executeButtonWidthShort
            : CombatLayoutConstants.executeButtonWidth);
    final h = CombatLayoutConstants.executeButtonHeightForWidth(w);
    return DecoratedBox(
      decoration: highlighted
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFE8B84A), width: 2),
              borderRadius: BorderRadius.circular(4),
            )
          : const BoxDecoration(),
      child: GameButton(
        label: '执行',
        subLabel: 'Go',
        height: h,
        width: w,
        onPressed: ready ? onExecute : null,
        semanticLabel: '执行回合',
      ),
    );
  }
}
