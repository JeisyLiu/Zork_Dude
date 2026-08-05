import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/shared/sprite_sheet_factory.dart';

/// Enemy using JSON emoji as placeholder sprite (Web-style).
class MistSlime extends SimpleEnemy
    with BlockMovementCollision, UseLifeBar, RandomMovement {
  MistSlime({
    required super.position,
    this.emoji = GameConstants.defaultEnemyEmoji,
    double? customLife,
    double? customSpeed,
    Vector2? size,
  }) : super(
          size: size ?? GameConstants.combatSpriteVector,
          speed: customSpeed ?? GameConstants.enemySpeed,
          life: customLife ?? GameConstants.enemyLife,
          initDirection: Direction.left,
        ) {
    setupLifeBar(
      size: Vector2(16, 2),
      barLifeDrawPosition: BarLifeDrawPosition.top,
      borderWidth: 1,
      borderColor: Colors.white24,
      borderRadius: BorderRadius.circular(2),
      showLifeText: false,
      colors: const [Color(0xFFE74C3C), Color(0xFF2ECC71)],
    );
  }

  final String emoji;

  @override
  Future<void> onLoad() async {
    animation = await SpriteSheetFactory.emojiCharacterAnimation(
      emoji: emoji.isNotEmpty ? emoji : GameConstants.defaultEnemyEmoji,
      size: size,
      background: const Color(0x331A2A1A),
    );
    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.55, size.y * 0.55),
        position: Vector2(size.x * 0.22, size.y * 0.28),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    seeAndMoveToPlayer(
      radiusVision: GameConstants.tileSize * 6,
      closePlayer: (player) {
        simpleAttackMelee(
          damage: 8,
          size: Vector2.all(size.x * 0.8),
          interval: 1200,
          withPush: false,
        );
      },
      notObserved: () {
        runRandomMovement(dt, maxDistance: 40, minDistance: 10);
        return false;
      },
    );
    super.update(dt);
  }

  @override
  void onDie() {
    super.onDie();
    removeFromParent();
  }
}
