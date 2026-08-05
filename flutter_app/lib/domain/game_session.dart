import 'dart:math';

import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_encounter_factory.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/dice.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/world/special_behavior_registry.dart';

const _helpText = '''╔══════════ 命令列表 ══════════╗

🚶 移动：n/s/e/w/u/d
👁️ 查看(look) 背包(inv) 帮助(help) 得分(score)
🗺️ 地图(map) 显示/隐藏迷雾残页
🎒 拿(take) 丢(drop) 用(use)
💬 对话(talk) 购买(buy) 出售(sell) 治疗(heal)
⚔️ 攻击(attack) 逃跑(flee)
🤝 招募(recruit) 队伍(party)
🔄 二周目(ng+/newgame+)：通关后保留装备重开

💡 主线/站点通关后仍可继续玩；提示只出现一次''';

class GameSession implements GameSessionRef, GameSessionRefWithNpcs {
  GameSession._();

  late Map<String, ItemDefinition> items;
  @override
  late Map<String, MonsterState> monsters;
  late Map<String, NpcState> npcs;
  late Map<String, CompanionState> companions;
  @override
  late Map<String, RoomState> rooms;
  late Map<String, RoomMapMeta> mapMeta;
  WorldDefinition? _worldDef;

  StatusEffectRegistry get statusEffects =>
      _worldDef?.statusEffects ?? StatusEffectRegistry.fromSpecs(const []);

  @override
  final Map<String, int> inventory = {};
  final List<String> companionList = [];
  @override
  final Map<String, dynamic> flags = {};
  final List<String> visitOrder = [];

  @override
  String currentRoomId = '';
  int turns = 0;
  @override
  int score = 0;
  @override
  int gold = 30;
  @override
  int playerHp = 60;
  @override
  int playerMaxHp = 60;
  int playerAtkBonus = 0;
  int playerDefBonus = 0;
  bool gameOver = false;
  @override
  bool won = false;
  @override
  bool siteWon = false;
  int ngCycle = 0;
  @override
  bool inCombat = false;
  @override
  String currentEnemy = '';
  CombatEncounter? activeEncounter;
  final CombatEngine combatEngine = CombatEngine();
  String equippedBag = 'bag_starter';

  static Future<GameSession> create(WorldRepository repo, {bool starterItems = true}) async {
    final def = await repo.loadFromAssets();
    return GameSession._fromDefinition(def, starterItems: starterItems);
  }

  factory GameSession._fromDefinition(WorldDefinition def, {bool starterItems = true}) {
    final s = GameSession._();
    s._worldDef = def;
    s.items = def.items.map((k, v) => MapEntry(k, _cloneItem(v)));
    s.monsters = def.monsters.map((k, v) => MapEntry(k, v.clone()));
    s.npcs = def.npcs.map((k, v) => MapEntry(k, NpcState(
          id: v.id,
          name: v.name,
          title: v.title,
          desc: v.desc,
          type: v.type,
          dialogs: Map.from(v.dialogs),
          tradeItems: List.from(v.tradeItems),
          buysTypes: List.from(v.buysTypes),
          questItem: v.questItem,
          questReward: v.questReward,
          questScore: v.questScore,
          giveItem: v.giveItem,
          emoji: v.emoji,
        )));
    s.companions = def.companions.map((k, v) => MapEntry(k, CompanionState(
          id: v.id,
          name: v.name,
          desc: v.desc,
          role: v.role,
          maxHp: v.maxHp,
          hp: v.hp,
          attack: v.attack,
          defense: v.defense,
          abilityDesc: v.abilityDesc,
          recruitItem: v.recruitItem,
          recruitMsg: v.recruitMsg,
          emoji: v.emoji,
        )));
    s.rooms = {};
    for (final r in def.rooms.values) {
      s.rooms[r.id] = RoomState(
        id: r.id,
        name: r.name,
        desc: r.desc,
        emoji: r.emoji,
        exits: Map.from(r.exits),
        dark: r.dark,
        items: List.from(r.items),
        npcId: r.npcId,
        monsterId: r.monsterId,
        monsterIds: List.from(r.monsterIds),
        mapMeta: r.mapMeta,
      );
    }
    s.mapMeta = Map.from(def.mapMeta);
    s.combatEngine.statusRegistry = def.statusEffects;
    s.combatEngine.monsters = s.monsters;
    s.combatEngine.items = s.items;
    SpecialBehaviorRegistry.apply(s);
    s.currentRoomId = 'forest_entrance';
    s.rooms['forest_entrance']!.visited = true;
    s.visitOrder.add('forest_entrance');
    if (starterItems) {
      s.invAdd('lesser_potion');
      s.invAdd('bread');
    }
    return s;
  }

  static ItemDefinition _cloneItem(ItemDefinition i) => ItemDefinition(
        id: i.id,
        name: i.name,
        desc: i.desc,
        type: i.type,
        usable: i.usable,
        takeable: i.takeable,
        useMsg: i.useMsg,
        weight: i.weight,
        value: i.value,
        heal: i.heal,
        damageBonus: i.damageBonus,
        defenseBonus: i.defenseBonus,
        emoji: i.emoji,
        capacity: i.capacity,
        combatEffects: List.from(i.combatEffects),
      );

  // --- Computed ---
  int get totalAtk {
    var b = playerAtkBonus;
    for (final iid in inventory.keys) {
      final it = items[iid];
      if (it != null) b += it.damageBonus;
    }
    for (final cid in companionList) {
      final c = companions[cid];
      if (c != null) b += c.getBonus()['dmg']!;
    }
    return b;
  }

  int get totalDef {
    var b = playerDefBonus;
    for (final iid in inventory.keys) {
      final it = items[iid];
      if (it != null) b += it.defenseBonus;
    }
    for (final cid in companionList) {
      final c = companions[cid];
      if (c != null) b += c.getBonus()['def']!;
    }
    return b;
  }

  int bagCapacity() {
    final bag = items[equippedBag];
    if (bag != null && bag.type == ItemType.bag && bag.capacity > 0) return bag.capacity;
    return maxWeight;
  }

  String equippedBagLabel() => items[equippedBag]?.label ?? '背包';

  bool hasLight() {
    if (currentRoomId == 'tower_top') return true;
    for (final iid in inventory.keys) {
      if (items[iid]?.type == ItemType.light) return true;
    }
    for (final cid in companionList) {
      if (companions[cid]?.role == CompanionRole.mage) return true;
    }
    return false;
  }

  @override
  bool hasItem(String id) => inventory.containsKey(id);

  @override
  void invAdd(String id, [int count = 1]) {
    final it = items[id];
    if (it != null && it.stackable) {
      inventory[id] = ((inventory[id] ?? 0) + count).clamp(0, 999);
    } else if (!inventory.containsKey(id)) {
      inventory[id] = count;
    }
  }

  @override
  void invRemove(String id, [int count = 1]) {
    final it = items[id];
    final cur = inventory[id] ?? 0;
    if (cur <= 0) return;
    if (it != null && it.stackable) {
      if (cur <= count) {
        inventory.remove(id);
      } else {
        inventory[id] = cur - count;
      }
    } else {
      inventory.remove(id);
    }
  }

  int _itemEncumbrance(ItemDefinition it, [int count = 1]) {
    if (!equipWeightTypes.contains(it.type)) return 0;
    return it.weight;
  }

  int totalWeight() {
    var total = 0;
    for (final e in inventory.entries) {
      if (e.key == equippedBag) continue;
      final it = items[e.key];
      if (it != null) total += _itemEncumbrance(it, e.value);
    }
    return total;
  }

  @override
  ItemDefinition? item(String id) => items[id];

  @override
  RoomState room(String id) => rooms[id]!;

  @override
  MonsterState? monster(String id) => monsters[id];

  @override
  NpcState? npc(String id) => npcs[id];

  String? resolveItemRef(String ref, Iterable<String> candidates) {
    final idx = int.tryParse(ref);
    final list = candidates.toList();
    if (idx != null && idx >= 1 && idx <= list.length) return list[idx - 1];
    final t = ref.toLowerCase().trim();
    for (final iid in list) {
      final it = items[iid];
      if (it != null &&
          (t == it.name.toLowerCase() || t == it.id.toLowerCase() || it.name.toLowerCase().contains(t))) {
        return iid;
      }
    }
    return null;
  }

  CommandResult processCommand(String raw) {
    if (gameOver) return CommandResult.ok('游戏已结束。');
    turns += 1;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return CommandResult.ok('输入 help。', incrementTurn: false);

    final parts = trimmed.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    final handler = _resolveHandler(cmd);
    if (handler == null) return CommandResult.ok("不懂 '$cmd'。输入 help。");
    return handler(args);
  }

  CommandResult Function(List<String>)? _resolveHandler(String cmd) {
    const table = <String, String>{
      'look': 'look', 'l': 'look',
      'north': 'north', 'n': 'north', 'south': 'south', 's': 'south',
      'east': 'east', 'e': 'east', 'west': 'west', 'w': 'west',
      'up': 'up', 'u': 'up', 'down': 'down', 'd': 'down',
      'take': 'take', 'get': 'take', 'drop': 'drop',
      'inventory': 'inventory', 'i': 'inventory', 'inv': 'inventory',
      'use': 'use', 'attack': 'attack', 'fight': 'attack', 'flee': 'flee',
      'talk': 'talk', 'say': 'talk', 'trade': 'trade',
      'buy': 'buy', 'sell': 'sell', 'heal': 'heal',
      'recruit': 'recruit', 'party': 'party', 'companions': 'party',
      'help': 'help', 'h': 'help', 'score': 'score', 'status': 'score',
      'ng+': 'ng+', 'newgame+': 'ng+', 'ngplus': 'ng+',
      'map': 'map', 'm': 'map', 'quit': 'quit', 'exit': 'quit',
    };
    if (table.containsKey(cmd)) return _handlers[table[cmd]!];
    String? match;
    for (final key in table.keys) {
      if (key.startsWith(cmd)) {
        if (match != null) return null;
        match = table[key];
      }
    }
    return match != null ? _handlers[match] : null;
  }

  late final Map<String, CommandResult Function(List<String>)> _handlers = {
    'look': (_) => CommandResult.ok(roomDescription(currentRoomId)),
    'north': (_) => doGo(Direction.north),
    'south': (_) => doGo(Direction.south),
    'east': (_) => doGo(Direction.east),
    'west': (_) => doGo(Direction.west),
    'up': (_) => doGo(Direction.up),
    'down': (_) => doGo(Direction.down),
    'take': doTake,
    'drop': doDrop,
    'inventory': (_) => CommandResult.ok(doInventory()),
    'use': doUse,
    'attack': (_) => CommandResult.ok(doAttackText()),
    'flee': (_) => doFlee(),
    'talk': (_) => CommandResult.ok(doTalk()),
    'trade': (_) => CommandResult.ok(doTrade()),
    'buy': doBuy,
    'sell': doSell,
    'heal': (_) => CommandResult.ok(doHeal()),
    'recruit': (_) => CommandResult.ok(doRecruit()),
    'party': (_) => CommandResult.ok(doParty()),
    'help': (_) => CommandResult.ok(_helpText),
    'score': (_) => CommandResult.ok(doScore()),
    'ng+': (_) => CommandResult.ok(doNewGamePlus()),
    'map': (_) => CommandResult.ok('切换地图显示。', incrementTurn: false),
    'quit': (_) {
      gameOver = true;
      return CommandResult.ok('再见！');
    },
  };

  String roomDescription(String id) {
    final rm = rooms[id];
    if (rm == null) return '未知地点。';
    if (rm.dark && !hasLight()) return '🌑 一片漆黑！你需要光源。';
    final title = rm.emoji.isNotEmpty ? '${rm.emoji} ${rm.name}' : rm.name;
    final text = StringBuffer('[$title]\n');
    text.writeln(rm.visited ? rm.desc.split('\n').first : rm.desc);
    if (rm.items.isNotEmpty) {
      final numbered = rm.items.asMap().entries.map((e) {
        final it = items[e.value];
        return '(${e.key + 1}) ${it?.label ?? e.value}';
      }).join(', ');
      text.writeln('\n可见物品：$numbered');
    }
    if (rm.npcId != null) {
      final n = npcs[rm.npcId];
      if (n != null) text.writeln('\n${n.emoji.isNotEmpty ? n.emoji : '👤'} ${n.name}（${n.title}）');
    }
    if (rm.monsterId != null) {
      final m = monsters[rm.monsterId];
      if (m != null && m.alive) {
        final tag = m.rank != MonsterRank.normal ? '[${m.rank.displayName}]' : '';
        text.writeln('\n⚠️ $tag ${m.label}（${m.hp}/${m.maxHp}）');
      }
    }
    text.write('\n出口：${rm.exits.keys.map((d) => d.name).join(', ')}');
    return text.toString();
  }

  CommandResult doGo(Direction d) {
    if (inCombat) return CommandResult.ok('战斗中！(attack/flee)');
    final room = rooms[currentRoomId]!;
    if (!room.exits.containsKey(d)) return CommandResult.ok('不能往 ${d.value}。');
    if (room.dark && !hasLight()) return CommandResult.ok('🌑 太黑了不敢走。');
    currentRoomId = room.exits[d]!;
    final nr = rooms[currentRoomId]!;
    var extra = '';
    if (nr.onEnter != null) {
      final r = nr.onEnter!(this);
      if (r != null) extra = '\n\n$r';
    }
    final events = <GameEvent>[];
    if (!nr.visited) {
      nr.visited = true;
      score += 10;
      visitOrder.add(currentRoomId);
      events.add(GameEvent(type: GameEventType.newVisit, roomId: currentRoomId));
    }
    final combat = checkCombat();
    if (combat != null) extra += '\n\n$combat';
  if (inCombat) {
      events.add(GameEvent(
        type: GameEventType.battleRequested,
        enemyId: currentEnemy,
        roomId: currentRoomId,
      ));
    }
    return CommandResult.ok('${roomDescription(currentRoomId)}$extra', events: events);
  }

  String? checkCombat() {
    final rm = rooms[currentRoomId]!;
    final ids = rm.resolveMonsterIds();
    if (ids.isEmpty) return null;

    final living = <MonsterState>[];
    for (final id in ids) {
      final m = monsters[id];
      if (m != null && m.alive && m.hostile) living.add(m);
    }
    if (living.isEmpty || inCombat) return null;

    inCombat = true;
    currentEnemy = living.first.id;
    activeEncounter = _buildEncounter(living);
    final names = living.map((m) => m.name).join('、');
    return '⚔️ $names 出现了！';
  }

  CombatEncounter _buildEncounter(List<MonsterState> enemyTemplates) {
    final party = companionList
        .map((id) => companions[id])
        .whereType<CompanionState>()
        .where((c) => c.recruited)
        .toList();
    return CombatEncounterFactory.build(
      roomId: currentRoomId,
      playerHp: playerHp,
      playerMaxHp: playerMaxHp,
      playerAttack: totalAtk,
      playerDefense: totalDef,
      playerSpeed: 6,
      party: party,
      enemyTemplates: enemyTemplates.map((m) => m.clone()).toList(),
    );
  }

  void syncCombatHpFromEncounter() {
    final enc = activeEncounter;
    if (enc == null) return;
    CombatEncounterFactory.syncAllyHpToSession(enc, this, companions);
  }

  bool submitCombatCommand(String actorInstanceId, CombatCommand command) {
    final enc = activeEncounter;
    if (enc == null || enc.phase != CombatPhase.command) return false;
    combatEngine.submitAllyCommand(enc, actorInstanceId, command);
    return true;
  }

  CombatRoundResult? resolveCombatRound() {
    final enc = activeEncounter;
    if (enc == null || !enc.allAlliesCommanded) return null;
    final result = combatEngine.resolveRound(enc);
    syncCombatHpFromEncounter();
    return result;
  }

  List<({String id, String label, int heal, int count, String effectHint})> combatUsableItems() {
    final usable = <({String id, String label, int heal, int count, String effectHint})>[];
    for (final e in inventory.entries) {
      final it = items[e.key];
      if (it == null || e.value <= 0) continue;
      final hasHeal = it.heal > 0 || it.type == ItemType.potion || it.type == ItemType.food;
      final hasEffects = it.combatEffects.isNotEmpty;
      if (!hasHeal && !hasEffects) continue;
      final hints = <String>[];
      if (it.heal > 0) hints.add('HP+${it.heal}');
      for (final fx in it.combatEffects) {
        if (fx.cleanse != null) {
          hints.add('净化');
        } else {
          hints.add(fx.effectId);
        }
      }
      usable.add((
        id: e.key,
        label: it.label,
        heal: it.heal > 0 ? it.heal : (hasHeal ? 10 : 0),
        count: e.value,
        effectHint: hints.join(' · '),
      ));
    }
    return usable;
  }

  List<TurnOrderEntry> previewCombatTurnOrder() {
    final enc = activeEncounter;
    if (enc == null || !enc.allAlliesCommanded) return const [];
    return combatEngine.previewTurnOrder(enc);
  }

  void consumeCombatItem(String itemId) {
    if (inventory.containsKey(itemId)) invRemove(itemId);
  }

  CommandResult finishEncounter(CombatOutcome outcome) {
    switch (outcome) {
      case CombatOutcome.victory:
        return resolveEncounterVictory();
      case CombatOutcome.defeat:
        return resolveCombatDefeat();
      case CombatOutcome.fled:
        return resolveCombatFleeSuccess();
    }
  }

  CommandResult resolveEncounterVictory() {
    final enc = activeEncounter;
    syncCombatHpFromEncounter();
    var defeated = enc?.defeatedEnemies() ?? <CombatActor>[];

    final lines = <String>[];
    var totalGold = 0;
    var totalExp = 0;
    final rewardedInstances = <String>{};

    if (defeated.isEmpty && currentEnemy.isNotEmpty) {
      final m = monsters[currentEnemy];
      if (m != null) {
        defeated = [
          CombatActor(
            instanceId: '${m.id}#0',
            templateId: m.id,
            side: CombatSide.enemy,
            name: m.name,
            maxHp: m.maxHp,
            hp: 0,
            attack: m.attack,
          ),
        ];
      }
    }

    for (final enemy in defeated) {
      if (rewardedInstances.contains(enemy.instanceId)) continue;
      rewardedInstances.add(enemy.instanceId);
      final m = monsters[enemy.templateId];
      if (m == null) continue;
      m.alive = false;
      m.hp = 0;
      lines.add('🎉 击败了 ${m.name}！');
      for (final li in m.loot) {
        if (items.containsKey(li)) {
          invAdd(li);
          lines.add('🏆 战利品：${items[li]!.name}');
        }
      }
      totalGold += m.gold;
      totalExp += m.exp;
    }

    gold += totalGold;
    score += totalExp;
    if (totalGold > 0 || totalExp > 0) {
      lines.add('💰 +${totalGold}金币 +${totalExp}经验');
    }

    _applyBossVictoryFlags(lines);
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;

    if (companionList.isNotEmpty) {
      final c = companions[companionList.first];
      if (c != null) lines.add('\n${c.banter()}');
    }

    return CommandResult.ok(
      lines.isEmpty ? '战斗胜利！' : lines.join('\n'),
      events: const [GameEvent(type: GameEventType.battleEnded)],
    );
  }

  void _applyBossVictoryFlags(List<String> lines) {
    for (final m in monsters.values) {
      if (!m.alive && m.id == 'scp_breach_core' && hasItem('containment_box')) {
        score += 50;
        lines.add('\n📦 你用收容箱稳定了异常核心，获得额外 50 分！');
      }
      if (!m.alive && m.id == 'scp_001') {
        siteWon = true;
        score += 100;
        lines.add('\n☢️ 站点最终威胁已被压制！站点行动告一段落（+100 分）。');
      }
      if (!m.alive && m.rank == MonsterRank.boss) {
        lines.add('\n💀 BOSS【${m.name}】被击败！');
      }
    }
  }

  String doInventory() {
    final totalItems = inventory.values.fold<int>(0, (a, b) => a + b);
    final lines = <String>[
      '🎒 ${equippedBagLabel()} (重量 ${totalWeight()}/${bagCapacity()} · 共 $totalItems 件)',
    ];
    if (inventory.isEmpty) {
      lines.add('  (空)');
    } else {
      var idx = 1;
      for (final e in inventory.entries) {
        final it = items[e.key];
        if (it == null) continue;
        var label = '  ($idx) ${it.label}';
        if (it.stackable && e.value > 1) label += ' x${e.value}';
        final bonus = <String>[];
        if (it.damageBonus > 0) bonus.add('攻+${it.damageBonus}');
        if (it.defenseBonus > 0) bonus.add('防+${it.defenseBonus}');
        if (bonus.isNotEmpty) label += ' [${bonus.join(' ')}]';
        label += ' (${it.type.jsonName})';
        lines.add(label);
        idx++;
      }
    }
    lines.add('\n❤️ HP: $playerHp/$playerMaxHp');
    lines.add('⚔️ 攻击: $totalAtk  |  🛡️ 防御: $totalDef');
    lines.add('💰 金币: $gold | 🏆 得分: $score');
    if (companionList.isNotEmpty) {
      lines.add('👥 队友：');
      for (final cid in companionList) {
        final c = companions[cid];
        if (c != null) lines.add('  · ${c.name} [${c.role.name}] HP:${c.hp}/${c.maxHp}');
      }
    }
    return lines.join('\n');
  }

  CommandResult doTake(List<String> args) {
    if (args.isEmpty) return CommandResult.ok('拿什么？ 用 take all 拿全部，或用序号 take 1');
    if (inCombat) return CommandResult.ok('战斗中不能拾取！');
    final t = args.join(' ');
    final rm = rooms[currentRoomId]!;
    if (t == 'all') {
      final taken = <String>[];
      for (final iid in List<String>.from(rm.items)) {
        final it = items[iid];
        if (it == null || !it.takeable) continue;
        if (!inventory.containsKey(iid) && totalWeight() + _itemEncumbrance(it) > bagCapacity()) continue;
        rm.items.remove(iid);
        invAdd(iid);
        score += 5;
        taken.add(it.name);
      }
      if (taken.isEmpty) return CommandResult.ok('这里没有能拿的东西。');
      return CommandResult.ok('拾取了：${taken.join('、')}。');
    }
    final found = resolveItemRef(t, rm.items);
    if (found == null) return CommandResult.ok('没有 $t。');
    final it = items[found]!;
    if (!it.takeable) return CommandResult.ok('拿不起 ${it.name}。');
    if (!inventory.containsKey(found) && totalWeight() + _itemEncumbrance(it) > bagCapacity()) {
      return CommandResult.ok('负重满了（${bagCapacity()}）。装备（武器/护甲）过重。');
    }
    rm.items.remove(found);
    invAdd(found);
    score += 5;
    var extra = '';
    if (currentRoomId == 'haunted_graveyard' && found == 'keycard_lvl2' && !flags.containsKey('grave_site_open')) {
      rm.exits[Direction.east] = 'scp_site_gate';
      flags['grave_site_open'] = true;
      extra = '\n你用钥匙卡刷开了藤蔓缠绕的石门！';
    }
    return CommandResult.ok('拾起了 ${it.name}。$extra');
  }

  CommandResult doDrop(List<String> args) {
    if (args.isEmpty) return CommandResult.ok('丢什么？ 用序号 drop 1');
    if (inCombat) return CommandResult.ok('战斗中不能丢弃！');
    final found = resolveItemRef(args.join(' '), inventory.keys);
    if (found == null) return CommandResult.ok('没有 ${args.join(' ')}。');
    if (found == equippedBag) return CommandResult.ok('不能丢下正在使用的背包。');
    invRemove(found);
    rooms[currentRoomId]!.items.add(found);
    return CommandResult.ok('丢下了 ${items[found]!.name}。');
  }

  CommandResult doUse(List<String> args) {
    if (args.isEmpty) return CommandResult.ok('用什么？ 用序号 use 1');
    final t = args.join(' ').toLowerCase();
    if (['914', 'scp-914', 'scp_914', '齿轮', '转换器'].contains(t)) {
      return CommandResult.ok(doScp914());
    }
    if (['294', 'scp-294', 'scp_294', '咖啡机'].contains(t)) {
      return CommandResult.ok(doScp294());
    }
    if (['261', 'scp-261', 'scp_261', '贩卖机'].contains(t)) {
      return CommandResult.ok(doScp261());
    }
    final found = resolveItemRef(t, inventory.keys);
    if (found == null) return CommandResult.ok('没有 $t。');
    final it = items[found]!;
    if (it.type == ItemType.bag) return CommandResult.ok(equipBag(found));
    if (!it.usable) return CommandResult.ok('${it.name} 不能用。');
    final msg = it.onUse?.call(this) ?? (it.heal > 0 ? _defaultHeal(it) : it.useMsg);
    if (it.type == ItemType.potion || it.type == ItemType.food) invRemove(found);
    score += 2;
    return CommandResult.ok(msg.isNotEmpty ? msg : '使用了 ${it.name}。');
  }

  String _defaultHeal(ItemDefinition it) {
    if (it.heal > 0) {
      playerHp = min(playerMaxHp, playerHp + it.heal);
      return it.useMsg.isNotEmpty ? it.useMsg : '恢复了 ${it.heal} 点 HP。';
    }
    return it.useMsg;
  }

  String equipBag(String iid) {
    final it = items[iid];
    if (it == null || it.type != ItemType.bag) return '${it?.name ?? iid} 不是背包。';
    if (iid == equippedBag) return '你已经装备着 ${it.name}。';
    final newCap = it.capacity > 0 ? it.capacity : maxWeight;
    if (totalWeight() > newCap) return '当前负重 ${totalWeight()}，${it.name} 只能装 $newCap，请先丢掉一些装备。';
    final oldId = equippedBag;
    equippedBag = iid;
    if (inventory.containsKey(iid)) invRemove(iid);
    if (oldId.isNotEmpty && items.containsKey(oldId)) invAdd(oldId);
    return '你换上了 ${it.name}（负重上限 $newCap）。';
  }

  String doScp914() {
    if (currentRoomId != 'scp_914_chamber') return '这里没有齿轮工房。去 914 号单元再试。';
    final candidates = inventory.keys.where((iid) {
      if (iid == equippedBag) return false;
      final it = items[iid];
      return it != null && it.type != ItemType.bag;
    }).toList();
    if (candidates.isEmpty) return '进料斗空空如也——先准备一件可精炼的背包物品。';
    final iid = candidates[Random().nextInt(candidates.length)];
    final it = items[iid]!;
    invRemove(iid);
    final roll = Random().nextDouble();
    if (roll < 0.25) return '【Rough】${it.name} 被绞成无法辨认的碎片……';
    if (roll < 0.5) {
      invAdd(iid);
      return '【1:1】${it.name} 原样吐出，几乎没有变化。';
    }
    if (roll < 0.8) {
      final out = items.containsKey('greater_potion') ? 'greater_potion' : 'lesser_potion';
      invAdd(out);
      score += 5;
      return '【Fine】${it.name} 被精炼成 ${items[out]!.name}！';
    }
    var out = Random().nextDouble() < 0.35 && items.containsKey('scp_500_pill') ? 'scp_500_pill' : 'anomaly_core';
    if (!items.containsKey(out)) out = 'diamond';
    invAdd(out);
    score += 15;
    return '【Very Fine】机械尖啸！你获得了 ${items[out]!.name}！';
  }

  String doScp294() {
    if (currentRoomId != 'scp_294_lounge') return '这里没有异常咖啡机。';
    const heal = 18;
    playerHp = min(playerMaxHp, playerHp + heal);
    score += 2;
    return '咖啡机吐出一杯冒着蒸汽的液体。你喝下后恢复了 $heal 点 HP。';
  }

  String doScp261() {
    if (currentRoomId != 'scp_261_canteen') return '这里没有次元贩卖机。';
    const cost = 5;
    if (gold < cost) return '需要投币 $cost 金，你只有 $gold。';
    gold -= cost;
    final pool = ['scp_261_snack', 'bread', 'lesser_potion', 'old_coin', 'scp_447_slime']
        .where(items.containsKey)
        .toList();
    if (pool.isEmpty) return '贩卖机卡住了……你损失了 $cost 金。';
    final out = pool[Random().nextInt(pool.length)];
    invAdd(out);
    return '贩卖机咔哒一声，吐出了 ${items[out]!.name}！（-$cost 金）';
  }

  String doTalk() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null || !npcs.containsKey(rm.npcId)) return '这里没有可对话的人。';
    final n = npcs[rm.npcId]!;
    final lines = <String>['[${n.name} · ${n.title}]', n.desc];
    if (!n.metBefore) {
      n.metBefore = true;
      lines.add('\n${n.name}：「${n.dialogs['greet'] ?? '你好。'}」');
      if (n.giveItem != null && items.containsKey(n.giveItem) && !inventory.containsKey(n.giveItem)) {
        invAdd(n.giveItem!);
        lines.add('\n${n.name} 给了你 ${items[n.giveItem!]!.name}！');
        score += 5;
      }
    } else {
      lines.add('\n${n.name}：「${n.dialogs['extra'] ?? n.dialogs['farewell'] ?? '还有什么事？'}」');
    }
    if (n.questItem != null && !n.questDone) {
      if (inventory.containsKey(n.questItem)) {
        invRemove(n.questItem!);
        if (n.questReward != null) {
          invAdd(n.questReward!);
          lines.add('\n✨ 提交任务！获得 ${items[n.questReward!]!.name}！');
        } else {
          lines.add('\n✨ ${n.name} 感谢你！');
        }
        score += n.questScore;
        n.questDone = true;
      } else {
        final qi = items[n.questItem];
        if (qi != null) {
          lines.add('\n💬 ${n.name}：${n.dialogs['quest'] ?? '帮我找 ${qi.name} 好吗？'}');
        }
      }
    }
    if (n.type == NpcType.merchant) lines.add('\n🛒 输入 trade / buy <物品> / sell <物品>');
    if (n.type == NpcType.healer) lines.add('\n💚 我可以为你治疗 (输入 heal)');
    return lines.join('\n');
  }

  String doTrade() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return '没有商人。';
    final n = npcs[rm.npcId]!;
    if (n.type != NpcType.merchant || n.tradeItems.isEmpty) return '${n.name} 没有商品。';
    final lines = <String>['\n🛒 ${n.name} 的商品：'];
    for (var i = 0; i < n.tradeItems.length; i++) {
      final (iid, price) = n.tradeItems[i];
      final it = items[iid];
      if (it != null) lines.add('  (${i + 1}) ${it.name} —— $price 金币');
    }
    lines.add('💰 你有 $gold 金币');
    return lines.join('\n');
  }

  CommandResult doBuy(List<String> args) {
    if (args.isEmpty) return CommandResult.ok('买什么？');
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return CommandResult.ok('没有商人。');
    final n = npcs[rm.npcId]!;
    if (n.type != NpcType.merchant) return CommandResult.ok('${n.name} 不是商人。');
    final name = args.join(' ');
    final idx = int.tryParse(name);
    if (idx != null && idx >= 1 && idx <= n.tradeItems.length) {
      final (iid, price) = n.tradeItems[idx - 1];
      final it = items[iid];
      if (it == null) return CommandResult.ok('没有商品。');
      if (gold >= price) {
        gold -= price;
        invAdd(iid);
        return CommandResult.ok('购买了 ${it.name}！花费 $price 金币。');
      }
      return CommandResult.ok('需要 $price 金币，你只有 $gold。');
    }
    for (final (iid, price) in n.tradeItems) {
      final it = items[iid];
      if (it != null && (name == it.name || name == it.id)) {
        if (gold >= price) {
          gold -= price;
          invAdd(iid);
          return CommandResult.ok('购买了 ${it.name}！花费 $price 金币。');
        }
        return CommandResult.ok('需要 $price 金币，你只有 $gold。');
      }
    }
    return CommandResult.ok("没有 '$name'。");
  }

  CommandResult doSell(List<String> args) {
    if (args.isEmpty) return CommandResult.ok('卖什么？');
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return CommandResult.ok('没有商人。');
    final n = npcs[rm.npcId]!;
    if (n.type != NpcType.merchant) return CommandResult.ok('${n.name} 不是商人。');
    final name = args.join(' ');
    final invList = inventory.keys.toList();
    final idx = int.tryParse(name);
    if (idx != null && idx >= 1 && idx <= invList.length) {
      final iid = invList[idx - 1];
      final it = items[iid];
      if (it != null && n.buysTypes.contains(it.type)) {
        final p = max(2, it.value ~/ 2);
        invRemove(iid);
        gold += p;
        return CommandResult.ok('卖了 ${it.name}，获得 $p 金币。');
      }
      return CommandResult.ok('不收这种物品。');
    }
    for (final iid in invList) {
      final it = items[iid];
      if (it != null && (name == it.name || name == it.id)) {
        if (n.buysTypes.contains(it.type)) {
          final p = max(2, it.value ~/ 2);
          invRemove(iid);
          gold += p;
          return CommandResult.ok('卖了 ${it.name}，获得 $p 金币。');
        }
        return CommandResult.ok('不收这种物品。');
      }
    }
    return CommandResult.ok("没有 '$name'。");
  }

  String doHeal() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return '没有治疗者。';
    final n = npcs[rm.npcId]!;
    if (n.type != NpcType.healer) return '${n.name} 不会治疗。';
    const cost = 10;
    if (gold < cost) return '治疗需要 $cost 金币。';
    gold -= cost;
    final h = rollDice(6, 3);
    playerHp = min(playerMaxHp, playerHp + h);
    return '${n.name} 为你治疗，恢复了 $h 点HP！花费 $cost 金币。';
  }

  String doAttackText() {
    if (!inCombat) return '没有敌人。进入战斗后使用回合指令攻击，或在此输入 attack。';
    return '⚔️ 已进入回合战斗！在战斗界面选择指令，或输入 flee 逃跑。';
  }

  CommandResult doFlee() {
    if (!inCombat) return CommandResult.ok('没有战斗。');
    final enc = activeEncounter;
    if (enc != null) {
      final hero = enc.allies.firstWhere((a) => a.isHero, orElse: () => enc.allies.first);
      submitCombatCommand(hero.instanceId, const CombatCommand.flee());
      if (enc.allAlliesCommanded) {
        final result = resolveCombatRound();
        if (result != null && result.fled) {
          return finishEncounter(CombatOutcome.fled);
        }
        return CommandResult.ok('逃跑失败！');
      }
      return CommandResult.ok('已下达逃跑指令，请在战斗界面确认回合。');
    }
    if (Random().nextDouble() < 0.5) {
      return resolveCombatFleeSuccess();
    }
    final m = monsters[currentEnemy];
    return CommandResult.ok('逃跑失败！${m?.name ?? '敌人'} 挡住了路。');
  }

  String doRecruit() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return '这里没有可招募的人。';
    const cm = {
      'old_hermit': 'companion_warrior',
      'wandering_rogue': 'companion_rogue',
      'priestess': 'companion_healer',
      'hunter': 'companion_scout',
      'bounty_hunter': 'companion_archer',
    };
    final cid = cm[rm.npcId];
    if (cid == null || !companions.containsKey(cid)) {
      return '${npcs[rm.npcId]?.name ?? ''} 看起来不想加入你。';
    }
    final c = companions[cid]!;
    if (c.recruited) return '${c.name} 已经是你的队友了。';
    if (c.recruitItem != null && !inventory.containsKey(c.recruitItem)) {
      final needed = items[c.recruitItem];
      return '招募 ${c.name} 需要 ${needed?.name ?? c.recruitItem}。';
    }
    if (c.recruitItem != null) invRemove(c.recruitItem!);
    c.recruited = true;
    companionList.add(cid);
    rm.npcId = null;
    score += 20;
    return '✨ ${c.name} ${c.recruitMsg}';
  }

  String doParty() {
    if (companionList.isEmpty) return '你目前没有队友。';
    final lines = <String>['👥 你的队友：'];
    for (final cid in companionList) {
      final c = companions[cid];
      if (c == null) continue;
      final b = c.getBonus();
      lines.add('  ${c.name} [${c.role.name}] HP:${c.hp}/${c.maxHp}');
      lines.add('  攻击+${b['dmg']} 防御+${b['def']}');
      lines.add('  能力：${c.abilityDesc}');
    }
    return lines.join('\n');
  }

  String doScore() {
    final cycle = ngCycle > 0 ? ' | 🔄 二周目#$ngCycle' : '';
    final cleared = <String>[];
    if (won) cleared.add('主线');
    if (siteWon) cleared.add('站点');
    final ct = cleared.isNotEmpty ? ' | ✅ ${cleared.join('+')}' : '';
    return '🏆 得分: $score  |  📖 回合: $turns$cycle$ct\n'
        '❤️ HP: $playerHp/$playerMaxHp  |  ⚔️ 攻击: $totalAtk  |  🛡️ 防御: $totalDef\n'
        '💰 金币: $gold';
  }

  String doNewGamePlus() {
    if (!won && !siteWon) return '需先完成主线（塔顶使用魔法宝石）或击败站点最终BOSS（001），才能开启二周目。';
    final saved = {
      'inventory': Map<String, int>.from(inventory),
      'equipped_bag': equippedBag,
      'gold': gold,
      'companion_list': List<String>.from(companionList),
      'score': score,
      'player_max_hp': playerMaxHp,
      'player_atk_bonus': playerAtkBonus,
      'player_def_bonus': playerDefBonus,
      'ng_cycle': ngCycle + 1,
    };
    populateWorld(starterItems: false);
    inventory
      ..clear()
      ..addAll(saved['inventory'] as Map<String, int>);
    equippedBag = saved['equipped_bag'] as String;
    gold = saved['gold'] as int;
    score = saved['score'] as int;
    playerMaxHp = saved['player_max_hp'] as int;
    playerHp = playerMaxHp;
    playerAtkBonus = saved['player_atk_bonus'] as int;
    playerDefBonus = saved['player_def_bonus'] as int;
    companionList
      ..clear()
      ..addAll(saved['companion_list'] as List<String>);
    ngCycle = saved['ng_cycle'] as int;
    flags['ng_cycle'] = ngCycle;
    won = false;
    siteWon = false;
    gameOver = false;
    inCombat = false;
    currentEnemy = '';
    for (final cid in companionList) {
      final c = companions[cid];
      if (c != null) {
        c.recruited = true;
        c.hp = c.maxHp;
      }
    }
    final mul = 1 + 0.15 * ngCycle;
    final atkMul = 1 + 0.1 * ngCycle;
    for (final m in monsters.values) {
      m.maxHp = max(1, (m.maxHp * mul).round());
      m.hp = m.maxHp;
      m.attack = max(1, (m.attack * atkMul).round());
      m.alive = true;
    }
    return '🔄 二周目 #$ngCycle 开始！装备、道具、金币与队友已保留。\n敌人变得更强了。你回到了迷雾森林入口。';
  }

  void populateWorld({bool starterItems = false}) {
    if (_worldDef == null) return;
    final def = _worldDef!;
    monsters = def.monsters.map((k, v) => MapEntry(k, v.clone()));
    npcs = def.npcs.map((k, v) => MapEntry(k, NpcState(
          id: v.id,
          name: v.name,
          title: v.title,
          desc: v.desc,
          type: v.type,
          dialogs: Map.from(v.dialogs),
          tradeItems: List.from(v.tradeItems),
          buysTypes: List.from(v.buysTypes),
          questItem: v.questItem,
          questReward: v.questReward,
          questScore: v.questScore,
          giveItem: v.giveItem,
          emoji: v.emoji,
        )));
    companions = def.companions.map((k, v) => MapEntry(k, CompanionState(
          id: v.id,
          name: v.name,
          desc: v.desc,
          role: v.role,
          maxHp: v.maxHp,
          hp: v.hp,
          attack: v.attack,
          defense: v.defense,
          abilityDesc: v.abilityDesc,
          recruitItem: v.recruitItem,
          recruitMsg: v.recruitMsg,
          emoji: v.emoji,
        )));
    rooms = {};
    for (final r in def.rooms.values) {
      rooms[r.id] = RoomState(
        id: r.id,
        name: r.name,
        desc: r.desc,
        emoji: r.emoji,
        exits: Map.from(r.exits),
        dark: r.dark,
        items: List.from(r.items),
        npcId: r.npcId,
        monsterId: r.monsterId,
        monsterIds: List.from(r.monsterIds),
        mapMeta: r.mapMeta,
      );
    }
    SpecialBehaviorRegistry.apply(this);
    visitOrder.clear();
    currentRoomId = 'forest_entrance';
    rooms['forest_entrance']!.visited = true;
    visitOrder.add('forest_entrance');
    turns = 0;
    inCombat = false;
    currentEnemy = '';
    gameOver = false;
    won = false;
    siteWon = false;
    flags.clear();
    if (starterItems) {
      inventory.clear();
      invAdd('lesser_potion');
      invAdd('bread');
    }
  }

  CommandResult resolveCombatDefeat() {
    gameOver = true;
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;
    return CommandResult.ok(
      '\n💀 你被击败了……',
      events: const [GameEvent(type: GameEventType.gameOver), GameEvent(type: GameEventType.battleEnded)],
    );
  }

  CommandResult resolveCombatFleeSuccess() {
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;
    return CommandResult.ok('你逃跑了！', events: [const GameEvent(type: GameEventType.battleEnded)]);
  }

  int visitedCount() => rooms.values.where((r) => r.visited).length;
}
