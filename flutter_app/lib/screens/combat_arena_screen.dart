import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/game/enemies/mist_slime.dart';
import 'package:zork_dude/game/interface/player_interface.dart';
import 'package:zork_dude/game/map/arena_map.dart';
import 'package:zork_dude/game/player/hero_player.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

/// Bonfire combat arena — only entered when GameSession.inCombat is true.
class CombatArenaScreen extends StatefulWidget {
  const CombatArenaScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<CombatArenaScreen> createState() => _CombatArenaScreenState();
}

class _CombatArenaScreenState extends State<CombatArenaScreen> {
  bool _resolved = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.controller.session!;
    final enemyId = s.currentEnemy;
    final monster = s.monsters[enemyId];
    if (monster == null || !s.inCombat) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.maybePop(context));
      return const Scaffold(body: Center(child: Text('无战斗')));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _flee();
      },
      child: Scaffold(
        backgroundColor: GameConstants.bgDeep,
        body: Stack(
          children: [
            BonfireWidget(
              backgroundColor: GameConstants.bgDeep,
              lightingColorGame: Colors.black.withValues(alpha: 0.4),
              playerControllers: [
                Joystick(
                  directional: JoystickDirectional(
                    size: 100,
                    margin: const EdgeInsets.only(left: 28, bottom: 36),
                    color: GameConstants.hero.withValues(alpha: 0.55),
                  ),
                  actions: [
                    JoystickAction(
                      actionId: GameConstants.actionAttack,
                      size: 64,
                      margin: const EdgeInsets.only(bottom: 48, right: 40),
                      color: const Color(0xFFE67E22).withValues(alpha: 0.75),
                    ),
                  ],
                ),
              ],
              map: ArenaMap.build(),
              player: CombatHeroPlayer(
                position: ArenaMap.playerSpawn(),
                session: s,
                onDeath: () => _finish(defeat: true),
              ),
              components: [
                CombatEnemy(
                  monster: monster,
                  position: ArenaMap.enemySpawn(),
                  onDefeated: () => _finish(victory: true),
                ),
              ],
              interface: PlayerInterface(),
              overlayBuilderMap: {
                'hud': (context, game) => _CombatHud(
                      monster: monster,
                      session: s,
                      onFlee: _flee,
                    ),
              },
              initialActiveOverlays: const ['hud'],
              cameraConfig: CameraConfig(
                moveOnlyMapArea: true,
                zoom: kIsWeb ? 2.2 : 2.5,
                speed: 4,
              ),
              collisionConfig: BonfireCollisionConfig.dafault(),
            ),
          ],
        ),
      ),
    );
  }

  void _flee() {
    if (_resolved) return;
    final result = widget.controller.session!.doFlee();
    widget.controller.applyCombatResult(result);
    if (!widget.controller.session!.inCombat) {
      _resolved = true;
      Navigator.pop(context);
    }
  }

  void _finish({bool victory = false, bool defeat = false}) {
    if (_resolved) return;
    _resolved = true;
    final s = widget.controller.session!;
    if (victory) {
      widget.controller.applyCombatResult(
        s.resolveCombatVictory(remainingPlayerHp: s.playerHp),
      );
    } else if (defeat) {
      widget.controller.applyCombatResult(s.resolveCombatDefeat());
    }
    Navigator.pop(context);
  }
}

class CombatHeroPlayer extends HeroPlayer {
  CombatHeroPlayer({
    required super.position,
    required this.session,
    required this.onDeath,
  });

  final dynamic session;
  final VoidCallback onDeath;

  @override
  Future<void> onLoad() async {
    initialLife(session.playerHp.toDouble());
    speed = GameConstants.playerSpeed + (session.totalAtk / 10);
    return super.onLoad();
  }

  @override
  void removeLife(double life) {
    super.removeLife(life);
    session.playerHp = this.life.toInt().clamp(0, session.playerMaxHp);
    if (session.playerHp <= 0) onDeath();
  }
}

class CombatEnemy extends MistSlime {
  CombatEnemy({
    required MonsterState monster,
    required Vector2 position,
    required this.onDefeated,
  })  : _monster = monster,
        super(
          position: position,
          emoji: monster.emoji.isNotEmpty
              ? monster.emoji
              : GameConstants.defaultEnemyEmoji,
          customLife: monster.hp.toDouble(),
          customSpeed: (8 + monster.attack * 2.5).clamp(20, 90).toDouble(),
          size: monster.rank.name == 'boss'
              ? Vector2.all(GameConstants.combatSpriteSize * 1.35)
              : null,
        );

  final MonsterState _monster;
  final VoidCallback onDefeated;

  @override
  Future<void> onLoad() async {
    initialLife(_monster.hp.toDouble());
    return super.onLoad();
  }

  @override
  void onDie() {
    super.onDie();
    onDefeated();
  }
}

class _CombatHud extends StatelessWidget {
  const _CombatHud({
    required this.monster,
    required this.session,
    required this.onFlee,
  });

  final MonsterState monster;
  final dynamic session;
  final VoidCallback onFlee;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '⚔️ ${monster.label}',
                    style: const TextStyle(
                      color: GameConstants.accent,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'HP ${session.playerHp}/${session.playerMaxHp}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: onFlee,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE67E22),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('逃跑', style: TextStyle(fontSize: 13, height: 1.1)),
                      Text('flee', style: TextStyle(fontSize: 9, height: 1.1)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              '左摇杆移动 · Joystick  ·  右键攻击 Attack',
              style: TextStyle(fontSize: 10, color: Color(0xFF7F8FA6)),
            ),
          ],
        ),
      ),
    );
  }
}
