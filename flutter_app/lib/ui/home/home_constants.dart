import 'package:flutter/material.dart';

/// Palette and layout constants for the minimalist pixel home screen.
abstract final class HomeConstants {
  static const String heroImagePath = 'assets/images/home/mist_tower_hero.png';

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
  static const double buttonWidth = 240;
  static const double buttonHeight = 50;

  static double heroSizeFor(Size screen) {
    final shortest = screen.shortestSide;
    final height = screen.height;
    if (height < 520 || shortest < 340) return 112;
    if (shortest >= 720 || screen.width >= 900) return 176;
    return 152;
  }
}
