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
  static const double bannerHeight = 44;
  static const double bannerHeightShort = 42;

  /// Preferred golden-ratio chip widths (height = width × 0.618).
  static const double chipWidth = 96;
  static const double chipWidthShort = 80;
  static const double chipWidthMin = 64;
  static const double chipWidthMinShort = 56;

  /// Primary action grid always uses 3 columns → even 3+3 rows for 6 actions.
  static const int primaryColumns = 3;

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

  /// Dock height that neatly fits the 3×2 golden button grid (+ optional tips).
  static double dockMinHeight({required bool short, bool showTips = true}) {
    final chipW = preferredChipWidth(short: short);
    final tips = (!short && showTips) ? 20.0 : 0.0;
    return gridContentHeight(chipW) + panelPadV(short: short) + tips;
  }

  /// Fit preferred golden chips into [availableWidth], scaling down uniformly if needed.
  static double chipWidthFor(double availableWidth, {required bool short}) {
    final preferred = preferredChipWidth(short: short);
    final minW = short ? chipWidthMinShort : chipWidthMin;
    final spacing = chipSpacing * (primaryColumns - 1);
    final ideal = (availableWidth - spacing) / primaryColumns;
    return ideal.clamp(minW, preferred);
  }

  static double dockMaxHeight(Size size) {
    // Allow dock to grow to preferred grid; slight headroom only.
    return dockMinHeight(short: isShort(size), showTips: !isShort(size)) + 8;
  }

  static int chipColumnsFor(double width, {bool short = false}) {
    if (short) {
      if (width >= 360) return 3;
      return 2;
    }
    if (width >= 480) return 4;
    return 3;
  }
}
