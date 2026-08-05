import 'package:flutter/material.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!inCombat) ...[
              DirectionPad(
                onMove: (dir) => controller.move(dir),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _ActionChip(
                    zh: '查看',
                    en: 'look',
                    onTap: () => controller.executeCommand('look'),
                  ),
                  _ActionChip(
                    zh: '背包',
                    en: 'inv',
                    onTap: () => controller.executeCommand('inventory'),
                  ),
                  if (!inCombat)
                    _ActionChip(zh: '拿起', en: 'take', onTap: _take),
                  if (!inCombat)
                    _ActionChip(zh: '丢弃', en: 'drop', onTap: _drop),
                  if (!inCombat)
                    _ActionChip(zh: '使用', en: 'use', onTap: _use),
                  _ActionChip(
                    zh: '对话',
                    en: 'talk',
                    onTap: () => controller.executeCommand('talk'),
                  ),
                  if (!inCombat)
                    _ActionChip(
                      zh: '商品',
                      en: 'trade',
                      onTap: () => controller.executeCommand('trade'),
                    ),
                  if (!inCombat)
                    _ActionChip(zh: '购买', en: 'buy', onTap: _buy),
                  if (!inCombat)
                    _ActionChip(zh: '出售', en: 'sell', onTap: _sell),
                  if (!inCombat)
                    _ActionChip(
                      zh: '治疗',
                      en: 'heal',
                      onTap: () => controller.executeCommand('heal'),
                    ),
                  if (inCombat)
                    _ActionChip(
                      zh: '攻击',
                      en: 'attack',
                      onTap: () => controller.executeCommand('attack'),
                    ),
                  if (inCombat)
                    _ActionChip(
                      zh: '逃跑',
                      en: 'flee',
                      onTap: () => controller.executeCommand('flee'),
                    ),
                  _ActionChip(
                    zh: '招募',
                    en: 'recruit',
                    onTap: () => controller.executeCommand('recruit'),
                  ),
                  _ActionChip(
                    zh: '队伍',
                    en: 'party',
                    onTap: () => controller.executeCommand('party'),
                  ),
                  _ActionChip(
                    zh: '得分',
                    en: 'score',
                    onTap: () => controller.executeCommand('score'),
                  ),
                  _ActionChip(
                    zh: '帮助',
                    en: 'help',
                    onTap: () => controller.executeCommand('help'),
                  ),
                  _ActionChip(
                    zh: '二周目',
                    en: 'ng+',
                    onTap: () => controller.executeCommand('ng+'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          inCombat
              ? '战斗中 · Combat: attack / flee'
              : '提示 · Tips: n s e w u d · look · take 1 · inv',
          style: const TextStyle(fontSize: 10, color: Color(0xFF7F8FA6)),
        ),
      ],
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

/// Cross-shaped D-pad for discrete room exits (mobile-friendly).
class DirectionPad extends StatelessWidget {
  const DirectionPad({super.key, required this.onMove});

  final void Function(Direction dir) onMove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _padBtn(Icons.keyboard_arrow_up, 'N', () => onMove(Direction.north)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _padBtn(Icons.keyboard_arrow_left, 'W', () => onMove(Direction.west)),
              const SizedBox(width: 36, height: 36),
              _padBtn(Icons.keyboard_arrow_right, 'E', () => onMove(Direction.east)),
            ],
          ),
          _padBtn(Icons.keyboard_arrow_down, 'S', () => onMove(Direction.south)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _smallPad('上', 'U', () => onMove(Direction.up)),
              const SizedBox(width: 6),
              _smallPad('下', 'D', () => onMove(Direction.down)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _padBtn(IconData icon, String en, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: GameConstants.hero, size: 20),
                Text(en, style: const TextStyle(fontSize: 9, color: Color(0xFF7F8FA6), height: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallPad(String zh, String en, VoidCallback onTap) {
    return Material(
      color: const Color(0xFF1A1A2E),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            '$zh $en',
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.zh,
    required this.en,
    required this.onTap,
  });

  final String zh;
  final String en;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF16162A),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3A3A5A)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(zh, style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.1)),
              Text(en, style: const TextStyle(fontSize: 9, color: Color(0xFF7F8FA6), height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}
