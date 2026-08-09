import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/widgets/mist_map_panel.dart';

import 'test_l10n.dart';
import 'test_game_messages.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    controller = GameController();
    controller.useTestMessages(testGameMessages());
    await controller.init();
    await controller.startNewGame(slot: 0);
  });

  tearDown(() {
    controller.dispose();
  });

  Future<void> pumpMap(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 450));
    await tester.pumpWidget(
      materialAppWithL10n(
        theme: GameUiTheme.appTheme(),
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 450)),
          child: GameSkinScope(
            skin: GameUiSkin.fantasy,
            child: Scaffold(
              body: SizedBox(
                width: 360,
                height: 320,
                child: MistMapPanel(controller: controller),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  test('player cannot switch map view to unvisited layers', () {
    expect(controller.developerMode, isFalse);
    expect(controller.canViewMapLayer(MapLayer.surface), isTrue);
    expect(controller.canViewMapLayer(MapLayer.cave), isFalse);
    expect(controller.canViewMapLayer(MapLayer.tower), isFalse);
    expect(controller.canViewMapLayer(MapLayer.site), isFalse);

    controller.setMapLayer(MapLayer.cave);
    expect(controller.mapLayer, MapLayer.surface);
  });

  testWidgets('player map hides unvisited layer tabs', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpMap(tester);

    expect(find.text('地表'), findsOneWidget);
    expect(find.text('洞穴'), findsNothing);
    expect(find.text('高塔'), findsNothing);
    expect(find.text('设施'), findsNothing);
  });

  test('developer mode can view any map layer', () async {
    debugDefaultTargetPlatformOverride = null;
    await controller.setDeveloperMode(true);
    expect(controller.developerMode, isTrue);
    expect(controller.canViewMapLayer(MapLayer.cave), isTrue);

    controller.setMapLayer(MapLayer.cave);
    expect(controller.mapLayer, MapLayer.cave);

    await controller.setDeveloperMode(false);
    expect(controller.mapLayer, MapLayer.surface);
  });

  testWidgets('developer mode shows all layer tabs', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await controller.setDeveloperMode(true);
    await pumpMap(tester);

    expect(find.text('地表'), findsOneWidget);
    expect(find.text('洞穴'), findsOneWidget);
    expect(find.text('高塔'), findsOneWidget);
    expect(find.text('设施'), findsOneWidget);
  });
}
