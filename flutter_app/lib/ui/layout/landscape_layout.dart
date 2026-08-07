import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Shared breakpoints and spacing for landscape-first 16:9 layouts.
///
/// Play screens render inside a fixed 16:9 canvas ([fitDesignAspect]) so
/// ultrawide / tall devices letterbox or pillarbox instead of stretching UI.
abstract final class LandscapeLayout {
  /// Design reference (16:9 landscape).
  static const double designWidth = 1280;
  static const double designHeight = 720;
  static const double designAspect = designWidth / designHeight;
  static const double scaleMin = 0.75;
  static const double scaleMinShort = 0.55;
  static const double shortScaleHeight = 480;
  static const double scaleMax = 1.25;
  static const double minTouchTarget = 40;

  /// Ultrawide phone landscape (e.g. 20:9, 19.5:9). Used for device detection
  /// outside the play canvas; inside [LandscapeScaffold] aspect is always 16:9.
  static const double ultrawideAspect = 19.5 / 9;

  static const double shortHeight = 420;
  static const double phoneShortHeight = 400;
  static const double sideBySideMinWidth = 640;
  static const double overlayCenterMinWidth = 900;
  static const double overlayCenterMaxWidth = 480;
  static const double overlaySideMaxWidth = 360;
  static const double overlaySideMinWidth = 280;
  static const double maxContentWidth = 960;

  /// Minimum share of usable height for main content (log + map).
  static const double contentMinHeightFraction = 0.38;

  /// Max share of usable height for exploration command dock (desktop).
  static const double explorationDockMaxFraction = 0.30;

  /// Mobile reclaims the hidden command-input row into a taller dock.
  static const double explorationDockMaxFractionMobile = 0.36;

  /// Max share of usable height for combat command dock.
  static const double combatDockMaxFraction = 0.28;

  /// Button aspect: width : height = 1 : [goldenRatio].
  static const double goldenRatio = 0.618;

  static const EdgeInsets safeMinimum = EdgeInsets.symmetric(horizontal: 4);

  static double heightFromWidth(double width) =>
      (width * goldenRatio * 10).roundToDouble() / 10;

  static bool isLandscape(Size size) => size.width > size.height;

  /// Raw screen height (legacy); prefer [isShortOf] with padding.
  static bool isShort(Size size) => size.height < shortHeight;

  static double usableHeight(Size size, EdgeInsets padding) =>
      (size.height - padding.vertical).clamp(0, size.height);

  static Size usableSize(Size size, EdgeInsets padding) => Size(
        size.width,
        usableHeight(size, padding),
      );

  static bool isShortOf(Size size, EdgeInsets padding) =>
      usableHeight(size, padding) < shortHeight;

  static bool isPhoneShortOf(Size size, EdgeInsets padding) =>
      usableHeight(size, padding) < phoneShortHeight;

  static bool isShortOfContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    return isShortOf(mq.size, mq.padding);
  }

  static bool isPhoneShortOfContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    return isPhoneShortOf(mq.size, mq.padding);
  }

  static double usableHeightOf(BuildContext context) {
    final mq = MediaQuery.of(context);
    return usableHeight(mq.size, mq.padding);
  }

  /// Largest 16:9 rect that fits in [maxSize] (letterbox / pillarbox).
  static Size fitDesignAspect(Size maxSize) {
    if (maxSize.width <= 0 || maxSize.height <= 0) return Size.zero;
    final maxAspect = maxSize.width / maxSize.height;
    if (maxAspect > designAspect) {
      final h = maxSize.height;
      return Size(h * designAspect, h);
    }
    final w = maxSize.width;
    return Size(w, w / designAspect);
  }

  /// Play canvas size from [LandscapeScaffold] (always ~16:9).
  static double playUsableHeightOf(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Play canvas size from [LandscapeScaffold] (always ~16:9).
  static double playUsableWidthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Uniform UI scale from design height (720dp), clamped.
  static double uiScaleOf(BuildContext context) {
    final h = playUsableHeightOf(context);
    if (h <= 0) return 1.0;
    final min = scaleMinForHeight(h);
    return (h / designHeight).clamp(min, scaleMax);
  }

  static double scaleMinForHeight(double usableHeight) =>
      usableHeight < shortScaleHeight ? scaleMinShort : scaleMin;

  /// Play-canvas width / height (≈16:9 inside [LandscapeScaffold]).
  static double aspectRatioOf(BuildContext context) {
    final w = playUsableWidthOf(context);
    final h = playUsableHeightOf(context);
    if (h <= 0) return designAspect;
    return w / h;
  }

  static bool isUltrawideOf(BuildContext context) =>
      aspectRatioOf(context) >= ultrawideAspect;

  /// Scaled spacing, font size, or non-touch dimension.
  static double sp(BuildContext context, double designDp) =>
      designDp * uiScaleOf(context);

  /// Scaled touch target with minimum 40dp.
  static double minTouch(BuildContext context, double designDp) =>
      math.max(sp(context, designDp), minTouchTarget);

  static bool isShortPlayContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    return isShortOf(mq.size, mq.padding) ||
        playUsableHeightOf(context) < shortHeight;
  }

  static bool isPhoneShortPlayContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    return isPhoneShortOf(mq.size, mq.padding) ||
        playUsableHeightOf(context) < phoneShortHeight;
  }

  static bool useSideBySide(Size size) =>
      isLandscape(size) || size.width >= sideBySideMinWidth;

  /// Tablet-wide landscape: use centered dialog instead of right rail.
  static bool useCenteredOverlay(Size size) => size.width >= overlayCenterMinWidth;

  static double outerPadding(Size size, {EdgeInsets? padding}) {
    final h = padding != null
        ? usableHeight(size, padding)
        : size.height;
    return h < shortHeight ? 3 : 6;
  }

  static EdgeInsets playSafeMinimum(Size size, EdgeInsets padding) {
    if (!isPhoneShortOf(size, padding)) return safeMinimum;
    return const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  }

  static double overlayPanelWidth(Size size) {
    if (useCenteredOverlay(size)) return overlayCenterMaxWidth;
    final rail = size.width * 0.42;
    return rail.clamp(overlaySideMinWidth, overlaySideMaxWidth);
  }

  /// Text command row is desktop-only; mobile uses quick-command chips.
  static bool get showCommandInput {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return false;
      default:
        return true;
    }
  }

  static double explorationDockMaxFractionForPlatform() =>
      showCommandInput
          ? explorationDockMaxFraction
          : explorationDockMaxFractionMobile;
}
