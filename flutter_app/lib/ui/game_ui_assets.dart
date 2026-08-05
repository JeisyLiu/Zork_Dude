import 'package:flutter/material.dart';

/// Asset paths for Kenney UI Pack Adventure (synced from root ui_pack/).
abstract final class GameUiAssets {
  static const base = 'assets/ui';

  // Panels
  static const panelBrown = '$base/panel_brown.png';
  static const panelBrownDark = '$base/panel_brown_dark.png';
  static const panelBrownCorners = '$base/panel_brown_corners_a.png';
  static const panelGrey = '$base/panel_grey.png';
  static const panelGreyDark = '$base/panel_grey_dark.png';
  static const panelGreyBolts = '$base/panel_grey_bolts.png';
  static const panelGreyBoltsDark = '$base/panel_grey_bolts_dark.png';
  static const panelBorderBrown = '$base/panel_border_brown.png';
  static const panelBorderGrey = '$base/panel_border_grey.png';

  // Buttons
  static const buttonBrown = '$base/button_brown.png';
  static const buttonGrey = '$base/button_grey.png';
  static const buttonRed = '$base/button_red.png';

  // Banners
  static const bannerHanging = '$base/banner_hanging.png';
  static const bannerCurtain = '$base/banner_classic_curtain.png';
  static const bannerModern = '$base/banner_modern.png';

  // Progress
  static const progressGreen = '$base/progress_green.png';
  static const progressGreenBorder = '$base/progress_green_border.png';
  static const progressGreenSmall = '$base/progress_green_small.png';
  static const progressGreenSmallBorder = '$base/progress_green_small_border.png';
  static const progressRed = '$base/progress_red.png';
  static const progressRedBorder = '$base/progress_red_border.png';
  static const progressRedSmall = '$base/progress_red_small.png';
  static const progressRedSmallBorder = '$base/progress_red_small_border.png';

  // Minimap / D-pad
  static const minimapRingBrown = '$base/minimap_ring_brown_detail.png';
  static const minimapRingGrey = '$base/minimap_ring_grey_detail.png';
  static const compassN = '$base/minimap_compass_toon_n.png';
  static const compassE = '$base/minimap_compass_toon_e.png';
  static const compassS = '$base/minimap_compass_toon_s.png';
  static const compassW = '$base/minimap_compass_toon_w.png';
  static const iconStarYellow = '$base/minimap_icon_star_yellow.png';
  static const iconJewelGreen = '$base/minimap_icon_jewel_white.png';
  static const iconExclamation = '$base/minimap_icon_exclamation_yellow.png';

  // Round / hex
  static const roundBrown = '$base/round_brown.png';
  static const roundGrey = '$base/round_grey.png';
  static const hexBrown = '$base/hexagon_brown.png';

  // Patterns
  static const patternPaper = '$base/pattern_grid_paper.png';

  // Scrollbars
  static const scrollbarBrown = '$base/scrollbar_brown.png';
  static const scrollbarThumb = '$base/scrollbar_brown_small.png';

  /// Standard 64x64 panel nine-patch slice.
  static const slicePanel64 = Rect.fromLTRB(16, 16, 48, 48);

  /// 48x24 button horizontal slice.
  static const sliceButton = Rect.fromLTRB(12, 8, 36, 16);

  /// 256x64 banner horizontal slice.
  static const sliceBanner = Rect.fromLTRB(32, 12, 224, 52);
}
