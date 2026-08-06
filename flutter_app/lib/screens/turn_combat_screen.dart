import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_banner.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/combat/combat_battlefield.dart';
import 'package:zork_dude/ui/combat/combat_command_menu.dart';
import 'package:zork_dude/ui/combat/combat_command_queue.dart';
import 'package:zork_dude/ui/combat/combat_item_picker.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/combat/combat_round_log.dart';
import 'package:zork_dude/ui/combat/combat_turn_order_bar.dart';
import 'package:zork_dude/ui/components/landscape_scaffold.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/ending/ending_flow.dart';
import 'package:zork_dude/widgets/combat_keyboard_scope.dart';

class TurnCombatScreen extends StatefulWidget {
  const TurnCombatScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<TurnCombatScreen> createState() => _TurnCombatScreenState();
}

class _TurnCombatScreenState extends State<TurnCombatScreen> {
  CombatUiPhase _phase = CombatUiPhase.pickingCommand;
  String? _activeActorId;
  CombatCommandOption _cmdHighlight = CombatCommandOption.attack;
  int _targetHighlight = 0;
  int _itemHighlight = 0;
  String? _pendingItemId;
  final List<String> _log = [];
  final List<CombatActionStep> _stepLog = [];
  final Set<String> _flashIds = {};
  String? _animatingActorId;
  bool _animating = false;
  bool _finished = false;

  CombatEncounter? get _encounter => widget.controller.activeEncounter;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
    _activeActorId = _encounter?.nextAllyNeedingCommand()?.instanceId;
    _log.add('⚔️ 回合制战斗开始！为每名队友选择指令。');
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    super.dispose();
  }

  void _onController() {
    if (mounted) setState(() {});
  }

  CombatActor? get _activeActor {
    final enc = _encounter;
    if (enc == null || _activeActorId == null) return null;
    return enc.actorById(_activeActorId!);
  }

  List<CombatActor> _targetPool({bool enemies = true}) {
    final enc = _encounter;
    if (enc == null) return const [];
    return enemies ? enc.livingEnemies() : enc.livingAllies();
  }

  void _selectCommand(CombatCommandOption option) {
    if (_animating || _finished) return;
    final actor = _activeActor;
    if (actor == null) return;

    setState(() => _cmdHighlight = option);

    switch (option) {
      case CombatCommandOption.attack:
      case CombatCommandOption.skill:
        setState(() {
          _phase = CombatUiPhase.pickingTarget;
          _targetHighlight = 0;
        });
      case CombatCommandOption.item:
        final items = widget.controller.combatUsableItems();
        if (items.isEmpty) return;
        setState(() {
          _phase = CombatUiPhase.pickingItem;
          _itemHighlight = 0;
          _pendingItemId = items.first.id;
          _targetHighlight = 0;
        });
      case CombatCommandOption.defend:
        _commitCommand(const CombatCommand.defend());
      case CombatCommandOption.melee:
        _startMelee();
      case CombatCommandOption.flee:
        _commitCommand(const CombatCommand.flee());
    }
  }

  void _startMelee() {
    final enc = _encounter;
    if (enc == null || !enc.canUseMelee) {
      _log.add('⚠️ 主角血量过低，无法混战（需高于 1/4 生命）。');
      setState(() {});
      return;
    }
    final ok = widget.controller.beginMelee();
    if (!ok) {
      _log.add('⚠️ 无法进入混战。');
      setState(() {});
      return;
    }
    _log.add('⚔️ 混战开始！双方自由交锋，主角血量低于 1/4 时自动停止。');
    setState(() {
      _phase = CombatUiPhase.readyToExecute;
      _activeActorId = null;
    });
    // Kick off immediately like Destiny of an Emperor melee.
    _executeRound();
  }

  void _commitCommand(CombatCommand command) {
    final actor = _activeActor;
    if (actor == null) return;
    widget.controller.submitCombatCommand(actor.instanceId, command);
    final enc = _encounter;
    final next = enc?.nextAllyNeedingCommand();
    setState(() {
      _phase = next == null ? CombatUiPhase.readyToExecute : CombatUiPhase.pickingCommand;
      _activeActorId = next?.instanceId;
      _cmdHighlight = CombatCommandOption.attack;
      _targetHighlight = 0;
      _itemHighlight = 0;
      _pendingItemId = null;
    });
  }

  void _confirmTarget(CombatActor target) {
    final actor = _activeActor;
    if (actor == null) return;

    if (_phase == CombatUiPhase.pickingItem && _pendingItemId != null) {
      widget.controller.consumeCombatItem(_pendingItemId!);
      _commitCommand(CombatCommand.item(_pendingItemId!, target.instanceId));
      return;
    }

    if (_cmdHighlight == CombatCommandOption.skill) {
      _commitCommand(CombatCommand.skill(target.instanceId));
      return;
    }
    _commitCommand(CombatCommand.attack(target.instanceId));
  }

  Future<void> _executeRound() async {
    if (_animating || _finished) return;
    final enc = _encounter;
    if (enc == null || !enc.allAlliesCommanded) return;

    setState(() {
      _animating = true;
      _phase = CombatUiPhase.animating;
      _animatingActorId = null;
    });

    final result = widget.controller.resolveCombatRound();
    if (result == null) {
      setState(() => _animating = false);
      return;
    }

    for (final step in result.steps) {
      await _playStep(step);
    }

    if (!mounted) return;

    if (result.combatEnded && result.outcome != null) {
      _finished = true;
      final encAfter = _encounter;
      encAfter?.meleeActive = false;
      widget.controller.finishCombat(result.outcome!);
      if (!mounted) return;
      await EndingFlow.presentIfNeeded(
        context: context,
        controller: widget.controller,
        afterDismiss: () {
          if (mounted) Navigator.pop(context);
        },
      );
      return;
    }

    final encNow = _encounter;
    if (encNow != null && encNow.meleeActive) {
      if (encNow.shouldStopMelee) {
        encNow.meleeActive = false;
        _log.add('💔 主角血量低于 1/4，混战中止。请手动下达指令。');
        setState(() {
          _animating = false;
          _phase = CombatUiPhase.pickingCommand;
          _activeActorId = encNow.nextAllyNeedingCommand()?.instanceId;
          _animatingActorId = null;
          _stepLog.clear();
        });
        return;
      }
      final continued = widget.controller.prepareNextMeleeRound();
      if (continued && mounted) {
        _log.add('— 混战继续 · 第 ${encNow.roundNumber} 回合 —');
        setState(() {
          _animating = false;
          _phase = CombatUiPhase.readyToExecute;
          _animatingActorId = null;
          _stepLog.clear();
        });
        await Future<void>.delayed(const Duration(milliseconds: 120));
        if (mounted && !_finished) await _executeRound();
        return;
      }
      encNow.meleeActive = false;
      _log.add('混战结束。');
    }

    setState(() {
      _animating = false;
      _phase = CombatUiPhase.pickingCommand;
      _activeActorId = enc.nextAllyNeedingCommand()?.instanceId;
      _animatingActorId = null;
      _log.add('— 第 ${enc.roundNumber} 回合 —');
      _stepLog.clear();
    });
  }

  Future<void> _playStep(CombatActionStep step) async {
    setState(() {
      _animatingActorId = step.actorInstanceId;
      if (step.message.isNotEmpty) {
        _log.add(step.message);
        _stepLog.add(step);
      }
      if (step.targetInstanceId != null) {
        final kind = step.kind;
        if (kind == CombatActionKind.attack ||
            kind == CombatActionKind.skill ||
            kind == CombatActionKind.statusTick) {
          _flashIds.add('${step.targetInstanceId}_dmg');
        } else if (kind == CombatActionKind.heal) {
          _flashIds.add('${step.targetInstanceId}_heal');
        }
      }
    });
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      _flashIds.clear();
    });
    await Future<void>.delayed(const Duration(milliseconds: 80));
  }

  bool _onCombatKey(LogicalKeyboardKey key) {
    if (_animating || _finished) return false;

    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.backspace) {
      final enc = _encounter;
      if (enc != null && enc.meleeActive && !_animating) {
        widget.controller.cancelMelee();
        _log.add('已取消混战。');
        setState(() {
          _phase = CombatUiPhase.pickingCommand;
          _activeActorId = enc.nextAllyNeedingCommand()?.instanceId;
        });
        return true;
      }
      if (_phase == CombatUiPhase.pickingTarget || _phase == CombatUiPhase.pickingItem) {
        setState(() => _phase = CombatUiPhase.pickingCommand);
        return true;
      }
      return false;
    }

    if (_phase == CombatUiPhase.readyToExecute) {
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
        _executeRound();
        return true;
      }
      return false;
    }

    if (_phase == CombatUiPhase.pickingItem) {
      final items = widget.controller.combatUsableItems();
      if (items.isEmpty) return false;

      if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
        setState(() {
          _itemHighlight = (_itemHighlight - 1).clamp(0, items.length - 1);
          _pendingItemId = items[_itemHighlight].id;
        });
        return true;
      }
      if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
        setState(() {
          _itemHighlight = (_itemHighlight + 1).clamp(0, items.length - 1);
          _pendingItemId = items[_itemHighlight].id;
        });
        return true;
      }
    }

    if (_phase == CombatUiPhase.pickingTarget || _phase == CombatUiPhase.pickingItem) {
      final pool = (_phase == CombatUiPhase.pickingItem ||
              _activeActor?.role == CompanionRole.healer)
          ? _targetPool(enemies: false)
          : _targetPool(enemies: true);
      if (pool.isEmpty) return false;

      if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
        setState(() => _targetHighlight = (_targetHighlight - 1).clamp(0, pool.length - 1));
        return true;
      }
      if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
        setState(() => _targetHighlight = (_targetHighlight + 1).clamp(0, pool.length - 1));
        return true;
      }
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
        _confirmTarget(pool[_targetHighlight]);
        return true;
      }
      return false;
    }

    if (_phase == CombatUiPhase.pickingCommand) {
      final options = CombatCommandMenu.options;
      if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
        setState(() {
          _cmdHighlight = options[
              (options.indexWhere((o) => o.$1 == _cmdHighlight) - 1 + options.length) %
                  options.length]
              .$1;
        });
        return true;
      }
      if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
        setState(() {
          _cmdHighlight = options[
              (options.indexWhere((o) => o.$1 == _cmdHighlight) + 1) % options.length]
              .$1;
        });
        return true;
      }
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
        _selectCommand(_cmdHighlight);
        return true;
      }
    }

    return false;
  }

  String? _highlightedTargetId() {
    if (_phase != CombatUiPhase.pickingTarget && _phase != CombatUiPhase.pickingItem) {
      return null;
    }
    final pool = (_phase == CombatUiPhase.pickingItem ||
            _activeActor?.role == CompanionRole.healer)
        ? _targetPool(enemies: false)
        : _targetPool(enemies: true);
    if (pool.isEmpty || _targetHighlight >= pool.length) return null;
    return pool[_targetHighlight].instanceId;
  }

  @override
  Widget build(BuildContext context) {
    final enc = _encounter;
    final session = widget.controller.session;
    if (enc == null || session == null || !session.inCombat) {
      return Scaffold(
        backgroundColor: GameUiTheme.scaffoldBgForMapLayer(
          widget.controller.mapLayer,
        ),
        body: Center(
          child: GameOutlinedText('战斗已结束', fontSize: 16, color: Colors.white),
        ),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final short = CombatLayoutConstants.isShort(size);
    final sideBySide = CombatLayoutConstants.useSideBySide(size);
    final layer = widget.controller.mapLayer;
    final skin = GameUiTheme.skinForMapLayer(layer);
    final bg = GameUiTheme.scaffoldBgForMapLayer(layer);
    final targetId = _highlightedTargetId();
    final items = widget.controller.combatUsableItems();
    final hasItems = items.isNotEmpty;
    final ready = enc.allAlliesCommanded && !_animating;
    final List<TurnOrderEntry> turnOrder =
        ready ? widget.controller.previewCombatTurnOrder() : const [];
    final registry = widget.controller.statusEffectRegistry;

    final meleeOn = enc.meleeActive;
    final phaseHint = switch (_phase) {
      CombatUiPhase.pickingCommand =>
        _activeActor != null ? '选择：${_activeActor!.name}' : '选择指令',
      CombatUiPhase.pickingTarget => '选择目标',
      CombatUiPhase.pickingItem => '选择道具',
      CombatUiPhase.readyToExecute => meleeOn ? '混战中' : '准备执行',
      CombatUiPhase.animating => meleeOn ? '混战交锋…' : '进行中…',
    };

    final content = Column(
      children: [
          // Merged banner + round/phase — one thin bar for 16:9 height budget.
          GameBanner(
            title: '回合战斗',
            subtitle: 'R${enc.roundNumber} · $phaseHint',
            height: short
                ? CombatLayoutConstants.bannerHeightShort
                : CombatLayoutConstants.bannerHeight,
          ),
          SizedBox(height: short ? 2 : 4),
          Expanded(
            child: sideBySide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _battleColumn(enc, short, targetId, registry),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            if (!short)
                              CombatCommandQueue(
                                encounter: enc,
                                activeActorId: _activeActorId,
                                compact: false,
                              ),
                            if (!short) const SizedBox(height: 4),
                            if (turnOrder.isNotEmpty) ...[
                              CombatTurnOrderBar(
                                entries: turnOrder,
                                highlightActorId: _animatingActorId,
                                compact: short,
                              ),
                              const SizedBox(height: 4),
                            ],
                            Expanded(
                              child: CombatRoundLog(
                                messages: _log,
                                steps: _stepLog,
                                compact: short,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _battleColumn(enc, short, targetId, registry),
                      ),
                      if (turnOrder.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        CombatTurnOrderBar(
                          entries: turnOrder,
                          highlightActorId: _animatingActorId,
                          compact: true,
                        ),
                      ],
                      const SizedBox(height: 2),
                      Expanded(
                        flex: 1,
                        child: CombatRoundLog(
                          messages: _log,
                          steps: _stepLog,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
          ),
          if (_phase == CombatUiPhase.pickingItem) ...[
            const SizedBox(height: 2),
            CombatItemPicker(
              items: items,
              selectedId: _pendingItemId,
              compact: true,
              onSelect: (id) {
                final idx = items.indexWhere((e) => e.id == id);
                setState(() {
                  _pendingItemId = id;
                  _itemHighlight = idx < 0 ? 0 : idx;
                });
              },
            ),
          ],
          SizedBox(height: short ? 2 : 4),
          SizedBox(
            height: CombatLayoutConstants.commandDockHeight(short: short),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final execPreferred = short
                    ? CombatLayoutConstants.executeButtonWidthShort
                    : CombatLayoutConstants.executeButtonWidth;
                final execW = CombatLayoutConstants.executeWidthFor(
                  availableWidth: (constraints.maxWidth * 0.22).clamp(
                    72.0,
                    execPreferred,
                  ),
                  short: short,
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CombatCommandMenu(
                        highlightIndex: CombatCommandMenu.options
                            .indexWhere((o) => o.$1 == _cmdHighlight),
                        enabled:
                            _phase == CombatUiPhase.pickingCommand && !_animating,
                        hasItems: hasItems,
                        meleeAvailable: enc.canUseMelee,
                        compact: short,
                        onSelect: _selectCommand,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Center(
                      child: CombatExecuteBar(
                        ready: ready,
                        highlighted: _phase == CombatUiPhase.readyToExecute,
                        onExecute: _executeRound,
                        compact: short,
                        width: execW,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
    );

    return GameSkinScope(
      skin: skin,
      combatBars: true,
      child: LandscapeScaffold(
        backgroundColor: bg,
        body: CombatKeyboardScope(
          enabled: !_animating && !_finished,
          onKey: _onCombatKey,
          child: content,
        ),
      ),
    );
  }

  Widget _battleColumn(
    CombatEncounter enc,
    bool compact,
    String? targetId,
    StatusEffectRegistry registry,
  ) {
    final pickingTarget =
        _phase == CombatUiPhase.pickingTarget || _phase == CombatUiPhase.pickingItem;
    final healTarget = _phase == CombatUiPhase.pickingItem ||
        (_phase == CombatUiPhase.pickingTarget && _activeActor?.role == CompanionRole.healer);

    return CombatBattlefield(
      allies: enc.allies,
      enemies: enc.enemies,
      statusRegistry: registry,
      pendingCommands: enc.pendingAllyCommands,
      selectedActorId: pickingTarget ? null : _activeActorId,
      highlightedTargetId: pickingTarget ? targetId : null,
      targetableSide: pickingTarget ? !healTarget : null,
      compact: compact,
      flashIds: _flashIds,
      onActorTap: pickingTarget
          ? (actor) {
              final pool = healTarget ? enc.livingAllies() : enc.livingEnemies();
              if (pool.any((a) => a.instanceId == actor.instanceId)) {
                _confirmTarget(actor);
              }
            }
          : null,
    );
  }
}
