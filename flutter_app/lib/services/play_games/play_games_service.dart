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

  Future<void> unlockLocal(String localId) async {
    final outbox = _outbox;
    if (outbox == null) {
      try {
        _outbox = await AchievementOutbox.load();
      } catch (_) {
        return;
      }
    }
    await _outbox!.markUnlocked(localId);
    if (_signedIn) {
      await _pushAchievement(localId);
    }
  }

  Future<void> submitBestScore(int score) async {
    if (score < 0) return;
    final outbox = _outbox;
    if (outbox == null) {
      try {
        _outbox = await AchievementOutbox.load();
      } catch (_) {
        return;
      }
    }
    await _outbox!.recordBestScore(score);
    if (_signedIn && _outbox!.shouldPushScore(score)) {
      await _pushScore(score);
    }
  }

  Future<void> flush() async {
    if (!isSupported || !_signedIn || _flushing) return;
    final outbox = _outbox;
    if (outbox == null) return;

    _flushing = true;
    try {
      for (final entry in outbox.pendingAchievements.toList()) {
        await _pushAchievement(entry.key);
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

  Future<void> _pushAchievement(String localId) async {
    final outbox = _outbox;
    if (outbox == null || !_signedIn) return;
    final androidId = PlayGamesIds.achievementAndroidId(localId);
    if (androidId == null) return;
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
