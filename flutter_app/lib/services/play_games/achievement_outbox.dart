import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Device-level pending Play Games sync state (not tied to save slots).
final class AchievementOutbox {
  AchievementOutbox._(this._prefs);

  static const _achievementsKey = 'pgs_achievements_v1';
  static const _leaderboardKey = 'pgs_leaderboard_high_score_v1';

  static Future<AchievementOutbox> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AchievementOutbox._(prefs);
  }

  final SharedPreferences _prefs;
  Map<String, AchievementRecord>? _achievements;
  LeaderboardRecord? _leaderboard;

  Map<String, AchievementRecord> get achievements {
    _achievements ??= _decodeAchievements(_prefs.getString(_achievementsKey));
    return _achievements!;
  }

  LeaderboardRecord get leaderboard {
    _leaderboard ??= _decodeLeaderboard(_prefs.getString(_leaderboardKey));
    return _leaderboard!;
  }

  Future<void> markUnlocked(String localId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = achievements[localId];
    if (existing != null) return;
    achievements[localId] = AchievementRecord(unlockedAt: now, pushed: false);
    await _persistAchievements();
  }

  Future<void> markPushed(String localId) async {
    final record = achievements[localId];
    if (record == null) return;
    achievements[localId] = record.copyWith(pushed: true);
    await _persistAchievements();
  }

  Iterable<MapEntry<String, AchievementRecord>> get pendingAchievements =>
      achievements.entries.where((e) => !e.value.pushed);

  /// Returns true when [score] is a new local best.
  Future<bool> recordBestScore(int score) async {
    final lb = leaderboard;
    if (score <= lb.best) return false;
    _leaderboard = LeaderboardRecord(best: score, pushedBest: lb.pushedBest);
    await _persistLeaderboard();
    return true;
  }

  Future<void> markScorePushed(int score) async {
    final lb = leaderboard;
    _leaderboard = LeaderboardRecord(
      best: lb.best,
      pushedBest: score > lb.pushedBest ? score : lb.pushedBest,
    );
    await _persistLeaderboard();
  }

  bool shouldPushScore(int score) => score > leaderboard.pushedBest;

  Future<void> _persistAchievements() async {
    final payload = achievements.map(
      (id, record) => MapEntry(id, record.toJson()),
    );
    await _prefs.setString(_achievementsKey, jsonEncode(payload));
  }

  Future<void> _persistLeaderboard() async {
    await _prefs.setString(_leaderboardKey, jsonEncode(leaderboard.toJson()));
  }

  static Map<String, AchievementRecord> _decodeAchievements(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (id, value) => MapEntry(
          id,
          AchievementRecord.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  static LeaderboardRecord _decodeLeaderboard(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const LeaderboardRecord(best: 0, pushedBest: 0);
    }
    try {
      return LeaderboardRecord.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const LeaderboardRecord(best: 0, pushedBest: 0);
    }
  }
}

final class AchievementRecord {
  const AchievementRecord({required this.unlockedAt, required this.pushed});

  final int unlockedAt;
  final bool pushed;

  AchievementRecord copyWith({bool? pushed}) =>
      AchievementRecord(unlockedAt: unlockedAt, pushed: pushed ?? this.pushed);

  Map<String, dynamic> toJson() => {
    'unlockedAt': unlockedAt,
    'pushed': pushed,
  };

  factory AchievementRecord.fromJson(Map<String, dynamic> json) =>
      AchievementRecord(
        unlockedAt: (json['unlockedAt'] as num?)?.toInt() ?? 0,
        pushed: json['pushed'] as bool? ?? false,
      );
}

final class LeaderboardRecord {
  const LeaderboardRecord({required this.best, required this.pushedBest});

  final int best;
  final int pushedBest;

  Map<String, dynamic> toJson() => {'best': best, 'pushedBest': pushedBest};

  factory LeaderboardRecord.fromJson(Map<String, dynamic> json) =>
      LeaderboardRecord(
        best: (json['best'] as num?)?.toInt() ?? 0,
        pushedBest: (json['pushedBest'] as num?)?.toInt() ?? 0,
      );
}
