import 'package:flutter/foundation.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';
import 'package:zork_dude/domain/map_service.dart';

class LogEntry {
  final String text;
  final bool isCommand;

  const LogEntry({required this.text, this.isCommand = false});
}

class GameController extends ChangeNotifier {
  GameController();

  GameSession? session;
  final List<LogEntry> log = [];
  bool mapVisible = true;
  MapLayer mapLayer = MapLayer.surface;
  bool mapListMode = false;
  bool loading = true;
  String? error;
  bool battleNavigationPending = false;

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

  Future<void> executeCommand(String raw, {bool echo = true}) async {
    final s = session;
    if (s == null || s.gameOver) return;
    if (echo) _append('> $raw', isCommand: true);
    if (raw.trim().toLowerCase() == 'map' || raw.trim().toLowerCase() == 'm') {
      toggleMap();
      _append(mapVisible ? '已显示迷雾残页。' : '已隐藏迷雾残页。');
      return;
    }
    final result = s.processCommand(raw);
    _handleResult(result);
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

  void _handleResult(CommandResult result) {
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
          break;
        case GameEventType.mainWinAnnounced:
        case GameEventType.siteWinAnnounced:
          break;
      }
    }
    final s = session!;
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
      _append('\n💀 你死了……');
    }
    notifyListeners();
  }

  void applyCombatResult(CommandResult result) {
    _handleResult(result);
  }

  CombatEncounter? get activeEncounter => session?.activeEncounter;

  bool submitCombatCommand(String actorInstanceId, CombatCommand command) {
    final s = session;
    if (s == null) return false;
    final ok = s.submitCombatCommand(actorInstanceId, command);
    if (ok) notifyListeners();
    return ok;
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
    applyCombatResult(s.finishEncounter(outcome));
  }

  List<({String id, String label, int heal})> combatUsableItems() {
    return session?.combatUsableItems() ?? const [];
  }

  void consumeCombatItem(String itemId) {
    session?.consumeCombatItem(itemId);
    notifyListeners();
  }

  void _append(String text, {bool isCommand = false}) {
    if (text.trim().isEmpty) return;
    log.add(LogEntry(text: text, isCommand: isCommand));
  }
}