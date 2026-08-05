import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_banner.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/combat/combat_battlefield.dart';
import 'package:zork_dude/ui/combat/combat_command_menu.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/combat/combat_round_log.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
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
  String? _pendingItemId;
  final List<String> _log = [];
  final Set<String> _flashIds = {};
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
          _pendingItemId = items.first.id;
          _targetHighlight = 0;
        });
      case CombatCommandOption.defend:
        _commitCommand(const CombatCommand.defend());
      case CombatCommandOption.flee:
        _commitCommand(const CombatCommand.flee());
    }
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
      widget.controller.finishCombat(result.outcome!);
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() {
      _animating = false;
      _phase = CombatUiPhase.pickingCommand;
      _activeActorId = enc.nextAllyNeedingCommand()?.instanceId;
      _log.add('— 新回合 —');
    });
  }

  Future<void> _playStep(CombatActionStep step) async {
    setState(() {
      if (step.message.isNotEmpty) _log.add(step.message);
      if (step.targetInstanceId != null) {
        final kind = step.kind;
        if (kind == CombatActionKind.attack ||
            kind == CombatActionKind.skill) {
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
        backgroundColor: GameConstants.bgDeep,
        body: Center(
          child: GameOutlinedText('战斗已结束', fontSize: 16, color: Colors.white),
        ),
      );
    }

    final compact = MediaQuery.sizeOf(context).width < CombatLayoutConstants.narrowWidth;
    final tight = compact || MediaQuery.sizeOf(context).height < 640;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final targetId = _highlightedTargetId();
    final hasItems = widget.controller.combatUsableItems().isNotEmpty;
    final ready = enc.allAlliesCommanded && !_animating;

    final content = Padding(
      padding: EdgeInsets.all(tight ? 4 : 12),
      child: Column(
        children: [
          GameBanner(
            title: '回合战斗',
            subtitle: 'Turn Battle',
            height: tight ? 48 : 56,
          ),
          SizedBox(height: tight ? 4 : 8),
          if (_activeActor != null && _phase == CombatUiPhase.pickingCommand && !tight)
            GameOutlinedText(
              '选择指令：${_activeActor!.name}',
              fontSize: 11,
              color: GameUiTheme.of(context).textMuted,
              strokeWidth: 0.8,
            ),
          if (_activeActor != null && _phase == CombatUiPhase.pickingCommand && !tight)
            const SizedBox(height: 6),
          Expanded(
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _battleColumn(enc, compact, targetId),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: CombatRoundLog(messages: _log),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(child: _battleColumn(enc, compact || tight, targetId)),
                      SizedBox(height: tight ? 4 : 8),
                      SizedBox(
                        height: tight ? 72 : 130,
                        child: CombatRoundLog(messages: _log),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: tight ? 4 : 8),
          CombatCommandMenu(
            highlightIndex: CombatCommandMenu.options.indexWhere((o) => o.$1 == _cmdHighlight),
            enabled: _phase == CombatUiPhase.pickingCommand && !_animating,
            hasItems: hasItems,
            compact: compact || tight,
            onSelect: _selectCommand,
          ),
          SizedBox(height: tight ? 4 : 6),
          CombatExecuteBar(
            ready: ready,
            highlighted: _phase == CombatUiPhase.readyToExecute,
            onExecute: _executeRound,
          ),
          if (!compact && !tight)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GameOutlinedText(
                '方向键选择 · 空格确认 · Esc 返回',
                fontSize: 9,
                color: GameUiTheme.of(context).textMuted,
                strokeWidth: 0,
              ),
            ),
        ],
      ),
    );

    return GameSkinScope(
      skin: GameUiSkin.combat,
      child: Scaffold(
        backgroundColor: GameConstants.bgDeep,
        body: SafeArea(
          child: CombatKeyboardScope(
            enabled: !_animating && !_finished,
            onKey: _onCombatKey,
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _battleColumn(CombatEncounter enc, bool compact, String? targetId) {
    final pickingTarget =
        _phase == CombatUiPhase.pickingTarget || _phase == CombatUiPhase.pickingItem;
    final healTarget = _phase == CombatUiPhase.pickingItem ||
        (_phase == CombatUiPhase.pickingTarget && _activeActor?.role == CompanionRole.healer);

    return CombatBattlefield(
      allies: enc.allies,
      enemies: enc.enemies,
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
