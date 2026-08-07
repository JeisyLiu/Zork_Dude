import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints and sizing for landscape-first exploration.
abstract final class ExplorationLayoutConstants {
  static const double sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const double shortHeight = LandscapeLayout.shortHeight;
  static const double directionPadWidth = 112;
  static const double directionPadWidthShort = 72;
  static const double chipSpacing = 8;
  static const double chipSpacingPhone = 6;
  static const double moreChipWidth = 96;
  static const double bannerHeight = 60;
  static const double bannerHeightShort = 48;
  static const double bannerHeightPhone = 48;

  /// Fixed golden-ratio chip widths (height = width × 0.618). No runtime rescale.
  static const double chipWidth = 96;
  static const double chipWidthShort = 80;
  static const double chipWidthPhone = 64;

  static const double mapMinWidth = 160;
  static const double mapMinWidthPhone = 120;

  /// Primary action grid: 6 columns × 2 rows.
  static const int primaryColumns = 6;

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static bool isShortOf(BuildContext context) =>
      LandscapeLayout.isShortOfContext(context);

  static bool isPhoneShortOf(BuildContext context) =>
      LandscapeLayout.isPhoneShortOfContext(context);

  static double preferredChipWidth({
    required bool short,
    bool phoneShort = false,
  }) {
    if (phoneShort) return chipWidthPhone;
    return short ? chipWidthShort : chipWidth;
  }

  static double chipHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double chipHeightFor({
    required bool short,
    bool phoneShort = false,
  }) =>
      chipHeightForWidth(preferredChipWidth(short: short, phoneShort: phoneShort));

  static double panelPadV({required bool short, bool phoneShort = false}) {
    if (phoneShort) return 8;
    return short ? 12.0 : 18.0;
  }

  static double chipSpacingFor({bool phoneShort = false}) =>
      phoneShort ? chipSpacingPhone : chipSpacing;

  /// Natural 2-row grid height for a given chip width (no panel padding).
  static double gridContentHeight(double chipWidth, {bool phoneShort = false}) {
    final h = chipHeightForWidth(chipWidth);
    final spacing = chipSpacingFor(phoneShort: phoneShort);
    return 2 * h + spacing;
  }

  static double directionPadBlockHeight({
    required bool short,
    bool phoneShort = false,
  }) {
    final chipW = preferredChipWidth(short: short, phoneShort: phoneShort);
    final gridH = gridContentHeight(chipW, phoneShort: phoneShort);
    final dpadBase = short || phoneShort
        ? directionPadWidthShort
        : directionPadWidth;
    final dpadSize = (gridH - (phoneShort ? 24 : (short ? 30 : 40)))
        .clamp(phoneShort ? 48.0 : 56.0, dpadBase);
    final upDown = phoneShort || short ? 26.0 : 36.0;
    return dpadSize + 4 + upDown;
  }

  /// Dock height that neatly fits the 6×2 golden button grid (+ optional tips).
  static double dockMinHeight({
    required bool short,
    bool phoneShort = false,
    bool showTips = true,
    bool inCombat = false,
  }) {
    final chipW = preferredChipWidth(short: short, phoneShort: phoneShort);
    final gridH = gridContentHeight(chipW, phoneShort: phoneShort);
    final rowH = inCombat
        ? gridH
        : math.max(gridH, directionPadBlockHeight(
            short: short,
            phoneShort: phoneShort,
          ));
    final tips = (!short && !phoneShort && showTips) ? 20.0 : 0.0;
    return rowH + panelPadV(short: short, phoneShort: phoneShort) + tips;
  }

  /// Cap dock height so the middle content area keeps room for map + log.
  static double dockMaxHeight(
    double usableHeight, {
    required bool short,
    bool phoneShort = false,
    bool showTips = true,
    bool inCombat = false,
  }) {
    final minH = dockMinHeight(
      short: short,
      phoneShort: phoneShort,
      showTips: showTips,
      inCombat: inCombat,
    );
    final cap = usableHeight * LandscapeLayout.explorationDockMaxFractionForPlatform();
    if (usableHeight <= 0) return minH;
    return math.min(minH, cap);
  }

  static double mapPanelMinWidth({required bool phoneShort}) =>
      phoneShort ? mapMinWidthPhone : mapMinWidth;

  static double stackedMapHeight(double usableHeight, {required bool short}) {
    final fraction = short ? 0.28 : 0.22;
    return math.max(short ? 100.0 : 140.0, usableHeight * fraction);
  }

  /// Fixed chip width (no scaling) — layout spreads buttons to fill the panel.
  static double chipWidthFor(
    double availableWidth, {
    required bool short,
    bool phoneShort = false,
  }) =>
      preferredChipWidth(short: short, phoneShort: phoneShort);

  static double dockMaxHeightFor(Size size, EdgeInsets padding) {
    final usable = LandscapeLayout.usableHeight(size, padding);
    final phone = LandscapeLayout.isPhoneShortOf(size, padding);
    final short = LandscapeLayout.isShortOf(size, padding);
    return dockMaxHeight(
      usable,
      short: short,
      phoneShort: phone,
      showTips: !short && !phone,
    );
  }

  static int chipColumnsFor(double width, {bool short = false}) => primaryColumns;

  static double bannerHeightFor({
    required bool short,
    bool phoneShort = false,
  }) {
    if (phoneShort) return bannerHeightPhone;
    return short ? bannerHeightShort : bannerHeight;
  }
}
