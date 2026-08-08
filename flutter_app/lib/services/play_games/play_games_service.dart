import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';
import 'package:zork_dude/services/play_games/achievement_outbox.dart';
import 'package:zork_dude/services/play_games/play_games_ids.dart';
import 'package:zork_dude/state/ending_kind.dart';

/// Silent Play Games sign-in, local outbox, and deferred achievement/score sync.
final class PlayGamesService extends ChangeNotifier {
  PlayGamesService._();

  static final instance = PlayGamesService._();

  bool _initializing = false;
  bool _initialized = false;
  bool _signedIn = false;
  bool _flushing = false;
  AchievementOutbox? _outbox;
  StreamSubscription<PlayerData?>? _playerSub;

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool get signedIn => _signedIn;

  Future<void> initialize() async {
    if (!isSupported || _initializing || _initialized) return;
    _initializing = true;
    try {
      _outbox = await AchievementOutbox.load();
      _playerSub = GameAuth.player.listen(
        _onPlayerChanged,
        onError: (_) => _setSignedIn(false),
      );
      _initialized = true;
      unawaited(_silentSignIn());
    } catch (_) {
      // Local-only mode when platform plugins are unavailable.
    } finally {
      _initializing = false;
    }
  }

  void _onPlayerChanged(PlayerData? player) {
    final wasSignedIn = _signedIn;
    _setSignedIn(player != null);
    if (!wasSignedIn && _signedIn) {
      unawaited(flush());
    }
  }

  void _setSignedIn(bool value) {
    if (_signedIn == value) return;
    _signedIn = value;
    notifyListeners();
  }

  Future<void> _silentSignIn() async {
    if (!isSupported) return;
    try {
      await GameAuth.signIn();
    } catch (_) {
      // Player can still play; achievements stay in local outbox.
    }
  }

  /// User-initiated connect from home screen.
  Future<bool> connect() async {
    if (!isSupported) return false;
    try {
      await GameAuth.signIn();
      final signedIn = await GameAuth.isSignedIn.timeout(
        const Duration(seconds: 8),
        onTimeout: () => _signedIn,
      );
      _setSignedIn(signedIn);
      if (signedIn) await flush();
      return signedIn;
    } catch (_) {
      return false;
    }
  }

  Future<AchievementOutbox?> _ensureOutbox() async {
    if (_outbox != null) return _outbox;
    try {
      _outbox = await AchievementOutbox.load();
      return _outbox;
    } catch (_) {
      return null;
    }
  }

  Future<void> onEnding(EndingKind kind) async {
    final localId = switch (kind) {
      EndingKind.dragonClear => PlayGamesLocalId.endingDragon,
      EndingKind.siteClear => PlayGamesLocalId.endingSite,
      EndingKind.mainClear => PlayGamesLocalId.endingMain,
      _ => null,
    };
    if (localId == null) return;
    await unlockLocal(localId);
  }

  Future<void> onNewGamePlus() async {
    await unlockLocal(PlayGamesLocalId.ngPlus);
  }

  Future<void> onCombatVictory() async {
    final outbox = await _ensureOutbox();
    if (outbox == null) return;

    final total = await outbox.addCareerVictory();
    if (total >= 1) {
      await unlockLocal(PlayGamesLocalId.firstVictory);
    }
    await _syncIncremental(
      PlayGamesLocalId.battles10,
      total,
      PlayGamesLocalId.incrementalTargets[PlayGamesLocalId.battles10]!,
    );
    await _syncIncremental(
      PlayGamesLocalId.battles25,
      total,
      PlayGamesLocalId.incrementalTargets[PlayGamesLocalId.battles25]!,
    );
  }

  /// Evaluate exploration / quest / party / score milestones from session state.
  Future<void> evaluateSession(PlayGamesSessionSnapshot snap) async {
    if (snap.currentRoomId != 'forest_entrance' || snap.visitedCount > 1) {
      await unlockLocal(PlayGamesLocalId.awaken);
    }
    if (snap.hasCompletedQuest) {
      await unlockLocal(PlayGamesLocalId.firstQuest);
    }
    if (snap.recruitedCount >= 1) {
      await unlockLocal(PlayGamesLocalId.firstRecruit);
    }
    if (snap.recruitedCount >= PlayGamesSessionSnapshot.companionTotal) {
      await unlockLocal(PlayGamesLocalId.fullParty);
    }
    if (snap.hasVisitedCave) {
      await unlockLocal(PlayGamesLocalId.enterCave);
    }
    if (snap.hasVisitedTower) {
      await unlockLocal(PlayGamesLocalId.enterTower);
    }
    if (snap.siteGateOpen) {
      await unlockLocal(PlayGamesLocalId.siteGate);
    }
    if (snap.hasVisitedSite) {
      await unlockLocal(PlayGamesLocalId.enterSite);
    }
    if (snap.visitedCount >= 20) {
      await unlockLocal(PlayGamesLocalId.explore20);
    }
    if (snap.visitedCount >= 40) {
      await unlockLocal(PlayGamesLocalId.explore40);
    }
    if (snap.score >= 1000) {
      await unlockLocal(PlayGamesLocalId.score1000);
    }
    await submitBestScore(snap.score);
  }

  Future<void> unlockLocal(String localId) async {
    final outbox = await _ensureOutbox();
    if (outbox == null) return;
    final already = outbox.isUnlocked(localId);
    await outbox.markUnlocked(localId);
    if (_signedIn && (!already || !(outbox.achievements[localId]?.pushed ?? false))) {
      await _pushAchievement(localId);
    }
  }

  Future<void> submitBestScore(int score) async {
    if (score < 0) return;
    final outbox = await _ensureOutbox();
    if (outbox == null) return;
    await outbox.recordBestScore(score);
    if (_signedIn && outbox.shouldPushScore(score)) {
      await _pushScore(score);
    }
  }

  Future<void> flush() async {
    if (!isSupported || !_signedIn || _flushing) return;
    final outbox = await _ensureOutbox();
    if (outbox == null) return;

    _flushing = true;
    try {
      for (final entry in outbox.pendingAchievements.toList()) {
        await _pushAchievement(entry.key);
      }
      // Re-sync incremental progress even if already marked unlocked locally.
      final wins = outbox.careerVictories;
      for (final entry in PlayGamesLocalId.incrementalTargets.entries) {
        await _syncIncremental(entry.key, wins, entry.value);
      }
      final best = outbox.leaderboard.best;
      if (outbox.shouldPushScore(best)) {
        await _pushScore(best);
      }
    } finally {
      _flushing = false;
    }
  }

  Future<bool> showAchievements() async {
    if (!isSupported || !_signedIn) return false;
    try {
      await Achievements.showAchievements();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> showLeaderboards() async {
    if (!isSupported || !_signedIn) return false;
    final androidId = PlayGamesIds.leaderboardAndroidId(
      PlayGamesLocalId.highScore,
    );
    if (androidId == null) return false;
    try {
      await Leaderboards.showLeaderboards(androidLeaderboardID: androidId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _syncIncremental(String localId, int absolute, int maxSteps) async {
    final outbox = await _ensureOutbox();
    if (outbox == null) return;

    final capped = absolute.clamp(0, maxSteps);
    if (capped >= maxSteps) {
      await outbox.markUnlocked(localId);
    }

    if (!_signedIn || !isSupported) return;

    final androidId = PlayGamesIds.achievementAndroidId(localId);
    if (androidId == null) return;

    final alreadyPushed = outbox.pushedStepsFor(localId);
    final delta = capped - alreadyPushed;
    if (delta <= 0) {
      if (capped >= maxSteps) {
        final rec = outbox.achievements[localId];
        if (rec != null && !rec.pushed) await outbox.markPushed(localId);
      }
      return;
    }

    try {
      await Achievements.increment(
        achievement: Achievement(androidID: androidId, steps: delta),
      );
      await outbox.markIncrementalPushed(localId, capped);
      if (capped >= maxSteps) {
        await outbox.markUnlocked(localId);
        await outbox.markPushed(localId);
      }
    } catch (_) {
      // Keep pending for a later flush attempt.
    }
  }

  Future<void> _pushAchievement(String localId) async {
    final outbox = _outbox;
    if (outbox == null || !_signedIn) return;
    final androidId = PlayGamesIds.achievementAndroidId(localId);
    if (androidId == null) return;

    if (PlayGamesIds.isIncremental(localId)) {
      final max = PlayGamesLocalId.incrementalTargets[localId]!;
      await _syncIncremental(localId, outbox.careerVictories, max);
      return;
    }

    try {
      await Achievements.unlock(
        achievement: Achievement(androidID: androidId),
      );
      await outbox.markPushed(localId);
    } catch (_) {
      // Keep pending for a later flush attempt.
    }
  }

  Future<void> _pushScore(int score) async {
    final outbox = _outbox;
    if (outbox == null || !_signedIn) return;
    final androidId = PlayGamesIds.leaderboardAndroidId(
      PlayGamesLocalId.highScore,
    );
    if (androidId == null) return;
    try {
      await Leaderboards.submitScore(
        score: Score(androidLeaderboardID: androidId, value: score),
      );
      await outbox.markScorePushed(score);
    } catch (_) {
      // Keep pending for a later flush attempt.
    }
  }

  @override
  void dispose() {
    unawaited(_playerSub?.cancel());
    super.dispose();
  }
}
