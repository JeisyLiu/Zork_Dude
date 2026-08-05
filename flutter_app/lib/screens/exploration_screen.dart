import 'package:flutter/material.dart';
import 'package:zork_dude/screens/combat_arena_screen.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_banner.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
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
      backgroundColor: Colors.transparent,
      builder: (ctx) => GameSkinScope(
        skin: GameUiTheme.skinForMapLayer(widget.controller.mapLayer),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GamePanel(
              dark: true,
              withBorder: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GameOutlinedText(
                      title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GameUiTheme.of(ctx).textPrimary,
                      strokeWidth: 2.8,
                    ),
                  ),
                  ...options.map((o) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GameButton(
                          width: double.infinity,
                          label: o.label,
                          onPressed: () {
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
                        ),
                      )),
                ],
              ),
            ),
          ),
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
    final skin = GameUiTheme.skinForMapLayer(c.mapLayer);

    return GameSkinScope(
      skin: skin,
      child: Scaffold(
        backgroundColor: GameConstants.bgDeep,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const GameBanner(title: '迷雾之塔', subtitle: 'Exploration', height: 48),
                const SizedBox(height: 6),
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
        ),
      ),
    );
  }
}
