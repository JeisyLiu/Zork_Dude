import 'package:flutter/material.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

class CombatCommandMenu extends StatelessWidget {
  const CombatCommandMenu({
    super.key,
    required this.highlightIndex,
    required this.onSelect,
    this.enabled = true,
    this.hasItems = false,
    this.meleeAvailable = true,
    this.showTitle = false,
  });

  final int highlightIndex;
  final void Function(CombatCommandOption option) onSelect;
  final bool enabled;
  final bool hasItems;
  final bool meleeAvailable;
  final bool showTitle;

  static const options = [
    (CombatCommandOption.attack, '攻击', 'Atk'),
    (CombatCommandOption.skill, '技能', 'Skill'),
    (CombatCommandOption.item, '道具', 'Item'),
    (CombatCommandOption.defend, '防御', 'Def'),
    (CombatCommandOption.melee, '混战', 'Melee'),
    (CombatCommandOption.flee, '逃跑', 'Flee'),
  ];

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final preferredW = CombatLayoutConstants.commandButtonWidthFor(context);

    return GamePanel(
      withBorder: true,
      padding: EdgeInsets.symmetric(
        horizontal: LandscapeLayout.sp(context, 10),
        vertical: LandscapeLayout.sp(context, 8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = options.length;
          final gap = LandscapeLayout.sp(context, 5);
          final maxEach =
              (constraints.maxWidth - gap * (count - 1)) / count;
          final btnW =
              maxEach < preferredW ? maxEach.clamp(48.0, preferredW) : preferredW;
          final btnH = CombatLayoutConstants.commandButtonHeightForWidth(btnW);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showTitle) ...[
                GameOutlinedText(
                  '指令 Commands',
                  fontSize: LandscapeLayout.sp(context, 13),
                  color: d.textMuted,
                  strokeWidth: 0,
                ),
                SizedBox(height: LandscapeLayout.sp(context, 6)),
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
                          (options[i].$1 == CombatCommandOption.item &&
                              !hasItems) ||
                          (options[i].$1 == CombatCommandOption.melee &&
                              !meleeAvailable),
                    ),
                ],
              ),
            ],
          );
        },
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
    this.width,
    this.label = '执行',
    this.subLabel = 'Go',
  });

  final bool ready;
  final VoidCallback? onExecute;
  final bool highlighted;
  final double? width;
  final String label;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    final w = width ?? CombatLayoutConstants.executeButtonWidthFor(context);
    final h = CombatLayoutConstants.executeButtonHeightForWidth(w);
    return DecoratedBox(
      decoration: highlighted
          ? BoxDecoration(
              border: Border.all(color: const Color(0xFFE8B84A), width: 2),
              borderRadius: BorderRadius.circular(4),
            )
          : const BoxDecoration(),
      child: GameButton(
        label: label,
        subLabel: subLabel,
        height: h,
        width: w,
        accent: true,
        onPressed: ready ? onExecute : null,
        semanticLabel: label,
      ),
    );
  }
}
