enum GameEventType {
  battleRequested,
  battleEnded,
  mainWinAnnounced,
  siteWinAnnounced,
  gameOver,
  newVisit,
  returnToTitle,
}

class GameEvent {
  final GameEventType type;
  final String? enemyId;
  final String? roomId;

  const GameEvent({
    required this.type,
    this.enemyId,
    this.roomId,
  });
}

class CommandResult {
  final String text;
  final List<GameEvent> events;
  final bool incrementTurn;

  const CommandResult({
    required this.text,
    this.events = const [],
    this.incrementTurn = true,
  });

  static CommandResult ok(String text, {List<GameEvent> events = const [], bool incrementTurn = true}) =>
      CommandResult(text: text, events: events, incrementTurn: incrementTurn);
}
