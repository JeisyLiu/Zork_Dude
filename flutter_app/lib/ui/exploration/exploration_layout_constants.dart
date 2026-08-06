import 'dart:ui' show Size;

import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints and sizing for landscape-first exploration.
abstract final class ExplorationLayoutConstants {
  static const double sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const double shortHeight = LandscapeLayout.shortHeight;
  static const double directionPadWidth = 112;
  static const double directionPadWidthShort = 72;
  static const double chipSpacing = 8;
  static const double moreChipWidth = 96;
  static const double bannerHeight = 60;
  static const double bannerHeightShort = 54;

  /// Fixed golden-ratio chip widths (height = width × 0.618). No runtime rescale.
  static const double chipWidth = 96;
  static const double chipWidthShort = 80;

  /// Primary action grid: 6 columns × 2 rows.
  static const int primaryColumns = 6;

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static double preferredChipWidth({required bool short}) =>
      short ? chipWidthShort : chipWidth;

  static double chipHeightForWidth(double width) =>
      LandscapeLayout.heightFromWidth(width);

  static double chipHeightFor({required bool short}) =>
      chipHeightForWidth(preferredChipWidth(short: short));

  /// Natural 2-row grid height for a given chip width (no panel padding).
  static double gridContentHeight(double chipWidth) {
    final h = chipHeightForWidth(chipWidth);
    return 2 * h + chipSpacing;
  }

  static double panelPadV({required bool short}) => short ? 12.0 : 18.0;

  /// Dock height that neatly fits the 6×2 golden button grid (+ optional tips).
  static double dockMinHeight({required bool short, bool showTips = true}) {
    final chipW = preferredChipWidth(short: short);
    final tips = (!short && showTips) ? 20.0 : 0.0;
    return gridContentHeight(chipW) + panelPadV(short: short) + tips;
  }

  /// Fixed chip width (no scaling) — layout spreads buttons to fill the panel.
  static double chipWidthFor(double availableWidth, {required bool short}) =>
      preferredChipWidth(short: short);

  static double dockMaxHeight(Size size) {
    return dockMinHeight(short: isShort(size), showTips: !isShort(size)) + 8;
  }

  static int chipColumnsFor(double width, {bool short = false}) => primaryColumns;
}
