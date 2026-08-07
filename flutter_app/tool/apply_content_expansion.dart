// Applies P0-P3 room graph expansion. Run: dart run tool/apply_content_expansion.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final script = File(Platform.script.toFilePath());
  final appRoot = script.parent.parent;
  final path = '${appRoot.path}/assets/data/rooms.json';
  final list = (jsonDecode(File(path).readAsStringSync()) as List)
      .cast<Map<String, dynamic>>();
  final byId = {for (final r in list) r['id'] as String: r};

  void setExits(String id, Map<String, String> exits) {
    byId[id]!['exits'] = exits;
  }

  void addExit(String id, String dir, String target) {
    final ex = Map<String, dynamic>.from(byId[id]!['exits'] as Map? ?? {});
    ex[dir] = target;
    byId[id]!['exits'] = ex;
  }

  void removeExit(String id, String dir) {
    final ex = Map<String, dynamic>.from(byId[id]!['exits'] as Map? ?? {});
    ex.remove(dir);
    byId[id]!['exits'] = ex;
  }

  void setNpc(String id, String? npc) {
    if (npc == null) {
      byId[id]!.remove('npc_id');
    } else {
      byId[id]!['npc_id'] = npc;
    }
  }

  void setMonster(String id, String? mid) {
    if (mid == null) {
      byId[id]!.remove('monster_id');
    } else {
      byId[id]!['monster_id'] = mid;
    }
  }

  // P0 gates
  removeExit('ancient_ruins', 'north');
  removeExit('tower_base', 'up');
  (byId['ancient_ruins']!['desc'] as String).replaceAll('东墙有石门', '北墙石门紧锁');
  byId['ancient_ruins']!['desc'] =
      '石室，墙上刻满浮雕。中央石台有天鹅绒垫。\n北墙石门紧锁，需要生锈钥匙。';
  byId['tower_base']!['desc'] =
      '古老石塔，爬满藤蔓。塔门紧闭，锁孔形状与银钥匙吻合。';

  // P0 monsters
  byId['goblin_cave']!['monster_ids'] = ['goblin', 'goblin_shaman'];
  byId['goblin_cave']!.remove('monster_id');
  setMonster('hidden_grove', 'treant');
  byId['haunted_graveyard']!['monster_ids'] = ['ghost', 'wraith'];
  byId['haunted_graveyard']!.remove('monster_id');
  setMonster('frozen_cave', 'basilisk');
  setMonster('forest_tower_ruins', 'forest_troll');

  // P0 NPC placement
  setNpc('crossroads', 'wandering_merchant');
  setNpc('dark_forest', 'old_hermit');
  setNpc('lake_village_temple', 'village_elder');
  setNpc('lake_shore', null);

  // P1 tower rewire
  setExits('tower_middle', {
    'down': 'tower_foyer',
    'up': 'tower_observatory',
    'east': 'tower_chapel',
  });
  setExits('tower_top', {'down': 'tower_ritual'});

  // P2 cave rewire
  setExits('goblin_cave', {'south': 'cave_middle', 'north': 'goblin_warren'});
  setExits('goblin_throne', {'south': 'goblin_warren'});
  byId['goblin_throne']!['map'] = {'layer': 'cave', 'x': 1, 'y': -1};
  setExits('cave_middle', {
    'up': 'cave_entrance',
    'down': 'spider_nest',
    'east': 'ancient_ruins',
    'north': 'goblin_cave',
    'south': 'underground_river',
  });
  setExits('cave_depths', {'up': 'spider_nest'});
  addExit('frozen_cave', 'east', 'crystal_gallery');
  addExit('underground_river', 'south', 'drowned_shrine');
  addExit('ancient_ruins', 'east', 'echoing_hall');
  setExits('alchemist_lab', {
    'east': 'hidden_grove',
    'north': 'mushroom_warren',
    'south': 'fungal_garden',
  });

  // P3 surface rewire
  setExits('forest_entrance', {
    'north': 'dark_forest',
    'west': 'abandoned_hut',
    'south': 'misty_path',
  });
  setExits('forest_tower_ruins', {
    'north': 'misty_path',
    'west': 'bandit_camp',
  });
  setExits('dark_forest', {
    'south': 'forest_entrance',
    'north': 'cave_entrance',
    'east': 'crossroads',
    'west': 'wolf_den',
  });
  byId['haunted_graveyard']!['map'] = {'layer': 'surface', 'x': 3, 'y': 1};
  setExits('haunted_graveyard', {'west': 'ruined_chapel'});
  addExit('crossroads', 'south', 'old_mill');
  setExits('bandit_camp', {'north': 'bandit_hideout', 'east': 'old_mill'});
  setExits('lake_shore', {
    'west': 'crossroads',
    'south': 'lake_village',
    'east': 'hunter_lodge',
  });
  setExits('lake_village', {
    'north': 'lake_shore',
    'south': 'lake_village_inn',
    'west': 'lake_village_smithy',
    'east': 'ferry_dock',
  });
  byId['lake_village_temple']!['map'] = {'layer': 'surface', 'x': 7, 'y': 4};
  setNpc('lake_village_temple', 'village_elder');
  setExits('lake_village_inn', {
    'north': 'lake_village',
    'east': 'lake_village_temple',
  });
  setExits('lake_village_temple', {'west': 'lake_village_inn'});
  byId['lake_island']!['map'] = {'layer': 'surface', 'x': 7, 'y': 3};
  setExits('lake_island', {'west': 'ferry_dock'});

  final newRooms = <Map<String, dynamic>>[
    _room(
      id: 'tower_foyer',
      name: '高塔门厅',
      emoji: '🏛️',
      layer: 'tower',
      x: 1,
      y: 2,
      desc: '银钥开启的塔门后，是一座高挑的石砌门厅。\n西厢军械库，东厢图书馆，螺旋楼梯继续向上。',
      exits: {
        'down': 'tower_base',
        'west': 'tower_armory',
        'east': 'tower_library',
        'up': 'tower_middle',
      },
    ),
    _room(
      id: 'tower_armory',
      name: '高塔军械库',
      emoji: '⚔️',
      layer: 'tower',
      x: 0,
      y: 2,
      desc: '铁架上挂满锈迹斑斑的兵器与盾牌。',
      exits: {'east': 'tower_foyer', 'down': 'tower_prison'},
      items: ['iron_sword', 'shield', 'chain_armor', 'lesser_potion'],
    ),
    _room(
      id: 'tower_library',
      name: '高塔图书馆',
      emoji: '📚',
      layer: 'tower',
      x: 2,
      y: 2,
      desc: '高耸的书架直通天花板。一位老学者在烛光下翻阅古籍。',
      exits: {'west': 'tower_foyer'},
      npcId: 'tower_librarian',
      items: ['magic_book', 'ancient_scroll'],
    ),
    _room(
      id: 'tower_chapel',
      name: '高塔礼拜堂',
      emoji: '⛪',
      layer: 'tower',
      x: 2,
      y: 1,
      desc: '狭长的礼拜堂，北侧有一扇沉重的石门通向仪式间。',
      exits: {'west': 'tower_middle', 'north': 'tower_ritual'},
      items: ['sacred_water', 'lesser_potion'],
    ),
    _room(
      id: 'tower_observatory',
      name: '高塔观星台',
      emoji: '🔭',
      layer: 'tower',
      x: 1,
      y: 1,
      desc: '圆形观星室，黄铜望远镜指向穹顶裂缝，窗外是无尽灰雾。',
      exits: {'down': 'tower_middle'},
      items: ['compass', 'moonlight_elixir'],
    ),
    _room(
      id: 'tower_prison',
      name: '高塔囚室',
      emoji: '⛓️',
      layer: 'tower',
      x: 0,
      y: 1,
      desc: '阴暗潮湿的囚室。一个身披破旧僧袍的老人盘坐在角落。',
      exits: {'up': 'tower_armory', 'west': 'tower_ritual'},
      npcId: 'cave_hermit',
      items: ['rope', 'bread'],
    ),
    _room(
      id: 'tower_ritual',
      name: '高塔仪式间',
      emoji: '🔮',
      layer: 'tower',
      x: 1,
      y: 0,
      desc: '地面刻满魔法阵，中央石像双眼亮起——通往塔顶的水晶门紧锁。',
      exits: {'south': 'tower_chapel', 'east': 'tower_prison'},
      monsterId: 'stone_golem',
    ),
    _room(
      id: 'goblin_warren',
      name: '哥布林窟',
      emoji: '👹',
      layer: 'cave',
      x: 1,
      y: 0,
      desc: '狭窄的甬道两侧挖满了哥布林窝棚，恶臭扑鼻。',
      exits: {'south': 'goblin_cave', 'north': 'goblin_throne'},
      dark: true,
      items: ['old_coin', 'goblin_ear'],
      monsterIds: ['goblin', 'goblin'],
    ),
    _room(
      id: 'spider_nest',
      name: '蜘蛛巢穴',
      emoji: '🕸️',
      layer: 'cave',
      x: 2,
      y: 2,
      desc: '洞壁与地面缠满黏湿蛛网，巨型蜘蛛在暗处窸窣移动。',
      exits: {'up': 'cave_middle', 'down': 'cave_depths'},
      dark: true,
      items: ['spider_silk', 'lesser_potion'],
      monsterId: 'giant_spider',
    ),
    _room(
      id: 'crystal_gallery',
      name: '水晶长廊',
      emoji: '💎',
      layer: 'cave',
      x: 4,
      y: 2,
      desc: '冰蓝色水晶从天花板垂下，光芒折射成万千色带。',
      exits: {'west': 'frozen_cave'},
      dark: true,
      items: ['ice_crystal', 'emerald', 'sapphire'],
    ),
    _room(
      id: 'drowned_shrine',
      name: '淹没神殿',
      emoji: '🌊',
      layer: 'cave',
      x: 3,
      y: 3,
      desc: '地下河水涌入古老神殿，水神雕像半没于水中。',
      exits: {'north': 'underground_river'},
      dark: true,
      items: ['sacred_water', 'golden_cup'],
      monsterId: 'giant_snake',
    ),
    _room(
      id: 'mushroom_warren',
      name: '蘑菇窟',
      emoji: '🍄',
      layer: 'cave',
      x: 0,
      y: 3,
      desc: '巨型蘑菇林立，荧光菌类照亮蜿蜒小径。',
      exits: {'south': 'alchemist_lab'},
      dark: true,
      items: ['mushroom', 'fairy_dust'],
    ),
    _room(
      id: 'fungal_garden',
      name: '真菌花园',
      emoji: '🌿',
      layer: 'cave',
      x: 0,
      y: 1,
      desc: '发光真菌与魔法草药共生，空气里满是花香。',
      exits: {'north': 'alchemist_lab'},
      items: ['magic_herb', 'mandrake_root'],
    ),
    _room(
      id: 'echoing_hall',
      name: '回音大厅',
      emoji: '🔊',
      layer: 'cave',
      x: 4,
      y: 1,
      desc: '巨大的空洞大厅，脚步声被放大成雷鸣般的回响。',
      exits: {'west': 'ancient_ruins', 'north': 'collapsed_tunnel'},
      dark: true,
      items: ['ancient_scroll', 'old_coin'],
      monsterId: 'ghost',
    ),
    _room(
      id: 'collapsed_tunnel',
      name: '坍塌隧道',
      emoji: '🪨',
      layer: 'cave',
      x: 4,
      y: 0,
      desc: '隧道被落石堵死，只剩窄缝可勉强通过。',
      exits: {'south': 'echoing_hall'},
      dark: true,
      items: ['gold_ingot', 'ancient_key'],
    ),
    _room(
      id: 'misty_path',
      name: '迷雾小径',
      emoji: '🌫️',
      layer: 'surface',
      x: 3,
      y: 4,
      desc: '浓雾在小径上流动，能见度不足十步。',
      exits: {'north': 'forest_entrance', 'south': 'forest_tower_ruins'},
      items: ['mushroom', 'old_coin'],
    ),
    _room(
      id: 'wolf_den',
      name: '狼穴',
      emoji: '🐺',
      layer: 'surface',
      x: 2,
      y: 2,
      desc: '岩石遮蔽的凹穴，几双幽绿的眼睛在黑暗中注视着你。',
      exits: {'east': 'dark_forest', 'south': 'ruined_chapel'},
      items: ['wolf_tooth', 'dried_meat'],
      monsterIds: ['wolf', 'wolf'],
    ),
    _room(
      id: 'old_mill',
      name: '旧磨坊',
      emoji: '🏚️',
      layer: 'surface',
      x: 4,
      y: 4,
      desc: '荒废的木制磨坊，水车轮半陷在干涸沟渠中。',
      exits: {'north': 'crossroads', 'west': 'bandit_camp'},
      items: ['bread', 'rope', 'old_coin'],
      monsterId: 'giant_rat',
    ),
    _room(
      id: 'ferry_dock',
      name: '渡船码头',
      emoji: '⛵',
      layer: 'surface',
      x: 6,
      y: 3,
      desc: '木制码头延伸入湖，渡船系在桩上轻轻摇晃。',
      exits: {'west': 'lake_village', 'east': 'lake_island'},
      items: ['fishing_rod', 'fish'],
    ),
    _room(
      id: 'hunter_lodge',
      name: '猎人小屋',
      emoji: '🏹',
      layer: 'surface',
      x: 6,
      y: 1,
      desc: '墙上挂满兽皮与弓箭，老人正在擦拭猎刀。',
      exits: {'west': 'lake_shore'},
      npcId: 'hunter',
      items: ['dried_meat'],
    ),
    _room(
      id: 'ruined_chapel',
      name: '废弃礼拜堂',
      emoji: '⛪',
      layer: 'surface',
      x: 2,
      y: 1,
      desc: '石头礼拜堂屋顶塌了大半，白衣女祭司在残破祭坛前祈祷。',
      exits: {'north': 'wolf_den', 'east': 'haunted_graveyard'},
      npcId: 'priestess',
      items: ['sacred_water', 'lesser_potion'],
    ),
  ];

  for (final r in newRooms) {
    if (byId.containsKey(r['id'])) {
      byId[r['id'] as String] = r;
    } else {
      list.add(r);
    }
  }

  File(path).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(list),
  );
  stdout.writeln('Expanded rooms: ${list.length} total');
}

Map<String, dynamic> _room({
  required String id,
  required String name,
  required String emoji,
  required String layer,
  required int x,
  required int y,
  required String desc,
  required Map<String, String> exits,
  List<String>? items,
  String? npcId,
  String? monsterId,
  List<String>? monsterIds,
  bool dark = false,
}) {
  final m = <String, dynamic>{
    'id': id,
    'name': name,
    'emoji': emoji,
    'map': {'layer': layer, 'x': x, 'y': y},
    'desc': desc,
    'exits': exits,
  };
  if (items != null) m['items'] = items;
  if (npcId != null) m['npc_id'] = npcId;
  if (monsterId != null) m['monster_id'] = monsterId;
  if (monsterIds != null) m['monster_ids'] = monsterIds;
  if (dark) m['dark'] = true;
  return m;
}
