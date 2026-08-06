import 'package:zork_dude/state/ending_kind.dart';

/// Illustration paths for ending overlays.
abstract final class EndingAssets {
  static const dragonClear = 'assets/images/ending/dragon_clear.png';
  static const mainClear = 'assets/images/ending/journey_complete.png';
  static const siteClear = 'assets/images/ending/site_clear.png';
  static const gameOver = 'assets/images/ending/game_over.png';

  static String imageFor(EndingKind kind) {
    switch (kind) {
      case EndingKind.dragonClear:
        return dragonClear;
      case EndingKind.mainClear:
        return mainClear;
      case EndingKind.siteClear:
        return siteClear;
      case EndingKind.gameOver:
        return gameOver;
      case EndingKind.none:
        return mainClear;
    }
  }
}
