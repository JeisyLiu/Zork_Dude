import 'package:flutter/material.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

enum InventoryPanelMode {
  /// Full backpack browse.
  all,

  /// Only usable / equippable items.
  usable,

  /// Items that can be dropped.
  droppable,
}

/// Landscape inventory: list → item detail with use / drop.
class InventoryPanel extends StatefulWidget {
  const InventoryPanel({
    super.key,
    required this.controller,
    this.mode = InventoryPanelMode.all,
  });

  final GameController controller;
  final InventoryPanelMode mode;

  static Future<void> show({
    required BuildContext context,
    required GameController controller,
    GameUiSkin? skin,
    InventoryPanelMode mode = InventoryPanelMode.all,
  }) {
    final title = switch (mode) {
      InventoryPanelMode.all => '背包 · Inventory',
      InventoryPanelMode.usable => '使用道具 · Use',
      InventoryPanelMode.droppable => '丢弃道具 · Drop',
    };
    return LandscapeOverlay.show<void>(
      context: context,
      title: title,
      skin: skin,
      child: InventoryPanel(controller: controller, mode: mode),
    );
  }

  @override
  State<InventoryPanel> createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {
  String? _selectedId;

  GameController get _c => widget.controller;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onChanged);
  }

  @override
  void dispose() {
    _c.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    final s = _c.session;
    if (_selectedId != null &&
        (s == null || !s.inventory.containsKey(_selectedId))) {
      _selectedId = null;
    }
    setState(() {});
  }

  List<({String id, ItemDefinition item, int count, int index})> _entries() {
    final s = _c.session;
    if (s == null) return const [];
    final out = <({String id, ItemDefinition item, int count, int index})>[];
    var idx = 1;
    for (final e in s.inventory.entries) {
      final it = s.items[e.key];
      if (it == null) continue;
      final canUse = it.usable || it.type == ItemType.bag;
      final canDrop = e.key != s.equippedBag;
      final keep = switch (widget.mode) {
        InventoryPanelMode.all => true,
        InventoryPanelMode.usable => canUse,
        InventoryPanelMode.droppable => canDrop,
      };
      if (keep) {
        out.add((id: e.key, item: it, count: e.value, index: idx));
      }
      idx++;
    }
    return out;
  }

  Future<void> _useItem(String id, int index) async {
    await _c.executeCommand('use $index');
    if (!mounted) return;
    final still = _c.session?.inventory.containsKey(id) ?? false;
    if (widget.mode != InventoryPanelMode.all || !still) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _selectedId = null);
    }
  }

  Future<void> _dropItem(String id, int index) async {
    await _c.executeCommand('drop $index');
    if (!mounted) return;
    final still = _c.session?.inventory.containsKey(id) ?? false;
    if (widget.mode != InventoryPanelMode.all || !still) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _selectedId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final s = _c.session;
    final short = ExplorationLayoutConstants.isShort(MediaQuery.sizeOf(context));
    final btnH = ExplorationLayoutConstants.chipHeightFor(
      short: short,
    );

    if (s == null) {
      return GameOutlinedText('尚未加载', fontSize: 13, color: d.textMuted);
    }

    if (_selectedId != null) {
      final entries = _entries();
      final hit = entries.where((e) => e.id == _selectedId).toList();
      if (hit.isEmpty) {
        _selectedId = null;
      } else {
        return _detail(
          d: d,
          entry: hit.first,
          sessionEquippedBag: s.equippedBag,
          btnH: btnH,
        );
      }
    }

    return _list(d: d, session: s, btnH: btnH);
  }

  Widget _list({
    required GameUiSkinData d,
    required GameSession session,
    required double btnH,
  }) {
    final s = session;
    final entries = _entries();
    final totalItems = s.inventory.values.fold<int>(0, (a, b) => a + b);

    return Column(
      key: const Key('inventory-list'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameOutlinedText(
          '${s.equippedBagLabel()} · 重量 ${s.totalWeight()}/${s.bagCapacity()} · $totalItems 件 · 💰${s.gold}',
          fontSize: 12,
          color: d.textMuted,
          strokeWidth: 0,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GameOutlinedText(
              widget.mode == InventoryPanelMode.usable
                  ? '没有可使用的道具。'
                  : widget.mode == InventoryPanelMode.droppable
                      ? '没有可丢弃的道具。'
                      : '背包是空的。',
              fontSize: 13,
              color: d.textMuted,
              strokeWidth: 0,
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.55,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, i) {
                final e = entries[i];
                final bonus = <String>[];
                if (e.item.heal > 0) bonus.add('HP+${e.item.heal}');
                if (e.item.damageBonus > 0) bonus.add('攻+${e.item.damageBonus}');
                if (e.item.defenseBonus > 0) {
                  bonus.add('防+${e.item.defenseBonus}');
                }
                final sub = [
                  if (e.count > 1) 'x${e.count}',
                  e.item.type.jsonName,
                  ...bonus,
                ].join(' · ');
                return GameButton(
                  key: Key('inventory-item-${e.id}'),
                  label: '(${e.index}) ${e.item.name}',
                  subLabel: sub,
                  width: double.infinity,
                  height: btnH,
                  onPressed: () => setState(() => _selectedId = e.id),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _detail({
    required GameUiSkinData d,
    required ({String id, ItemDefinition item, int count, int index}) entry,
    required String? sessionEquippedBag,
    required double btnH,
  }) {
    final it = entry.item;
    final canUse = it.usable || it.type == ItemType.bag;
    final canDrop = entry.id != sessionEquippedBag;
    final stats = <String>[
      '类型 ${it.type.jsonName}',
      '重量 ${it.weight}',
      if (it.value > 0) '价值 ${it.value}',
      if (it.heal > 0) '治疗 +${it.heal}',
      if (it.damageBonus > 0) '攻击 +${it.damageBonus}',
      if (it.defenseBonus > 0) '防御 +${it.defenseBonus}',
      if (it.type == ItemType.bag && it.capacity > 0) '容量 ${it.capacity}',
      if (entry.count > 1) '数量 x${entry.count}',
    ];

    return Column(
      key: Key('inventory-detail-${entry.id}'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameOutlinedText(
          it.label,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: d.textPrimary,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 6),
        GameOutlinedText(
          it.desc.isNotEmpty ? it.desc : '没有更多描述。',
          fontSize: 13,
          color: d.textPrimary,
          strokeWidth: 0,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        GameOutlinedText(
          stats.join(' · '),
          fontSize: 11,
          color: d.textMuted,
          strokeWidth: 0,
          textAlign: TextAlign.left,
        ),
        if (it.useMsg.isNotEmpty) ...[
          const SizedBox(height: 6),
          GameOutlinedText(
            '使用效果：${it.useMsg}',
            fontSize: 12,
            color: d.textMuted,
            strokeWidth: 0,
            textAlign: TextAlign.left,
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (canUse)
              GameButton(
                key: const Key('inventory-action-use'),
                label: it.type == ItemType.bag ? '装备' : '使用',
                subLabel: 'use',
                accent: true,
                width: 100,
                height: btnH,
                onPressed: () => _useItem(entry.id, entry.index),
              ),
            if (canDrop)
              GameButton(
                key: const Key('inventory-action-drop'),
                label: '丢弃',
                subLabel: 'drop',
                width: 100,
                height: btnH,
                onPressed: () => _dropItem(entry.id, entry.index),
              ),
            GameButton(
              key: const Key('inventory-action-back'),
              label: '返回',
              subLabel: 'back',
              width: 100,
              height: btnH,
              onPressed: () => setState(() => _selectedId = null),
            ),
          ],
        ),
      ],
    );
  }
}
