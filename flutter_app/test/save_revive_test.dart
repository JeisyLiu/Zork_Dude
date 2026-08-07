import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/components/save_slot_picker.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Save roundtrip', () {
    test('toSaveJson includes savedAt and layersVisited', () async {
      final session = await GameSession.create(WorldRepository());
      session.rooms['crossroads']!.visited = true;
      final json = session.toSaveJson();
      expect(json['savedAt'], isNotNull);
      expect(json['layersVisited'], isA<List>());
    });

    test('toSaveJson and applySaveJson preserve progress', () async {
      final session = await GameSession.create(WorldRepository());
      session.processCommand('w');
      session.previousRoomId = 'forest_entrance';
      session.score = 250;
      session.gold = 88;
      session.playerHp = 42;
      session.flags['test_flag'] = true;
      session.rooms['crossroads']!.visited = true;
      session.visitOrder.add('crossroads');
      session.monsters['giant_rat']!.hp = 3;
      session.monsters['giant_rat']!.alive = true;

      final json = session.toSaveJson();
      final loaded = await GameSession.create(WorldRepository(), starterItems: false);
      loaded.applySaveJson(json);

      expect(loaded.currentRoomId, session.currentRoomId);
      expect(loaded.previousRoomId, 'forest_entrance');
      expect(loaded.score, 250);
      expect(loaded.gold, 88);
      expect(loaded.playerHp, 42);
      expect(loaded.flags['test_flag'], isTrue);
      expect(loaded.rooms['crossroads']!.visited, isTrue);
      expect(loaded.monsters['giant_rat']!.hp, 3);
    });

    test('SaveRepository saveSlot and loadSlot', () async {
      final repo = SaveRepository();
      final session = await GameSession.create(WorldRepository());
      session.score = 120;
      session.currentRoomId = 'abandoned_hut';
      session.previousRoomId = 'forest_entrance';

      await repo.saveSlot(2, session);
      expect(await repo.hasSave(), isTrue);
      expect(await repo.getActiveSlot(), 2);

      final data = await repo.loadSlot(2);
      expect(data, isNotNull);
      expect(data!['score'], 120);
      expect(data['currentRoomId'], 'abandoned_hut');
    });

    test('legacy save migrates to slot 0', () async {
      final legacy = {
        'version': GameSession.saveVersion,
        'score': 99,
        'currentRoomId': 'forest_entrance',
        'playerHp': 50,
        'playerMaxHp': 50,
      };
      SharedPreferences.setMockInitialValues({
        SaveRepository.legacySaveKey: jsonEncode(legacy),
      });
      final repo = SaveRepository();
      await repo.migrateIfNeeded();
      final data = await repo.loadSlot(0);
      expect(data!['score'], 99);
      expect(await repo.getActiveSlot(), 0);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(SaveRepository.legacySaveKey), isFalse);
    });

    test('two slots yield null soleOccupiedIndex', () async {
      final repo = SaveRepository();
      final a = await GameSession.create(WorldRepository());
      a.score = 10;
      final b = await GameSession.create(WorldRepository());
      b.score = 20;
      await repo.saveSlot(0, a);
      await repo.saveSlot(3, b);
      expect(await repo.soleOccupiedIndex(), isNull);
      expect(await repo.occupiedCount(), 2);
      final slots = await repo.listSlots();
      expect(slots[0]!.score, 10);
      expect(slots[3]!.score, 20);
    });
  });

  group('Death revive', () {
    test('reviveAfterDeath penalizes score and clamps at zero', () async {
      final session = await GameSession.create(WorldRepository());
      session.score = 50;
      session.previousRoomId = 'forest_entrance';
      session.currentRoomId = 'abandoned_hut';
      session.playerHp = 0;

      session.reviveAfterDeath();

      expect(session.score, 0);
      expect(session.currentRoomId, 'forest_entrance');
      expect(session.playerHp, session.playerMaxHp);
      expect(session.gameOver, isFalse);
      expect(session.inCombat, isFalse);
    });

    test('reviveAfterDeath uses forest_entrance when no previous room', () async {
      final session = await GameSession.create(WorldRepository());
      session.previousRoomId = null;
      session.currentRoomId = 'forest_entrance';
      session.playerHp = 0;
      session.score = 200;

      session.reviveAfterDeath();

      expect(session.currentRoomId, 'forest_entrance');
      expect(session.score, 100);
    });

    test('doGo records previousRoomId', () async {
      final session = await GameSession.create(WorldRepository());
      expect(session.previousRoomId, isNull);
      session.processCommand('w');
      expect(session.previousRoomId, 'forest_entrance');
      expect(session.currentRoomId, 'abandoned_hut');
    });

    test('combat defeat revives at previous room via controller', () async {
      final session = await GameSession.create(WorldRepository());
      session.processCommand('w');
      session.score = 300;
      session.playerHp = 0;

      final controller = GameController(saveRepository: SaveRepository());
      controller.session = session;
      controller.activeSlot = 0;
      controller.finishCombat(CombatOutcome.defeat);

      expect(session.gameOver, isFalse);
      expect(session.currentRoomId, 'forest_entrance');
      expect(session.score, 200);
      expect(session.playerHp, session.playerMaxHp);
      expect(controller.pendingEnding, EndingKind.gameOver);
    });
  });
}
