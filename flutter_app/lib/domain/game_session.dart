import 'dart:math';

import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_encounter_factory.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/combat_reward.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/dice.dart';
import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/world/special_behavior_registry.dart';
import 'package:zork_dude/l10n/game_messages.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

class GameSession implements GameSessionRef, GameSessionRefWithNpcs {
  GameSession._(this.messages);

  @override
  final GameMessages messages;

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
  String? previousRoomId;
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
  CombatReward? lastCombatReward;
  final CombatEngine combatEngine = CombatEngine();
  String equippedBag = 'bag_starter';

  static Future<GameSession> create(
    WorldRepository repo, {
    GameMessages? messages,
    String? localeTag,
    bool starterItems = true,
  }) async {
    final resolvedMessages =
        messages ?? await GameMessages.load(localeTag ?? LocaleTag.zhHans);
    final def = await repo.loadFromAssets();
    return GameSession._fromDefinition(
      def,
      messages: resolvedMessages,
      starterItems: starterItems,
    );
  }

  factory GameSession._fromDefinition(
    WorldDefinition def, {
    required GameMessages messages,
    bool starterItems = true,
  }) {
    final s = GameSession._(messages);
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
    s.combatEngine.messages = messages;
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

  String equippedBagLabel() => items[equippedBag]?.label ?? messages.defaultBagLabel;

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

  /// Opens the haunted graveyard east exit when the player holds the magic gem.
  String _tryOpenGraveSiteGate() {
    if (currentRoomId != 'haunted_graveyard' || flags.containsKey('grave_site_open')) {
      return '';
    }
    if (!hasItem('magic_gem')) return '';
    final rm = rooms['haunted_graveyard'];
    if (rm == null) return '';
    rm.exits[Direction.east] = 'scp_site_gate';
    flags['grave_site_open'] = true;
    return messages.graveGateOpened;
  }

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
    if (gameOver) return CommandResult.ok(messages.gameOver);
    turns += 1;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return CommandResult.ok(messages.emptyInputHint, incrementTurn: false);

    final parts = trimmed.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    final handler = _resolveHandler(cmd);
    if (handler == null) return CommandResult.ok(messages.unknownCommand(cmd));
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
    'help': (_) => CommandResult.ok(messages.helpText),
    'score': (_) => CommandResult.ok(doScore()),
    'ng+': (_) => CommandResult.ok(doNewGamePlus()),
    'map': (_) => CommandResult.ok(messages.mapToggleHint, incrementTurn: false),
    'quit': (_) => CommandResult.ok(
          '',
          events: const [GameEvent(type: GameEventType.returnToTitle)],
          incrementTurn: false,
        ),
  };

  String roomDescription(String id) {
    final rm = rooms[id];
    if (rm == null) return messages.roomUnknown;
    if (rm.dark && !hasLight()) return messages.roomTooDarkNeedLight;
    final title = rm.emoji.isNotEmpty ? '${rm.emoji} ${rm.name}' : rm.name;
    final text = StringBuffer('[$title]\n');
    text.writeln(rm.visited ? rm.desc.split('\n').first : rm.desc);
    if (rm.items.isNotEmpty) {
      final numbered = rm.items.asMap().entries.map((e) {
        final it = items[e.value];
        return '(${e.key + 1}) ${it?.label ?? e.value}';
      }).join(', ');
      text.writeln('\n${messages.roomItemsVisible(numbered)}');
    }
    if (rm.npcId != null) {
      final n = npcs[rm.npcId];
      if (n != null) {
        text.writeln('\n${messages.roomNpcPresent(
          n.emoji.isNotEmpty ? n.emoji : '👤',
          n.name,
          n.title,
        )}');
      }
    }
    if (rm.monsterId != null) {
      final mon = monsters[rm.monsterId];
      if (mon != null && mon.alive) {
        final tag = mon.rank != MonsterRank.normal
            ? '[${mon.rank.displayName(messages)}]'
            : '';
        text.writeln('\n${messages.roomMonsterPresent(tag, mon.label, mon.hp, mon.maxHp)}');
      }
    }
    final dirs = rm.exits.keys.map((d) => messages.mapDirName(d.value)).join(', ');
    text.write('\n${messages.roomExits(dirs)}');
    return text.toString();
  }

  String? _movementBlocked(String targetRoomId) {
    switch (targetRoomId) {
      case 'scp_cell_block':
        if (!hasItem('keycard_lvl2')) {
          return messages.moveBlockedCellBlock;
        }
      case 'scp_682_pit':
        if (!hasItem('keycard_lvl3') && !flags.containsKey('scp_079_unlocked')) {
          return messages.moveBlocked682Pit;
        }
    }
    return null;
  }

  void _recordRoomChange(String nextRoomId) {
    if (nextRoomId != currentRoomId) {
      previousRoomId = currentRoomId;
    }
  }

  CommandResult doGo(Direction d) {
    if (inCombat) return CommandResult.ok(messages.moveInCombat);
    final room = rooms[currentRoomId]!;
    if (!room.exits.containsKey(d)) return CommandResult.ok(messages.moveCannotGo(messages.mapDirName(d.value)));
    if (room.dark && !hasLight()) return CommandResult.ok(messages.moveTooDark);
    final nextId = room.exits[d]!;
    final blocked = _movementBlocked(nextId);
    if (blocked != null) return CommandResult.ok(blocked);
    _recordRoomChange(nextId);
    currentRoomId = nextId;
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
    return messages.combatEnemiesAppeared(names);
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
      messages: messages,
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

  /// Start Destiny-of-an-Emperor style melee. Returns false if unavailable.
  bool beginMelee() {
    final enc = activeEncounter;
    if (enc == null || enc.phase != CombatPhase.command) return false;
    if (!enc.canUseMelee) return false;
    enc.meleeActive = true;
    enc.pendingAllyCommands.clear();
    return combatEngine.fillMeleeAllyCommands(enc);
  }

  /// Refill auto-attacks while melee continues. Clears melee if threshold hit.
  bool prepareNextMeleeRound() {
    final enc = activeEncounter;
    if (enc == null || !enc.meleeActive) return false;
    if (enc.shouldStopMelee || enc.livingEnemies().isEmpty) {
      enc.meleeActive = false;
      return false;
    }
    enc.pendingAllyCommands.clear();
    return combatEngine.fillMeleeAllyCommands(enc);
  }

  void cancelMelee() {
    activeEncounter?.meleeActive = false;
  }

  CombatRoundResult? resolveCombatRound() {
    final enc = activeEncounter;
    if (enc == null || !enc.allAlliesCommanded) return null;
    final result = combatEngine.resolveRound(enc);
    syncCombatHpFromEncounter();
    if (enc.meleeActive && enc.shouldStopMelee) {
      enc.meleeActive = false;
    }
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
          hints.add(messages.itemEffectCleanse);
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
    final defeatedNames = <String>[];
    final lootLabels = <String>[];
    final notes = <String>[];
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
      defeatedNames.add(m.label);
      lines.add(messages.combatDefeatedEnemy(m.name));
      for (final li in m.loot) {
        if (items.containsKey(li)) {
          invAdd(li);
          lootLabels.add(items[li]!.label);
          lines.add(messages.combatLootItem(items[li]!.name));
        }
      }
      totalGold += m.gold;
      totalExp += m.exp;
    }

    gold += totalGold;
    score += totalExp;
    if (totalGold > 0 || totalExp > 0) {
      lines.add(messages.combatRewardGoldExp(totalGold, totalExp));
    }

    _applyBossVictoryFlags(lines, notes);
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;

    String? banter;
    if (companionList.isNotEmpty) {
      final c = companions[companionList.first];
      if (c != null) {
        banter = c.banter(messages);
        lines.add('\n$banter');
      }
    }

    lastCombatReward = CombatReward(
      defeatedNames: defeatedNames,
      lootLabels: lootLabels,
      gold: totalGold,
      exp: totalExp,
      notes: notes,
      banter: banter,
    );

    return CommandResult.ok(
      lines.isEmpty ? messages.combatVictoryDefault : lines.join('\n'),
      events: const [GameEvent(type: GameEventType.battleEnded)],
    );
  }

  void _applyBossVictoryFlags(List<String> lines, List<String> notes) {
    for (final m in monsters.values) {
      if (!m.alive && m.id == 'scp_breach_core' && hasItem('containment_box')) {
        score += 50;
        final msg = messages.combatContainmentBonus;
        lines.add('\n$msg');
        notes.add(msg);
      }
      if (!m.alive && m.id == 'scp_001') {
        siteWon = true;
        score += 100;
        final msg = messages.combatSiteBossSuppressed;
        lines.add('\n$msg');
        notes.add(msg);
      }
      if (!m.alive && m.rank == MonsterRank.boss) {
        final msg = messages.combatBossDefeated(m.name);
        lines.add('\n$msg');
        notes.add(msg);
      }
    }
  }

  String doInventory() {
    final totalItems = inventory.values.fold<int>(0, (a, b) => a + b);
    final lines = <String>[
      messages.inventoryHeader(
        equippedBagLabel(),
        totalWeight(),
        bagCapacity(),
        totalItems,
      ),
    ];
    if (inventory.isEmpty) {
      lines.add(messages.inventoryEmpty);
    } else {
      var idx = 1;
      for (final e in inventory.entries) {
        final it = items[e.key];
        if (it == null) continue;
        var label = '  ($idx) ${it.label}';
        if (it.stackable && e.value > 1) label += ' x${e.value}';
        final bonus = <String>[];
        if (it.damageBonus > 0) bonus.add(messages.inventoryItemAtkBonus(it.damageBonus));
        if (it.defenseBonus > 0) bonus.add(messages.inventoryItemDefBonus(it.defenseBonus));
        if (bonus.isNotEmpty) label += ' [${bonus.join(' ')}]';
        label += ' (${it.type.jsonName})';
        lines.add(label);
        idx++;
      }
    }
    lines.add('\n${messages.inventoryHpLine(playerHp, playerMaxHp)}');
    lines.add(messages.inventoryAtkDefLine(totalAtk, totalDef));
    lines.add(messages.inventoryGoldScoreLine(gold, score));
    if (companionList.isNotEmpty) {
      lines.add(messages.inventoryCompanionsHeader);
      for (final cid in companionList) {
        final c = companions[cid];
        if (c != null) {
          lines.add(messages.inventoryCompanionLine(
            c.name,
            c.role.name,
            c.hp,
            c.maxHp,
          ));
        }
      }
    }
    return lines.join('\n');
  }

  CommandResult doTake(List<String> args) {
    if (args.isEmpty) return CommandResult.ok(messages.takeWhat);
    if (inCombat) return CommandResult.ok(messages.combatCannotTake);
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
      if (taken.isEmpty) return CommandResult.ok(messages.takeNothingHere);
      return CommandResult.ok(messages.takeMultiple(taken.join('、')));
    }
    final found = resolveItemRef(t, rm.items);
    if (found == null) return CommandResult.ok(messages.takeNotFound(t));
    final it = items[found]!;
    if (!it.takeable) return CommandResult.ok(messages.takeCannotPickUp(it.name));
    if (!inventory.containsKey(found) && totalWeight() + _itemEncumbrance(it) > bagCapacity()) {
      return CommandResult.ok(messages.takeOverweight(bagCapacity()));
    }
    rm.items.remove(found);
    invAdd(found);
    score += 5;
    final extra = _tryOpenGraveSiteGate();
    return CommandResult.ok(messages.takePickedUp(it.name, extra));
  }

  CommandResult doDrop(List<String> args) {
    if (args.isEmpty) return CommandResult.ok(messages.dropWhat);
    if (inCombat) return CommandResult.ok(messages.combatCannotDrop);
    final found = resolveItemRef(args.join(' '), inventory.keys);
    if (found == null) return CommandResult.ok(messages.dropNotFound(args.join(' ')));
    if (found == equippedBag) return CommandResult.ok(messages.dropCannotDropBag);
    invRemove(found);
    rooms[currentRoomId]!.items.add(found);
    return CommandResult.ok(messages.dropDropped(items[found]!.name));
  }

  CommandResult doUse(List<String> args) {
    if (args.isEmpty) return CommandResult.ok(messages.useWhat);
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

    final parsed = _resolveUseTarget(args);
    if (parsed == null) return CommandResult.ok(messages.useNotFound(t));
    final found = parsed.itemId;
    final destArgs = parsed.rest;

    if (found == 'magic_scroll') {
      return _useTeleportScroll(destArgs);
    }

    final it = items[found]!;
    if (it.type == ItemType.bag) return CommandResult.ok(equipBag(found));
    if (!it.usable) return CommandResult.ok(messages.useCannotUse(it.name));
    final msg = it.onUse?.call(this) ?? (it.heal > 0 ? _defaultHeal(it) : it.useMsg);
    if (it.type == ItemType.potion || it.type == ItemType.food) invRemove(found);
    score += 2;
    return CommandResult.ok(msg.isNotEmpty ? msg : messages.useDefault(it.name));
  }

  /// Resolves inventory item from [args], allowing trailing destination tokens.
  ({String itemId, List<String> rest})? _resolveUseTarget(List<String> args) {
    final keys = inventory.keys;
    final whole = resolveItemRef(args.join(' '), keys);
    if (whole != null) return (itemId: whole, rest: const <String>[]);

    if (args.length > 1) {
      final first = resolveItemRef(args.first, keys);
      if (first != null) {
        return (itemId: first, rest: args.sublist(1));
      }
      for (var take = args.length - 1; take >= 1; take--) {
        final hit = resolveItemRef(args.sublist(0, take).join(' '), keys);
        if (hit != null) {
          return (itemId: hit, rest: args.sublist(take));
        }
      }
    }
    return null;
  }

  String? resolveRoomRef(String ref, Iterable<String> candidates) {
    final list = candidates.toList();
    final idx = int.tryParse(ref);
    if (idx != null && idx >= 1 && idx <= list.length) return list[idx - 1];
    final t = ref.toLowerCase().trim();
    for (final id in list) {
      if (id.toLowerCase() == t) return id;
      final rm = rooms[id];
      if (rm == null) continue;
      final name = rm.name.toLowerCase();
      if (name == t || name.contains(t) || t.contains(name)) return id;
    }
    return null;
  }

  List<String> visitedRoomIds() => rooms.entries
      .where((e) => e.value.visited)
      .map((e) => e.key)
      .toList();

  CommandResult _useTeleportScroll(List<String> destArgs) {
    if (inCombat) {
      return CommandResult.ok(messages.scrollCombatBlocked);
    }
    if (!hasItem('magic_scroll')) {
      return CommandResult.ok(messages.scrollNotOwned);
    }
    final visited = visitedRoomIds();
    if (destArgs.isEmpty) {
      final lines = <String>[
        messages.scrollPickDestination,
        messages.scrollUsageHint,
      ];
      for (var i = 0; i < visited.length; i++) {
        final id = visited[i];
        final name = rooms[id]?.name ?? id;
        final here = id == currentRoomId ? messages.scrollDestinationCurrent : '';
        lines.add('  ${i + 1}. $name ($id)$here');
      }
      return CommandResult.ok(lines.join('\n'));
    }

    final dest = resolveRoomRef(destArgs.join(' '), visited);
    if (dest == null) {
      return CommandResult.ok(messages.scrollDestinationInvalid);
    }
    if (dest == currentRoomId) {
      return CommandResult.ok(messages.scrollAlreadyHere(rooms[dest]!.name));
    }

    invRemove('magic_scroll');
    _recordRoomChange(dest);
    currentRoomId = dest;
    final nr = rooms[dest]!;
    if (!nr.visited) {
      nr.visited = true;
      visitOrder.add(dest);
    }

    var extra = '';
    if (nr.onEnter != null) {
      final r = nr.onEnter!(this);
      if (r != null && r.isNotEmpty) extra += '\n\n$r';
    }
    final combat = checkCombat();
    if (combat != null) extra += '\n\n$combat';

    final events = <GameEvent>[];
    if (inCombat) {
      events.add(GameEvent(
        type: GameEventType.battleRequested,
        enemyId: currentEnemy,
        roomId: currentRoomId,
      ));
    }
    score += 5;
    return CommandResult.ok(
      '${messages.scrollTeleportSuccess(nr.name)}\n${roomDescription(currentRoomId)}$extra',
      events: events,
    );
  }

  String _defaultHeal(ItemDefinition it) {
    if (it.heal > 0) {
      playerHp = min(playerMaxHp, playerHp + it.heal);
      return it.useMsg.isNotEmpty ? it.useMsg : messages.useHealDefault(it.heal);
    }
    return it.useMsg;
  }

  String equipBag(String iid) {
    final it = items[iid];
    if (it == null || it.type != ItemType.bag) {
      return messages.msg('equip_bag_not_bag', {'name': it?.name ?? iid});
    }
    if (iid == equippedBag) {
      return messages.msg('equip_bag_already', {'name': it.name});
    }
    final newCap = it.capacity > 0 ? it.capacity : maxWeight;
    if (totalWeight() > newCap) {
      return messages.msg('equip_bag_overweight', {
        'weight': totalWeight(),
        'name': it.name,
        'capacity': newCap,
      });
    }
    final oldId = equippedBag;
    equippedBag = iid;
    if (inventory.containsKey(iid)) invRemove(iid);
    if (oldId.isNotEmpty && items.containsKey(oldId)) invAdd(oldId);
    return messages.msg('equip_bag_success', {'name': it.name, 'capacity': newCap});
  }

  String doScp914() {
    if (currentRoomId != 'scp_914_chamber') return messages.msg('scp_914_wrong_room');
    final candidates = inventory.keys.where((iid) {
      if (iid == equippedBag) return false;
      final it = items[iid];
      return it != null && it.type != ItemType.bag;
    }).toList();
    if (candidates.isEmpty) return messages.msg('scp_914_empty');
    final iid = candidates[Random().nextInt(candidates.length)];
    final it = items[iid]!;
    invRemove(iid);
    final roll = Random().nextDouble();
    if (roll < 0.25) return messages.msg('scp_914_rough', {'name': it.name});
    if (roll < 0.5) {
      invAdd(iid);
      return messages.msg('scp_914_one_to_one', {'name': it.name});
    }
    if (roll < 0.8) {
      final out = items.containsKey('greater_potion') ? 'greater_potion' : 'lesser_potion';
      invAdd(out);
      score += 5;
      return messages.msg('scp_914_fine', {'name': it.name, 'out': items[out]!.name});
    }
    var out = Random().nextDouble() < 0.35 && items.containsKey('scp_500_pill') ? 'scp_500_pill' : 'anomaly_core';
    if (!items.containsKey(out)) out = 'diamond';
    invAdd(out);
    score += 15;
    return messages.msg('scp_914_very_fine', {'out': items[out]!.name});
  }

  String doScp294() {
    if (currentRoomId != 'scp_294_lounge') return messages.msg('scp_294_wrong_room');
    const heal = 18;
    playerHp = min(playerMaxHp, playerHp + heal);
    score += 2;
    return messages.msg('scp_294_heal', {'amount': heal});
  }

  String doScp261() {
    if (currentRoomId != 'scp_261_canteen') return messages.msg('scp_261_wrong_room');
    const cost = 5;
    if (gold < cost) return messages.msg('scp_261_need_gold', {'cost': cost, 'gold': gold});
    gold -= cost;
    final pool = ['scp_261_snack', 'bread', 'lesser_potion', 'old_coin', 'scp_447_slime']
        .where(items.containsKey)
        .toList();
    if (pool.isEmpty) return messages.msg('scp_261_jammed', {'cost': cost});
    final out = pool[Random().nextInt(pool.length)];
    invAdd(out);
    return messages.msg('scp_261_success', {'item': items[out]!.name, 'cost': cost});
  }

  String doTalk() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null || !npcs.containsKey(rm.npcId)) return messages.talkNoNpc;
    final n = npcs[rm.npcId]!;
    final lines = <String>[messages.talkNpcHeader(n.name, n.title), n.desc];
    if (!n.metBefore) {
      n.metBefore = true;
      lines.add('\n${n.name}：「${n.dialogs['greet'] ?? messages.talkGreetDefault}」');
      if (n.giveItem != null && items.containsKey(n.giveItem) && !inventory.containsKey(n.giveItem)) {
        invAdd(n.giveItem!);
        lines.add('\n${messages.talkNpcGiveItem(n.name, items[n.giveItem!]!.name)}');
        score += 5;
      }
    } else {
      lines.add('\n${n.name}：「${n.dialogs['extra'] ?? n.dialogs['farewell'] ?? messages.talkExtraDefault}」');
    }
    if (n.questItem != null && !n.questDone) {
      if (inventory.containsKey(n.questItem)) {
        invRemove(n.questItem!);
        if (n.questReward != null) {
          invAdd(n.questReward!);
          lines.add('\n${messages.talkQuestSubmitReward(items[n.questReward!]!.name)}');
        } else {
          lines.add('\n${messages.talkQuestSubmitThanks(n.name)}');
        }
        score += n.questScore;
        n.questDone = true;
        if (n.id == 'scp_079') {
          flags['scp_079_unlocked'] = true;
          lines.add('\n${messages.talkScp079Unlock}');
        }
      } else {
        final qi = items[n.questItem];
        if (qi != null) {
          lines.add('\n💬 ${n.name}：${n.dialogs['quest'] ?? messages.talkQuestAskDefault(qi.name)}');
        }
      }
    }
    if (n.id == 'dr_ellis' && n.questDone && !flags.containsKey('ellis_keycard')) {
      if (inventory.containsKey('site_ration')) {
        invRemove('site_ration');
        invAdd('keycard_lvl3');
        flags['ellis_keycard'] = true;
        flags['scp_079_unlocked'] = true;
        lines.add('\n${messages.msg('talk_ellis_keycard_given')}');
        score += 15;
      } else {
        lines.add('\n${messages.msg('talk_ellis_keycard_need_ration')}');
      }
    }
    if (n.id == 'wandering_merchant' && !flags.containsKey('merchant_favor')) {
      if (hasItem('fish') || hasItem('magic_herb')) {
        flags['merchant_favor'] = true;
        score += 5;
        lines.add('\n${messages.msg('talk_merchant_favor')}');
      }
    }
    if (n.id == 'village_elder' && flags.containsKey('bandit_cleared') && !flags.containsKey('elder_bandit_reward')) {
      flags['elder_bandit_reward'] = true;
      gold += 30;
      score += 20;
      lines.add('\n${messages.msg('talk_elder_bandit_reward')}');
    }
    if (n.id == 'hunter' && n.questDone && !flags.containsKey('hunter_tip')) {
      flags['hunter_tip'] = true;
      lines.add('\n${messages.msg('talk_hunter_tip')}');
    }
    if (n.type == NpcType.merchant || n.type == NpcType.blacksmith) {
      lines.add('\n${messages.msg('talk_trade_hint')}');
    }
    if (n.type == NpcType.healer) lines.add('\n${messages.msg('talk_heal_hint')}');
    return lines.join('\n');
  }

  bool _npcCanTrade(NpcState n) =>
      (n.type == NpcType.merchant || n.type == NpcType.blacksmith) &&
      n.tradeItems.isNotEmpty;

  String doTrade() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return messages.msg('trade_no_merchant');
    final n = npcs[rm.npcId]!;
    if (!_npcCanTrade(n)) return messages.msg('trade_npc_no_goods', {'name': n.name});
    final lines = <String>['\n${messages.msg('trade_header', {'name': n.name})}'];
    for (var i = 0; i < n.tradeItems.length; i++) {
      final (iid, price) = n.tradeItems[i];
      final it = items[iid];
      if (it != null) lines.add('  (${i + 1}) ${it.name} —— $price ${messages.msg('trade_gold_unit')}');
    }
    lines.add(messages.msg('trade_your_gold', {'gold': gold}));
    return lines.join('\n');
  }

  CommandResult doBuy(List<String> args) {
    if (args.isEmpty) return CommandResult.ok(messages.msg('buy_what'));
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return CommandResult.ok(messages.msg('trade_no_merchant'));
    final n = npcs[rm.npcId]!;
    if (!_npcCanTrade(n)) return CommandResult.ok(messages.msg('buy_not_merchant', {'name': n.name}));
    final name = args.join(' ');
    final idx = int.tryParse(name);
    if (idx != null && idx >= 1 && idx <= n.tradeItems.length) {
      final (iid, price) = n.tradeItems[idx - 1];
      final it = items[iid];
      if (it == null) return CommandResult.ok(messages.msg('buy_no_goods'));
      if (gold >= price) {
        gold -= price;
        invAdd(iid);
        return CommandResult.ok(messages.msg('buy_success', {'item': it.name, 'price': price}));
      }
      return CommandResult.ok(messages.msg('buy_need_gold', {'price': price, 'gold': gold}));
    }
    for (final (iid, price) in n.tradeItems) {
      final it = items[iid];
      if (it != null && (name == it.name || name == it.id)) {
        if (gold >= price) {
          gold -= price;
          invAdd(iid);
          return CommandResult.ok(messages.msg('buy_success', {'item': it.name, 'price': price}));
        }
        return CommandResult.ok(messages.msg('buy_need_gold', {'price': price, 'gold': gold}));
      }
    }
    return CommandResult.ok(messages.msg('buy_not_found', {'name': name}));
  }

  CommandResult doSell(List<String> args) {
    if (args.isEmpty) return CommandResult.ok(messages.msg('sell_what'));
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return CommandResult.ok(messages.msg('trade_no_merchant'));
    final n = npcs[rm.npcId]!;
    if (!_npcCanTrade(n)) return CommandResult.ok(messages.msg('sell_not_merchant', {'name': n.name}));
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
        return CommandResult.ok(messages.msg('sell_success', {'item': it.name, 'price': p}));
      }
      return CommandResult.ok(messages.msg('sell_refused'));
    }
    for (final iid in invList) {
      final it = items[iid];
      if (it != null && (name == it.name || name == it.id)) {
        if (n.buysTypes.contains(it.type)) {
          final p = max(2, it.value ~/ 2);
          invRemove(iid);
          gold += p;
          return CommandResult.ok(messages.msg('sell_success', {'item': it.name, 'price': p}));
        }
        return CommandResult.ok(messages.msg('sell_refused'));
      }
    }
    return CommandResult.ok(messages.msg('sell_not_found', {'name': name}));
  }

  String doHeal() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return messages.msg('heal_no_healer');
    final n = npcs[rm.npcId]!;
    if (n.type != NpcType.healer) return messages.msg('heal_cannot', {'name': n.name});
    const cost = 10;
    if (gold < cost) return messages.msg('heal_need_gold', {'cost': cost});
    gold -= cost;
    final h = rollDice(6, 3);
    playerHp = min(playerMaxHp, playerHp + h);
    return messages.msg('heal_success', {'name': n.name, 'amount': h, 'cost': cost});
  }

  String doAttackText() {
    if (!inCombat) return messages.combatNoEnemy;
    return messages.combatTurnModeHint;
  }

  CommandResult doFlee() {
    if (!inCombat) return CommandResult.ok(messages.msg('flee_no_combat'));
    final enc = activeEncounter;
    if (enc != null) {
      final hero = enc.allies.firstWhere((a) => a.isHero, orElse: () => enc.allies.first);
      submitCombatCommand(hero.instanceId, const CombatCommand.flee());
      if (enc.allAlliesCommanded) {
        final result = resolveCombatRound();
        if (result != null && result.fled) {
          return finishEncounter(CombatOutcome.fled);
        }
        return CommandResult.ok(messages.combatFleeFailed);
      }
      return CommandResult.ok(messages.combatFleeCommandPending);
    }
    if (Random().nextDouble() < 0.5) {
      return resolveCombatFleeSuccess();
    }
    final m = monsters[currentEnemy];
    return CommandResult.ok(messages.combatFleeFailedBlocked(m?.name ?? messages.msg('enemy_generic')));
  }

  String doRecruit() {
    final rm = rooms[currentRoomId]!;
    if (rm.npcId == null) return messages.msg('recruit_no_npc');
    const cm = {
      'old_hermit': 'companion_warrior',
      'wandering_rogue': 'companion_rogue',
      'priestess': 'companion_healer',
      'hunter': 'companion_scout',
      'bounty_hunter': 'companion_archer',
      'tower_librarian': 'companion_mage',
      'cave_hermit': 'companion_monk',
    };
    final cid = cm[rm.npcId];
    if (cid == null || !companions.containsKey(cid)) {
      return messages.msg('recruit_refused', {'name': npcs[rm.npcId]?.name ?? ''});
    }
    final c = companions[cid]!;
    if (c.recruited) return messages.msg('recruit_already', {'name': c.name});
    if (c.recruitItem != null && !inventory.containsKey(c.recruitItem)) {
      final needed = items[c.recruitItem];
      return messages.msg('recruit_need_item', {
        'name': c.name,
        'item': needed?.name ?? c.recruitItem,
      });
    }
    if (c.recruitItem != null) invRemove(c.recruitItem!);
    c.recruited = true;
    companionList.add(cid);
    rm.npcId = null;
    score += 20;
    return messages.msg('recruit_success', {
      'name': c.name,
      'msg': c.recruitDisplay(messages),
    });
  }

  String doParty() {
    if (companionList.isEmpty) return messages.msg('party_empty');
    final lines = <String>[messages.msg('party_header')];
    for (final cid in companionList) {
      final c = companions[cid];
      if (c == null) continue;
      final b = c.getBonus();
      lines.add(messages.msg('party_member_line', {
        'name': c.name,
        'role': c.role.name,
        'hp': c.hp,
        'max_hp': c.maxHp,
      }));
      lines.add(messages.msg('party_member_bonus', {
        'atk': b['dmg'],
        'def': b['def'],
      }));
      lines.add(messages.msg('party_member_ability', {'desc': c.abilityDesc}));
    }
    return lines.join('\n');
  }

  String doScore() {
    final cycle = ngCycle > 0 ? messages.msg('score_ng_cycle', {'cycle': ngCycle}) : '';
    final cleared = <String>[];
    if (won) cleared.add(messages.msg('score_clear_main'));
    if (siteWon) cleared.add(messages.msg('score_clear_site'));
    final ct = cleared.isNotEmpty
        ? messages.msg('score_cleared', {'list': cleared.join('+')})
        : '';
    return messages.msg('score_summary', {
      'score': score,
      'turns': turns,
      'cycle': cycle,
      'cleared': ct,
      'hp': playerHp,
      'max_hp': playerMaxHp,
      'atk': totalAtk,
      'def': totalDef,
      'gold': gold,
    });
  }

  String doNewGamePlus() {
    if (!won && !siteWon) return messages.msg('ng_plus_locked');
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
    return messages.msg('ng_plus_started', {'cycle': ngCycle});
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

  static const int deathScorePenalty = 100;
  static const String defaultReviveRoomId = 'forest_entrance';
  static const int saveVersion = 1;

  /// Penalize score, return to [previousRoomId], restore HP, and clear combat.
  void reviveAfterDeath() {
    score = max(0, score - deathScorePenalty);
    final dest = (previousRoomId != null && rooms.containsKey(previousRoomId))
        ? previousRoomId!
        : defaultReviveRoomId;
    currentRoomId = dest;
    playerHp = playerMaxHp;
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;
    gameOver = false;
  }

  /// Visited map layers for save-slot picker metadata.
  List<String> _layersVisitedForSave() {
    final layers = <MapLayer>{};
    for (final entry in rooms.entries) {
      if (!entry.value.visited) continue;
      final meta = mapMeta[entry.key];
      if (meta == null) continue;
      if (meta.layers != null) {
        layers.addAll(meta.layers!.keys);
      } else if (meta.layer != null) {
        layers.add(meta.layer!);
      }
    }
    const order = [
      MapLayer.surface,
      MapLayer.cave,
      MapLayer.tower,
      MapLayer.site,
    ];
    return order.where(layers.contains).map((l) => l.name).toList();
  }

  Map<String, dynamic> toSaveJson() {
    final now = DateTime.now().toUtc().toIso8601String();
    final layersVisited = _layersVisitedForSave();
    return {
      'version': saveVersion,
      'savedAt': now,
      'layersVisited': layersVisited,
      'currentRoomId': currentRoomId,
      'previousRoomId': previousRoomId,
      'turns': turns,
      'score': score,
      'gold': gold,
      'playerHp': playerHp,
      'playerMaxHp': playerMaxHp,
      'playerAtkBonus': playerAtkBonus,
      'playerDefBonus': playerDefBonus,
      'gameOver': gameOver,
      'won': won,
      'siteWon': siteWon,
      'ngCycle': ngCycle,
      'equippedBag': equippedBag,
      'flags': Map<String, dynamic>.from(flags),
      'inventory': Map<String, int>.from(inventory),
      'companionList': List<String>.from(companionList),
      'visitOrder': List<String>.from(visitOrder),
      'companions': {
        for (final e in companions.entries)
          e.key: {
            'hp': e.value.hp,
            'recruited': e.value.recruited,
          },
      },
      'rooms': {
        for (final e in rooms.entries)
          e.key: {
            'visited': e.value.visited,
            'items': List<String>.from(e.value.items),
            'exits': {
              for (final ex in e.value.exits.entries) ex.key.value: ex.value,
            },
          },
      },
      'monsters': {
        for (final e in monsters.entries)
          e.key: {
            'hp': e.value.hp,
            'maxHp': e.value.maxHp,
            'attack': e.value.attack,
            'alive': e.value.alive,
          },
      },
      'npcs': {
        for (final e in npcs.entries)
          e.key: {
            'questDone': e.value.questDone,
            'metBefore': e.value.metBefore,
          },
      },
    };
  }

  void applySaveJson(Map<String, dynamic> json) {
    if (json['version'] != saveVersion) {
      throw StateError('Unsupported save version: ${json['version']}');
    }
    currentRoomId = json['currentRoomId'] as String;
    previousRoomId = json['previousRoomId'] as String?;
    turns = (json['turns'] as num?)?.toInt() ?? 0;
    score = (json['score'] as num?)?.toInt() ?? 0;
    gold = (json['gold'] as num?)?.toInt() ?? 0;
    playerHp = (json['playerHp'] as num?)?.toInt() ?? playerMaxHp;
    playerMaxHp = (json['playerMaxHp'] as num?)?.toInt() ?? playerMaxHp;
    playerAtkBonus = (json['playerAtkBonus'] as num?)?.toInt() ?? 0;
    playerDefBonus = (json['playerDefBonus'] as num?)?.toInt() ?? 0;
    gameOver = json['gameOver'] as bool? ?? false;
    won = json['won'] as bool? ?? false;
    siteWon = json['siteWon'] as bool? ?? false;
    ngCycle = (json['ngCycle'] as num?)?.toInt() ?? 0;
    equippedBag = json['equippedBag'] as String? ?? equippedBag;

    flags
      ..clear()
      ..addAll((json['flags'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          {});

    inventory
      ..clear()
      ..addAll((json['inventory'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), (v as num).toInt()),
          ) ??
          {});

    companionList
      ..clear()
      ..addAll((json['companionList'] as List?)?.map((e) => e.toString()) ?? []);

    visitOrder
      ..clear()
      ..addAll((json['visitOrder'] as List?)?.map((e) => e.toString()) ?? []);

    final companionData = json['companions'] as Map<String, dynamic>? ?? {};
    for (final e in companionData.entries) {
      final c = companions[e.key];
      if (c == null) continue;
      final m = e.value as Map<String, dynamic>;
      c.hp = (m['hp'] as num?)?.toInt() ?? c.hp;
      c.recruited = m['recruited'] as bool? ?? c.recruited;
    }

    final roomData = json['rooms'] as Map<String, dynamic>? ?? {};
    for (final e in roomData.entries) {
      final rm = rooms[e.key];
      if (rm == null) continue;
      final m = e.value as Map<String, dynamic>;
      rm.visited = m['visited'] as bool? ?? rm.visited;
      rm.items = List<String>.from((m['items'] as List?)?.map((i) => i.toString()) ?? rm.items);
      final exitsRaw = m['exits'] as Map<String, dynamic>? ?? {};
      rm.exits
        ..clear()
        ..addAll({
          for (final ex in exitsRaw.entries)
            if (Direction.fromString(ex.key) != null)
              Direction.fromString(ex.key)!: ex.value.toString(),
        });
    }

    final monsterData = json['monsters'] as Map<String, dynamic>? ?? {};
    for (final e in monsterData.entries) {
      final m = monsters[e.key];
      if (m == null) continue;
      final data = e.value as Map<String, dynamic>;
      m.maxHp = (data['maxHp'] as num?)?.toInt() ?? m.maxHp;
      m.hp = (data['hp'] as num?)?.toInt() ?? m.hp;
      m.attack = (data['attack'] as num?)?.toInt() ?? m.attack;
      m.alive = data['alive'] as bool? ?? m.alive;
    }

    final npcData = json['npcs'] as Map<String, dynamic>? ?? {};
    for (final e in npcData.entries) {
      final n = npcs[e.key];
      if (n == null) continue;
      final data = e.value as Map<String, dynamic>;
      n.questDone = data['questDone'] as bool? ?? n.questDone;
      n.metBefore = data['metBefore'] as bool? ?? n.metBefore;
    }
  }

  CommandResult resolveCombatDefeat() {
    reviveAfterDeath();
    return CommandResult.ok(
      '\n${messages.combatDefeat(deathScorePenalty)}',
      events: const [GameEvent(type: GameEventType.gameOver), GameEvent(type: GameEventType.battleEnded)],
    );
  }

  CommandResult resolveCombatFleeSuccess() {
    inCombat = false;
    currentEnemy = '';
    activeEncounter = null;
    return CommandResult.ok(messages.combatFled, events: [const GameEvent(type: GameEventType.battleEnded)]);
  }

  int visitedCount() => rooms.values.where((r) => r.visited).length;
}
