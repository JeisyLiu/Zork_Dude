import 'package:flutter/foundation.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_engine.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/state/ending_kind.dart';

class LogEntry {
  final String text;
  final bool isCommand;

  const LogEntry({required this.text, this.isCommand = false});
}

class GameController extends ChangeNotifier {
  GameController();

  static const _commandThrottle = Duration(milliseconds: 280);

  GameSession? session;
  final List<LogEntry> log = [];
  bool mapVisible = true;
  MapLayer mapLayer = MapLayer.surface;
  bool mapListMode = false;
  bool loading = true;
  String? error;
  bool battleNavigationPending = false;
  EndingKind pendingEnding = EndingKind.none;
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

  Future<void> init() async {
    try {
      loading = true;
      notifyListeners();
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

  void toggleMap() {
    if (!_canAcceptCommand()) return;
    _lastCommandAt = DateTime.now();
    mapVisible = !mapVisible;
    notifyListeners();
  }

  void setMapLayer(MapLayer layer) {
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

  bool _canAcceptCommand() {
    final s = session;
    if (loading || s == null || s.gameOver || battleNavigationPending || _commandBusy) {
      return false;
    }
    final last = _lastCommandAt;
    if (last != null && DateTime.now().difference(last) < _commandThrottle) {
      return false;
    }
    return true;
  }

  Future<void> executeCommand(String raw, {bool echo = true}) async {
    if (!_canAcceptCommand()) return;
    final s = session!;
    _commandBusy = true;
    _lastCommandAt = DateTime.now();
    notifyListeners();
    try {
      if (echo) _append('> $raw', isCommand: true);
      if (raw.trim().toLowerCase() == 'map' || raw.trim().toLowerCase() == 'm') {
        mapVisible = !mapVisible;
        _append(mapVisible ? '已显示迷雾残页。' : '已隐藏迷雾残页。');
        return;
      }
      final wasWon = s.won;
      final result = s.processCommand(raw);
      _handleResult(result, wasWonBefore: wasWon);
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
        case GameEventType.mainWinAnnounced:
        case GameEventType.siteWinAnnounced:
          break;
      }
    }
    final s = session!;
    if (s.won && !wasWonBefore && pendingEnding != EndingKind.mainClear) {
      pendingEnding = EndingKind.mainClear;
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
    if (s.playerHp <= 0 && !s.gameOver) {
      s.gameOver = true;
      pendingEnding = EndingKind.gameOver;
      _append('\n💀 你死了……');
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
    _classifyCombatEnding(outcome, defeatedIds);
  }

  List<String> _collectDefeatedMonsterIds(GameSession s, CombatOutcome outcome) {
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
    } else if (defeatedIds.contains('dragon_whelp')) {
      pendingEnding = EndingKind.dragonClear;
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
    mapLayer = MapLayer.surface;
    _append(s.roomDescription(s.currentRoomId));
    notifyListeners();
  }

  List<({String id, String label, int heal, int count, String effectHint})> combatUsableItems() {
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
