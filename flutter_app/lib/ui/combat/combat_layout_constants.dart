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
  static const executeButtonWidth = 64.0;
  static const executeButtonWidthShort = 56.0;
  static const commandButtonWidth = 64.0;
  static const commandButtonWidthShort = 52.0;

  static double commandButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double executeButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

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
  flee,
}
