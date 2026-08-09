import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/game_progress_bar.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/settings/settings_overlay.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final s = controller.session;
    if (s == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final ratio = s.playerMaxHp > 0 ? s.playerHp / s.playerMaxHp : 0.0;
    final companions = s.companionList
        .map((c) => s.companions[c]?.name)
        .whereType<String>()
        .join(', ');
    final mapBtnH = LandscapeLayout.minTouch(context, 32);
    final mapBtnW = LandscapeLayout.minTouch(context, 68);
    final statGap = LandscapeLayout.sp(context, 8);
    final fontSize = LandscapeLayout.sp(context, 11);
    final progressW = LandscapeLayout.sp(context, 72);
    final progressH = LandscapeLayout.sp(context, 12);

    return GamePanel(
      dark: true,
      withBorder: true,
      padding: EdgeInsets.symmetric(
        horizontal: LandscapeLayout.sp(context, 10),
        vertical: LandscapeLayout.sp(context, 6),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stat(
              context,
              '❤️',
              '${s.playerHp}/${s.playerMaxHp}',
              fontSize: fontSize,
              child: GameProgressBar(
                value: ratio,
                width: progressW,
                height: progressH,
              ),
            ),
            SizedBox(width: statGap),
            _stat(context, '⚔️', '${s.totalAtk}', fontSize: fontSize),
            SizedBox(width: statGap),
            _stat(context, '🛡️', '${s.totalDef}', fontSize: fontSize),
            SizedBox(width: statGap),
            _stat(context, '💰', '${s.gold}', fontSize: fontSize),
            SizedBox(width: statGap),
            _stat(context, '🏆', '${s.score}', fontSize: fontSize),
            SizedBox(width: statGap),
            _stat(
              context,
              '🎒',
              '${s.totalWeight()}/${s.bagCapacity()}',
              fontSize: fontSize,
            ),
            if (companions.isNotEmpty) ...[
              SizedBox(width: statGap),
              _stat(
                context,
                '👥',
                companions.length > 8 ? '${companions.substring(0, 8)}…' : companions,
                fontSize: fontSize,
              ),
            ],
            SizedBox(width: statGap),
            GameButton(
              label: controller.mapVisible ? l10n.cmdMapOn : l10n.cmdMapOff,
              subLabel: 'map',
              height: mapBtnH,
              width: mapBtnW,
              onPressed: controller.toggleMap,
              semanticLabel: l10n.cmdToggleMap,
            ),
            SizedBox(width: statGap),
            SettingsGearButton(
              skin: GameUiTheme.skinForMapLayer(controller.mapLayer),
              size: mapBtnH,
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
    required double fontSize,
    Widget? child,
  }) {
    final d = GameUiTheme.of(context);
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
