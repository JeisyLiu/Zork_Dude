import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/command_result.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/domain/models/enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WorldRepository', () {
    test('loads expected entity counts', () async {
      final repo = WorldRepository();
      final def = await repo.loadFromAssets();
      expect(def.roomCount, 59);
      expect(def.itemCount, greaterThanOrEqualTo(100));
      expect(def.monsterCount, 34);
      expect(def.npcCount, 21);
      expect(def.companionCount, 7);
    });
  });

  group('GameSession', () {
    late GameSession session;

    setUp(() async {
      session = await GameSession.create(WorldRepository());
    });

    test('starts at forest entrance with starter items', () {
      expect(session.currentRoomId, 'forest_entrance');
      expect(session.hasItem('lesser_potion'), isTrue);
      expect(session.hasItem('bread'), isTrue);
    });

    test('movement west triggers combat with giant rat', () {
      final result = session.processCommand('w');
      expect(result.text, isNotEmpty);
      expect(session.inCombat, isTrue);
      expect(session.currentEnemy, 'giant_rat');
      expect(
        result.events.any((e) => e.type == GameEventType.battleRequested),
        isTrue,
      );
    });

    test('inventory command works', () {
      final result = session.processCommand('inventory');
      expect(result.text, contains('🎒'));
    });

    test('help command works', () {
      final result = session.processCommand('help');
      expect(result.text, contains('命令列表'));
    });

    test('combat blocks take', () {
      session.inCombat = true;
      final result = session.processCommand('take 1');
      expect(result.text, contains('战斗中'));
    });

    test('fishing rod catches fish at lake shore', () {
      session.currentRoomId = 'lake_shore';
      session.invAdd('fishing_rod');
      final before = session.inventory['fish'] ?? 0;
      final result = session.processCommand('use fishing_rod');
      expect(result.text, contains('钓到'));
      expect(session.inventory['fish'] ?? 0, before + 1);
    });

    test('fishing rod fails away from water', () {
      session.currentRoomId = 'forest_entrance';
      session.invAdd('fishing_rod');
      final result = session.processCommand('use fishing_rod');
      expect(result.text, contains('没法钓鱼'));
      expect(session.hasItem('fish'), isFalse);
    });

    test('teleport scroll lists destinations without consuming', () {
      session.invAdd('magic_scroll');
      final result = session.processCommand('use magic_scroll');
      expect(result.text, contains('已探索'));
      expect(session.hasItem('magic_scroll'), isTrue);
      expect(session.currentRoomId, 'forest_entrance');
    });

    test('teleport scroll moves to visited room and consumes', () {
      session.rooms['crossroads']!.visited = true;
      session.visitOrder.add('crossroads');
      session.invAdd('magic_scroll');
      final result = session.processCommand('use magic_scroll crossroads');
      expect(session.currentRoomId, 'crossroads');
      expect(session.hasItem('magic_scroll'), isFalse);
      expect(result.text, contains('传送'));
    });

    test('flee has fifty percent chance path', () {
      session.inCombat = true;
      session.currentEnemy = 'giant_rat';
      final result = session.doFlee();
      expect(result.text, isNotEmpty);
    });
  });

  group('MapService', () {
    test('builds nodes for surface layer', () async {
      final session = await GameSession.create(WorldRepository());
      final vm = MapService().buildView(session, MapLayer.surface);
      expect(vm.nodes, isNotEmpty);
      expect(vm.visitedCount, greaterThan(0));
    });

    test('exitDirTo only allows adjacent rooms', () async {
      final session = await GameSession.create(WorldRepository());
      final svc = MapService();
      final dir = svc.exitDirTo(session, 'abandoned_hut');
      expect(dir, Direction.west);
      expect(svc.exitDirTo(session, 'tower_top'), isNull);
    });
  });
}
