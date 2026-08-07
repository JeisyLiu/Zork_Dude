import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/main.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/home/home_ambient_background.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpUntilLoaded(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 80; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.textContaining('进入迷雾').evaluate().isNotEmpty) return;
    }
  }

  testWidgets('Home screen shows Mist Tower title and navigates', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MistTowerApp(),
      ),
    );
    expect(find.text('迷雾之塔'), findsOneWidget);

    await pumpUntilLoaded(tester);
    expect(find.textContaining('进入迷雾'), findsOneWidget);

    await tester.tap(find.text('进入迷雾'));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byType(ExplorationScreen).evaluate().isNotEmpty) break;
    }
    expect(find.byType(ExplorationScreen), findsOneWidget);
  });

  testWidgets('UI assets are declared and loadable', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Image.asset(GameUiAssets.panelBrown);
          },
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('GameSkinScope switches site skin', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: GameUiTheme.appTheme(),
        home: Builder(
          builder: (context) {
            final fantasy = GameUiTheme.dataFor(GameUiSkin.fantasy);
            final cave = GameUiTheme.dataFor(GameUiSkin.cave);
            final tower = GameUiTheme.dataFor(GameUiSkin.tower);
            final site = GameUiTheme.dataFor(GameUiSkin.site);
            expect(fantasy.panel, isNot(equals(site.panelDark)));
            expect(GameUiTheme.skinForMapLayer(MapLayer.surface), GameUiSkin.fantasy);
            expect(GameUiTheme.skinForMapLayer(MapLayer.cave), GameUiSkin.cave);
            expect(GameUiTheme.skinForMapLayer(MapLayer.tower), GameUiSkin.tower);
            expect(GameUiTheme.skinForMapLayer(MapLayer.site), GameUiSkin.site);
            expect(cave.scaffoldBg, isNot(equals(tower.scaffoldBg)));
            expect(
              GameUiTheme.combatDataForMapLayer(MapLayer.tower).progressFill,
              contains('progress_red'),
            );
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('Home layout fits 667x375 without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(667, 375));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MistTowerApp());
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('迷雾之塔'), findsOneWidget);
  });

  testWidgets('Home layout fits 800x360 without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 360));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MistTowerApp());
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('迷雾之塔'), findsOneWidget);
  });

  testWidgets('Home layout fits 853x384 without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(853, 384));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MistTowerApp());
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('迷雾之塔'), findsOneWidget);
  });

  testWidgets('Home layout fits 854x480 without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(854, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MistTowerApp());
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(HomeAmbientBackground), findsOneWidget);
    expect(find.byType(GameButton), findsOneWidget);
  });

  testWidgets('Home layout fits 1280x720 without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MistTowerApp());
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('MIST TOWER'), findsOneWidget);
  });

  testWidgets('Home renders with animations disabled', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MistTowerApp(),
      ),
    );
    await pumpUntilLoaded(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('迷雾之塔'), findsOneWidget);
    expect(find.byType(HomeAmbientBackground), findsOneWidget);
  });
}
