import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
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
  static const bannerHeight = 58.0;
  static const bannerHeightShort = 52.0;
  static const bannerHeightPhone = 46.0;

  /// Golden-ratio action / execute buttons (height = width × 0.618).
  static const executeButtonWidth = 140.0;
  static const executeButtonWidthShort = 112.0;
  static const executeButtonWidthPhone = 96.0;
  static const commandButtonWidth = 96.0;
  static const commandButtonWidthShort = 80.0;
  static const commandButtonWidthPhone = 64.0;

  static double commandButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double executeButtonHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double commandButtonWidthFor({
    required bool short,
    bool phoneShort = false,
  }) {
    if (phoneShort) return commandButtonWidthPhone;
    return short ? commandButtonWidthShort : commandButtonWidth;
  }

  static double executeButtonWidthFor({
    required bool short,
    bool phoneShort = false,
  }) {
    if (phoneShort) return executeButtonWidthPhone;
    return short ? executeButtonWidthShort : executeButtonWidth;
  }

  /// Bottom command dock height: execute button + panel vertical padding.
  static double commandDockHeight({
    required bool short,
    bool phoneShort = false,
  }) {
    final execW = executeButtonWidthFor(short: short, phoneShort: phoneShort);
    final execH = executeButtonHeightForWidth(execW);
    final padV = phoneShort ? 8.0 : (short ? 12.0 : 16.0);
    return execH + padV;
  }

  static double commandDockMaxHeight(
    double usableHeight, {
    required bool short,
    bool phoneShort = false,
  }) {
    final minH = commandDockHeight(short: short, phoneShort: phoneShort);
    final cap = usableHeight * LandscapeLayout.combatDockMaxFraction;
    return math.min(minH, cap);
  }

  static double commandDockHeightFor(BuildContext context) {
    final usable = LandscapeLayout.playUsableHeightOf(context);
    final phone = LandscapeLayout.isPhoneShortPlayContext(context);
    final short = LandscapeLayout.isShortPlayContext(context);
    return commandDockMaxHeight(
      usable,
      short: short,
      phoneShort: phone,
    );
  }

  /// Scale execute width down when remaining space after command buttons is tight.
  static double executeWidthFor({
    required double availableWidth,
    required bool short,
    bool phoneShort = false,
  }) {
    final preferred = executeButtonWidthFor(
      short: short,
      phoneShort: phoneShort,
    );
    return availableWidth.clamp(72.0, preferred);
  }

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static bool isShortOf(BuildContext context) =>
      LandscapeLayout.isShortOfContext(context);

  static bool isPhoneShortOf(BuildContext context) =>
      LandscapeLayout.isPhoneShortOfContext(context);

  static double bannerHeightFor({
    required bool short,
    bool phoneShort = false,
  }) {
    if (phoneShort) return bannerHeightPhone;
    return short ? bannerHeightShort : bannerHeight;
  }
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
