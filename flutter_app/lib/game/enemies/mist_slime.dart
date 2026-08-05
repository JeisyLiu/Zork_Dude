import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/shared/sprite_sheet_factory.dart';

/// Placeholder mist slime — chases the player and deals melee damage.
class MistSlime extends SimpleEnemy
    with BlockMovementCollision, UseLifeBar, RandomMovement {
  MistSlime({
    required super.position,
    double? customLife,
    double? customSpeed,
  }) : super(
          size: GameConstants.tileVector,
          speed: customSpeed ?? GameConstants.enemySpeed,
          life: customLife ?? GameConstants.enemyLife,
          initDirection: Direction.left,
        ) {
    setupLifeBar(
      size: Vector2(14, 2),
      barLifeDrawPosition: BarLifeDrawPosition.top,
      borderWidth: 1,
      borderColor: Colors.white24,
      borderRadius: BorderRadius.circular(2),
      showLifeText: false,
      colors: const [Color(0xFFE74C3C), Color(0xFF2ECC71)],
    );
  }

  @override
  Future<void> onLoad() async {
    animation = await SpriteSheetFactory.characterAnimation(
      color: GameConstants.slime,
      size: GameConstants.tileVector,
      borderColor: const Color(0xFF1B5E20),
    );
    add(
      RectangleHitbox(
        size: Vector2(10, 10),
        position: Vector2(3, 4),
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
          size: Vector2.all(GameConstants.tileSize * 0.8),
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
