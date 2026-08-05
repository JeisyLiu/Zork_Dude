import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Nine-patch panel background from Kenney UI assets.
class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.padding,
    this.dark = false,
    this.withBorder = false,
    this.skin,
  });

  /// Default inner content padding for a plain panel (avoids wooden rim).
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(16, 12, 16, 12);

  /// Extra inset when a decorative border frame is drawn on top.
  static const EdgeInsets borderedPadding = EdgeInsets.fromLTRB(18, 14, 18, 14);

  /// Compact dock / toolbar panels.
  static const EdgeInsets compactPadding = EdgeInsets.fromLTRB(12, 10, 12, 10);

  final Widget child;
  final EdgeInsets? padding;
  final bool dark;
  final bool withBorder;
  final GameUiSkinData? skin;

  @override
  Widget build(BuildContext context) {
    final d = skin ?? GameUiTheme.of(context);
    final bg = dark ? d.panelDark : d.panel;
    final resolvedPadding = padding ?? (withBorder ? borderedPadding : contentPadding);
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: _ninePatch(bg, GameUiAssets.slicePanel64),
        ),
        if (withBorder)
          Positioned.fill(
            child: _ninePatch(d.panelBorder, GameUiAssets.slicePanel64),
          ),
        Padding(padding: resolvedPadding, child: child),
      ],
    );
  }

  static Widget _ninePatch(String asset, Rect slice) {
    return Image.asset(
      asset,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
      centerSlice: slice,
      gaplessPlayback: true,
    );
  }
}
