enum Direction {
  north,
  south,
  east,
  west,
  up,
  down;

  String get value => name;

  static Direction? fromString(String s) {
    final t = s.toLowerCase().trim();
    for (final d in Direction.values) {
      if (d.value == t || d.value[0] == t) return d;
    }
    return null;
  }

  static const aliases = {
    'n': north,
    's': south,
    'e': east,
    'w': west,
    'u': up,
    'd': down,
  };
}

enum ItemType {
  key,
  weapon,
  armor,
  potion,
  treasure,
  tool,
  light,
  scroll,
  food,
  quest,
  material,
  book,
  ring,
  amulet,
  mineral,
  bag;

  static ItemType fromString(String s) =>
      ItemType.values.firstWhere((e) => e.name == s.toLowerCase());

  String get jsonName => name.toUpperCase();
}

enum NpcType {
  merchant,
  quest,
  wiseman,
  healer,
  beggar,
  guardian,
  wanderer,
  innkeeper,
  blacksmith,
  hunter,
  priestess;

  static NpcType fromString(String s) =>
      NpcType.values.firstWhere((e) => e.name == s.toLowerCase());
}

enum CompanionRole {
  warrior,
  rogue,
  mage,
  healer,
  scout;

  static CompanionRole fromString(String s) =>
      CompanionRole.values.firstWhere((e) => e.name == s.toLowerCase());
}

enum MonsterRank {
  normal,
  elite,
  boss;

  static MonsterRank fromString(String s) {
    switch (s.toUpperCase()) {
      case 'ELITE':
        return MonsterRank.elite;
      case 'BOSS':
        return MonsterRank.boss;
      default:
        return MonsterRank.normal;
    }
  }

  String get displayName {
    switch (this) {
      case MonsterRank.normal:
        return '普通';
      case MonsterRank.elite:
        return '精英';
      case MonsterRank.boss:
        return 'BOSS';
    }
  }
}

enum MapLayer { surface, cave, tower, site }

const int maxWeight = 15;
const equipWeightTypes = {ItemType.weapon, ItemType.armor};
const stackableTypes = {ItemType.food, ItemType.treasure, ItemType.material};
