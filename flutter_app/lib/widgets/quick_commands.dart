import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/exploration/inventory_panel.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/navigation/game_exit.dart';

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
    final panelEnabled = !controller.commandBusy;

    final padV = ExplorationLayoutConstants.panelPadV(short: compact);
    final dockH = ExplorationLayoutConstants.dockMinHeight(
      short: compact,
      showTips: !compact,
    );

    return GamePanel(
      padding: EdgeInsets.fromLTRB(
        compact ? 8 : 12,
        padV / 2,
        compact ? 8 : 12,
        padV / 2,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: dockH - padV),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = ExplorationLayoutConstants.primaryColumns;
                final primary = _primaryActions(
                  context: context,
                  inCombat: inCombat,
                  hasItems: hasItems,
                  hasNpc: hasNpc,
                  hasInventory: hasInventory,
                  panelEnabled: panelEnabled,
                );

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!inCombat) ...[
                      Builder(
                        builder: (context) {
                          final prefW =
                              ExplorationLayoutConstants.preferredChipWidth(
                            short: compact,
                          );
                          final gridH =
                              ExplorationLayoutConstants.gridContentHeight(
                            prefW,
                          );
                          final dpadBase = compact
                              ? ExplorationLayoutConstants
                                  .directionPadWidthShort
                              : ExplorationLayoutConstants.directionPadWidth;
                          final dpadSize =
                              (gridH - (compact ? 30 : 40)).clamp(56.0, dpadBase);
                          return DirectionPad(
                            onMove: (dir) => controller.move(dir),
                            compact: compact,
                            enabled: panelEnabled,
                            size: dpadSize,
                          );
                        },
                      ),
                      SizedBox(width: compact ? 8 : 12),
                    ],
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, gridConstraints) {
                          final chipW = ExplorationLayoutConstants.chipWidthFor(
                            gridConstraints.maxWidth,
                            short: compact,
                          );
                          final chipH =
                              ExplorationLayoutConstants.chipHeightForWidth(
                            chipW,
                          );
                          return _ActionGrid(
                            columns: columns,
                            actions: primary,
                            chipWidth: chipW,
                            chipHeight: chipH,
                            onMore: panelEnabled
                                ? () => _showMoreSheet(context, inCombat)
                                : () {},
                            panelEnabled: panelEnabled,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            if (!compact) ...[
              const SizedBox(height: 6),
              GameOutlinedText(
                inCombat
                    ? '战斗中 · Combat: attack / flee'
                    : '提示 · Tips: ←↑↓→ / WASD · PgUp/PgDn · look · take 1',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: d.textMuted,
                strokeWidth: 0,
                textAlign: TextAlign.left,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<_QuickAction> _primaryActions({
    required BuildContext context,
    required bool inCombat,
    required bool hasItems,
    required bool hasNpc,
    required bool hasInventory,
    required bool panelEnabled,
  }) {
    if (inCombat) {
      return [
        _QuickAction(
          label: '攻击',
          subLabel: 'attack',
          accent: true,
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('attack'),
        ),
        _QuickAction(
          label: '逃跑',
          subLabel: 'flee',
          accent: true,
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('flee'),
        ),
        _QuickAction(
          label: '查看',
          subLabel: 'look',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('look'),
        ),
        _QuickAction(
          label: '背包',
          subLabel: 'inv',
          enabled: panelEnabled,
          onPressed: () => _openInventory(context, InventoryPanelMode.all),
        ),
        _QuickAction(
          label: '对话',
          subLabel: 'talk',
          highlighted: hasNpc,
          enabled: panelEnabled && hasNpc,
          onPressed: () => controller.executeCommand('talk'),
        ),
        _QuickAction(
          label: '治疗',
          subLabel: 'heal',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('heal'),
        ),
        _QuickAction(
          label: '招募',
          subLabel: 'recruit',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('recruit'),
        ),
        _QuickAction(
          label: '队伍',
          subLabel: 'party',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('party'),
        ),
        _QuickAction(
          label: '得分',
          subLabel: 'score',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('score'),
        ),
        _QuickAction(
          label: '帮助',
          subLabel: 'help',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('help'),
        ),
        _QuickAction(
          label: '二周目',
          subLabel: 'ng+',
          enabled: panelEnabled,
          onPressed: () => controller.executeCommand('ng+'),
        ),
        _QuickAction(
          label: '更多',
          subLabel: 'more',
          isMore: true,
          enabled: panelEnabled,
        ),
      ];
    }

    // 6×2: 查看/背包/拿起/使用/对话/治疗 + 丢弃/商品/购买/出售/招募/队伍
    return [
      _QuickAction(
        label: '查看',
        subLabel: 'look',
        enabled: panelEnabled,
        onPressed: () => controller.executeCommand('look'),
      ),
      _QuickAction(
        label: '背包',
        subLabel: 'inv',
        enabled: panelEnabled,
        onPressed: () => _openInventory(context, InventoryPanelMode.all),
      ),
      _QuickAction(
        label: '拿起',
        subLabel: 'take',
        highlighted: hasItems,
        enabled: panelEnabled && hasItems,
        onPressed: _take,
      ),
      _QuickAction(
        label: '使用',
        subLabel: 'use',
        highlighted: hasInventory,
        enabled: panelEnabled && hasInventory,
        onPressed: () => _openInventory(context, InventoryPanelMode.usable),
      ),
      _QuickAction(
        label: '对话',
        subLabel: 'talk',
        highlighted: hasNpc,
        enabled: panelEnabled && hasNpc,
        onPressed: () => controller.executeCommand('talk'),
      ),
      _QuickAction(
        label: '治疗',
        subLabel: 'heal',
        enabled: panelEnabled,
        onPressed: () => controller.executeCommand('heal'),
      ),
      _QuickAction(
        label: '丢弃',
        subLabel: 'drop',
        enabled: panelEnabled && hasInventory,
        onPressed: () => _openInventory(context, InventoryPanelMode.droppable),
      ),
      _QuickAction(
        label: '商品',
        subLabel: 'trade',
        enabled: panelEnabled,
        onPressed: () => controller.executeCommand('trade'),
      ),
      _QuickAction(
        label: '购买',
        subLabel: 'buy',
        enabled: panelEnabled,
        onPressed: _buy,
      ),
      _QuickAction(
        label: '出售',
        subLabel: 'sell',
        enabled: panelEnabled && hasInventory,
        onPressed: _sell,
      ),
      _QuickAction(
        label: '招募',
        subLabel: 'recruit',
        enabled: panelEnabled,
        onPressed: () => controller.executeCommand('recruit'),
      ),
      _QuickAction(
        label: '更多',
        subLabel: 'more',
        isMore: true,
        enabled: panelEnabled,
      ),
    ];
  }

  void _openInventory(BuildContext context, InventoryPanelMode mode) {
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);
    InventoryPanel.show(
      context: context,
      controller: controller,
      skin: skin,
      mode: mode,
    );
  }

  List<_QuickAction> _moreActions(BuildContext context, bool inCombat) {
    return [
      _QuickAction(label: '得分', subLabel: 'score', onPressed: () => controller.executeCommand('score')),
      _QuickAction(label: '帮助', subLabel: 'help', onPressed: () => controller.executeCommand('help')),
      if (!inCombat)
        _QuickAction(label: '二周目', subLabel: 'ng+', onPressed: () => controller.executeCommand('ng+')),
      if (!inCombat)
        _QuickAction(label: '队伍', subLabel: 'party', onPressed: () => controller.executeCommand('party')),
      _QuickAction(
        label: '回标题',
        subLabel: 'title',
        onPressed: () => GameExit.returnToTitle(context, controller),
      ),
      if (kDebugMode)
        _QuickAction(
          label: controller.developerMode ? '全图关' : '全图开',
          subLabel: 'dev',
          onPressed: () async {
            await controller.toggleDeveloperMode();
          },
        ),
    ];
  }

  void _showMoreSheet(BuildContext context, bool inCombat) {
    final actions = _moreActions(context, inCombat);
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);

    LandscapeOverlay.show<void>(
      context: context,
      title: '更多命令 · More',
      skin: skin,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final action in actions)
            GameButton(
              label: action.label,
              subLabel: action.subLabel,
              width: ExplorationLayoutConstants.moreChipWidth,
              height: ExplorationLayoutConstants.chipHeightForWidth(
                ExplorationLayoutConstants.moreChipWidth,
              ),
              accent: action.accent,
              onPressed: () {
                Navigator.pop(context);
                action.onPressed?.call();
              },
            ),
        ],
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
    this.enabled = true,
  });

  final String label;
  final String subLabel;
  final VoidCallback? onPressed;
  final bool accent;
  final bool highlighted;
  final bool isMore;
  final bool enabled;
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.columns,
    required this.actions,
    required this.onMore,
    required this.chipWidth,
    required this.chipHeight,
    this.panelEnabled = true,
  });

  final int columns;
  final List<_QuickAction> actions;
  final VoidCallback onMore;
  final double chipWidth;
  final double chipHeight;
  final bool panelEnabled;

  @override
  Widget build(BuildContext context) {
    final rows = <List<_QuickAction>>[];
    for (var i = 0; i < actions.length; i += columns) {
      final end = i + columns > actions.length ? actions.length : i + columns;
      rows.add(actions.sublist(i, end));
    }

    final spacing = ExplorationLayoutConstants.chipSpacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < columns; i++)
                SizedBox(
                  width: chipWidth,
                  height: chipHeight,
                  child: i < rows[r].length
                      ? _chipFor(rows[r][i])
                      : const SizedBox.shrink(),
                ),
            ],
          ),
          if (r < rows.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }

  Widget _chipFor(_QuickAction action) {
    final active = panelEnabled && action.enabled;
    if (action.isMore) {
      return GameButton(
        key: const Key('quick-command-more'),
        label: action.label,
        subLabel: action.subLabel,
        height: chipHeight,
        width: chipWidth,
        enabled: active,
        onPressed: active ? onMore : null,
        semanticLabel: '更多命令',
      );
    }

    return Opacity(
      opacity: action.highlighted ? 1 : 0.82,
      child: GameButton(
        label: action.label,
        subLabel: action.subLabel,
        height: chipHeight,
        width: chipWidth,
        accent: action.accent || action.highlighted,
        enabled: active,
        onPressed: active ? action.onPressed : null,
      ),
    );
  }
}

/// Cross-shaped D-pad using minimap ring + compass sprites.
class DirectionPad extends StatelessWidget {
  const DirectionPad({
    super.key,
    required this.onMove,
    this.compact = false,
    this.enabled = true,
    this.size,
  });

  final void Function(Direction dir) onMove;
  final bool compact;
  final bool enabled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final ring = size ??
        (compact
            ? ExplorationLayoutConstants.directionPadWidthShort
            : ExplorationLayoutConstants.directionPadWidth);
    final upDown = compact ? 26.0 : 36.0;
    return SizedBox(
      width: ring,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ring,
            height: ring,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  d.minimapRing,
                  width: ring,
                  height: ring,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
                Positioned(
                  top: 4,
                  child: _compassBtn(
                    GameUiAssets.compassN,
                    '北 N',
                    enabled ? () => onMove(Direction.north) : null,
                  ),
                ),
                Positioned(
                  left: 4,
                  child: _compassBtn(
                    GameUiAssets.compassW,
                    '西 W',
                    enabled ? () => onMove(Direction.west) : null,
                  ),
                ),
                Positioned(
                  right: 4,
                  child: _compassBtn(
                    GameUiAssets.compassE,
                    '东 E',
                    enabled ? () => onMove(Direction.east) : null,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  child: _compassBtn(
                    GameUiAssets.compassS,
                    '南 S',
                    enabled ? () => onMove(Direction.south) : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameIconButton(
                size: upDown,
                semanticLabel: '上 U',
                enabled: enabled,
                onPressed: enabled ? () => onMove(Direction.up) : null,
                child: const GameOutlinedText('U', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 0),
              ),
              SizedBox(width: compact ? 4 : 6),
              GameIconButton(
                size: upDown,
                semanticLabel: '下 D',
                enabled: enabled,
                onPressed: enabled ? () => onMove(Direction.down) : null,
                child: const GameOutlinedText('D', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compassBtn(String asset, String label, VoidCallback? onTap) {
    return Semantics(
      button: true,
      label: label,
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Opacity(
            opacity: onTap != null ? 1 : 0.45,
            child: Image.asset(
              asset,
              width: 28,
              height: 28,
              filterQuality: FilterQuality.none,
            ),
          ),
        ),
      ),
    );
  }
}
