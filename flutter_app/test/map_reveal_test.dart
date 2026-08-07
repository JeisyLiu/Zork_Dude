import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MapService revealAll', () {
    late GameSession session;
    final svc = MapService();

    setUp(() async {
      session = await GameSession.create(WorldRepository());
    });

    test('default view only shows visited rooms on layer', () {
      final vm = svc.buildView(session, MapLayer.surface);
      expect(vm.nodes.length, lessThan(svc.roomsOnLayer(session, MapLayer.surface).length));
      expect(vm.nodes.every((n) => !n.fog || n.shortLabel == '❓'), isTrue);
    });

    test('revealAll shows every room with coordinates on layer', () {
      final layer = MapLayer.surface;
      final expected = svc.roomsOnLayer(session, layer).length;
      final vm = svc.buildView(session, layer, revealAll: true);

      expect(vm.nodes.length, expected);
      expect(vm.nodes.every((n) => !n.fog), isTrue);
      expect(vm.fogEdges, isEmpty);
      expect(vm.knownEdges, isNotEmpty);
    });

    test('revealAll includes cross-layer portals', () {
      final vm = svc.buildView(session, MapLayer.surface, revealAll: true);
      expect(vm.portals, isNotEmpty);
    });

    test('roomsOnLayer matches mapPos count', () {
      for (final layer in MapLayer.values) {
        final ids = svc.roomsOnLayer(session, layer);
        final manual = session.rooms.keys
            .where((id) => mapPos(id, layer, session.mapMeta) != null)
            .length;
        expect(ids.length, manual);
      }
    });

    test('switching layers yields different revealAll node sets', () {
      final surface = svc.buildView(session, MapLayer.surface, revealAll: true);
      final cave = svc.buildView(session, MapLayer.cave, revealAll: true);
      final tower = svc.buildView(session, MapLayer.tower, revealAll: true);

      expect(surface.nodes.map((n) => n.id).toSet(),
          isNot(equals(cave.nodes.map((n) => n.id).toSet())));
      expect(cave.nodes, isNotEmpty);
      expect(tower.nodes, isNotEmpty);
      expect(
        surface.nodes.any((n) => n.id == 'forest_entrance'),
        isTrue,
      );
      expect(
        cave.nodes.any((n) => n.id == 'cave_middle'),
        isTrue,
      );
      expect(
        tower.nodes.any((n) => n.id == 'tower_top'),
        isTrue,
      );
    });
  });
}
