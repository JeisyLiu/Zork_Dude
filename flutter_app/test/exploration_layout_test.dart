import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
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

  tearDownAll(() {
    sharedController.dispose();
  });

  for (final size in const [
    Size(320, 568),
    Size(390, 844),
    Size(1024, 576),
    Size(1280, 720),
  ]) {
    testWidgets('Exploration layout fits ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpExplorationScreen(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.byType(ExplorationScreen), findsOneWidget);
      expect(find.byType(DirectionPad), findsOneWidget);
      expect(find.text('更多'), findsWidgets);
      expect(find.text('发送'), findsNothing);
    });
  }

  testWidgets('More sheet exposes low-frequency commands', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExplorationScreen(tester, const Size(1280, 720));
    await tester.tap(find.text('更多').last);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('帮助'), findsWidgets);
    expect(find.text('二周目'), findsWidgets);
    expect(find.text('丢弃'), findsWidgets);
  });

  testWidgets('Story log scrolls to latest entry after command', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
  });

  testWidgets('Command input submits via icon and ignores empty text', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpExplorationScreen(tester, const Size(1280, 720));

    expect(find.bySemanticsLabel('发送命令'), findsOneWidget);

    final before = storyLogScrollController(tester)?.position.maxScrollExtent ?? 0;

    await tester.tap(find.bySemanticsLabel('发送命令'));
    await tester.pump();
    expect(storyLogScrollController(tester)?.position.maxScrollExtent ?? 0, before);

    await tester.enterText(find.byType(TextField), 'help');
    await tester.tap(find.bySemanticsLabel('发送命令'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.textContaining('help'), findsWidgets);
  });
}
