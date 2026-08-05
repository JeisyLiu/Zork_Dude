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

  /// Soft wood tone — close to Kenney panel brown frames, still muted (not bright).
  static const Color bgDeep = Color(0xFF3A2E22);
  static const Color bgMid = Color(0xFF4A3C2C);
  static const Color bgMist = Color(0xFF554632);
  static const Color grass = Color(0xFF4A4030);
  static const Color path = Color(0xFF5A4C38);
  static const Color wall = Color(0xFF3A2E22);
  static const Color tree = Color(0xFF3D3224);
  static const Color hero = Color(0xFFB8955A);
  static const Color slime = Color(0xFF6B8F5A);
  static const Color accent = Color(0xFFE8DCC8);
}
