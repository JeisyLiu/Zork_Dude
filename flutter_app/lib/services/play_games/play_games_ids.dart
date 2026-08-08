/// Local logical IDs for Play Games achievements and leaderboards.
abstract final class PlayGamesLocalId {
  // Early game
  static const awaken = 'awaken';
  static const firstVictory = 'first_victory';
  static const firstRecruit = 'first_recruit';
  static const firstQuest = 'first_quest';

  // Mid game exploration
  static const enterCave = 'enter_cave';
  static const enterTower = 'enter_tower';
  static const siteGate = 'site_gate';
  static const enterSite = 'enter_site';
  static const explore20 = 'explore_20';
  static const explore40 = 'explore_40';

  // Incremental combat
  static const battles10 = 'battles_10';
  static const battles25 = 'battles_25';

  // Endings
  static const endingDragon = 'ending_dragon';
  static const endingMain = 'ending_main';
  static const endingSite = 'ending_site';

  // Late / rare
  static const fullParty = 'full_party';
  static const ngPlus = 'ng_plus';
  static const score1000 = 'score_1000';

  static const highScore = 'high_score';

  /// Incremental achievements and their Console step totals.
  static const incrementalTargets = <String, int>{
    battles10: 10,
    battles25: 25,
  };

  static const allAchievements = <String>[
    awaken,
    firstVictory,
    firstRecruit,
    firstQuest,
    enterCave,
    enterTower,
    siteGate,
    enterSite,
    explore20,
    explore40,
    battles10,
    battles25,
    endingDragon,
    endingMain,
    endingSite,
    fullParty,
    ngPlus,
    score1000,
  ];
}

/// Maps local IDs to Android resource IDs from Play Console.
/// Replace placeholders after PGS setup.
abstract final class PlayGamesIds {
  static const androidAchievements = <String, String>{
    PlayGamesLocalId.awaken: 'CgkI_PLACEHOLDER_AWAKEN',
    PlayGamesLocalId.firstVictory: 'CgkI_PLACEHOLDER_FIRST_VICTORY',
    PlayGamesLocalId.firstRecruit: 'CgkI_PLACEHOLDER_FIRST_RECRUIT',
    PlayGamesLocalId.firstQuest: 'CgkI_PLACEHOLDER_FIRST_QUEST',
    PlayGamesLocalId.enterCave: 'CgkI_PLACEHOLDER_ENTER_CAVE',
    PlayGamesLocalId.enterTower: 'CgkI_PLACEHOLDER_ENTER_TOWER',
    PlayGamesLocalId.siteGate: 'CgkI_PLACEHOLDER_SITE_GATE',
    PlayGamesLocalId.enterSite: 'CgkI_PLACEHOLDER_ENTER_SITE',
    PlayGamesLocalId.explore20: 'CgkI_PLACEHOLDER_EXPLORE_20',
    PlayGamesLocalId.explore40: 'CgkI_PLACEHOLDER_EXPLORE_40',
    PlayGamesLocalId.battles10: 'CgkI_PLACEHOLDER_BATTLES_10',
    PlayGamesLocalId.battles25: 'CgkI_PLACEHOLDER_BATTLES_25',
    PlayGamesLocalId.endingDragon: 'CgkI_PLACEHOLDER_DRAGON',
    PlayGamesLocalId.endingSite: 'CgkI_PLACEHOLDER_SITE',
    PlayGamesLocalId.endingMain: 'CgkI_PLACEHOLDER_MAIN',
    PlayGamesLocalId.fullParty: 'CgkI_PLACEHOLDER_FULL_PARTY',
    PlayGamesLocalId.ngPlus: 'CgkI_PLACEHOLDER_NG_PLUS',
    PlayGamesLocalId.score1000: 'CgkI_PLACEHOLDER_SCORE_1000',
  };

  static const androidLeaderboards = <String, String>{
    PlayGamesLocalId.highScore: 'CgkI_PLACEHOLDER_LEADERBOARD',
  };

  static String? achievementAndroidId(String localId) =>
      androidAchievements[localId];

  static String? leaderboardAndroidId(String localId) =>
      androidLeaderboards[localId];

  static bool isIncremental(String localId) =>
      PlayGamesLocalId.incrementalTargets.containsKey(localId);
}
