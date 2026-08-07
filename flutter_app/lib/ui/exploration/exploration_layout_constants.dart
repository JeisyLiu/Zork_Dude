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
  static const double chipSpacing = 6;
  static const double moreChipWidth = 96;
  static const double bannerHeight = 60;
  static const double chipWidth = 96;
  static const double mapMinWidth = 160;
  static const double panelPadVDesign = 14;
  static const double dpadUpDownDesign = 36;
  static const double dpadGapDesign = 4;
  static const double dpadMinSize = 56;
  static const double stackedMapMinHeight = 140;
  static const double stackedMapFraction = 0.22;
  static const double panelPadHDesign = 10;

  /// Primary action grid: single row of command chips.
  static const int primaryColumns = 8;

  /// Floating move pad (mobile): compass ring diameter at 1280×720.
  static const double floatingCompassDesign = 112;
  static const double floatingUpDownDesign = 44;
  static const double floatingPadGapDesign = 8;
  static const double floatingPadMarginDesign = 8;
  static const double floatingPadOpacity = 0.78;
  static const int primaryRows = 1;

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

  /// Natural single-row grid height for scaled chip width (no panel padding).
  static double gridContentHeight(BuildContext context) {
    return chipHeightForWidth(preferredChipWidth(context));
  }

  static double directionPadWidthFor(BuildContext context) =>
      LandscapeLayout.sp(context, directionPadWidth);

  static double upDownButtonSizeFor(BuildContext context) =>
      LandscapeLayout.sp(context, dpadUpDownDesign);

  static double floatingCompassSizeFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, floatingCompassDesign);

  static double floatingUpDownSizeFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, floatingUpDownDesign);

  static double floatingPadGapFor(BuildContext context) =>
      LandscapeLayout.sp(context, floatingPadGapDesign);

  static double floatingPadMarginFor(BuildContext context) =>
      LandscapeLayout.sp(context, floatingPadMarginDesign);

  /// Total height of the floating move pad (compass + U/D column).
  static double floatingMovePadHeight(BuildContext context) {
    final compass = floatingCompassSizeFor(context);
    final ud = floatingUpDownSizeFor(context) * 2;
    return math.max(compass, ud);
  }

  /// Compass + vertical U/D column width in the dock row.
  static double directionPadBlockWidth(BuildContext context) {
    final rowH = gridContentHeight(context);
    final compass = directionPadWidthFor(context).clamp(
      LandscapeLayout.sp(context, dpadMinSize),
      rowH,
    );
    final ud = upDownButtonSizeFor(context);
    final gap = LandscapeLayout.sp(context, 8);
    return compass + gap + ud;
  }

  static double directionPadBlockHeight(
    BuildContext context, {
    bool inCombat = false,
  }) {
    if (inCombat) return 0;
    return gridContentHeight(context);
  }

  /// Dock height for the single-row command strip.
  static double dockMinHeight(
    BuildContext context, {
    bool inCombat = false,
  }) {
    final gridH = gridContentHeight(context);
    final rowH = inCombat
        ? gridH
        : math.max(gridH, directionPadBlockHeight(context, inCombat: inCombat));
    return rowH + panelPadV(context);
  }

  /// Target dock height: on mobile reclaim the hidden input-row budget;
  /// on desktop keep natural size unless the fraction cap forces a shrink.
  static double dockMaxHeight(
    BuildContext context, {
    bool inCombat = false,
  }) {
    final usableH = LandscapeLayout.playUsableHeightOf(context);
    final natural = dockMinHeight(context, inCombat: inCombat);
    if (usableH <= 0) return natural;
    final cap =
        usableH * LandscapeLayout.explorationDockMaxFractionForPlatform();
    final maxByContent =
        usableH * (1.0 - LandscapeLayout.contentMinHeightFraction);
    final ceiling = math.min(cap, maxByContent);
    if (!LandscapeLayout.showCommandInput) {
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

  /// Chip width that fills [availableWidth] across [primaryColumns].
  static double chipWidthFor(BuildContext context, double availableWidth) {
    final cols = primaryColumns;
    final spacing = chipSpacingFor(context) * (cols - 1);
    if (availableWidth <= spacing) {
      return LandscapeLayout.minTouchTarget;
    }
    final fitted = (availableWidth - spacing) / cols;
    final preferred = preferredChipWidth(context);
    return fitted.clamp(LandscapeLayout.minTouchTarget * 0.85, preferred * 1.35);
  }

  static double dockMaxHeightFor(BuildContext context) => dockMaxHeight(context);

  static int chipColumnsFor(double width, {bool short = false}) =>
      primaryColumns;

  static double bannerHeightFor(BuildContext context) =>
      LandscapeLayout.sp(context, bannerHeight);

  static double moreChipWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, moreChipWidth);
}
