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
  });

  final int highlightIndex;
  final void Function(CombatCommandOption option) onSelect;
  final bool enabled;
  final bool hasItems;
  final bool compact;

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
    final h = compact ? 28.0 : CombatLayoutConstants.commandButtonHeight;

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText('指令 Commands', fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < options.length; i++)
                _optionButton(
                  context,
                  index: i,
                  option: options[i].$1,
                  label: options[i].$2,
                  sub: options[i].$3,
                  height: h,
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
          width: compact ? 64 : 72,
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
  });

  final bool ready;
  final VoidCallback? onExecute;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: highlighted
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFE8B84A), width: 2),
              borderRadius: BorderRadius.circular(4),
            )
          : const BoxDecoration(),
      child: GameButton(
        label: '执行回合',
        subLabel: 'Execute',
        height: 38,
        onPressed: ready ? onExecute : null,
        semanticLabel: '执行回合',
      ),
    );
  }
}
