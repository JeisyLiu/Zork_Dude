import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/ui/home/home_enter_transition.dart';
import 'package:zork_dude/ui/home/home_hero_art.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeEnterTransition skips when animations disabled', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Scaffold(
            body: HomeEnterTransition(onCompleted: () => completed = true),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(completed, isTrue);
  });

  testWidgets('HomeEnterTransition completes after mist animation', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeEnterTransition(onCompleted: () => completed = true),
        ),
      ),
    );
    await tester.pump();
    expect(completed, isFalse);

    await tester.pump(const Duration(milliseconds: 400));
    expect(completed, isFalse);

    await tester.pump(const Duration(milliseconds: 500));
    expect(completed, isTrue);
  });

  testWidgets('HomeHeroArt stays static when animations disabled', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: HomeHeroArt(size: 120)),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(HomeHeroArt), findsOneWidget);
  });
}
