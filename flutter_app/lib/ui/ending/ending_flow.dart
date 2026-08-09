import 'package:flutter/material.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/ending/credits_roll.dart';
import 'package:zork_dude/ui/ending/ending_overlay.dart';
import 'package:zork_dude/ui/navigation/game_exit.dart';

/// Presents pending ending overlays and chains site credits.
abstract final class EndingFlow {
  /// Shows overlay when [controller.pendingEnding] is set. Returns when flow ends.
  static Future<void> presentIfNeeded({
    required BuildContext context,
    required GameController controller,
    VoidCallback? afterDismiss,
  }) async {
    final kind = controller.pendingEnding;
    if (kind == EndingKind.none) {
      afterDismiss?.call();
      return;
    }

    switch (kind) {
      case EndingKind.dragonClear:
        await _showDragon(context, controller, afterDismiss);
      case EndingKind.mainClear:
        await _showMain(context, controller, afterDismiss);
      case EndingKind.siteClear:
        await _showSite(context, controller, afterDismiss);
      case EndingKind.gameOver:
        await _showGameOver(context, controller, afterDismiss);
      case EndingKind.none:
        afterDismiss?.call();
    }
  }

  static Future<void> _showDragon(
    BuildContext context,
    GameController controller,
    VoidCallback? afterDismiss,
  ) async {
    controller.consumePendingEnding();
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: true,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) => EndingOverlay(
          kind: EndingKind.dragonClear,
          onPrimary: () => Navigator.of(context).pop(),
          onSecondary: () {
            Navigator.of(context).pop();
            controller.completeMainJourney();
            if (controller.pendingEnding == EndingKind.mainClear &&
                context.mounted) {
              _showMain(context, controller, afterDismiss);
            } else {
              afterDismiss?.call();
            }
          },
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
    if (controller.pendingEnding == EndingKind.none) {
      afterDismiss?.call();
    }
  }

  static Future<void> _showMain(
    BuildContext context,
    GameController controller,
    VoidCallback? afterDismiss,
  ) async {
    controller.consumePendingEnding();
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (_, __, ___) => EndingOverlay(
          kind: EndingKind.mainClear,
          onPrimary: () => Navigator.of(context).pop(),
          onSecondary: () {
            Navigator.of(context).pop();
            GameExit.returnToTitle(context, controller, confirm: false);
          },
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
    afterDismiss?.call();
  }

  static Future<void> _showSite(
    BuildContext context,
    GameController controller,
    VoidCallback? afterDismiss,
  ) async {
    controller.consumePendingEnding();
    final watchCredits = await Navigator.of(context).push<bool>(
      PageRouteBuilder<bool>(
        opaque: true,
        pageBuilder: (_, __, ___) => EndingOverlay(
          kind: EndingKind.siteClear,
          onPrimary: () => Navigator.of(context).pop(true),
          onSecondary: () => Navigator.of(context).pop(false),
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
    if (!context.mounted) return;
    if (watchCredits == true) {
      await Navigator.of(context).push<void>(
        PageRouteBuilder<void>(
          opaque: true,
          pageBuilder: (_, __, ___) =>
              CreditsRoll(onFinished: () => Navigator.of(context).pop()),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
    afterDismiss?.call();
  }

  static Future<void> _showGameOver(
    BuildContext context,
    GameController controller,
    VoidCallback? afterDismiss,
  ) async {
    controller.consumePendingEnding();
    final l10n = AppLocalizations.of(context);
    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        opaque: true,
        pageBuilder: (_, __, ___) => EndingOverlay(
          kind: EndingKind.gameOver,
          rewardLabel: l10n.watchAdRecoverLoss,
          rewardSubLabel: l10n.refundScorePoints(GameSession.deathScorePenalty),
          onRewarded:
              !controller.rewardedReviveUsed &&
                  OffpackAds.instance.rewardReady(OffpackRewardPlacement.revive)
              ? () => OffpackAds.instance.showRewarded(
                  OffpackRewardPlacement.revive,
                )
              : null,
          onRewardEarned: () {
            Navigator.of(context).pop();
            controller.refundDeathPenaltyAfterReward();
            afterDismiss?.call();
          },
          onPrimary: () {
            Navigator.of(context).pop();
            controller.reviveFromDeath();
            afterDismiss?.call();
          },
          onSecondary: () {
            Navigator.of(context).pop();
            GameExit.returnToTitle(context, controller, confirm: false);
          },
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }
}
