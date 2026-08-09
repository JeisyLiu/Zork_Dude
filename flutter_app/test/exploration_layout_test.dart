import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/widgets/mist_map_panel.dart';
import 'package:zork_dude/widgets/quick_commands.dart';
import 'package:zork_dude/widgets/story_log.dart';
import 'test_l10n.dart';

late GameController sharedController;

Future<void> pumpExplorationScreen(
  WidgetTester tester,
  Size size, {
  EdgeInsets padding = EdgeInsets.zero,
}) async {
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(
    materialAppWithL10n(
      theme: GameUiTheme.appTheme(),
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          padding: padding,
          disableAnimations: true,
        ),
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

ScrollController? storyLogScrollController(WidgetTester tester) {
  final listView = tester.widget<ListView>(
    find.descendant(
      of: find.byType(StoryLogView),
      matching: find.byType(ListView),
    ),
  );
  return listView.controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sharedController = GameController();
    await sharedController.init();
  });

  setUp(() {
    sharedController.resetCommandGateForTest();
  });

  tearDownAll(() {
    sharedController.dispose();
  });

  for (final size in const [
    Size(667, 375),
    Size(800, 360),
    Size(800, 450),
    Size(853, 384),
    Size(853, 480),
    Size(854, 480),
    Size(914, 411),
    Size(915, 412),
    Size(960, 432),
    Size(1067, 480),
    Size(1280, 720),
    Size(1600, 900),
    Size(1920, 1080),
  ]) {
    testWidgets('Exploration layout fits ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpExplorationScreen(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.byType(ExplorationScreen), findsOneWidget);
      expect(find.text('查看'), findsWidgets);
      expect(find.text('丢弃'), findsWidgets);
      expect(find.text('更多'), findsWidgets);
      expect(find.text('发送'), findsNothing);
      if (LandscapeLayout.showCommandInput) {
        expect(find.byType(DirectionPad), findsOneWidget);
      } else {
        expect(find.byType(FloatingMovePad), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(QuickCommandPanel),
            matching: find.byType(DirectionPad),
          ),
          findsNothing,
        );
      }
    });
  }

  testWidgets('Phone landscape keeps map panel visible at 853x384', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const size = Size(853, 384);
    await pumpExplorationScreen(tester, size);

    expect(tester.takeException(), isNull);
    expect(find.byType(MistMapPanel), findsOneWidget);

    final mapBox = tester.renderObject<RenderBox>(
      find.byType(MistMapPanel),
    );
    expect(mapBox.size.width, greaterThanOrEqualTo(120));
  });

  testWidgets('Phone landscape keeps map panel visible at 800x360', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const size = Size(800, 360);
    await pumpExplorationScreen(tester, size);

    expect(tester.takeException(), isNull);
    expect(find.byType(MistMapPanel), findsOneWidget);

    final mapBox = tester.renderObject<RenderBox>(
      find.byType(MistMapPanel),
    );
    expect(mapBox.size.width, greaterThanOrEqualTo(120));
  });

  testWidgets('Android exploration hides command input row', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(853, 384));

      expect(tester.takeException(), isNull);
      expect(LandscapeLayout.showCommandInput, isFalse);
      expect(find.bySemanticsLabel('发送命令'), findsNothing);
      expect(find.byType(MistMapPanel), findsOneWidget);
      expect(find.byType(FloatingMovePad), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(QuickCommandPanel),
          matching: find.byType(DirectionPad),
        ),
        findsNothing,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Android short landscape has no overflow at 800x360', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(800, 360));

      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel('发送命令'), findsNothing);
      expect(find.byType(MistMapPanel), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('20:9 landscape keeps 16:9 play canvas and short uiScale', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExplorationScreen(tester, const Size(914, 411));
    final scale = _uiScale(tester);
    final playCtx = tester.element(find.byType(QuickCommandPanel));

    expect(scale, lessThan(0.75));
    expect(scale, greaterThanOrEqualTo(LandscapeLayout.scaleMinShort));
    expect(
      LandscapeLayout.aspectRatioOf(playCtx),
      closeTo(LandscapeLayout.designAspect, 0.02),
    );
    expect(LandscapeLayout.isUltrawideOf(playCtx), isFalse);
  });

  testWidgets('20:9 with SafeArea padding has no overflow', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(
        tester,
        const Size(1067, 480),
        padding: const EdgeInsets.fromLTRB(48, 0, 48, 24),
      );

      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel('发送命令'), findsNothing);
      expect(find.byType(MistMapPanel), findsOneWidget);
      expect(_uiScale(tester), lessThan(0.75));
      expect(
        LandscapeLayout.aspectRatioOf(
          tester.element(find.byType(QuickCommandPanel)),
        ),
        closeTo(LandscapeLayout.designAspect, 0.02),
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Chip width grows with wider 16:9 dock', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const small = Size(800, 450);
    const large = Size(1280, 720);

    await pumpExplorationScreen(tester, small);
    final smallChip = _chipWidth(tester);

    await pumpExplorationScreen(tester, large);
    final largeChip = _chipWidth(tester);

    expect(largeChip, greaterThan(smallChip));
    expect(smallChip, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget * 0.85));
  });

  testWidgets('Single-row chips fill dock width at 1280x720', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(1280, 720));
      final chip = _chipWidth(tester);
      expect(chip, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget * 0.85));
      expect(find.byType(FloatingMovePad), findsNothing);
      expect(
        find.descendant(
          of: find.byType(QuickCommandPanel),
          matching: find.byType(VerticalUpDownPad),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(VerticalUpDownPad),
          matching: find.text('U'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(VerticalUpDownPad),
          matching: find.text('D'),
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Tips:'), findsNothing);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Primary panel exposes eight chips and more-sheet trade commands', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(1280, 720));

      expect(find.text('治疗'), findsWidgets);
      expect(find.text('丢弃'), findsWidgets);
      expect(find.text('更多'), findsWidgets);
      expect(find.text('商品'), findsNothing);
      expect(find.text('购买'), findsNothing);
      expect(find.text('出售'), findsNothing);
      expect(find.text('招募'), findsNothing);

      await tester.tap(find.byKey(const Key('quick-command-more')));
      await tester.pumpAndSettle();

      expect(find.text('商品'), findsOneWidget);
      expect(find.text('购买'), findsOneWidget);
      expect(find.text('出售'), findsOneWidget);
      expect(find.text('招募'), findsOneWidget);
      expect(find.text('回标题'), findsOneWidget);
      expect(find.text('队伍'), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Story log scrolls to latest entry after command', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(1280, 720));

      await tester.enterText(find.byType(TextField), 'look');
      await tester.tap(find.bySemanticsLabel('发送命令'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final scroll = storyLogScrollController(tester);
      expect(scroll, isNotNull);
      expect(scroll!.hasClients, isTrue);
      expect(scroll.offset, scroll.position.maxScrollExtent);
      expect(find.textContaining('look'), findsWidgets);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Command input submits via icon and ignores empty text', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(1280, 720));

      expect(find.bySemanticsLabel('发送命令'), findsOneWidget);

      final before = storyLogScrollController(tester)?.position.maxScrollExtent ?? 0;

      await tester.tap(find.bySemanticsLabel('发送命令'));
      await tester.pump();
      expect(storyLogScrollController(tester)?.position.maxScrollExtent ?? 0, before);

      sharedController.resetCommandGateForTest();
      await tester.enterText(find.byType(TextField), 'help');
      await tester.tap(find.bySemanticsLabel('发送命令'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(
        sharedController.log.any((e) => e.text.toLowerCase().contains('help')),
        isTrue,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('DirectionPad compass buttons meet min touch target at small ring', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      materialAppWithL10n(
        theme: GameUiTheme.appTheme(),
        home: GameSkinScope(
          skin: GameUiSkin.fantasy,
          child: SizedBox(
            width: 200,
            height: 200,
            child: DirectionPad(
              size: 62,
              onMove: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    for (final label in ['北 N', '东 E', '南 S', '西 W']) {
      final finder = find.bySemanticsLabel(label);
      expect(finder, findsOneWidget);
      final box = tester.renderObject<RenderBox>(finder);
      expect(box.size.width, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
      expect(box.size.height, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
    }

    Offset centerOf(String label) {
      final box = tester.renderObject<RenderBox>(find.bySemanticsLabel(label));
      return box.localToGlobal(box.size.center(Offset.zero));
    }

    final n = centerOf('北 N');
    final s = centerOf('南 S');
    final w = centerOf('西 W');
    final e = centerOf('东 E');
    // Icons must stay on cardinal sides, not collapse into the ring center.
    expect(s.dy - n.dy, greaterThanOrEqualTo(18));
    expect(e.dx - w.dx, greaterThanOrEqualTo(18));
  });

  testWidgets('Short phone floating pad compass buttons meet min touch target', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    try {
      await pumpExplorationScreen(tester, const Size(667, 375));

      expect(tester.takeException(), isNull);
      expect(find.byType(FloatingMovePad), findsOneWidget);

      for (final label in ['北 N', '东 E', '南 S', '西 W']) {
        final finder = find.bySemanticsLabel(label);
        expect(finder, findsOneWidget);
        final box = tester.renderObject<RenderBox>(finder);
        expect(box.size.width, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
        expect(box.size.height, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
      }
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

double _chipWidth(WidgetTester tester) {
  final chipFinder = find.descendant(
    of: find.byType(QuickCommandPanel),
    matching: find.ancestor(
      of: find.text('查看'),
      matching: find.byType(GameButton),
    ),
  );
  return tester.renderObject<RenderBox>(chipFinder.first).size.width;
}

double _uiScale(WidgetTester tester) {
  return LandscapeLayout.uiScaleOf(
    tester.element(find.byType(QuickCommandPanel)),
  );
}
