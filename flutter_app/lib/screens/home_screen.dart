import 'package:flutter/material.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

/// Launch screen before entering the Zork exploration world.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = GameController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.init();
  }

  void _onControllerChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A12),
              Color(0xFF16213E),
              Color(0xFF0F1A14),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text('🌫', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text(
                  '迷雾之塔',
                  style: TextStyle(
                    color: GameConstants.accent,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Zork 探索 + Bonfire 战斗',
                  style: TextStyle(
                    color: GameConstants.accent.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  '你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GameConstants.accent.withValues(alpha: 0.75),
                    height: 1.6,
                    fontSize: 14,
                  ),
                ),
                const Spacer(flex: 2),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: GameConstants.hero,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _controller.loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ExplorationScreen(controller: _controller),
                              ),
                            );
                          },
                    child: Text(
                      _controller.loading ? '加载中…' : '进入迷雾',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '指令探索 · 迷雾地图 · 遇敌进入动作战斗',
                  style: TextStyle(
                    color: GameConstants.accent.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
