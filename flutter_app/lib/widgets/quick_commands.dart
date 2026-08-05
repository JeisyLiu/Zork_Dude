import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Exploration controls: fixed D-pad + grouped two-row action grid + more sheet.
class QuickCommandPanel extends StatelessWidget {
  const QuickCommandPanel({
    super.key,
    required this.controller,
    required this.onPickTargets,
    this.compact = false,
  });

  final GameController controller;
  final void Function(String title, List<({String label, String value})> options) onPickTargets;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = controller.session;
    final inCombat = s?.inCombat ?? false;
    final d = GameUiTheme.of(context);
    final room = s != null ? s.rooms[s.currentRoomId] : null;
    final hasItems = room?.items.isNotEmpty ?? false;
    final hasNpc = room?.npcId != null;
    final hasInventory = s != null && s.inventory.isNotEmpty;
    final npc = hasNpc && s != null ? s.npcs[room!.npcId] : null;
    final hasTrade = npc != null && npc.tradeItems.isNotEmpty;

    return GamePanel(
      padding: GamePanel.compactPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = ExplorationLayoutConstants.chipColumnsFor(constraints.maxWidth);
              final primary = _primaryActions(
                inCombat: inCombat,
                hasItems: hasItems,
                hasNpc: hasNpc,
                hasInventory: hasInventory,
                hasTrade: hasTrade,
              );

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!inCombat) ...[
                    DirectionPad(
                      onMove: (dir) => controller.move(dir),
                      compact: compact,
                    ),
                    SizedBox(width: compact ? 8 : 12),
                  ],
                  Expanded(
                    child: _ActionGrid(
                      columns: columns,
                      actions: primary,
                      onMore: () => _showMoreSheet(context, inCombat),
                      compact: compact,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          GameOutlinedText(
            inCombat
                ? '战斗中 · Combat: attack / flee'
                : '提示 · Tips: ←↑↓→ / WASD · PgUp/PgDn · look · take 1',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: d.textMuted,
            strokeWidth: 1.0,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  List<_QuickAction> _primaryActions({
    required bool inCombat,
    required bool hasItems,
    required bool hasNpc,
    required bool hasInventory,
    required bool hasTrade,
  }) {
    if (inCombat) {
      return [
        _QuickAction(
          label: '攻击',
          subLabel: 'attack',
          accent: true,
          onPressed: () => controller.executeCommand('attack'),
        ),
        _QuickAction(
          label: '逃跑',
          subLabel: 'flee',
          accent: true,
          onPressed: () => controller.executeCommand('flee'),
        ),
        _QuickAction(label: '查看', subLabel: 'look', onPressed: () => controller.executeCommand('look')),
        _QuickAction(label: '背包', subLabel: 'inv', onPressed: () => controller.executeCommand('inventory')),
        _QuickAction(label: '对话', subLabel: 'talk', highlighted: hasNpc, onPressed: () => controller.executeCommand('talk')),
        const _QuickAction(label: '更多', subLabel: 'more', isMore: true),
      ];
    }

    return [
      _QuickAction(label: '查看', subLabel: 'look', onPressed: () => controller.executeCommand('look')),
      _QuickAction(label: '背包', subLabel: 'inv', onPressed: () => controller.executeCommand('inventory')),
      _QuickAction(label: '拿起', subLabel: 'take', highlighted: hasItems, onPressed: _take),
      _QuickAction(label: '使用', subLabel: 'use', highlighted: hasInventory, onPressed: _use),
      _QuickAction(label: '对话', subLabel: 'talk', highlighted: hasNpc, onPressed: () => controller.executeCommand('talk')),
      _QuickAction(label: '治疗', subLabel: 'heal', onPressed: () => controller.executeCommand('heal')),
      const _QuickAction(label: '更多', subLabel: 'more', isMore: true),
    ];
  }

  List<_QuickAction> _moreActions(bool inCombat) {
    if (inCombat) {
      return [
        _QuickAction(label: '招募', subLabel: 'recruit', onPressed: () => controller.executeCommand('recruit')),
        _QuickAction(label: '队伍', subLabel: 'party', onPressed: () => controller.executeCommand('party')),
        _QuickAction(label: '得分', subLabel: 'score', onPressed: () => controller.executeCommand('score')),
        _QuickAction(label: '帮助', subLabel: 'help', onPressed: () => controller.executeCommand('help')),
        _QuickAction(label: '二周目', subLabel: 'ng+', onPressed: () => controller.executeCommand('ng+')),
      ];
    }

    return [
      _QuickAction(label: '丢弃', subLabel: 'drop', onPressed: _drop),
      _QuickAction(label: '商品', subLabel: 'trade', onPressed: () => controller.executeCommand('trade')),
      _QuickAction(label: '购买', subLabel: 'buy', onPressed: _buy),
      _QuickAction(label: '出售', subLabel: 'sell', onPressed: _sell),
      _QuickAction(label: '招募', subLabel: 'recruit', onPressed: () => controller.executeCommand('recruit')),
      _QuickAction(label: '队伍', subLabel: 'party', onPressed: () => controller.executeCommand('party')),
      _QuickAction(label: '得分', subLabel: 'score', onPressed: () => controller.executeCommand('score')),
      _QuickAction(label: '帮助', subLabel: 'help', onPressed: () => controller.executeCommand('help')),
      _QuickAction(label: '二周目', subLabel: 'ng+', onPressed: () => controller.executeCommand('ng+')),
    ];
  }

  void _showMoreSheet(BuildContext context, bool inCombat) {
    final actions = _moreActions(inCombat);
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GameSkinScope(
        skin: skin,
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
                      '更多命令 · More',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GameUiTheme.of(ctx).textPrimary,
                      strokeWidth: 1.4,
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final action in actions)
                        GameButton(
                          label: action.label,
                          subLabel: action.subLabel,
                          height: ExplorationLayoutConstants.chipHeight,
                          width: 88,
                          accent: action.accent,
                          onPressed: () {
                            Navigator.pop(ctx);
                            action.onPressed?.call();
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _take() {
    final s = controller.session!;
    final rm = s.rooms[s.currentRoomId]!;
    if (rm.items.isEmpty) {
      controller.executeCommand('take');
      return;
    }
    onPickTargets('拿起 take', [
      ...rm.items.asMap().entries.map((e) {
        final it = s.items[e.value];
        return (label: '(${e.key + 1}) ${it?.name ?? e.value}', value: '${e.key + 1}');
      }),
      (label: '全部 all', value: 'all'),
    ]);
  }

  void _drop() {
    final s = controller.session!;
    final keys = s.inventory.keys.toList();
    if (keys.isEmpty) {
      controller.executeCommand('drop');
      return;
    }
    onPickTargets('丢弃 drop', [
      for (var i = 0; i < keys.length; i++)
        (label: '(${i + 1}) ${s.items[keys[i]]?.name ?? keys[i]}', value: '${i + 1}'),
    ]);
  }

  void _use() {
    final s = controller.session!;
    final keys = s.inventory.keys.toList();
    if (keys.isEmpty) {
      controller.executeCommand('use');
      return;
    }
    onPickTargets('使用 use', [
      for (var i = 0; i < keys.length; i++)
        (label: '(${i + 1}) ${s.items[keys[i]]?.name ?? keys[i]}', value: '${i + 1}'),
    ]);
  }

  void _buy() {
    final s = controller.session!;
    final rm = s.rooms[s.currentRoomId]!;
    final npc = rm.npcId != null ? s.npcs[rm.npcId] : null;
    if (npc == null || npc.tradeItems.isEmpty) {
      controller.executeCommand('buy');
      return;
    }
    onPickTargets('购买 buy', [
      for (var i = 0; i < npc.tradeItems.length; i++)
        (
          label: '(${i + 1}) ${s.items[npc.tradeItems[i].$1]?.name} ${npc.tradeItems[i].$2}💰',
          value: '${i + 1}',
        ),
    ]);
  }

  void _sell() {
    final s = controller.session!;
    final keys = s.inventory.keys.toList();
    if (keys.isEmpty) {
      controller.executeCommand('sell');
      return;
    }
    onPickTargets('出售 sell', [
      for (var i = 0; i < keys.length; i++)
        (label: '(${i + 1}) ${s.items[keys[i]]?.name ?? keys[i]}', value: '${i + 1}'),
    ]);
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.subLabel,
    this.onPressed,
    this.accent = false,
    this.highlighted = false,
    this.isMore = false,
  });

  final String label;
  final String subLabel;
  final VoidCallback? onPressed;
  final bool accent;
  final bool highlighted;
  final bool isMore;
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.columns,
    required this.actions,
    required this.onMore,
    this.compact = false,
  });

  final int columns;
  final List<_QuickAction> actions;
  final VoidCallback onMore;
  final bool compact;

  double get _chipHeight =>
      compact ? 38 : ExplorationLayoutConstants.chipHeight;

  @override
  Widget build(BuildContext context) {
    final rows = <List<_QuickAction>>[];
    for (var i = 0; i < actions.length; i += columns) {
      final end = i + columns > actions.length ? actions.length : i + columns;
      rows.add(actions.sublist(i, end));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          Row(
            children: [
              for (var i = 0; i < columns; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < columns - 1 ? ExplorationLayoutConstants.chipSpacing : 0,
                    ),
                    child: i < rows[r].length
                        ? _chipFor(context, rows[r][i])
                        : SizedBox(height: _chipHeight),
                  ),
                ),
            ],
          ),
          if (r < rows.length - 1) const SizedBox(height: ExplorationLayoutConstants.chipSpacing),
        ],
      ],
    );
  }

  Widget _chipFor(BuildContext context, _QuickAction action) {
    if (action.isMore) {
      return GameButton(
        label: action.label,
        subLabel: action.subLabel,
        height: _chipHeight,
        width: double.infinity,
        onPressed: onMore,
        semanticLabel: '更多命令',
      );
    }

    return Opacity(
      opacity: action.highlighted ? 1 : 0.82,
      child: GameButton(
        label: action.label,
        subLabel: action.subLabel,
        height: _chipHeight,
        width: double.infinity,
        accent: action.accent || action.highlighted,
        onPressed: action.onPressed,
      ),
    );
  }
}

/// Cross-shaped D-pad using minimap ring + compass sprites.
class DirectionPad extends StatelessWidget {
  const DirectionPad({super.key, required this.onMove, this.compact = false});

  final void Function(Direction dir) onMove;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final size = compact ? 96.0 : ExplorationLayoutConstants.directionPadWidth;
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  d.minimapRing,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
                Positioned(top: 4, child: _compassBtn(GameUiAssets.compassN, '北 N', () => onMove(Direction.north))),
                Positioned(
                  left: 4,
                  child: _compassBtn(GameUiAssets.compassW, '西 W', () => onMove(Direction.west)),
                ),
                Positioned(
                  right: 4,
                  child: _compassBtn(GameUiAssets.compassE, '东 E', () => onMove(Direction.east)),
                ),
                Positioned(bottom: 4, child: _compassBtn(GameUiAssets.compassS, '南 S', () => onMove(Direction.south))),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameIconButton(
                size: compact ? 30 : 36,
                semanticLabel: '上 U',
                onPressed: () => onMove(Direction.up),
                child: const GameOutlinedText('U', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 1.2),
              ),
              const SizedBox(width: 6),
              GameIconButton(
                size: compact ? 30 : 36,
                semanticLabel: '下 D',
                onPressed: () => onMove(Direction.down),
                child: const GameOutlinedText('D', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 1.2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compassBtn(String asset, String label, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Image.asset(
            asset,
            width: 28,
            height: 28,
            filterQuality: FilterQuality.none,
          ),
        ),
      ),
    );
  }
}
