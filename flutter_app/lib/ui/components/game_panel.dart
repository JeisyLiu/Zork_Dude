import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Nine-patch panel background from Kenney UI assets.
class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.dark = false,
    this.withBorder = false,
    this.skin,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool dark;
  final bool withBorder;
  final GameUiSkinData? skin;

  @override
  Widget build(BuildContext context) {
    final d = skin ?? GameUiTheme.of(context);
    final bg = dark ? d.panelDark : d.panel;
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
        Padding(padding: padding, child: child),
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
