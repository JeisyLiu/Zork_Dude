import 'dart:io';

/// Syncs Play Games resource IDs from games-ids.xml into play_games_ids.dart.
///
/// Usage (from flutter_app/):
///   1. Replace android/app/src/main/res/values/games-ids.xml with Console export
///   2. dart run tool/apply_pgs_ids.dart
void main() {
  final root = Directory.current;
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Run from flutter_app directory');
    exit(1);
  }

  final xmlPath = 'android/app/src/main/res/values/games-ids.xml';
  final dartPath = 'lib/services/play_games/play_games_ids.dart';
  final xmlFile = File(xmlPath);
  if (!xmlFile.existsSync()) {
    stderr.writeln('Missing $xmlPath');
    exit(1);
  }

  final xml = xmlFile.readAsStringSync();
  final appId = _readString(xml, 'app_id');
  final achievements = <String, String>{};
  final leaderboards = <String, String>{};

  const achievementMap = {
    'achievement_awaken': 'awaken',
    'achievement_first_victory': 'first_victory',
    'achievement_first_recruit': 'first_recruit',
    'achievement_first_quest': 'first_quest',
    'achievement_enter_cave': 'enter_cave',
    'achievement_enter_tower': 'enter_tower',
    'achievement_site_gate': 'site_gate',
    'achievement_enter_site': 'enter_site',
    'achievement_explore_20': 'explore_20',
    'achievement_explore_40': 'explore_40',
    'achievement_battles_10': 'battles_10',
    'achievement_battles_25': 'battles_25',
    'achievement_ending_dragon': 'ending_dragon',
    'achievement_ending_site': 'ending_site',
    'achievement_ending_main': 'ending_main',
    'achievement_full_party': 'full_party',
    'achievement_ng_plus': 'ng_plus',
    'achievement_score_1000': 'score_1000',
  };

  for (final entry in achievementMap.entries) {
    final id = _readString(xml, entry.key);
    if (id != null) achievements[entry.value] = id;
  }

  final lb = _readString(xml, 'leaderboard_high_score');
  if (lb != null) leaderboards['high_score'] = lb;

  if (appId == null || appId.contains('PLACEHOLDER') || appId == '000000000000') {
    stderr.writeln('app_id still placeholder — paste Console export first');
    exit(1);
  }

  final placeholders = [
    ...achievements.values,
    ...leaderboards.values,
  ].where((id) => id.contains('PLACEHOLDER')).toList();
  if (placeholders.isNotEmpty) {
    stderr.writeln('Still has placeholders: $placeholders');
    exit(1);
  }

  _writeDart(dartPath, achievements, leaderboards);
  stdout.writeln('Updated $dartPath (${achievements.length} achievements, ${leaderboards.length} leaderboards)');
  stdout.writeln('app_id: $appId (in games-ids.xml only)');
}

String? _readString(String xml, String name) {
  final re = RegExp(
    '<string\\s+name="$name"[^>]*>([^<]+)</string>',
  );
  final m = re.firstMatch(xml);
  return m?.group(1)?.trim();
}

void _writeDart(
  String path,
  Map<String, String> achievements,
  Map<String, String> leaderboards,
) {
  final achLines = achievements.entries
      .map((e) => "    PlayGamesLocalId.${_dartKey(e.key)}: '${e.value}',")
      .join('\n');
  final lbLines = leaderboards.entries
      .map((e) => "    PlayGamesLocalId.${_dartKey(e.key)}: '${e.value}',")
      .join('\n');

  // Keep PlayGamesLocalId in separate file - read original structure
  final original = File(path).readAsStringSync();
  if (!original.contains('abstract final class PlayGamesLocalId')) {
    stderr.writeln('Unexpected $path structure');
    exit(1);
  }

  final localIdEnd = original.indexOf('/// Maps local IDs to Android resource IDs');
  if (localIdEnd < 0) {
    stderr.writeln('Cannot find PlayGamesIds section in $path');
    exit(1);
  }

  final header = original.substring(0, localIdEnd);
  final newContent = '''$header/// Maps local IDs to Android resource IDs from Play Console.
/// Synced by: dart run tool/apply_pgs_ids.dart
abstract final class PlayGamesIds {
  static const androidAchievements = <String, String>{
$achLines
  };

  static const androidLeaderboards = <String, String>{
$lbLines
  };

  static String? achievementAndroidId(String localId) =>
      androidAchievements[localId];

  static String? leaderboardAndroidId(String localId) =>
      androidLeaderboards[localId];

  static bool isIncremental(String localId) =>
      PlayGamesLocalId.incrementalTargets.containsKey(localId);
}
''';

  File(path).writeAsStringSync(newContent);
}

String _dartKey(String localId) {
  const map = {
    'explore_20': 'explore20',
    'explore_40': 'explore40',
    'battles_10': 'battles10',
    'battles_25': 'battles25',
    'ending_dragon': 'endingDragon',
    'ending_main': 'endingMain',
    'ending_site': 'endingSite',
    'first_victory': 'firstVictory',
    'first_recruit': 'firstRecruit',
    'first_quest': 'firstQuest',
    'enter_cave': 'enterCave',
    'enter_tower': 'enterTower',
    'site_gate': 'siteGate',
    'enter_site': 'enterSite',
    'full_party': 'fullParty',
    'ng_plus': 'ngPlus',
    'score_1000': 'score1000',
    'high_score': 'highScore',
  };
  return map[localId] ?? localId;
}
