import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

late GameController sharedController;

Future<void> pumpExploration(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(
    MaterialApp(
      theme: GameUiTheme.appTheme(),
      home: MediaQuery(
        data: MediaQueryData(size: size, disableAnimations: true),
        child: GameSkinScope(
          skin: GameUiSkin.fantasy,
          child: ExplorationScreen(controller: sharedController),
        ),
      ),
    ),
  );
  await tester.pump();
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sharedController = GameController();
    await sharedController.init();
  });

  tearDownAll(() {
    sharedController.dispose();
  });

  testWidgets('More overlay uses right rail width on phone landscape', (tester) async {
    const size = Size(667, 375);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExploration(tester, size);
    final more = find.byKey(const Key('quick-command-more'));
    await tester.ensureVisible(more);
    await tester.tap(more);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);

    final panelBox = tester.renderObject<RenderBox>(
      find.byKey(LandscapeOverlay.panelKey),
    );
    final expectedWidth = LandscapeLayout.overlayPanelWidth(size);
    expect(panelBox.size.width, closeTo(expectedWidth, 1));
    expect(panelBox.size.width, greaterThanOrEqualTo(LandscapeLayout.overlaySideMinWidth));
    expect(panelBox.size.width, lessThanOrEqualTo(LandscapeLayout.overlaySideMaxWidth));
    expect(find.text('帮助'), findsWidgets);
  });

  testWidgets('Target picker overlay fits phone landscape without overflow', (tester) async {
    const size = Size(667, 375);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.binding.setSurfaceSize(size);
    await tester.pumpWidget(
      MaterialApp(
        theme: GameUiTheme.appTheme(),
        home: MediaQuery(
          data: MediaQueryData(size: size, disableAnimations: true),
          child: GameSkinScope(
            skin: GameUiSkin.fantasy,
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: Semantics(
                    button: true,
                    label: '打开浮层',
                    child: GameButton(
                      label: '打开',
                      semanticLabel: '打开浮层',
                      width: 120,
                      height: LandscapeLayout.heightFromWidth(120),
                      onPressed: () => LandscapeOverlay.show<void>(
                        context: context,
                        title: '使用 use',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GameButton(
                              width: 88,
                              height: LandscapeLayout.heightFromWidth(88),
                              label: '(1) 面包',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('打开浮层'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.textContaining('使用'), findsWidgets);

    final panelBox = tester.renderObject<RenderBox>(
      find.byKey(LandscapeOverlay.panelKey),
    );
    expect(panelBox.size.width, closeTo(LandscapeLayout.overlayPanelWidth(size), 1));
  });

  testWidgets('More overlay is centered dialog on tablet landscape', (tester) async {
    const size = Size(1280, 720);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExploration(tester, size);
    final more = find.byKey(const Key('quick-command-more'));
    await tester.ensureVisible(more);
    await tester.tap(more);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(LandscapeLayout.useCenteredOverlay(size), isTrue);

    final panelBox = tester.renderObject<RenderBox>(
      find.byKey(LandscapeOverlay.panelKey),
    );
    expect(panelBox.size.width, closeTo(LandscapeLayout.overlayCenterMaxWidth, 1));
  });
}
