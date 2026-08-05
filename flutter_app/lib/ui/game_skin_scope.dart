import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Applies [GameUiSkinData] via Theme extension for descendant widgets.
class GameSkinScope extends StatelessWidget {
  const GameSkinScope({
    super.key,
    required this.skin,
    required this.child,
  });

  final GameUiSkin skin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final data = GameUiTheme.dataFor(skin);
    return Theme(
      data: base.copyWith(
        extensions: [
          GameUiThemeExtension(skinData: data),
        ],
      ),
      child: child,
    );
  }
}
