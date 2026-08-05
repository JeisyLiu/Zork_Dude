import 'dart:ui' show Size;

import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Layout breakpoints and sizing for landscape-first exploration.
abstract final class ExplorationLayoutConstants {
  static const double sideBySideMinWidth = LandscapeLayout.sideBySideMinWidth;
  static const double shortHeight = LandscapeLayout.shortHeight;
  static const double directionPadWidth = 112;
  static const double directionPadWidthShort = 64;
  static const double commandDockMaxHeightWide = 132;
  static const double commandDockMaxHeightShort = 112;
  static const double commandDockMaxHeightNarrow = 148;
  static const double chipHeight = 32;
  static const double chipHeightShort = 28;
  static const double chipSpacing = 6;
  static const double moreChipWidth = 88;
  static const double bannerHeight = 44;
  static const double bannerHeightShort = 42;

  static bool isLandscape(Size size) => LandscapeLayout.isLandscape(size);

  static bool useSideBySide(Size size) => LandscapeLayout.useSideBySide(size);

  static bool isShort(Size size) => LandscapeLayout.isShort(size);

  static double chipHeightFor({required bool short}) =>
      short ? chipHeightShort : chipHeight;

  static double dockMaxHeight(Size size) {
    if (isShort(size)) return commandDockMaxHeightShort;
    if (useSideBySide(size)) return commandDockMaxHeightWide;
    return commandDockMaxHeightNarrow;
  }

  static int chipColumnsFor(double width, {bool short = false}) {
    // Short landscape: prefer one row so dock fits without scrolling.
    if (short) {
      if (width >= 420) return 7;
      if (width >= 360) return 6;
      return 5;
    }
    if (width >= 640) return 5;
    if (width >= 480) return 4;
    if (width >= 360) return 4;
    return 3;
  }
}
