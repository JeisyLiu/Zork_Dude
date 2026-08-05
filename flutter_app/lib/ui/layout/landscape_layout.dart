import 'package:flutter/material.dart';

/// Shared breakpoints and spacing for landscape-first 16:9 layouts.
abstract final class LandscapeLayout {
  static const double shortHeight = 420;
  static const double sideBySideMinWidth = 640;
  static const double overlayCenterMinWidth = 900;
  static const double overlayCenterMaxWidth = 480;
  static const double overlaySideMaxWidth = 360;
  static const double overlaySideMinWidth = 280;
  static const double maxContentWidth = 960;

  /// Button aspect: width : height = 1 : [goldenRatio].
  static const double goldenRatio = 0.618;

  static const EdgeInsets safeMinimum = EdgeInsets.symmetric(horizontal: 4);

  static double heightFromWidth(double width) =>
      (width * goldenRatio * 10).roundToDouble() / 10;

  static bool isLandscape(Size size) => size.width > size.height;

  static bool isShort(Size size) => size.height < shortHeight;

  static bool useSideBySide(Size size) =>
      isLandscape(size) || size.width >= sideBySideMinWidth;

  /// Tablet-wide landscape: use centered dialog instead of right rail.
  static bool useCenteredOverlay(Size size) => size.width >= overlayCenterMinWidth;

  static double outerPadding(Size size) => isShort(size) ? 3 : 6;

  static double overlayPanelWidth(Size size) {
    if (useCenteredOverlay(size)) return overlayCenterMaxWidth;
    final rail = size.width * 0.42;
    return rail.clamp(overlaySideMinWidth, overlaySideMaxWidth);
  }
}
