import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/combat_effects.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/dice.dart';
import 'package:zork_dude/l10n/game_messages.dart';

typedef ItemUseHandler = String? Function(GameSessionRef session);

/// Minimal interface for special item handlers to avoid circular imports.
abstract class GameSessionRef {
  GameMessages get messages;
  String get currentRoomId;
  Map<String, int> get inventory;
  Map<String, dynamic> get flags;
  int get playerHp;
  set playerHp(int v);
  int get playerMaxHp;
  set playerMaxHp(int v);
  int get score;
  set score(int v);
  int get gold;
  set gold(int v);
  bool get inCombat;
  set inCombat(bool v);
  String get currentEnemy;
  set currentEnemy(String v);
  bool get won;
  set won(bool v);
  bool get siteWon;
  set siteWon(bool v);
  bool hasItem(String id);
  void invAdd(String id, [int count]);
  void invRemove(String id, [int count]);
  ItemDefinition? item(String id);
  RoomState room(String id);
  MonsterState? monster(String id);
  Map<String, RoomState> get rooms;
  Map<String, MonsterState> get monsters;
}

class ItemDefinition {
  final String id;
  final String name;
  final String desc;
  final ItemType type;
  bool usable;
  final bool takeable;
  final String useMsg;
  final int weight;
  final int value;
  final int heal;
  final int damageBonus;
  final int defenseBonus;
  final String emoji;
  final int capacity;
  final List<CombatEffectApplication> combatEffects;
  ItemUseHandler? onUse;

  ItemDefinition({
    required this.id,
    required this.name,
    required this.desc,
    this.type = ItemType.treasure,
    this.usable = false,
    this.takeable = true,
    this.useMsg = '',
    this.weight = 1,
    this.value = 0,
    this.heal = 0,
    this.damageBonus = 0,
    this.defenseBonus = 0,
    this.emoji = '',
    this.capacity = 0,
    this.combatEffects = const [],
    this.onUse,
  });

  bool get stackable => stackableTypes.contains(type);

  String get label => emoji.isNotEmpty ? '$emoji $name' : name;

  factory ItemDefinition.fromJson(Map<String, dynamic> json) {
    return ItemDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String? ?? '',
      type: ItemType.fromString(json['type'] as String? ?? 'TREASURE'),
      usable: json['usable'] as bool? ?? false,
      takeable: json['takeable'] as bool? ?? true,
      useMsg: json['use_msg'] as String? ?? '',
      weight: (json['weight'] as num?)?.toInt() ?? 1,
      value: (json['value'] as num?)?.toInt() ?? 0,
      heal: (json['heal'] as num?)?.toInt() ?? 0,
      damageBonus: (json['dmg_bonus'] as num?)?.toInt() ?? 0,
      defenseBonus: (json['def_bonus'] as num?)?.toInt() ?? 0,
      emoji: json['emoji'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      combatEffects: CombatEffectApplication.listFromJson(json['combat_effects']),
    );
  }

  bool get hasCombatUse => heal > 0 || combatEffects.isNotEmpty;
}

class MonsterState {
  final String id;
  final String name;
  final String desc;
  int maxHp;
  int hp;
  int attack;
  int defense;
  int speed;
  EnemyAiType aiType;
  MonsterRank rank;
  List<String> loot;
  int exp;
  int gold;
  bool hostile;
  Map<String, String> dialog;
  String emoji;
  bool alive;
  final List<CombatEffectApplication> onHitEffects;
  final List<CombatEffectApplication> combatSkillEffects;

  MonsterState({
    required this.id,
    required this.name,
    required this.desc,
    required this.maxHp,
    required this.hp,
    required this.attack,
    this.defense = 0,
    this.speed = 5,
    this.aiType = EnemyAiType.normal,
    this.rank = MonsterRank.normal,
    this.loot = const [],
    this.exp = 10,
    this.gold = 0,
    this.hostile = true,
    this.dialog = const {},
    this.emoji = '',
    this.alive = true,
    this.onHitEffects = const [],
    this.combatSkillEffects = const [],
  });

  String get label => emoji.isNotEmpty ? '$emoji $name' : name;

  int takeDamage(int dmg) {
    final actual = (dmg - defense).clamp(0, dmg);
    hp = (hp - actual).clamp(0, maxHp);
    if (hp <= 0) alive = false;
    return actual;
  }

  Map<String, int> attackDamage() {
    final base = (attack + _roll(4) - 3).clamp(1, 999);
    return {'dmg': base};
  }

  static int _roll(int sides, [int times = 1]) {
    // Deterministic placeholder; GameSession uses Dice.roll
    return sides;
  }

  factory MonsterState.fromJson(Map<String, dynamic> json) {
    final hp = (json['hp'] as num).toInt();
    return MonsterState(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String? ?? '',
      maxHp: hp,
      hp: hp,
      attack: (json['atk'] as num).toInt(),
      defense: (json['defense'] as num?)?.toInt() ?? 0,
      speed: (json['speed'] as num?)?.toInt() ?? _defaultSpeed(json),
      aiType: _parseAiType(json['ai'] as String?),
      rank: MonsterRank.fromString(json['rank'] as String? ?? 'NORMAL'),
      loot: (json['loot'] as List?)?.map((e) => e.toString()).toList() ?? [],
      exp: (json['exp'] as num?)?.toInt() ?? 10,
      gold: (json['gold'] as num?)?.toInt() ?? 0,
      hostile: json['hostile'] as bool? ?? true,
      dialog: _parseDialog(json['dialog']),
      emoji: json['emoji'] as String? ?? '',
      onHitEffects: CombatEffectApplication.listFromJson(json['on_hit_effects']),
      combatSkillEffects: CombatEffectApplication.listFromJson(
        (json['combat_skill'] as Map<String, dynamic>?)?['effects'],
      ),
    );
  }

  static Map<String, String> _parseDialog(dynamic raw) {
    if (raw == null) return {};
    if (raw is String) return {'taunt': raw};
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }

  static int _defaultSpeed(Map<String, dynamic> json) {
    final rank = MonsterRank.fromString(json['rank'] as String? ?? 'NORMAL');
    switch (rank) {
      case MonsterRank.boss:
        return 7;
      case MonsterRank.elite:
        return 6;
      case MonsterRank.normal:
        return 5;
    }
  }

  static EnemyAiType _parseAiType(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'low_hp':
      case 'lowhp':
        return EnemyAiType.lowHpTarget;
      case 'boss':
        return EnemyAiType.boss;
      default:
        return EnemyAiType.normal;
    }
  }

  MonsterState clone() => MonsterState(
        id: id,
        name: name,
        desc: desc,
        maxHp: maxHp,
        hp: hp,
        attack: attack,
        defense: defense,
        speed: speed,
        aiType: aiType,
        rank: rank,
        loot: List.from(loot),
        exp: exp,
        gold: gold,
        hostile: hostile,
        dialog: dialog,
        emoji: emoji,
        alive: alive,
        onHitEffects: List.from(onHitEffects),
        combatSkillEffects: List.from(combatSkillEffects),
      );
}

class NpcState {
  final String id;
  final String name;
  final String title;
  final String desc;
  final NpcType type;
  final Map<String, String> dialogs;
  final List<(String, int)> tradeItems;
  final List<ItemType> buysTypes;
  final String? questItem;
  final String? questReward;
  final int questScore;
  final String? giveItem;
  final String emoji;
  bool questDone;
  bool metBefore;

  NpcState({
    required this.id,
    required this.name,
    this.title = '',
    this.desc = '',
    this.type = NpcType.wanderer,
    this.dialogs = const {},
    this.tradeItems = const [],
    this.buysTypes = const [],
    this.questItem,
    this.questReward,
    this.questScore = 30,
    this.giveItem,
    this.emoji = '',
    this.questDone = false,
    this.metBefore = false,
  });

  factory NpcState.fromJson(Map<String, dynamic> json) {
    return NpcState(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      type: NpcType.fromString(json['type'] as String? ?? 'WANDERER'),
      dialogs: (json['dialogs'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
          ) ??
          {},
      tradeItems: (json['trade_items'] as List?)
              ?.map((e) => (e[0].toString(), (e[1] as num).toInt()))
              .toList() ??
          [],
      buysTypes: (json['buys_types'] as List?)
              ?.map((t) => ItemType.fromString(t.toString()))
              .toList() ??
          [],
      questItem: json['quest_item'] as String?,
      questReward: json['quest_reward'] as String?,
      questScore: (json['quest_score'] as num?)?.toInt() ?? 30,
      giveItem: json['give_item'] as String?,
      emoji: json['emoji'] as String? ?? '',
    );
  }
}

class CompanionState {
  final String id;
  final String name;
  final String desc;
  final CompanionRole role;
  final int maxHp;
  int hp;
  final int attack;
  final int defense;
  final int speed;
  final String abilityDesc;
  final String? recruitItem;
  final String recruitMsg;
  final String emoji;
  bool recruited;

  CompanionState({
    required this.id,
    required this.name,
    this.desc = '',
    this.role = CompanionRole.warrior,
    required this.maxHp,
    required this.hp,
    required this.attack,
    this.defense = 2,
    this.speed = 6,
    this.abilityDesc = '',
    this.recruitItem,
    this.recruitMsg = '',
    this.emoji = '',
    this.recruited = false,
  });

  Map<String, int> getBonus() {
    switch (role) {
      case CompanionRole.warrior:
        return {'dmg': 3, 'def': 2, 'hp': 10};
      case CompanionRole.rogue:
        return {'dmg': 2, 'def': 0, 'hp': 5};
      case CompanionRole.mage:
        return {'dmg': 5, 'def': -1, 'hp': 0};
      case CompanionRole.healer:
        return {'dmg': 0, 'def': 1, 'hp': 15};
      case CompanionRole.scout:
        return {'dmg': 1, 'def': 0, 'hp': 5};
    }
  }

  String recruitDisplay(GameMessages messages) =>
      recruitMsg.isNotEmpty ? recruitMsg : messages.companionRecruitDefault;

  String banter(GameMessages messages) {
    final prefix = emoji.isNotEmpty ? '$emoji ' : '';
    final line = messages.msg('companion_banter_${role.name}');
    return '[$prefix$name] $line';
  }

  String combatAssist(GameSessionRef g) {
    final m = g.messages;
    if (role == CompanionRole.mage) {
      return m.msg('companion_combat_mage', {'name': name});
    }
    if (role == CompanionRole.healer) {
      final h = rollDice(6, 2);
      g.playerHp = (g.playerHp + h).clamp(0, g.playerMaxHp);
      return m.msg('companion_combat_heal', {'name': name, 'amount': h});
    }
    if (role == CompanionRole.rogue) {
      return m.msg('companion_combat_rogue', {'name': name});
    }
    return m.msg('companion_combat_default', {'name': name});
  }

  factory CompanionState.fromJson(Map<String, dynamic> json) {
    final hp = (json['hp'] as num?)?.toInt() ?? 50;
    return CompanionState(
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String? ?? '',
      role: CompanionRole.fromString(json['role'] as String? ?? 'WARRIOR'),
      maxHp: hp,
      hp: hp,
      attack: (json['atk'] as num?)?.toInt() ?? 8,
      defense: (json['defense'] as num?)?.toInt() ?? 2,
      speed: (json['speed'] as num?)?.toInt() ?? 6,
      abilityDesc: json['ability_desc'] as String? ?? '',
      recruitItem: json['recruit_item'] as String?,
      recruitMsg: json['recruit_msg'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
    );
  }
}

typedef RoomEnterHandler = String? Function(GameSessionRef session);

class RoomState {
  final String id;
  final String name;
  final String desc;
  final String emoji;
  final Map<Direction, String> exits;
  final bool dark;
  List<String> items;
  String? npcId;
  final String? monsterId;
  final List<String> monsterIds;
  bool visited;
  RoomEnterHandler? onEnter;
  final RoomMapMeta mapMeta;

  RoomState({
    required this.id,
    required this.name,
    required this.desc,
    this.emoji = '',
    required this.exits,
    this.dark = false,
    List<String>? items,
    this.npcId,
    this.monsterId,
    List<String>? monsterIds,
    this.visited = false,
    this.onEnter,
    RoomMapMeta? mapMeta,
  })  : items = items ?? [],
        monsterIds = monsterIds ?? const [],
        mapMeta = mapMeta ?? const RoomMapMeta();

  /// Encounter monster template ids for this room (supports multi-enemy).
  List<String> resolveMonsterIds() {
    if (monsterIds.isNotEmpty) return List<String>.from(monsterIds);
    if (monsterId != null) return [monsterId!];
    return const [];
  }

  String description(GameSessionRef g, {NpcState? npc, MonsterState? monster}) {
    final m = g.messages;
    final lines = <String>[name, desc];
    if (items.isNotEmpty) {
      final labels = items.map((i) => g.item(i)?.label ?? i).join('、');
      lines.add('\n${m.roomItemsOnGround(labels)}');
    }
    if (npc != null) lines.add('\n👤 ${npc.name}');
    if (monster != null && monster.alive) {
      final tag = monster.rank != MonsterRank.normal
          ? '[${monster.rank.displayName(m)}]'
          : '';
      lines.add('\n⚠️ $tag ${monster.label}');
    }
    return lines.join('\n');
  }
}

abstract class GameSessionRefWithNpcs extends GameSessionRef {
  NpcState? npc(String id);
}