import 'dart:ui' show Size;

import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints for landscape-first 16:9 play screens.
abstract final class CombatLayoutConstants {
  static const sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const shortHeight = LandscapeLayout.shortHeight;

  static const unitSlotWidth = 72.0;
  static const unitSlotHeight = 88.0;
  static const unitSlotCompact = 60.0;
  static const logMaxLines = 6;
  static const battlefieldGap = 6.0;
  static const unitGap = 6.0;
  static const bannerHeight = 40.0;
  static const bannerHeightShort = 36.0;

  /// Golden-ratio action / execute buttons (height = width × 0.618).
  static const executeButtonWidth = 140.0;
  static const executeButtonWidthShort = 112.0;
  static const commandButtonWidth = 96.0;
  static const commandButtonWidthShort = 80.0;

  static double commandButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double executeButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  /// Bottom command dock height: execute button + panel vertical padding.
  static double commandDockHeight({required bool short}) {
    final execW = short ? executeButtonWidthShort : executeButtonWidth;
    final execH = executeButtonHeightForWidth(execW);
    final padV = short ? 12.0 : 16.0;
    return execH + padV;
  }

  /// Scale execute width down when remaining space after command buttons is tight.
  static double executeWidthFor({
    required double availableWidth,
    required bool short,
  }) {
    final preferred = short ? executeButtonWidthShort : executeButtonWidth;
    return availableWidth.clamp(72.0, preferred);
  }

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);
}

enum CombatUiPhase {
  pickingCommand,
  pickingTarget,
  pickingItem,
  readyToExecute,
  animating,
}

enum CombatCommandOption {
  attack,
  skill,
  item,
  defend,
  melee,
  flee,
}
