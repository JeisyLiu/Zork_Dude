import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Applies [GameUiSkinData] via Theme extension for descendant widgets.
class GameSkinScope extends StatelessWidget {
  const GameSkinScope({
    super.key,
    required this.skin,
    required this.child,
    this.combatBars = false,
  });

  final GameUiSkin skin;
  final Widget child;

  /// When true, swap progress fills to red combat bars while keeping panel look.
  final bool combatBars;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    var data = GameUiTheme.dataFor(skin);
    if (combatBars) data = data.withCombatBars();
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
