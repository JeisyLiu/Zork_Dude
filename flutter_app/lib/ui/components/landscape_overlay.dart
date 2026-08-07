import 'package:flutter/material.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Landscape-friendly overlay: right rail on phones, centered panel on tablets.
abstract final class LandscapeOverlay {
  static const panelKey = Key('landscape-overlay-panel');

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    GameUiSkin? skin,
  }) {
    final screenSize = MediaQuery.sizeOf(context);
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: title,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final body = _LandscapeOverlayBody(
          title: title,
          child: child,
          screenSize: screenSize,
        );
        if (skin == null) return body;
        return GameSkinScope(skin: skin, child: body);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: child,
        );
      },
    );
  }
}

class _LandscapeOverlayBody extends StatelessWidget {
  const _LandscapeOverlayBody({
    required this.title,
    required this.child,
    required this.screenSize,
  });

  final String title;
  final Widget child;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    final centered = LandscapeLayout.useCenteredOverlay(screenSize);
    final panelWidth = LandscapeLayout.overlayPanelWidth(screenSize);
    final maxHeight = screenSize.height * 0.92;

    final panel = KeyedSubtree(
      key: LandscapeOverlay.panelKey,
      child: SizedBox(
        width: panelWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: GamePanel(
          dark: true,
          withBorder: true,
          padding: GamePanel.compactPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    GameIconButton(
                      size: LandscapeLayout.minTouch(context, 44),
                      asset: GameUiAssets.buttonRedClose,
                      semanticLabel: '关闭',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: LandscapeLayout.sp(context, 8)),
                    Expanded(
                      child: GameOutlinedText(
                        title,
                        fontSize: LandscapeLayout.sp(context, 14),
                        fontWeight: FontWeight.bold,
                        color: GameUiTheme.of(context).textPrimary,
                        strokeWidth: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(child: child),
              ),
            ],
          ),
        ),
      ),
    ),
    );

    if (centered) {
      return Material(
        type: MaterialType.transparency,
        child: Center(child: panel),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: panel,
        ),
      ),
    );
  }
}
