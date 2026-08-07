import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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
      expect(
        session.rooms['haunted_graveyard']!.exits[Direction.east],
        'scp_site_gate',
      );
      expect(session.flags['grave_site_open'], isTrue);
      expect(msg, contains('魔法宝石'));
    });

    test('picking up gem in graveyard opens gate', () {
      session.rooms['haunted_graveyard']!.items.add('magic_gem');
      final result = session.processCommand('take magic_gem');
      expect(session.hasItem('magic_gem'), isTrue);
      expect(
        session.rooms['haunted_graveyard']!.exits[Direction.east],
        'scp_site_gate',
      );
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

    test('rewarded action refunds the death score penalty once', () async {
      final session = await GameSession.create(WorldRepository());
      session.score = 200;
      final controller = GameController()..session = session;

      controller.refundDeathPenaltyAfterReward();
      controller.refundDeathPenaltyAfterReward();

      expect(session.score, 200 + GameSession.deathScorePenalty);
      expect(controller.rewardedReviveUsed, isTrue);
    });

    test('combat gold bonus can only be granted once', () async {
      final session = await GameSession.create(WorldRepository());
      final controller = GameController()..session = session;
      controller.pendingCombatGoldBonus = 12;
      final before = session.gold;

      controller.grantCombatGoldBonus();
      controller.grantCombatGoldBonus();

      expect(session.gold, before + 12);
      expect(controller.pendingCombatGoldBonus, 0);
    });

    test('gold offer skips first three wins and respects cooldown', () async {
      final controller = GameController()..pendingCombatGoldBonus = 12;
      final base = DateTime(2026, 8, 7, 12);

      controller.combatVictoryCount = 3;
      expect(controller.shouldOfferCombatGoldBonus(now: base), isFalse);

      controller.combatVictoryCount = 6;
      expect(controller.shouldOfferCombatGoldBonus(now: base), isTrue);
      controller.markCombatGoldOfferShown(now: base);
      expect(
        controller.shouldOfferCombatGoldBonus(
          now: base.add(const Duration(minutes: 9)),
        ),
        isFalse,
      );
      expect(
        controller.shouldOfferCombatGoldBonus(
          now: base.add(const Duration(minutes: 10)),
        ),
        isTrue,
      );
    });

    test('rewarded revive is marked used until restart', () async {
      final session = await GameSession.create(WorldRepository());
      session.gameOver = true;
      session.playerHp = 0;
      final controller = GameController()..session = session;

      controller.refundDeathPenaltyAfterReward();
      expect(controller.rewardedReviveUsed, isTrue);

      controller.restartGame();
      expect(controller.rewardedReviveUsed, isFalse);
    });

    test('new game plus resets ad run limits', () async {
      final session = await GameSession.create(WorldRepository());
      session.won = true;
      final controller = GameController()
        ..session = session
        ..loading = false
        ..rewardedReviveUsed = true
        ..combatVictoryCount = 6
        ..pendingCombatGoldBonus = 12;

      await controller.executeCommand('ng+');

      expect(controller.rewardedReviveUsed, isFalse);
      expect(controller.combatVictoryCount, 0);
      expect(controller.pendingCombatGoldBonus, 0);
    });

    test(
      'completeMainJourney sets won and mainClear when dragon dead',
      () async {
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
      },
    );
  });
}
