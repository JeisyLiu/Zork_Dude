import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    controller = GameController();
    await controller.init();
    await controller.startNewGame(slot: 0);
  });

  tearDown(() {
    controller.dispose();
  });

  test('player cannot switch map view to unvisited layers', () {
    expect(controller.developerMode, isFalse);
    expect(controller.canViewMapLayer(MapLayer.surface), isTrue);
    expect(controller.canViewMapLayer(MapLayer.cave), isFalse);
    expect(controller.canViewMapLayer(MapLayer.tower), isFalse);
    expect(controller.canViewMapLayer(MapLayer.site), isFalse);

    controller.setMapLayer(MapLayer.cave);
    expect(controller.mapLayer, MapLayer.surface);
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
}
