import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/shared/game_constants.dart';

/// Bonfire HUD slot — extend with mini-map, inventory icons, etc.
class PlayerInterface extends GameInterface {}

/// Flutter overlay shown above the Bonfire canvas.
class MistHudOverlay extends StatelessWidget {
  const MistHudOverlay({super.key, required this.game});

  final BonfireGame game;

  @override
  Widget build(BuildContext context) {
    final player = game.player;
    final life = player?.life ?? 0;
    final maxLife = player?.maxLife ?? 1;
    final ratio = (life / maxLife).clamp(0.0, 1.0);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(
          children: [
            const Text(
              '🌫 迷雾之塔',
              style: TextStyle(
                color: GameConstants.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                shadows: [Shadow(blurRadius: 4, color: Colors.black87)],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'HP ${life.toInt()}/${maxLife.toInt()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: const Color(0xFF2D2D3A),
                      color: Color.lerp(
                        const Color(0xFFE74C3C),
                        const Color(0xFF2ECC71),
                        ratio,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
