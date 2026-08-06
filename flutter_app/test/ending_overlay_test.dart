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
    expect(find.text('重新开始'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CreditsRoll shows static list when animations disabled', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: CreditsRoll(onFinished: _noop),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Beatinghouse'), findsOneWidget);
    expect(find.text('Jeisy Liu'), findsWidgets);
    expect(find.text('Anysphere, xAI'), findsOneWidget);
    expect(find.text('继续探索'), findsWidgets);
  });
}

void _noop() {}
