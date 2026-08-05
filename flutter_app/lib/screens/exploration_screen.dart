import 'package:flutter/material.dart';
import 'package:zork_dude/screens/combat_arena_screen.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/widgets/command_input.dart';
import 'package:zork_dude/widgets/mist_map_panel.dart';
import 'package:zork_dude/widgets/quick_commands.dart';
import 'package:zork_dude/widgets/status_bar.dart';
import 'package:zork_dude/widgets/story_log.dart';

class ExplorationScreen extends StatefulWidget {
  const ExplorationScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller.battleNavigationPending && mounted) {
      widget.controller.battleNavigationPending = false;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CombatArenaScreen(controller: widget.controller),
        ),
      );
    }
    setState(() {});
  }

  void _showTargetPicker(String title, List<({String label, String value})> options) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF12121E),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(title, style: const TextStyle(color: GameConstants.accent)),
            ),
            ...options.map((o) => ListTile(
                  title: Text(o.label, style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    Navigator.pop(ctx);
                    final lower = title.toLowerCase();
                    final cmd = lower.contains('drop') || title.contains('丢弃')
                        ? 'drop ${o.value}'
                        : lower.contains('use') || title.contains('使用')
                            ? 'use ${o.value}'
                            : lower.contains('buy') || title.contains('购买')
                                ? 'buy ${o.value}'
                                : lower.contains('sell') || title.contains('出售')
                                    ? 'sell ${o.value}'
                                    : 'take ${o.value}';
                    widget.controller.executeCommand(cmd);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    if (c.loading) {
      return const Scaffold(
        backgroundColor: GameConstants.bgDeep,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (c.error != null) {
      return Scaffold(
        backgroundColor: GameConstants.bgDeep,
        body: Center(child: Text(c.error!, style: const TextStyle(color: Colors.red))),
      );
    }

    final wide = MediaQuery.sizeOf(context).width > 900;

    return Scaffold(
      backgroundColor: GameConstants.bgDeep,
      appBar: AppBar(
        backgroundColor: const Color(0xFF12121E),
        title: const Text('🌫 迷雾之塔', style: TextStyle(letterSpacing: 1)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            StatusBar(controller: c),
            const SizedBox(height: 6),
            Expanded(
              child: wide
                  ? Row(
                      children: [
                        Expanded(flex: 3, child: StoryLogView(controller: c)),
                        if (c.mapVisible) ...[
                          const SizedBox(width: 8),
                          Expanded(flex: 2, child: MistMapPanel(controller: c)),
                        ],
                      ],
                    )
                  : Column(
                      children: [
                        if (c.mapVisible) ...[
                          SizedBox(height: 180, child: MistMapPanel(controller: c)),
                          const SizedBox(height: 6),
                        ],
                        Expanded(child: StoryLogView(controller: c)),
                      ],
                    ),
            ),
            const SizedBox(height: 6),
            QuickCommandPanel(controller: c, onPickTargets: _showTargetPicker),
            const SizedBox(height: 6),
            CommandInputRow(controller: c),
          ],
        ),
      ),
    );
  }
}
