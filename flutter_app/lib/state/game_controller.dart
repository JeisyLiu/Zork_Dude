import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/combat_reward.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/services/play_games/achievement_outbox.dart';
import 'package:zork_dude/services/play_games/play_games_service.dart';
import 'package:zork_dude/state/ending_kind.dart';

class LogEntry {
  final String text;
  final bool isCommand;

  const LogEntry({required this.text, this.isCommand = false});
}

class GameController extends ChangeNotifier {
  GameController({SaveRepository? saveRepository})
    : _saveRepo = saveRepository ?? SaveRepository();

  static const _commandThrottle = Duration(milliseconds: 280);

  final SaveRepository _saveRepo;
  bool hasSave = false;
  int? activeSlot;
  List<SaveSlotInfo?> slots = List<SaveSlotInfo?>.filled(
    SaveRepository.maxSlots,
    null,
  );

  GameSession? session;
  final List<LogEntry> log = [];
  bool mapVisible = true;
  MapLayer mapLayer = MapLayer.surface;
  bool mapListMode = false;
  bool loading = true;
  String? error;
  bool battleNavigationPending = false;
  EndingKind pendingEnding = EndingKind.none;
  CombatReward? lastCombatReward;
  int pendingCombatGoldBonus = 0;
  int combatVictoryCount = 0;
  bool rewardedReviveUsed = false;
  DateTime? _lastGoldOfferAt;
  bool pendingReturnToTitle = false;
  bool developerMode = false;
  bool _commandBusy = false;
  DateTime? _lastCommandAt;

  bool get commandBusy => _commandBusy;

  /// Clears throttle/busy state for widget tests (real-time clock vs fake pump).
  @visibleForTesting
  void resetCommandGateForTest() {
    _commandBusy = false;
    _lastCommandAt = null;
  }

  void consumePendingEnding() {
    pendingEnding = EndingKind.none;
    notifyListeners();
  }

  bool consumePendingReturnToTitle() {
    if (!pendingReturnToTitle) return false;
    pendingReturnToTitle = false;
    notifyListeners();
    return true;
  }

  Future<void> prepareReturnToTitle() async {
    final s = session;
    if (s == null) return;
    s.inCombat = false;
    s.currentEnemy = '';
    s.activeEncounter = null;
    s.gameOver = false;
    pendingEnding = EndingKind.none;
    battleNavigationPending = false;
    lastCombatReward = null;
    await _persist();
    notifyListeners();
  }

  Future<void> refreshSlots() async {
    try {
      await _saveRepo.migrateIfNeeded();
      slots = await _saveRepo.listSlots();
      hasSave = slots.any((s) => s != null);
      activeSlot ??= await _saveRepo.getActiveSlot();
    } catch (_) {
      hasSave = false;
    }
    notifyListeners();
  }

  int get occupiedCount => slots.where((s) => s != null).length;

  int? get soleOccupiedIndex {
    int? found;
    for (var i = 0; i < slots.length; i++) {
      if (slots[i] == null) continue;
      if (found != null) return null;
      found = i;
    }
    return found;
  }

  int? get firstEmptyIndex {
    for (var i = 0; i < slots.length; i++) {
      if (slots[i] == null) return i;
    }
    return null;
  }

  Future<void> init() async {
    try {
      loading = true;
      notifyListeners();
      await refreshSlots();
      if (kDebugMode) {
        try {
          final prefs = await SharedPreferences.getInstance();
          developerMode = prefs.getBool('developer_mode') ?? false;
        } catch (_) {
          developerMode = false;
        }
      } else {
        developerMode = false;
      }
      session = await GameSession.create(WorldRepository());
      log.clear();
      _append(session!.roomDescription(session!.currentRoomId));
      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> continueGame({required int slot}) async {
    try {
      loading = true;
      notifyListeners();
      final data = await _saveRepo.loadSlot(slot);
      if (data == null) {
        await refreshSlots();
        loading = false;
        notifyListeners();
        return;
      }
      activeSlot = slot;
      await _saveRepo.setActiveSlot(slot);
      session = await GameSession.create(
        WorldRepository(),
        starterItems: false,
      );
      session!.applySaveJson(data);
      log.clear();
      pendingEnding = EndingKind.none;
      battleNavigationPending = false;
      lastCombatReward = null;
      syncMapLayerToPlayer();
      _append('═══ 继续旅程 ═══');
      _append(session!.roomDescription(session!.currentRoomId));
      loading = false;
      notifyListeners();
      unawaited(_persist());
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> startNewGame({required int slot}) async {
    try {
      loading = true;
      notifyListeners();
      activeSlot = slot;
      session = await GameSession.create(WorldRepository());
      log.clear();
      pendingEnding = EndingKind.none;
      battleNavigationPending = false;
      lastCombatReward = null;
      mapLayer = MapLayer.surface;
      _append(session!.roomDescription(session!.currentRoomId));
      await _saveRepo.saveSlot(slot, session!);
      await refreshSlots();
      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final s = session;
    if (s == null) return;
    try {
      var slot = activeSlot;
      slot ??= soleOccupiedIndex ?? firstEmptyIndex ?? 0;
      activeSlot = slot;
      await _saveRepo.saveSlot(slot, s);
      await refreshSlots();
    } catch (_) {
      // Autosave unavailable (e.g. widget tests without platform plugins).
    }
    _syncPlayGamesProgress();
  }

  void _syncPlayGamesProgress() {
    final s = session;
    if (s == null) return;
    unawaited(
      PlayGamesService.instance.evaluateSession(_playGamesSnapshot(s)),
    );
  }

  void _notifyPlayGamesEnding(EndingKind kind) {
    unawaited(PlayGamesService.instance.onEnding(kind));
  }

  PlayGamesSessionSnapshot _playGamesSnapshot(GameSession s) {
    var cave = false;
    var tower = false;
    var site = false;
    for (final entry in s.rooms.entries) {
      if (!entry.value.visited) continue;
      switch (mapLayerOfRoom(entry.key, s.mapMeta)) {
        case MapLayer.cave:
          cave = true;
        case MapLayer.tower:
          tower = true;
        case MapLayer.site:
          site = true;
        case MapLayer.surface:
          break;
      }
    }
    return PlayGamesSessionSnapshot(
      currentRoomId: s.currentRoomId,
      visitedCount: s.visitedCount(),
      score: s.score,
      siteGateOpen: s.flags.containsKey('grave_site_open'),
      hasVisitedCave: cave,
      hasVisitedTower: tower,
      hasVisitedSite: site,
      recruitedCount: s.companions.values.where((c) => c.recruited).length,
      hasCompletedQuest: s.npcs.values.any((n) => n.questDone),
    );
  }

  void reviveFromDeath() {
    final s = session;
    if (s == null) return;
    if (s.gameOver || s.inCombat) {
      s.reviveAfterDeath();
    }
    notifyListeners();
  }

  void toggleMap() {
    if (!_canAcceptCommand()) return;
    _lastCommandAt = DateTime.now();
    mapVisible = !mapVisible;
    notifyListeners();
  }

  /// Players may only view layers with at least one visited room.
  /// Developer mode can switch to any layer (with full reveal in the map UI).
  bool canViewMapLayer(MapLayer layer) {
    if (developerMode) return true;
    final s = session;
    if (s == null) return layer == MapLayer.surface;
    return MapService().visitedOnLayer(s, layer).isNotEmpty;
  }

  void setMapLayer(MapLayer layer) {
    if (!canViewMapLayer(layer)) return;
    if (mapLayer == layer) return;
    mapLayer = layer;
    notifyListeners();
  }

  void setMapListMode(bool list) {
    mapListMode = list;
    notifyListeners();
  }

  void syncMapLayerToPlayer() {
    final s = session;
    if (s == null) return;
    mapLayer = mapLayerOfRoom(s.currentRoomId, s.mapMeta);
  }

  void _clampMapLayerToAccessible() {
    if (canViewMapLayer(mapLayer)) return;
    syncMapLayerToPlayer();
  }

  bool _canAcceptCommand() {
    final s = session;
    if (loading ||
        s == null ||
        s.gameOver ||
        battleNavigationPending ||
        _commandBusy) {
      return false;
    }
    final last = _lastCommandAt;
    if (last != null && DateTime.now().difference(last) < _commandThrottle) {
      return false;
    }
    return true;
  }

  Future<void> setDeveloperMode(bool value) async {
    if (!kDebugMode) return;
    developerMode = value;
    if (!value) _clampMapLayerToAccessible();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('developer_mode', value);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> toggleDeveloperMode() async {
    await setDeveloperMode(!developerMode);
  }

  Future<void> executeCommand(String raw, {bool echo = true}) async {
    if (!_canAcceptCommand()) return;
    final s = session!;
    _commandBusy = true;
    _lastCommandAt = DateTime.now();
    notifyListeners();
    try {
      if (echo) _append('> $raw', isCommand: true);
      final lowered = raw.trim().toLowerCase();
      if (lowered == 'quit' || lowered == 'exit') {
        pendingReturnToTitle = true;
        return;
      }
      if (lowered == 'map' || lowered == 'm') {
        mapVisible = !mapVisible;
        _append(mapVisible ? '已显示迷雾残页。' : '已隐藏迷雾残页。');
        return;
      }
      if (kDebugMode && (lowered == 'dev' || lowered == 'developer')) {
        await toggleDeveloperMode();
        _append('开发者模式：${developerMode ? '开' : '关'}');
        return;
      }
      final wasWon = s.won;
      final startsNewGamePlus =
          (s.won || s.siteWon) &&
          const {'ng+', 'newgame+', 'ngplus'}.contains(lowered);
      final result = s.processCommand(raw);
      _handleResult(result, wasWonBefore: wasWon);
      if (startsNewGamePlus) {
        _resetAdRunState();
        unawaited(PlayGamesService.instance.onNewGamePlus());
      }
    } finally {
      _commandBusy = false;
      notifyListeners();
    }
  }

  Future<void> move(Direction dir) async {
    await executeCommand(dir.value, echo: true);
  }

  Future<void> moveToRoom(String roomId) async {
    final s = session;
    if (s == null || s.inCombat) return;
    final dir = MapService().exitDirTo(s, roomId);
    if (dir != null) await move(dir);
  }

  void _handleResult(CommandResult result, {bool wasWonBefore = false}) {
    if (result.text.isNotEmpty) _append(result.text);
    for (final event in result.events) {
      switch (event.type) {
        case GameEventType.battleRequested:
          battleNavigationPending = true;
        case GameEventType.battleEnded:
          battleNavigationPending = false;
        case GameEventType.newVisit:
          syncMapLayerToPlayer();
        case GameEventType.gameOver:
          pendingEnding = EndingKind.gameOver;
        case GameEventType.returnToTitle:
          pendingReturnToTitle = true;
        case GameEventType.mainWinAnnounced:
        case GameEventType.siteWinAnnounced:
          break;
      }
    }
    final s = session!;
    if (s.won && !wasWonBefore && pendingEnding != EndingKind.mainClear) {
      pendingEnding = EndingKind.mainClear;
      _notifyPlayGamesEnding(EndingKind.mainClear);
    }
    if (s.won && !s.flags.containsKey('main_win_announced')) {
      s.flags['main_win_announced'] = true;
      _append('\n🎉 主线通关！你找回了所有记忆，打破了迷雾诅咒！');
      _append('可继续探索基金会收容站点，或使用 ng+ 开启二周目。');
    }
    if (s.siteWon && !s.flags.containsKey('site_win_announced')) {
      s.flags['site_win_announced'] = true;
      _append('\n☢️ 站点最终BOSS已击败！站点行动完成！');
      _append('可继续自由探索，或使用 ng+ 开启二周目。');
    }
    if (s.playerHp <= 0) {
      s.reviveAfterDeath();
      pendingEnding = EndingKind.gameOver;
      _append('\n💀 你死了……得分 -${GameSession.deathScorePenalty}（不低于 0）');
      unawaited(_persist());
    } else {
      unawaited(_persist());
    }
    notifyListeners();
  }

  void applyCombatResult(CommandResult result) {
    final wasWon = session?.won ?? false;
    _handleResult(result, wasWonBefore: wasWon);
  }

  CombatEncounter? get activeEncounter => session?.activeEncounter;

  bool submitCombatCommand(String actorInstanceId, CombatCommand command) {
    final s = session;
    if (s == null) return false;
    final ok = s.submitCombatCommand(actorInstanceId, command);
    if (ok) notifyListeners();
    return ok;
  }

  bool beginMelee() {
    final s = session;
    if (s == null) return false;
    final ok = s.beginMelee();
    if (ok) notifyListeners();
    return ok;
  }

  bool prepareNextMeleeRound() {
    final s = session;
    if (s == null) return false;
    final ok = s.prepareNextMeleeRound();
    notifyListeners();
    return ok;
  }

  void cancelMelee() {
    session?.cancelMelee();
    notifyListeners();
  }

  CombatRoundResult? resolveCombatRound() {
    final s = session;
    if (s == null) return null;
    final result = s.resolveCombatRound();
    if (result != null) notifyListeners();
    return result;
  }

  void finishCombat(CombatOutcome outcome) {
    final s = session;
    if (s == null) return;
    final defeatedIds = _collectDefeatedMonsterIds(s, outcome);
    applyCombatResult(s.finishEncounter(outcome));
    lastCombatReward = outcome == CombatOutcome.victory
        ? s.lastCombatReward
        : null;
    final defeatedBoss = defeatedIds.any(
      (id) => s.monsters[id]?.rank == MonsterRank.boss,
    );
    if (outcome == CombatOutcome.victory) {
      combatVictoryCount += 1;
      unawaited(PlayGamesService.instance.onCombatVictory());
    }
    pendingCombatGoldBonus = outcome == CombatOutcome.victory && !defeatedBoss
        ? (lastCombatReward?.gold ?? 0)
        : 0;
    _classifyCombatEnding(outcome, defeatedIds);
    unawaited(_persist());
  }

  bool shouldOfferCombatGoldBonus({DateTime? now}) {
    if (pendingCombatGoldBonus <= 0 ||
        combatVictoryCount <= 3 ||
        combatVictoryCount % 3 != 0) {
      return false;
    }
    final clock = now ?? DateTime.now();
    return _lastGoldOfferAt == null ||
        clock.difference(_lastGoldOfferAt!) >= const Duration(minutes: 10);
  }

  void markCombatGoldOfferShown({DateTime? now}) {
    _lastGoldOfferAt = now ?? DateTime.now();
  }

  void grantCombatGoldBonus() {
    final s = session;
    if (s == null || pendingCombatGoldBonus <= 0) return;
    final bonus = pendingCombatGoldBonus;
    pendingCombatGoldBonus = 0;
    s.gold += bonus;
    _append('\n✨ 迷雾馈赠：额外获得 $bonus 金币。');
    unawaited(_persist());
    notifyListeners();
  }

  void declineCombatGoldBonus() => pendingCombatGoldBonus = 0;

  void refundDeathPenaltyAfterReward() {
    final s = session;
    if (s == null || rewardedReviveUsed) return;
    rewardedReviveUsed = true;
    s.score += GameSession.deathScorePenalty;
    _append('\n🔥 微光挽回了本次死亡损失，返还 ${GameSession.deathScorePenalty} 分。');
    unawaited(_persist());
    notifyListeners();
  }

  CombatReward? takeLastCombatReward() {
    final reward = lastCombatReward;
    lastCombatReward = null;
    session?.lastCombatReward = null;
    return reward;
  }

  List<String> _collectDefeatedMonsterIds(
    GameSession s,
    CombatOutcome outcome,
  ) {
    if (outcome != CombatOutcome.victory) return const [];
    final enc = s.activeEncounter;
    final ids = <String>{};
    if (enc != null) {
      for (final e in enc.defeatedEnemies()) {
        ids.add(e.templateId);
      }
      for (final e in enc.enemies.where((e) => !e.alive)) {
        ids.add(e.templateId);
      }
    }
    if (ids.isEmpty && s.currentEnemy.isNotEmpty) {
      ids.add(s.currentEnemy);
    }
    return ids.toList();
  }

  void _classifyCombatEnding(CombatOutcome outcome, List<String> defeatedIds) {
    if (outcome == CombatOutcome.defeat) {
      pendingEnding = EndingKind.gameOver;
      notifyListeners();
      return;
    }
    if (outcome != CombatOutcome.victory) return;
    if (defeatedIds.contains('scp_001')) {
      pendingEnding = EndingKind.siteClear;
      _notifyPlayGamesEnding(EndingKind.siteClear);
    } else if (defeatedIds.contains('dragon_whelp')) {
      pendingEnding = EndingKind.dragonClear;
      _notifyPlayGamesEnding(EndingKind.dragonClear);
    }
    notifyListeners();
  }

  void completeMainJourney() {
    final s = session;
    if (s == null) return;
    s.currentRoomId = 'tower_top';
    final tower = s.rooms['tower_top'];
    if (tower != null) tower.visited = true;
    syncMapLayerToPlayer();
    final dragon = s.monster('dragon_whelp');
    if (s.hasItem('magic_gem') && dragon != null && !dragon.alive) {
      s.won = true;
      pendingEnding = EndingKind.mainClear;
      _notifyPlayGamesEnding(EndingKind.mainClear);
      if (!s.flags.containsKey('main_win_announced')) {
        s.flags['main_win_announced'] = true;
        _append('\n🎉 宝石在塔顶共鸣，记忆涌回——迷雾诅咒随之消散！');
        _append('可继续探索基金会收容站点，或使用 ng+ 开启二周目。');
      }
    } else {
      _append('你回到了塔顶。宝石仍在手中，等待被嵌入书桌凹槽。');
    }
    notifyListeners();
  }

  void restartGame() {
    final s = session;
    if (s == null) return;
    s.populateWorld(starterItems: true);
    log.clear();
    pendingEnding = EndingKind.none;
    battleNavigationPending = false;
    lastCombatReward = null;
    _resetAdRunState();
    mapLayer = MapLayer.surface;
    _append(s.roomDescription(s.currentRoomId));
    unawaited(_persist());
    notifyListeners();
  }

  void _resetAdRunState() {
    pendingCombatGoldBonus = 0;
    combatVictoryCount = 0;
    rewardedReviveUsed = false;
    _lastGoldOfferAt = null;
  }

  List<({String id, String label, int heal, int count, String effectHint})>
  combatUsableItems() {
    return session?.combatUsableItems() ?? const [];
  }

  List<TurnOrderEntry> previewCombatTurnOrder() {
    return session?.previewCombatTurnOrder() ?? const [];
  }

  StatusEffectRegistry get statusEffectRegistry =>
      session?.statusEffects ?? StatusEffectRegistry.fromSpecs(const []);

  void consumeCombatItem(String itemId) {
    session?.consumeCombatItem(itemId);
    notifyListeners();
  }

  void _append(String text, {bool isCommand = false}) {
    if (text.trim().isEmpty) return;
    log.add(LogEntry(text: text, isCommand: isCommand));
  }
}
