import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Shared breakpoints and spacing for landscape-first 16:9 layouts.
abstract final class LandscapeLayout {
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

  /// Tighter cap on mobile where the command input row is hidden.
  static const double explorationDockMaxFractionMobile = 0.28;

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

  /// Usable height inside [LandscapeScaffold] body (minus outer padding).
  static double playUsableHeightOf(BuildContext context) {
    final mq = MediaQuery.of(context);
    final outer = outerPadding(mq.size, padding: mq.padding);
    final safeMin = playSafeMinimum(mq.size, mq.padding);
    final top = math.max(mq.padding.top, safeMin.top);
    final bottom = math.max(mq.padding.bottom, safeMin.bottom);
    return (mq.size.height - top - bottom - outer * 2)
        .clamp(0.0, mq.size.height);
  }

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
