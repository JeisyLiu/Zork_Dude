import 'package:flutter/material.dart';
import 'package:zork_dude/screens/turn_combat_screen.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/combat/encounter_transition.dart';
import 'package:zork_dude/ui/components/game_banner.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/components/landscape_scaffold.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/navigation/game_exit.dart';
import 'package:zork_dude/ui/navigation/landscape_page_route.dart';
import 'package:zork_dude/widgets/command_input.dart';
import 'package:zork_dude/widgets/exploration_keyboard_scope.dart';
import 'package:zork_dude/widgets/mist_map_panel.dart';
import 'package:zork_dude/widgets/quick_commands.dart';
import 'package:zork_dude/widgets/status_bar.dart';
import 'package:zork_dude/ui/ending/ending_flow.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/widgets/story_log.dart';

class ExplorationScreen extends StatefulWidget {
  const ExplorationScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen> {
  final _commandFocus = FocusNode(debugLabel: 'command-input');
  bool _endingPresenting = false;
  bool _showingEncounter = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _commandFocus.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller.battleNavigationPending &&
        !_showingEncounter &&
        mounted) {
      _showingEncounter = true;
    }
    _presentEndingIfNeeded();
    _presentReturnToTitleIfNeeded();
    setState(() {});
  }

  Future<void> _presentReturnToTitleIfNeeded() async {
    if (!mounted) return;
    if (!widget.controller.consumePendingReturnToTitle()) return;
    await GameExit.returnToTitle(context, widget.controller);
  }

  String _encounterEnemyLabel() {
    final enc = widget.controller.activeEncounter;
    if (enc == null) return '';
    final living = enc.livingEnemies();
    if (living.isEmpty) return '';
    return living.map((e) => e.name).join(' · ');
  }

  void _finishEncounterIntro() {
    if (!mounted) return;
    widget.controller.battleNavigationPending = false;
    setState(() => _showingEncounter = false);
    Navigator.of(context).push(
      LandscapePageRoute.battle<void>(
        context,
        TurnCombatScreen(controller: widget.controller),
      ),
    );
  }

  Future<void> _presentEndingIfNeeded() async {
    if (_endingPresenting || !mounted) return;
    final kind = widget.controller.pendingEnding;
    if (kind == EndingKind.none) return;
    // Combat-triggered endings are shown on the combat screen.
    if (kind == EndingKind.dragonClear ||
        kind == EndingKind.siteClear ||
        kind == EndingKind.gameOver) {
      return;
    }
    _endingPresenting = true;
    await EndingFlow.presentIfNeeded(
      context: context,
      controller: widget.controller,
    );
    _endingPresenting = false;
    if (mounted) setState(() {});
  }

  void _showTargetPicker(String title, List<({String label, String value})> options) {
    final skin = GameUiTheme.skinForMapLayer(widget.controller.mapLayer);
    LandscapeOverlay.show<void>(
      context: context,
      title: title,
      skin: skin,
      child: Builder(
        builder: (context) {
          final btnW = ExplorationLayoutConstants.moreChipWidth;
          final btnH = ExplorationLayoutConstants.chipHeightForWidth(btnW);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final o in options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GameButton(
                    width: double.infinity,
                    height: btnH,
                    label: o.label,
                    onPressed: () {
                      Navigator.pop(context);
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
                ),
            ],
          );
        },
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

    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final usableH = LandscapeLayout.playUsableHeightOf(context);
    final sideBySide = ExplorationLayoutConstants.useSideBySide(size);
    final short = LandscapeLayout.isShortPlayContext(context);
    final phoneShort = LandscapeLayout.isPhoneShortPlayContext(context);
    final skin = GameUiTheme.skinForMapLayer(c.mapLayer);
    final bannerH = ExplorationLayoutConstants.bannerHeightFor(
      short: short,
      phoneShort: phoneShort,
    );
    final motionDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await GameExit.returnToTitle(context, c);
      },
      child: GameSkinScope(
      skin: skin,
      child: ExplorationKeyboardScope(
        controller: c,
        commandFocus: _commandFocus,
        child: LandscapeScaffold(
          backgroundColor: GameUiTheme.scaffoldBgForMapLayer(c.mapLayer),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  GameBanner(
                    title: '迷雾之塔',
                    height: bannerH,
                    titleSize: phoneShort ? 14 : (short ? 15 : 17),
                  ),
                  SizedBox(height: phoneShort ? 0 : (short ? 2 : 4)),
                  StatusBar(controller: c),
                  SizedBox(height: phoneShort ? 0 : (short ? 2 : 4)),
                  Expanded(
                    child: sideBySide
                        ? Row(
                            children: [
                              Expanded(flex: 3, child: StoryLogView(controller: c)),
                              if (c.mapVisible) ...[
                                const SizedBox(width: 6),
                                Expanded(
                                  flex: 2,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: ExplorationLayoutConstants
                                          .mapPanelMinWidth(
                                        phoneShort: phoneShort,
                                      ),
                                    ),
                                    child: MistMapPanel(controller: c),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : Column(
                            children: [
                              AnimatedSwitcher(
                                duration: motionDuration,
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                child: c.mapVisible
                                    ? SizedBox(
                                        key: const ValueKey('map-panel'),
                                        height: ExplorationLayoutConstants
                                            .stackedMapHeight(
                                          usableH,
                                          short: short,
                                        ),
                                        child: MistMapPanel(controller: c),
                                      )
                                    : const SizedBox.shrink(key: ValueKey('map-hidden')),
                              ),
                              if (c.mapVisible) const SizedBox(height: 4),
                              Expanded(child: StoryLogView(controller: c)),
                            ],
                          ),
                  ),
                  SizedBox(height: phoneShort ? 1 : (short ? 2 : 4)),
                  QuickCommandPanel(
                    controller: c,
                    onPickTargets: _showTargetPicker,
                    compact: short,
                    phoneShort: phoneShort,
                  ),
                  SizedBox(height: phoneShort ? 1 : (short ? 2 : 4)),
                  CommandInputRow(
                    controller: c,
                    focusNode: _commandFocus,
                  ),
                ],
              ),
              if (_showingEncounter)
                EncounterTransition(
                  enemyLabel: _encounterEnemyLabel(),
                  onCompleted: _finishEncounterIntro,
                ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
