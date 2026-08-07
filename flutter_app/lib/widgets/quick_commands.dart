import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/ui/exploration/inventory_panel.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/navigation/game_exit.dart';

/// Exploration controls: D-pad + vertical U/D + single-row action chips.
class QuickCommandPanel extends StatelessWidget {
  const QuickCommandPanel({
    super.key,
    required this.controller,
    required this.onPickTargets,
  });

  final GameController controller;
  final void Function(String title, List<({String label, String value})> options) onPickTargets;

  @override
  Widget build(BuildContext context) {
    final s = controller.session;
    final inCombat = s?.inCombat ?? false;
    final room = s != null ? s.rooms[s.currentRoomId] : null;
    final hasItems = room?.items.isNotEmpty ?? false;
    final hasNpc = room?.npcId != null;
    final hasInventory = s != null && s.inventory.isNotEmpty;
    final panelEnabled = !controller.commandBusy;

    final dockTarget = ExplorationLayoutConstants.dockMaxHeight(
      context,
      inCombat: inCombat,
    );
    final dockNatural = ExplorationLayoutConstants.dockMinHeight(
      context,
      inCombat: inCombat,
    );
    final padV = ExplorationLayoutConstants.panelPadV(context);
    final padH = ExplorationLayoutConstants.panelPadH(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowGap = LandscapeLayout.sp(context, 8);
        final chipSpacing =
            ExplorationLayoutConstants.chipSpacingFor(context);
        final dockDpad = LandscapeLayout.showCommandInput && !inCombat;
        final dpadBlock = dockDpad
            ? ExplorationLayoutConstants.directionPadBlockWidth(context) +
                rowGap
            : 0.0;
        final availableGridW =
            (constraints.maxWidth - padH * 2 - dpadBlock)
                .clamp(0.0, constraints.maxWidth);
        final chipW = ExplorationLayoutConstants.chipWidthFor(
          context,
          availableGridW,
        );
        final chipH = ExplorationLayoutConstants.chipHeightForWidth(chipW);
        // Keep compass/UD aligned to the single chip row height.
        final compassSize = math
            .min(
              ExplorationLayoutConstants.directionPadWidthFor(context),
              chipH,
            )
            .clamp(
              math.min(
                chipH,
                LandscapeLayout.sp(
                  context,
                  ExplorationLayoutConstants.dpadMinSize,
                ),
              ),
              chipH,
            )
            .toDouble();
        final udSize = math
            .min(
              ExplorationLayoutConstants.upDownButtonSizeFor(context),
              math.max(1.0, (chipH - 2) / 2),
            )
            .toDouble();
        final columns = ExplorationLayoutConstants.primaryColumns;
        final primary = _primaryActions(
          context: context,
          inCombat: inCombat,
          hasItems: hasItems,
          hasNpc: hasNpc,
          hasInventory: hasInventory,
          panelEnabled: panelEnabled,
        );

        final extraPad = math.max(0.0, dockTarget - dockNatural);
        final contentH = dockNatural + extraPad;
        final panel = GamePanel(
          padding: EdgeInsets.fromLTRB(
            padH,
            padV / 2 + extraPad,
            padH,
            padV / 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (dockDpad) ...[
                DirectionPad(
                  onMove: (dir) => controller.move(dir),
                  enabled: panelEnabled,
                  size: compassSize,
                ),
                SizedBox(width: rowGap),
                VerticalUpDownPad(
                  onMove: (dir) => controller.move(dir),
                  enabled: panelEnabled,
                  buttonSize: udSize,
                  height: chipH,
                ),
                SizedBox(width: rowGap),
              ],
              Expanded(
                child: _ActionGrid(
                  columns: columns,
                  actions: primary,
                  chipHeight: chipH,
                  chipSpacing: chipSpacing,
                  onMore: panelEnabled
                      ? () => _showMoreSheet(context, inCombat)
                      : () {},
                  panelEnabled: panelEnabled,
                ),
              ),
            ],
          ),
        );

        return SizedBox(
          height: dockTarget,
          width: constraints.maxWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: constraints.maxWidth,
              height: contentH,
              child: panel,
            ),
          ),
        );
      },
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

    // Single row: look/inv/take/use/talk/heal/drop/more
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

  List<_QuickAction> _moreActions(
    BuildContext context,
    bool inCombat, {
    required bool hasInventory,
  }) {
    return [
      if (!inCombat) ...[
        _QuickAction(
          label: '商品',
          subLabel: 'trade',
          onPressed: () => controller.executeCommand('trade'),
        ),
        _QuickAction(label: '购买', subLabel: 'buy', onPressed: _buy),
        _QuickAction(
          label: '出售',
          subLabel: 'sell',
          onPressed: _sell,
          enabled: hasInventory,
        ),
        _QuickAction(
          label: '招募',
          subLabel: 'recruit',
          onPressed: () => controller.executeCommand('recruit'),
        ),
      ],
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
    final s = controller.session;
    final hasInventory = s != null && s.inventory.isNotEmpty;
    final actions = _moreActions(
      context,
      inCombat,
      hasInventory: hasInventory,
    );
    final skin = GameUiTheme.skinForMapLayer(controller.mapLayer);
    final moreW = ExplorationLayoutConstants.moreChipWidthFor(context);
    final moreH = ExplorationLayoutConstants.chipHeightForWidth(moreW);

    LandscapeOverlay.show<void>(
      context: context,
      title: '更多命令 · More',
      skin: skin,
      child: Wrap(
        spacing: LandscapeLayout.sp(context, 6),
        runSpacing: LandscapeLayout.sp(context, 6),
        children: [
          for (final action in actions)
            GameButton(
              label: action.label,
              subLabel: action.subLabel,
              width: moreW,
              height: moreH,
              accent: action.accent,
              enabled: action.enabled,
              onPressed: action.enabled
                  ? () {
                      Navigator.pop(context);
                      action.onPressed?.call();
                    }
                  : null,
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
    required this.chipHeight,
    required this.chipSpacing,
    this.panelEnabled = true,
  });

  final int columns;
  final List<_QuickAction> actions;
  final VoidCallback onMore;
  final double chipHeight;
  final double chipSpacing;
  final bool panelEnabled;

  @override
  Widget build(BuildContext context) {
    final count = math.min(columns, actions.length);
    return SizedBox(
      height: chipHeight,
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) SizedBox(width: chipSpacing),
            Expanded(child: _chipFor(actions[i])),
          ],
        ],
      ),
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
        width: double.infinity,
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
        width: double.infinity,
        accent: action.accent || action.highlighted,
        enabled: active,
        onPressed: active ? action.onPressed : null,
      ),
    );
  }
}

/// Semi-transparent floating move controls for mobile exploration.
class FloatingMovePad extends StatelessWidget {
  const FloatingMovePad({
    super.key,
    required this.onMove,
    this.enabled = true,
  });

  final void Function(Direction dir) onMove;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final compass = ExplorationLayoutConstants.floatingCompassSizeFor(context);
    final ud = ExplorationLayoutConstants.floatingUpDownSizeFor(context);
    final gap = ExplorationLayoutConstants.floatingPadGapFor(context);
    final udColumnH = ud * 2;
    final rowH = math.max(compass, udColumnH);

    return Opacity(
      opacity: ExplorationLayoutConstants.floatingPadOpacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(LandscapeLayout.sp(context, 10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(LandscapeLayout.sp(context, 6)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DirectionPad(
                onMove: onMove,
                enabled: enabled,
                size: compass,
              ),
              SizedBox(width: gap),
              VerticalUpDownPad(
                onMove: onMove,
                enabled: enabled,
                buttonSize: ud,
                height: rowH,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compass-only D-pad (N/E/S/W). U/D live in [VerticalUpDownPad].
class DirectionPad extends StatelessWidget {
  const DirectionPad({
    super.key,
    required this.onMove,
    this.enabled = true,
    this.size,
  });

  final void Function(Direction dir) onMove;
  final bool enabled;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final ring = size ??
        ExplorationLayoutConstants.directionPadWidthFor(context);
    final compassSize = LandscapeLayout.sp(context, 28);
    final padInset = LandscapeLayout.sp(context, 4);
    return SizedBox(
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
            top: padInset,
            child: _compassBtn(
              GameUiAssets.compassN,
              '北 N',
              compassSize,
              enabled ? () => onMove(Direction.north) : null,
            ),
          ),
          Positioned(
            left: padInset,
            child: _compassBtn(
              GameUiAssets.compassW,
              '西 W',
              compassSize,
              enabled ? () => onMove(Direction.west) : null,
            ),
          ),
          Positioned(
            right: padInset,
            child: _compassBtn(
              GameUiAssets.compassE,
              '东 E',
              compassSize,
              enabled ? () => onMove(Direction.east) : null,
            ),
          ),
          Positioned(
            bottom: padInset,
            child: _compassBtn(
              GameUiAssets.compassS,
              '南 S',
              compassSize,
              enabled ? () => onMove(Direction.south) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compassBtn(
    String asset,
    String label,
    double size,
    VoidCallback? onTap,
  ) {
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
              width: size,
              height: size,
              filterQuality: FilterQuality.none,
            ),
          ),
        ),
      ),
    );
  }
}

/// Vertical U / D controls placed beside the compass in the dock row.
class VerticalUpDownPad extends StatelessWidget {
  const VerticalUpDownPad({
    super.key,
    required this.onMove,
    this.enabled = true,
    required this.buttonSize,
    required this.height,
  });

  final void Function(Direction dir) onMove;
  final bool enabled;
  final double buttonSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: math.min(buttonSize, math.max(1.0, height / 2)),
      height: height,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = math
                    .min(
                      buttonSize,
                      math.min(constraints.maxWidth, constraints.maxHeight),
                    )
                    .toDouble();
                return Center(
                  child: GameIconButton(
                    size: size,
                    semanticLabel: '上 U',
                    enabled: enabled,
                    onPressed: enabled ? () => onMove(Direction.up) : null,
                    child: GameOutlinedText(
                      'U',
                      fontSize: math.max(8.0, size * 0.35),
                      fontWeight: FontWeight.bold,
                      strokeWidth: 0,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = math
                    .min(
                      buttonSize,
                      math.min(constraints.maxWidth, constraints.maxHeight),
                    )
                    .toDouble();
                return Center(
                  child: GameIconButton(
                    size: size,
                    semanticLabel: '下 D',
                    enabled: enabled,
                    onPressed: enabled ? () => onMove(Direction.down) : null,
                    child: GameOutlinedText(
                      'D',
                      fontSize: math.max(8.0, size * 0.35),
                      fontWeight: FontWeight.bold,
                      strokeWidth: 0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

