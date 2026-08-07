import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints for landscape-first 16:9 play screens.
abstract final class CombatLayoutConstants {
  static const sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const shortHeight = LandscapeLayout.shortHeight;

  // Design constants (1280×720 reference).
  static const unitSlotWidth = 72.0;
  static const unitSlotHeight = 88.0;
  static const unitSlotCompact = 60.0;
  static const logMaxLines = 6;
  static const battlefieldGap = 6.0;
  static const unitGap = 6.0;
  static const bannerHeight = 58.0;
  static const executeButtonWidth = 140.0;
  static const commandButtonWidth = 96.0;
  static const commandDockPadVDesign = 16.0;
  static const menuButtonWidthDesign = 64.0;
  static const menuButtonHeightDesign = 32.0;

  static double commandButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double executeButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double commandButtonWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, commandButtonWidth);

  static double executeButtonWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, executeButtonWidth);

  /// Bottom command dock height: execute button + panel vertical padding.
  static double commandDockHeight(BuildContext context) {
    final execW = executeButtonWidthFor(context);
    final execH = executeButtonHeightForWidth(execW);
    final padV = LandscapeLayout.sp(context, commandDockPadVDesign);
    return execH + padV;
  }

  static double commandDockMaxHeight(BuildContext context) {
    final usable = LandscapeLayout.playUsableHeightOf(context);
    final minH = commandDockHeight(context);
    final cap = usable * LandscapeLayout.combatDockMaxFraction;
    return math.min(minH, cap);
  }

  static double commandDockHeightFor(BuildContext context) =>
      commandDockMaxHeight(context);

  /// Scale execute width down when remaining space after command buttons is tight.
  static double executeWidthFor({
    required BuildContext context,
    required double availableWidth,
  }) {
    final preferred = executeButtonWidthFor(context);
    return availableWidth.clamp(
      LandscapeLayout.minTouchTarget,
      preferred,
    );
  }

  static double menuButtonWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, menuButtonWidthDesign);

  static double menuButtonHeightFor(BuildContext context) =>
      LandscapeLayout.sp(context, menuButtonHeightDesign);

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static bool isShortOf(BuildContext context) =>
      LandscapeLayout.isShortOfContext(context);

  static bool isPhoneShortOf(BuildContext context) =>
      LandscapeLayout.isPhoneShortOfContext(context);

  static double bannerHeightFor(BuildContext context) =>
      LandscapeLayout.sp(context, bannerHeight);
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
