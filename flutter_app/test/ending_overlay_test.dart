import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/ui/ending/credits_roll.dart';
import 'package:zork_dude/ui/ending/ending_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EndingOverlay renders with animations disabled', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: EndingOverlay(
            kind: EndingKind.gameOver,
            onPrimary: _noop,
            onSecondary: _noop,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('你倒下了'), findsOneWidget);
    expect(find.text('在上一地点醒来'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CreditsRoll shows static list when animations disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(home: CreditsRoll(onFinished: _noop)),
      ),
    );
    await tester.pump();
    expect(find.text('Beatinghouse'), findsOneWidget);
    expect(find.text('Jeisy Liu'), findsWidgets);
    expect(find.text('Anysphere, xAI'), findsOneWidget);
    expect(find.text('继续探索'), findsWidgets);
  });

  testWidgets('game over reward action matches ending card style', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(667, 375));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: EndingOverlay(
            kind: EndingKind.gameOver,
            onPrimary: _noop,
            onRewarded: () async => false,
            rewardLabel: '观看广告 · 挽回损失',
            rewardSubLabel: '返还 100 分',
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('观看广告 · 挽回损失'), findsOneWidget);
    expect(find.text('返还 100 分'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
