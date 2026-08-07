import 'package:flutter/material.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Game-skinned yes/no confirm overlay (Kenney panel + buttons).
abstract final class GameConfirmDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelLabel = '取消',
    String confirmLabel = '确认',
    String? cancelSubLabel,
    String? confirmSubLabel,
    GameUiSkin skin = GameUiSkin.fantasy,
  }) async {
    final btnH = ExplorationLayoutConstants.chipHeightForWidth(
      ExplorationLayoutConstants.moreChipWidth,
    );
    final result = await LandscapeOverlay.show<bool>(
      context: context,
      title: title,
      skin: skin,
      child: Builder(
        builder: (dialogContext) {
          final theme = GameUiTheme.of(dialogContext);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameOutlinedText(
                message,
                fontSize: 13,
                color: theme.textPrimary,
                strokeWidth: 0,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              GameButton(
                width: double.infinity,
                height: btnH,
                label: cancelLabel,
                subLabel: cancelSubLabel ?? 'cancel',
                onPressed: () => Navigator.pop(dialogContext, false),
              ),
              const SizedBox(height: 8),
              GameButton(
                width: double.infinity,
                height: btnH,
                label: confirmLabel,
                subLabel: confirmSubLabel ?? 'confirm',
                accent: true,
                onPressed: () => Navigator.pop(dialogContext, true),
              ),
            ],
          );
        },
      ),
    );
    return result == true;
  }
}
