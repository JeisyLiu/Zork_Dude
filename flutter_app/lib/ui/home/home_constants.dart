import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Palette and layout constants for the minimalist pixel home screen.
abstract final class HomeConstants {
  static const String heroImagePath = 'assets/images/home/mist_tower_hero.png';

  /// Cover CTA plate (blank; label drawn in code). Falls back to Kenney if missing.
  static const String enterButtonAsset = 'assets/images/home/button_enter.png';

  // Background gradient — dark olive-brown to charcoal.
  static const Color bgTop = Color(0xFF1E1C16);
  static const Color bgMid = Color(0xFF171711);
  static const Color bgBottom = Color(0xFF12100C);

  // Typography.
  static const Color titleColor = Color(0xFFC4B48A);
  static const Color subtitleColor = Color(0xFF8A7E62);
  static const Color bodyColor = Color(0xFFB8AA8E);
  static const Color hintColor = Color(0xFF6E6654);

  // Ambient layers.
  static const Color fogColor = Color(0xFF9A9080);
  static const Color particleColor = Color(0xFFC4B48A);
  static const Color vignetteColor = Color(0xFF000000);

  // Pixel tower fallback.
  static const Color towerStone = Color(0xFF3A3630);
  static const Color towerStoneLight = Color(0xFF4A4640);
  static const Color towerMist = Color(0xFF6A6458);
  static const Color towerRune = Color(0xFF8A7A50);

  static const double maxContentWidth = 520;

  /// Cover CTA matches `button_enter.png` plate (≈3:1).
  static const double buttonWidth = 216;
  static const double buttonAspect = 3;
  static const double heroSize = 196;
  static const double closeButtonSize = 44;

  // Typography design sizes.
  static const double titleFontSize = 30;
  static const double subtitleFontSize = 12;
  static const double bodyFontSize = 14;
  static const double hintFontSize = 10;
  static const double gapLarge = 16;
  static const double gapMedium = 12;
  static const double gapSmall = 10;
  static const double scrollPadV = 12;
  static const double scrollPadH = 16;
  static const double dividerWidth = 120;
  static const double dividerHeight = 3;

  /// Light text on dark enter-plate.
  static const Color buttonLabelColor = Color(0xFFE8DCC0);
  static const Color buttonSubLabelColor = Color(0xFFC4B48A);

  static double buttonHeightFor(double width) => width / buttonAspect;

  static double heroSizeFor(BuildContext context) =>
      LandscapeLayout.sp(context, heroSize);

  static double buttonWidthFor(BuildContext context) =>
      LandscapeLayout.minTouch(context, buttonWidth);
}
