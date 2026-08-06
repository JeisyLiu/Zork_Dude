import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';

/// Per-region UI skins. [fantasy] is the village / surface look (kept for home).
enum GameUiSkin { fantasy, cave, tower, site, combat }

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
    required this.scaffoldBg,
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
  final Color scaffoldBg;

  /// Village / mist forest surface — warm timber.
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
    scaffoldBg: Color(0xFF3A2E22),
  );

  /// Cave / underground — damp stone, moss green accents.
  static const cave = GameUiSkinData(
    panel: GameUiAssets.panelGreyGreen,
    panelDark: GameUiAssets.panelGreyDark,
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
    pattern: GameUiAssets.patternDiagonalGrey,
    textPrimary: Color(0xFF0E1612),
    textMuted: Color(0xFF243028),
    scaffoldBg: Color(0xFF1A221C),
  );

  /// Mist tower — deep timber, curtain banner, cool gold text.
  static const tower = GameUiSkinData(
    panel: GameUiAssets.panelBrownDamaged,
    panelDark: GameUiAssets.panelBrownDamagedDark,
    panelBorder: GameUiAssets.panelBorderBrown,
    button: GameUiAssets.buttonBrown,
    buttonAccent: GameUiAssets.buttonRed,
    banner: GameUiAssets.bannerCurtain,
    progressFill: GameUiAssets.progressBlue,
    progressBorder: GameUiAssets.progressBlueBorder,
    progressFillSmall: GameUiAssets.progressBlueSmall,
    progressBorderSmall: GameUiAssets.progressBlueSmallBorder,
    minimapRing: GameUiAssets.minimapRingBrown,
    roundButton: GameUiAssets.roundBrown,
    pattern: GameUiAssets.patternPaper,
    textPrimary: Color(0xFF16120C),
    textMuted: Color(0xFF3A3228),
    scaffoldBg: Color(0xFF2A241C),
  );

  /// Foundation site / facility — bolted steel.
  static const site = GameUiSkinData(
    panel: GameUiAssets.panelGreyBolts,
    panelDark: GameUiAssets.panelGreyBoltsDark,
    panelBorder: GameUiAssets.panelBorderGrey,
    button: GameUiAssets.buttonGrey,
    buttonAccent: GameUiAssets.buttonRed,
    banner: GameUiAssets.bannerModern,
    progressFill: GameUiAssets.progressBlue,
    progressBorder: GameUiAssets.progressBlueBorder,
    progressFillSmall: GameUiAssets.progressBlueSmall,
    progressBorderSmall: GameUiAssets.progressBlueSmallBorder,
    minimapRing: GameUiAssets.minimapRingGrey,
    roundButton: GameUiAssets.roundGrey,
    pattern: GameUiAssets.patternBlueprint,
    textPrimary: Color(0xFF101820),
    textMuted: Color(0xFF2A3540),
    scaffoldBg: Color(0xFF1A2228),
  );

  /// Legacy combat look (bolted grey + red bars). Prefer [combatDataForLayer].
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
    scaffoldBg: Color(0xFF221A18),
  );

  GameUiSkinData copyWith({
    String? panel,
    String? panelDark,
    String? panelBorder,
    String? button,
    String? buttonAccent,
    String? banner,
    String? progressFill,
    String? progressBorder,
    String? progressFillSmall,
    String? progressBorderSmall,
    String? minimapRing,
    String? roundButton,
    String? pattern,
    Color? textPrimary,
    Color? textMuted,
    Color? scaffoldBg,
  }) {
    return GameUiSkinData(
      panel: panel ?? this.panel,
      panelDark: panelDark ?? this.panelDark,
      panelBorder: panelBorder ?? this.panelBorder,
      button: button ?? this.button,
      buttonAccent: buttonAccent ?? this.buttonAccent,
      banner: banner ?? this.banner,
      progressFill: progressFill ?? this.progressFill,
      progressBorder: progressBorder ?? this.progressBorder,
      progressFillSmall: progressFillSmall ?? this.progressFillSmall,
      progressBorderSmall: progressBorderSmall ?? this.progressBorderSmall,
      minimapRing: minimapRing ?? this.minimapRing,
      roundButton: roundButton ?? this.roundButton,
      pattern: pattern ?? this.pattern,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      scaffoldBg: scaffoldBg ?? this.scaffoldBg,
    );
  }

  /// Layer look with red combat bars for HP readability.
  GameUiSkinData withCombatBars() {
    return copyWith(
      progressFill: GameUiAssets.progressRed,
      progressBorder: GameUiAssets.progressRedBorder,
      progressFillSmall: GameUiAssets.progressRedSmall,
      progressBorderSmall: GameUiAssets.progressRedSmallBorder,
      buttonAccent: GameUiAssets.buttonRed,
    );
  }
}

abstract final class GameUiTheme {
  static GameUiSkin skinForMapLayer(MapLayer layer) {
    switch (layer) {
      case MapLayer.cave:
        return GameUiSkin.cave;
      case MapLayer.tower:
        return GameUiSkin.tower;
      case MapLayer.site:
        return GameUiSkin.site;
      case MapLayer.surface:
        return GameUiSkin.fantasy;
    }
  }

  static GameUiSkinData dataFor(GameUiSkin skin) {
    switch (skin) {
      case GameUiSkin.fantasy:
        return GameUiSkinData.fantasy;
      case GameUiSkin.cave:
        return GameUiSkinData.cave;
      case GameUiSkin.tower:
        return GameUiSkinData.tower;
      case GameUiSkin.site:
        return GameUiSkinData.site;
      case GameUiSkin.combat:
        return GameUiSkinData.combat;
    }
  }

  static GameUiSkinData dataForMapLayer(MapLayer layer) =>
      dataFor(skinForMapLayer(layer));

  static GameUiSkinData combatDataForMapLayer(MapLayer layer) =>
      dataForMapLayer(layer).withCombatBars();

  static Color scaffoldBgForMapLayer(MapLayer layer) =>
      dataForMapLayer(layer).scaffoldBg;

  static GameUiSkinData of(BuildContext context) {
    return Theme.of(context).extension<GameUiThemeExtension>()?.skinData ??
        GameUiSkinData.fantasy;
  }

  static ThemeData appTheme({GameUiSkin skin = GameUiSkin.fantasy}) {
    final d = dataFor(skin);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: d.scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B7355),
        brightness: Brightness.dark,
        surface: d.scaffoldBg,
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
