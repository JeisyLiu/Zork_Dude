import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints and sizing for landscape-first exploration.
abstract final class ExplorationLayoutConstants {
  static const double sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const double shortHeight = LandscapeLayout.shortHeight;

  // Design constants (1280×720 reference).
  static const double directionPadWidth = 112;
  static const double chipSpacing = 8;
  static const double moreChipWidth = 96;
  static const double bannerHeight = 60;
  static const double chipWidth = 96;
  static const double mapMinWidth = 160;
  static const double panelPadVDesign = 18;
  static const double tipsRowHeight = 20;
  static const double dpadUpDownDesign = 36;
  static const double dpadGapDesign = 4;
  static const double dpadMinSize = 56;
  static const double dpadGridOffset = 40;
  static const double stackedMapMinHeight = 140;
  static const double stackedMapFraction = 0.22;
  static const double panelPadHDesign = 12;

  /// Primary action grid: 6 columns × 2 rows.
  static const int primaryColumns = 6;

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static bool isShortOf(BuildContext context) =>
      LandscapeLayout.isShortOfContext(context);

  static bool isPhoneShortOf(BuildContext context) =>
      LandscapeLayout.isPhoneShortOfContext(context);

  static double preferredChipWidth(BuildContext context) =>
      LandscapeLayout.minTouch(context, chipWidth);

  static double chipHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double chipHeightFor(BuildContext context) =>
      chipHeightForWidth(preferredChipWidth(context));

  static double panelPadV(BuildContext context) =>
      LandscapeLayout.sp(context, panelPadVDesign);

  static double panelPadH(BuildContext context) =>
      LandscapeLayout.sp(context, panelPadHDesign);

  static double chipSpacingFor(BuildContext context) =>
      LandscapeLayout.sp(context, chipSpacing);

  /// Natural 2-row grid height for scaled chip width (no panel padding).
  static double gridContentHeight(BuildContext context) {
    final w = preferredChipWidth(context);
    final h = chipHeightForWidth(w);
    final spacing = chipSpacingFor(context);
    return 2 * h + spacing;
  }

  static double directionPadWidthFor(BuildContext context) =>
      LandscapeLayout.sp(context, directionPadWidth);

  static double directionPadBlockHeight(
    BuildContext context, {
    bool inCombat = false,
  }) {
    if (inCombat) return 0;
    final gridH = gridContentHeight(context);
    final dpadBase = directionPadWidthFor(context);
    final offset = LandscapeLayout.sp(context, dpadGridOffset);
    final minSize = LandscapeLayout.sp(context, dpadMinSize);
    final dpadSize = (gridH - offset).clamp(minSize, dpadBase);
    final upDown = LandscapeLayout.sp(context, dpadUpDownDesign);
    return dpadSize + LandscapeLayout.sp(context, dpadGapDesign) + upDown;
  }

  /// Dock height that neatly fits the 6×2 golden button grid (+ optional tips).
  static double dockMinHeight(
    BuildContext context, {
    bool showTips = true,
    bool inCombat = false,
  }) {
    final gridH = gridContentHeight(context);
    final rowH = inCombat
        ? gridH
        : math.max(gridH, directionPadBlockHeight(context, inCombat: inCombat));
    final tips =
        showTips ? LandscapeLayout.sp(context, tipsRowHeight) : 0.0;
    return rowH + panelPadV(context) + tips;
  }

  /// Target dock height: on mobile reclaim the hidden input-row budget;
  /// on desktop keep natural size unless the fraction cap forces a shrink.
  static double dockMaxHeight(
    BuildContext context, {
    bool showTips = true,
    bool inCombat = false,
  }) {
    final usableH = LandscapeLayout.playUsableHeightOf(context);
    final natural = dockMinHeight(
      context,
      showTips: showTips,
      inCombat: inCombat,
    );
    if (usableH <= 0) return natural;
    final cap =
        usableH * LandscapeLayout.explorationDockMaxFractionForPlatform();
    final maxByContent =
        usableH * (1.0 - LandscapeLayout.contentMinHeightFraction);
    final ceiling = math.min(cap, maxByContent);
    if (!LandscapeLayout.showCommandInput) {
      // Roughly one command-input row (design 48dp), spent on a taller dock.
      final reclaim = LandscapeLayout.sp(context, 48);
      return math.min(natural + reclaim, ceiling);
    }
    return math.min(natural, ceiling);
  }

  static double mapPanelMinWidth(BuildContext context) =>
      LandscapeLayout.sp(context, mapMinWidth);

  static double stackedMapHeight(BuildContext context) {
    final usableH = LandscapeLayout.playUsableHeightOf(context);
    return math.max(
      LandscapeLayout.sp(context, stackedMapMinHeight),
      usableH * stackedMapFraction,
    );
  }

  /// Fixed scaled chip width — layout spreads buttons to fill the panel.
  static double chipWidthFor(BuildContext context, double availableWidth) =>
      preferredChipWidth(context);

  static double dockMaxHeightFor(BuildContext context) => dockMaxHeight(context);

  static int chipColumnsFor(double width, {bool short = false}) =>
      primaryColumns;

  static double bannerHeightFor(BuildContext context) =>
      LandscapeLayout.sp(context, bannerHeight);

  static double moreChipWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, moreChipWidth);
}
