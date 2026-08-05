import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/shared/sprite_sheet_factory.dart';

/// The amnesiac traveler — controlled by joystick / keyboard.
class HeroPlayer extends SimplePlayer with BlockMovementCollision, UseLifeBar {
  HeroPlayer({required super.position})
      : super(
          size: GameConstants.tileVector,
          speed: GameConstants.playerSpeed,
          life: GameConstants.playerLife,
          initDirection: Direction.down,
        ) {
    setupLifeBar(
      size: Vector2(18, 3),
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
      color: GameConstants.hero,
      size: GameConstants.tileVector,
      borderColor: Colors.white70,
    );
    add(
      RectangleHitbox(
        size: Vector2(10, 10),
        position: Vector2(3, 5),
      ),
    );
    return super.onLoad();
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN) {
      final isAttack = event.id == GameConstants.actionAttack ||
          event.id == LogicalKeyboardKey.space;
      if (isAttack) {
        _meleeAttack();
      }
    }
    super.onJoystickAction(event);
  }

  void _meleeAttack() {
    simpleAttackMelee(
      damage: 15,
      size: Vector2.all(GameConstants.tileSize * 0.9),
      animationRight: SpriteSheetFactory.solidAnimation(
        color: const Color(0x88FFFFFF),
        size: Vector2.all(GameConstants.tileSize),
      ),
      withPush: true,
    );
  }
}
