import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/game_progress_bar.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final s = controller.session;
    if (s == null) return const SizedBox.shrink();
    final ratio = s.playerMaxHp > 0 ? s.playerHp / s.playerMaxHp : 0.0;
    final companions = s.companionList
        .map((c) => s.companions[c]?.name)
        .whereType<String>()
        .join(', ');
    final short = ExplorationLayoutConstants.isShort(MediaQuery.sizeOf(context));
    final mapBtnH = short ? 26.0 : 32.0;
    final mapBtnW = short ? 56.0 : 68.0;

    return GamePanel(
      dark: true,
      withBorder: true,
      padding: EdgeInsets.symmetric(
        horizontal: short ? 6 : 10,
        vertical: short ? 3 : 6,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stat(context, '❤️', '${s.playerHp}/${s.playerMaxHp}',
                child: GameProgressBar(
                  value: ratio,
                  width: short ? 44 : 56,
                  height: short ? 7 : 9,
                ),
                compact: short),
            SizedBox(width: short ? 6 : 8),
            _stat(context, '⚔️', '${s.totalAtk}', compact: short),
            SizedBox(width: short ? 6 : 8),
            _stat(context, '🛡️', '${s.totalDef}', compact: short),
            SizedBox(width: short ? 6 : 8),
            _stat(context, '💰', '${s.gold}', compact: short),
            SizedBox(width: short ? 6 : 8),
            _stat(context, '🏆', '${s.score}', compact: short),
            SizedBox(width: short ? 6 : 8),
            _stat(context, '🎒', '${s.totalWeight()}/${s.bagCapacity()}', compact: short),
            if (companions.isNotEmpty) ...[
              SizedBox(width: short ? 6 : 8),
              _stat(
                context,
                '👥',
                companions.length > 8 ? '${companions.substring(0, 8)}…' : companions,
                compact: short,
              ),
            ],
            SizedBox(width: short ? 6 : 8),
            GameButton(
              label: controller.mapVisible ? '地图' : '地图·关',
              subLabel: 'map',
              height: mapBtnH,
              width: mapBtnW,
              onPressed: controller.toggleMap,
              semanticLabel: '切换地图',
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    String icon,
    String value, {
    Widget? child,
    bool compact = false,
  }) {
    final d = GameUiTheme.of(context);
    final fontSize = compact ? 10.0 : 11.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: fontSize)),
        const SizedBox(width: 2),
        ?child,
        if (child != null) const SizedBox(width: 3),
        GameOutlinedText(
          value,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: d.textPrimary,
          strokeWidth: 0,
        ),
      ],
    );
  }
}
