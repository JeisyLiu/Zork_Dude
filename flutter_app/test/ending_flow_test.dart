import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SCP gate requires magic gem', () {
    late GameSession session;

    setUp(() async {
      session = await GameSession.create(WorldRepository());
      session.currentRoomId = 'haunted_graveyard';
    });

    test('east exit closed without magic gem', () {
      final rm = session.rooms['haunted_graveyard']!;
      expect(rm.exits.containsKey(Direction.east), isFalse);
      expect(session.flags.containsKey('grave_site_open'), isFalse);
    });

    test('magic gem opens east exit on enter', () {
      session.invAdd('magic_gem');
      final msg = session.rooms['haunted_graveyard']!.onEnter?.call(session);
      expect(session.rooms['haunted_graveyard']!.exits[Direction.east], 'scp_site_gate');
      expect(session.flags['grave_site_open'], isTrue);
      expect(msg, contains('魔法宝石'));
    });

    test('picking up gem in graveyard opens gate', () {
      session.rooms['haunted_graveyard']!.items.add('magic_gem');
      final result = session.processCommand('take magic_gem');
      expect(session.hasItem('magic_gem'), isTrue);
      expect(session.rooms['haunted_graveyard']!.exits[Direction.east], 'scp_site_gate');
      expect(result.text, contains('魔法宝石'));
    });
  });

  group('Ending state', () {
    test('defeat sets gameOver pending ending', () async {
      final session = await GameSession.create(WorldRepository());
      final controller = GameController();
      controller.session = session;
      controller.finishCombat(CombatOutcome.defeat);
      expect(controller.pendingEnding, EndingKind.gameOver);
    });

    test('completeMainJourney sets won and mainClear when dragon dead', () async {
      final session = await GameSession.create(WorldRepository());
      session.invAdd('magic_gem');
      final dragon = session.monster('dragon_whelp');
      dragon!.alive = false;
      dragon.hp = 0;

      final controller = GameController();
      controller.session = session;
      controller.completeMainJourney();

      expect(session.won, isTrue);
      expect(session.currentRoomId, 'tower_top');
      expect(session.hasItem('magic_gem'), isTrue);
      expect(controller.pendingEnding, EndingKind.mainClear);
    });
  });
}
