import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/screens/home_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

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
    return GameConfirmDialog.show(
      context: context,
      title: '返回标题？',
      message: '当前进度已自动保存，可从标题页「继续旅程」恢复。',
      confirmLabel: '返回标题',
      confirmSubLabel: 'title',
      skin: skin,
    );
  }

  static Future<bool> confirmQuitApp(
    BuildContext context, {
    GameUiSkin skin = GameUiSkin.fantasy,
  }) {
    return GameConfirmDialog.show(
      context: context,
      title: '退出游戏？',
      message: '将关闭迷雾之塔。',
      confirmLabel: '退出',
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
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);
    final btnW = ExplorationLayoutConstants.moreChipWidthFor(context);
    final btnH = ExplorationLayoutConstants.chipHeightForWidth(btnW);

    await LandscapeOverlay.show<void>(
      context: context,
      title: '战斗菜单 · Pause',
      skin: skin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameButton(
            width: double.infinity,
            height: btnH,
            label: '继续战斗',
            subLabel: 'resume',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GameButton(
            width: double.infinity,
            height: btnH,
            label: '回标题',
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
