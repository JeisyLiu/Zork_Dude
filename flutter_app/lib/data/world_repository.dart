import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';

class WorldDefinition {
  final Map<String, ItemDefinition> items;
  final Map<String, MonsterState> monsters;
  final Map<String, NpcState> npcs;
  final Map<String, CompanionState> companions;
  final Map<String, RoomState> rooms;
  final Map<String, RoomMapMeta> mapMeta;
  final StatusEffectRegistry statusEffects;

  const WorldDefinition({
    required this.items,
    required this.monsters,
    required this.npcs,
    required this.companions,
    required this.rooms,
    required this.mapMeta,
    required this.statusEffects,
  });

  int get roomCount => rooms.length;
  int get itemCount => items.length;
  int get monsterCount => monsters.length;
  int get npcCount => npcs.length;
  int get companionCount => companions.length;
}

class WorldRepository {
  static const _files = [
    'items.json',
    'monsters.json',
    'npcs.json',
    'companions.json',
    'rooms.json',
  ];

  Future<WorldDefinition> loadFromAssets() async {
    final maps = <String, List<dynamic>>{};
    for (final file in _files) {
      final raw = await rootBundle.loadString('assets/data/$file');
      maps[file] = jsonDecode(raw) as List<dynamic>;
    }

    final items = <String, ItemDefinition>{};
    for (final d in maps['items.json']!) {
      final item = ItemDefinition.fromJson(d as Map<String, dynamic>);
      items[item.id] = item;
    }

    final monsters = <String, MonsterState>{};
    for (final d in maps['monsters.json']!) {
      final m = MonsterState.fromJson(d as Map<String, dynamic>);
      monsters[m.id] = m;
    }

    final npcs = <String, NpcState>{};
    for (final d in maps['npcs.json']!) {
      final n = NpcState.fromJson(d as Map<String, dynamic>);
      npcs[n.id] = n;
    }

    final companions = <String, CompanionState>{};
    for (final d in maps['companions.json']!) {
      final c = CompanionState.fromJson(d as Map<String, dynamic>);
      companions[c.id] = c;
    }

    const dirMap = {
      'north': Direction.north,
      'south': Direction.south,
      'east': Direction.east,
      'west': Direction.west,
      'up': Direction.up,
      'down': Direction.down,
    };

    final rooms = <String, RoomState>{};
    final mapMetaList = <({String id, String emoji, Map<String, dynamic>? map})>[];

    for (final d in maps['rooms.json']!) {
      final json = d as Map<String, dynamic>;
      final exitsRaw = json['exits'] as Map<String, dynamic>? ?? {};
      final exits = <Direction, String>{};
      for (final e in exitsRaw.entries) {
        final dir = dirMap[e.key];
        if (dir != null) exits[dir] = e.value.toString();
      }
      final emoji = json['emoji'] as String? ?? '';
      final mapJson = json['map'] as Map<String, dynamic>?;
      mapMetaList.add((id: json['id'] as String, emoji: emoji, map: mapJson));
      final room = RoomState(
        id: json['id'] as String,
        name: json['name'] as String,
        desc: json['desc'] as String? ?? '',
        emoji: emoji,
        exits: exits,
        dark: json['dark'] as bool? ?? false,
        items: (json['items'] as List?)?.map((e) => e.toString()).toList() ?? [],
        npcId: json['npc_id'] as String?,
        monsterId: json['monster_id'] as String?,
        monsterIds: (json['monster_ids'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        mapMeta: RoomMapMeta.fromJson(mapJson, emoji: emoji),
      );
      rooms[room.id] = room;
    }

    final mapMeta = buildMapMetaFromRooms(mapMetaList);
    final statusEffects = await StatusEffectRegistry.loadFromAssets();
    _validate(items, monsters, npcs, companions, rooms, statusEffects);
    return WorldDefinition(
      items: items,
      monsters: monsters,
      npcs: npcs,
      companions: companions,
      rooms: rooms,
      mapMeta: mapMeta,
      statusEffects: statusEffects,
    );
  }

  void _validate(
    Map<String, ItemDefinition> items,
    Map<String, MonsterState> monsters,
    Map<String, NpcState> npcs,
    Map<String, CompanionState> companions,
    Map<String, RoomState> rooms,
    StatusEffectRegistry statusEffects,
  ) {
    for (final room in rooms.values) {
      for (final target in room.exits.values) {
        if (!rooms.containsKey(target)) {
          throw StateError('Room ${room.id} exit to unknown $target');
        }
      }
      for (final iid in room.items) {
        if (!items.containsKey(iid)) {
          throw StateError('Room ${room.id} references unknown item $iid');
        }
      }
      if (room.monsterId != null && !monsters.containsKey(room.monsterId)) {
        throw StateError('Room ${room.id} references unknown monster ${room.monsterId}');
      }
      for (final mid in room.monsterIds) {
        if (!monsters.containsKey(mid)) {
          throw StateError('Room ${room.id} references unknown monster $mid in monster_ids');
        }
      }
      if (room.npcId != null && !npcs.containsKey(room.npcId)) {
        throw StateError('Room ${room.id} references unknown npc ${room.npcId}');
      }
    }
    for (final m in monsters.values) {
      for (final li in m.loot) {
        if (!items.containsKey(li)) {
          throw StateError('Monster ${m.id} loot references unknown $li');
        }
      }
    }
    for (final c in companions.values) {
      if (c.recruitItem != null && !items.containsKey(c.recruitItem)) {
        throw StateError('Companion ${c.id} recruit_item unknown ${c.recruitItem}');
      }
    }
    for (final item in items.values) {
      for (final effect in item.combatEffects) {
        if (effect.cleanse != null) continue;
        if (statusEffects.spec(effect.effectId) == null) {
          throw StateError('Item ${item.id} references unknown effect ${effect.effectId}');
        }
      }
    }
    for (final m in monsters.values) {
      for (final effect in [...m.onHitEffects, ...m.combatSkillEffects]) {
        if (statusEffects.spec(effect.effectId) == null) {
          throw StateError('Monster ${m.id} references unknown effect ${effect.effectId}');
        }
      }
    }
  }
}
