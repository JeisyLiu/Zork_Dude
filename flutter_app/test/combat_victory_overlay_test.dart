import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_reward.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/ui/combat/combat_victory_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CombatReward settlement', () {
    test('victory builds structured reward with loot and currency', () async {
      final session = await GameSession.create(WorldRepository());
      session.processCommand('w');
      expect(session.inCombat, isTrue);

      final result = session.resolveEncounterVictory();
      expect(result.text, contains('击败'));
      final reward = session.lastCombatReward;
      expect(reward, isNotNull);
      expect(reward!.defeatedNames, isNotEmpty);
      expect(reward.exp, greaterThan(0));
    });

    test('finishEncounter victory stores lastCombatReward', () async {
      final session = await GameSession.create(WorldRepository());
      session.processCommand('w');
      session.finishEncounter(CombatOutcome.victory);
      expect(session.lastCombatReward, isNotNull);
      expect(session.inCombat, isFalse);
    });
  });

  testWidgets('CombatVictoryOverlay shows rewards and dismisses on tap',
      (tester) async {
    var continued = false;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: CombatVictoryOverlay(
            reward: const CombatReward(
              defeatedNames: ['巨鼠'],
              lootLabels: ['🧀 奶酪'],
              gold: 5,
              exp: 10,
            ),
            onContinue: () => continued = true,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('战斗胜利'), findsOneWidget);
    expect(find.text('巨鼠'), findsOneWidget);
    expect(find.textContaining('奶酪'), findsOneWidget);
    expect(find.textContaining('金币'), findsOneWidget);
    expect(find.text('点击继续'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.tap(find.byType(CombatVictoryOverlay));
    await tester.pump();
    expect(continued, isTrue);
  });
}
