import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/screens/home_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/settings/settings_overlay.dart';

/// Shared exit / return-to-title navigation for home, exploration, and combat.
abstract final class GameExit {
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static Future<bool> confirmReturnToTitle(
    BuildContext context, {
    GameUiSkin skin = GameUiSkin.fantasy,
  }) {
    final l10n = AppLocalizations.of(context);
    return GameConfirmDialog.show(
      context: context,
      title: l10n.returnToTitleTitle,
      message: l10n.returnToTitleMessage,
      confirmLabel: l10n.returnToTitle,
      confirmSubLabel: 'title',
      skin: skin,
    );
  }

  static Future<bool> confirmQuitApp(
    BuildContext context, {
    GameUiSkin skin = GameUiSkin.fantasy,
  }) {
    final l10n = AppLocalizations.of(context);
    return GameConfirmDialog.show(
      context: context,
      title: l10n.quitAppTitle,
      message: l10n.quitAppMessage,
      confirmLabel: l10n.quit,
      confirmSubLabel: 'quit',
      skin: skin,
    );
  }

  static void navigateHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  static Future<void> returnToTitle(
    BuildContext context,
    GameController controller, {
    bool confirm = true,
  }) async {
    if (confirm) {
      final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);
      final ok = await confirmReturnToTitle(context, skin: skin);
      if (!ok || !context.mounted) return;
    }
    await controller.prepareReturnToTitle();
    if (!context.mounted) return;
    navigateHome(context);
  }

  static void quitApp() {
    SystemNavigator.pop();
  }

  static Future<void> showCombatPauseMenu(
    BuildContext context,
    GameController controller,
  ) async {
    final l10n = AppLocalizations.of(context);
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);
    final btnW = ExplorationLayoutConstants.moreChipWidthFor(context);
    final btnH = ExplorationLayoutConstants.chipHeightForWidth(btnW);

    await LandscapeOverlay.show<void>(
      context: context,
      title: l10n.combatPauseTitle,
      skin: skin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameButton(
            width: double.infinity,
            height: btnH,
            label: l10n.resumeCombat,
            subLabel: 'resume',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GameButton(
            width: double.infinity,
            height: btnH,
            label: l10n.settingsMenuLabel,
            subLabel: 'settings',
            onPressed: () {
              Navigator.pop(context);
              if (!context.mounted) return;
              SettingsEntry.open(context, skin: skin);
            },
          ),
          const SizedBox(height: 8),
          GameButton(
            width: double.infinity,
            height: btnH,
            label: l10n.backToTitle,
            subLabel: 'title',
            onPressed: () async {
              Navigator.pop(context);
              if (!context.mounted) return;
              await returnToTitle(context, controller);
            },
          ),
        ],
      ),
    );
  }
}
