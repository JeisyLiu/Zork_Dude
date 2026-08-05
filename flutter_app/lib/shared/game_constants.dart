import 'package:bonfire/bonfire.dart';

/// Shared gameplay constants for Mist Tower (迷雾之塔).
abstract final class GameConstants {
  static const double tileSize = 16;
  static Vector2 get tileVector => Vector2.all(tileSize);

  /// Larger emoji sprites for combat readability (still grid-aligned enough).
  static const double combatSpriteSize = 24;
  static Vector2 get combatSpriteVector => Vector2.all(combatSpriteSize);

  static const String playerEmoji = '🧙';
  static const String defaultEnemyEmoji = '👾';

  static const double playerSpeed = 80;
  static const double playerLife = 100;
  static const double enemyLife = 40;
  static const double enemySpeed = 45;

  static const int actionAttack = 1;
  static const int actionInteract = 2;

  /// Misty palette matching the web/CLI mood.
  static const Color bgDeep = Color(0xFF0A0A12);
  static const Color grass = Color(0xFF1E3A2F);
  static const Color path = Color(0xFF2A3F4A);
  static const Color wall = Color(0xFF1A1A2E);
  static const Color tree = Color(0xFF0F2A1C);
  static const Color hero = Color(0xFF54A0FF);
  static const Color slime = Color(0xFF2ECC71);
  static const Color accent = Color(0xFFC8D6E5);
}
