import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/shared/sprite_sheet_factory.dart';

/// The amnesiac traveler — controlled by joystick / keyboard.
class HeroPlayer extends SimplePlayer with BlockMovementCollision, UseLifeBar {
  HeroPlayer({
    required super.position,
    this.emoji = GameConstants.playerEmoji,
    Vector2? size,
  }) : super(
          size: size ?? GameConstants.combatSpriteVector,
          speed: GameConstants.playerSpeed,
          life: GameConstants.playerLife,
          initDirection: Direction.down,
        ) {
    setupLifeBar(
      size: Vector2(20, 3),
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
      emoji: emoji,
      size: size,
      background: const Color(0x332A4A6A),
    );
    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.55, size.y * 0.55),
        position: Vector2(size.x * 0.22, size.y * 0.3),
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
      size: Vector2.all(size.x * 0.9),
      animationRight: SpriteSheetFactory.emojiAnimation(
        emoji: '⚔️',
        size: Vector2.all(size.x),
      ),
      withPush: true,
    );
  }
}
