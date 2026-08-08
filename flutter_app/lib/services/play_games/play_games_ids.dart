/// Local logical IDs for Play Games achievements and leaderboards.
abstract final class PlayGamesLocalId {
  static const endingDragon = 'ending_dragon';
  static const endingSite = 'ending_site';
  static const endingMain = 'ending_main';
  static const highScore = 'high_score';
}

/// Maps local IDs to Android resource IDs from Play Console.
/// Replace placeholders after PGS setup.
abstract final class PlayGamesIds {
  static const androidAchievements = <String, String>{
    PlayGamesLocalId.endingDragon: 'CgkI_PLACEHOLDER_DRAGON',
    PlayGamesLocalId.endingSite: 'CgkI_PLACEHOLDER_SITE',
    PlayGamesLocalId.endingMain: 'CgkI_PLACEHOLDER_MAIN',
  };

  static const androidLeaderboards = <String, String>{
    PlayGamesLocalId.highScore: 'CgkI_PLACEHOLDER_LEADERBOARD',
  };

  static String? achievementAndroidId(String localId) =>
      androidAchievements[localId];

  static String? leaderboardAndroidId(String localId) =>
      androidLeaderboards[localId];
}
