import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';

enum GameUiSkin { fantasy, site, combat }

/// Resolved asset set for a skin.
class GameUiSkinData {
  const GameUiSkinData({
    required this.panel,
    required this.panelDark,
    required this.panelBorder,
    required this.button,
    required this.buttonAccent,
    required this.banner,
    required this.progressFill,
    required this.progressBorder,
    required this.progressFillSmall,
    required this.progressBorderSmall,
    required this.minimapRing,
    required this.roundButton,
    required this.pattern,
    required this.textPrimary,
    required this.textMuted,
  });

  final String panel;
  final String panelDark;
  final String panelBorder;
  final String button;
  final String buttonAccent;
  final String banner;
  final String progressFill;
  final String progressBorder;
  final String progressFillSmall;
  final String progressBorderSmall;
  final String minimapRing;
  final String roundButton;
  final String pattern;
  final Color textPrimary;
  final Color textMuted;

  static const fantasy = GameUiSkinData(
    panel: GameUiAssets.panelBrown,
    panelDark: GameUiAssets.panelBrownDark,
    panelBorder: GameUiAssets.panelBorderBrown,
    button: GameUiAssets.buttonBrown,
    buttonAccent: GameUiAssets.buttonRed,
    banner: GameUiAssets.bannerHanging,
    progressFill: GameUiAssets.progressGreen,
    progressBorder: GameUiAssets.progressGreenBorder,
    progressFillSmall: GameUiAssets.progressGreenSmall,
    progressBorderSmall: GameUiAssets.progressGreenSmallBorder,
    minimapRing: GameUiAssets.minimapRingBrown,
    roundButton: GameUiAssets.roundBrown,
    pattern: GameUiAssets.patternPaper,
    textPrimary: Color(0xFF1A1208),
    textMuted: Color(0xFF3D2E1F),
  );

  static const site = GameUiSkinData(
    panel: GameUiAssets.panelGrey,
    panelDark: GameUiAssets.panelGreyBoltsDark,
    panelBorder: GameUiAssets.panelBorderGrey,
    button: GameUiAssets.buttonGrey,
    buttonAccent: GameUiAssets.buttonRed,
    banner: GameUiAssets.bannerModern,
    progressFill: GameUiAssets.progressGreen,
    progressBorder: GameUiAssets.progressGreenBorder,
    progressFillSmall: GameUiAssets.progressGreenSmall,
    progressBorderSmall: GameUiAssets.progressGreenSmallBorder,
    minimapRing: GameUiAssets.minimapRingGrey,
    roundButton: GameUiAssets.roundGrey,
    pattern: GameUiAssets.patternPaper,
    textPrimary: Color(0xFF101820),
    textMuted: Color(0xFF2A3540),
  );

  static const combat = GameUiSkinData(
    panel: GameUiAssets.panelGreyBolts,
    panelDark: GameUiAssets.panelGreyBoltsDark,
    panelBorder: GameUiAssets.panelBorderGrey,
    button: GameUiAssets.buttonGrey,
    buttonAccent: GameUiAssets.buttonRed,
    banner: GameUiAssets.bannerModern,
    progressFill: GameUiAssets.progressRed,
    progressBorder: GameUiAssets.progressRedBorder,
    progressFillSmall: GameUiAssets.progressRedSmall,
    progressBorderSmall: GameUiAssets.progressRedSmallBorder,
    minimapRing: GameUiAssets.minimapRingGrey,
    roundButton: GameUiAssets.roundGrey,
    pattern: GameUiAssets.patternPaper,
    textPrimary: Color(0xFF101820),
    textMuted: Color(0xFF2A3540),
  );
}

abstract final class GameUiTheme {
  static GameUiSkin skinForMapLayer(MapLayer layer) {
    return layer == MapLayer.site ? GameUiSkin.site : GameUiSkin.fantasy;
  }

  static GameUiSkinData dataFor(GameUiSkin skin) {
    switch (skin) {
      case GameUiSkin.fantasy:
        return GameUiSkinData.fantasy;
      case GameUiSkin.site:
        return GameUiSkinData.site;
      case GameUiSkin.combat:
        return GameUiSkinData.combat;
    }
  }

  static GameUiSkinData of(BuildContext context) {
    return Theme.of(context).extension<GameUiThemeExtension>()?.skinData ??
        GameUiSkinData.fantasy;
  }

  static ThemeData appTheme({GameUiSkin skin = GameUiSkin.fantasy}) {
    final d = dataFor(skin);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF3A2E22),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B7355),
        brightness: Brightness.dark,
        surface: const Color(0xFF4A3C2C),
      ),
      extensions: [GameUiThemeExtension(skinData: d)],
      useMaterial3: true,
    );
  }
}

class GameUiThemeExtension extends ThemeExtension<GameUiThemeExtension> {
  const GameUiThemeExtension({required this.skinData});

  final GameUiSkinData skinData;

  @override
  GameUiThemeExtension copyWith({GameUiSkinData? skinData}) {
    return GameUiThemeExtension(skinData: skinData ?? this.skinData);
  }

  @override
  GameUiThemeExtension lerp(GameUiThemeExtension? other, double t) {
    return other ?? this;
  }
}
