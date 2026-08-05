import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// Exploration controls: D-pad + bilingual action chips.
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
    final d = GameUiTheme.of(context);

    return GamePanel(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!inCombat) ...[
                    DirectionPad(onMove: (dir) => controller.move(dir)),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: constraints.maxWidth < 360 ? Axis.vertical : Axis.horizontal,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _chips(inCombat),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          GameOutlinedText(
            inCombat
                ? '战斗中 · Combat: attack / flee'
                : '提示 · Tips: n s e w u d · look · take 1 · inv',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: d.textMuted,
            strokeWidth: 2.2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  List<Widget> _chips(bool inCombat) {
    return [
      GameButton(label: '查看', subLabel: 'look', height: 40, width: 72, onPressed: () => controller.executeCommand('look')),
      GameButton(label: '背包', subLabel: 'inv', height: 40, width: 72, onPressed: () => controller.executeCommand('inventory')),
      if (!inCombat) GameButton(label: '拿起', subLabel: 'take', height: 40, width: 72, onPressed: _take),
      if (!inCombat) GameButton(label: '丢弃', subLabel: 'drop', height: 40, width: 72, onPressed: _drop),
      if (!inCombat) GameButton(label: '使用', subLabel: 'use', height: 40, width: 72, onPressed: _use),
      GameButton(label: '对话', subLabel: 'talk', height: 40, width: 72, onPressed: () => controller.executeCommand('talk')),
      if (!inCombat) GameButton(label: '商品', subLabel: 'trade', height: 40, width: 72, onPressed: () => controller.executeCommand('trade')),
      if (!inCombat) GameButton(label: '购买', subLabel: 'buy', height: 40, width: 72, onPressed: _buy),
      if (!inCombat) GameButton(label: '出售', subLabel: 'sell', height: 40, width: 72, onPressed: _sell),
      if (!inCombat) GameButton(label: '治疗', subLabel: 'heal', height: 40, width: 72, onPressed: () => controller.executeCommand('heal')),
      if (inCombat) GameButton(label: '攻击', subLabel: 'attack', height: 40, width: 72, onPressed: () => controller.executeCommand('attack')),
      if (inCombat) GameButton(label: '逃跑', subLabel: 'flee', height: 40, width: 72, accent: true, onPressed: () => controller.executeCommand('flee')),
      GameButton(label: '招募', subLabel: 'recruit', height: 40, width: 72, onPressed: () => controller.executeCommand('recruit')),
      GameButton(label: '队伍', subLabel: 'party', height: 40, width: 72, onPressed: () => controller.executeCommand('party')),
      GameButton(label: '得分', subLabel: 'score', height: 40, width: 72, onPressed: () => controller.executeCommand('score')),
      GameButton(label: '帮助', subLabel: 'help', height: 40, width: 72, onPressed: () => controller.executeCommand('help')),
      GameButton(label: '二周目', subLabel: 'ng+', height: 40, width: 72, onPressed: () => controller.executeCommand('ng+')),
    ];
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

/// Cross-shaped D-pad using minimap ring + compass sprites.
class DirectionPad extends StatelessWidget {
  const DirectionPad({super.key, required this.onMove});

  final void Function(Direction dir) onMove;

  static const double _size = 112;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    return SizedBox(
      width: _size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _size,
            height: _size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  d.minimapRing,
                  width: _size,
                  height: _size,
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
                size: 36,
                semanticLabel: '上 U',
                onPressed: () => onMove(Direction.up),
                child: const GameOutlinedText('U', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 2.4),
              ),
              const SizedBox(width: 6),
              GameIconButton(
                size: 36,
                semanticLabel: '下 D',
                onPressed: () => onMove(Direction.down),
                child: const GameOutlinedText('D', fontSize: 11, fontWeight: FontWeight.bold, strokeWidth: 2.4),
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
