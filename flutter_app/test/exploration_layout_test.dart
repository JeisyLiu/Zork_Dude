import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/widgets/mist_map_panel.dart';
import 'package:zork_dude/widgets/quick_commands.dart';
import 'package:zork_dude/widgets/story_log.dart';

late GameController sharedController;

Future<void> pumpExplorationScreen(WidgetTester tester, Size size) async {
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
    Size(1280, 720),
    Size(1600, 900),
    Size(1920, 1080),
  ]) {
    testWidgets('Exploration layout fits ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpExplorationScreen(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.byType(ExplorationScreen), findsOneWidget);
      expect(find.byType(DirectionPad), findsOneWidget);
      expect(find.text('查看'), findsWidgets);
      expect(find.text('丢弃'), findsWidgets);
      expect(find.text('更多'), findsWidgets);
      expect(find.text('发送'), findsNothing);
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

  testWidgets('Chip width ratio tracks uiScale at same 16:9 aspect', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const small = Size(800, 450);
    const large = Size(1280, 720);

    await pumpExplorationScreen(tester, small);
    final smallChip = _chipWidth(tester);
    final smallScale = _uiScale(tester);

    await pumpExplorationScreen(tester, large);
    final largeChip = _chipWidth(tester);
    final largeScale = _uiScale(tester);

    expect(smallScale, lessThan(largeScale));
    expect(smallChip / largeChip, closeTo(smallScale / largeScale, 0.05));
    expect(smallChip, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
    expect(largeChip, greaterThanOrEqualTo(LandscapeLayout.minTouchTarget));
  });

  testWidgets('Scaled chip matches layout constant at 1280x720', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExplorationScreen(tester, const Size(1280, 720));
    final chip = _chipWidth(tester);
    final expected = ExplorationLayoutConstants.preferredChipWidth(
      tester.element(find.byType(QuickCommandPanel)),
    );
    expect(chip, closeTo(expected, 2));
  });

  testWidgets('Primary panel exposes former more-sheet commands', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExplorationScreen(tester, const Size(1280, 720));

    expect(find.text('治疗'), findsWidgets);
    expect(find.text('丢弃'), findsWidgets);
    expect(find.text('商品'), findsWidgets);
    expect(find.text('购买'), findsWidgets);
    expect(find.text('出售'), findsWidgets);
    expect(find.text('招募'), findsWidgets);
    expect(find.text('更多'), findsWidgets);

    await tester.tap(find.byKey(const Key('quick-command-more')));
    await tester.pumpAndSettle();

    expect(find.text('回标题'), findsOneWidget);
    expect(find.text('队伍'), findsOneWidget);
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
    tester.element(find.byType(ExplorationScreen)),
  );
}
