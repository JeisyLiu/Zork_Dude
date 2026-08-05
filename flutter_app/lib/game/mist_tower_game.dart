import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/game/interface/player_interface.dart';
import 'package:zork_dude/game/map/forest_map.dart';
import 'package:zork_dude/game/player/hero_player.dart';
import 'package:zork_dude/shared/game_constants.dart';

/// Root Bonfire scene — forest clearing demo used as the mobile scaffold.
class MistTowerGame extends StatelessWidget {
  const MistTowerGame({super.key});

  static const String hudOverlay = 'hud';

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      backgroundColor: GameConstants.bgDeep,
      lightingColorGame: Colors.black.withValues(alpha: 0.35),
      playerControllers: [
        Joystick(
          directional: JoystickDirectional(
            color: GameConstants.hero.withValues(alpha: 0.55),
          ),
          actions: [
            JoystickAction(
              actionId: GameConstants.actionAttack,
              size: 52,
              margin: const EdgeInsets.only(bottom: 50, right: 50),
              color: const Color(0xFFE67E22).withValues(alpha: 0.7),
            ),
          ],
        ),
        Keyboard(
          config: KeyboardConfig(
            directionalKeys: [
              KeyboardDirectionalKeys.arrows(),
              KeyboardDirectionalKeys.wasd(),
            ],
            acceptedKeys: [
              LogicalKeyboardKey.space,
            ], // mutable list required by KeyboardConfig
          ),
        ),
      ],
      map: ForestMap.build(),
      player: HeroPlayer(position: ForestMap.playerSpawn()),
      components: ForestMap.enemies(),
      interface: PlayerInterface(),
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        zoom: kIsWeb ? 2.2 : 2.5,
        speed: 4,
      ),
      collisionConfig: BonfireCollisionConfig.dafault(),
      overlayBuilderMap: {
        hudOverlay: (context, game) => MistHudOverlay(game: game),
      },
      initialActiveOverlays: const [hudOverlay],
      onReady: (game) {
        // Reserved for loading shared JSON data / save slots later.
      },
    );
  }
}
