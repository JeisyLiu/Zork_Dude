import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/game_progress_bar.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
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

    return GamePanel(
      dark: true,
      withBorder: true,
      padding: GamePanel.borderedPadding,
      child: Wrap(
        spacing: 10,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _stat(context, '❤️', '${s.playerHp}/${s.playerMaxHp}', child: GameProgressBar(value: ratio, width: 64)),
          _stat(context, '⚔️', '${s.totalAtk}'),
          _stat(context, '🛡️', '${s.totalDef}'),
          _stat(context, '💰', '${s.gold}'),
          _stat(context, '🏆', '${s.score}'),
          _stat(context, '🎒', '${s.totalWeight()}/${s.bagCapacity()}'),
          if (companions.isNotEmpty) _stat(context, '👥', companions),
          GameButton(
            label: controller.mapVisible ? '地图' : '地图·关',
            subLabel: 'map',
            height: 36,
            width: 76,
            onPressed: controller.toggleMap,
            semanticLabel: '切换地图',
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String icon, String value, {Widget? child}) {
    final d = GameUiTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 3),
        if (child != null) child,
        if (child != null) const SizedBox(width: 4),
        GameOutlinedText(
          value,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: d.textPrimary,
          strokeWidth: 1.2,
        ),
      ],
    );
  }
}
