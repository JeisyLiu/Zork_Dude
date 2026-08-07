import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ensures world rooms form one playable graph from [startRoomId], including
/// known dynamic exits from [SpecialBehaviorRegistry].
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const startRoomId = 'forest_entrance';

  /// Dynamic exits not present in static JSON but unlocked during play.
  const dynamicExits = <String, Map<String, String>>{
    'haunted_graveyard': {'east': 'scp_site_gate'},
    'scp_682_pit': {'east': 'scp_001_vault'},
    'ancient_ruins': {'north': 'hidden_passage'},
    'tower_base': {'up': 'tower_foyer'},
    'tower_ritual': {'up': 'tower_top'},
  };

  late Map<String, Map<String, String>> graph;

  setUpAll(() async {
    final raw = await rootBundle.loadString('assets/data/rooms.json');
    final list = jsonDecode(raw) as List<dynamic>;
    graph = {};
    for (final entry in list) {
      final m = entry as Map<String, dynamic>;
      final id = m['id'] as String;
      final exitsRaw = m['exits'] as Map<String, dynamic>? ?? {};
      graph[id] = {
        for (final e in exitsRaw.entries) e.key: e.value as String,
        ...?dynamicExits[id],
      };
    }
  });

  test('every room is reachable from forest_entrance', () {
    final visited = <String>{startRoomId};
    final queue = [startRoomId];

    while (queue.isNotEmpty) {
      final id = queue.removeAt(0);
      for (final target in graph[id]?.values ?? const <String>[]) {
        if (visited.add(target)) queue.add(target);
      }
    }

    final missing = graph.keys.where((id) => !visited.contains(id)).toList()
      ..sort();
    expect(
      missing,
      isEmpty,
      reason: 'Unreachable rooms: ${missing.join(', ')}',
    );
  });

  test('every exit target references a defined room', () {
    for (final entry in graph.entries) {
      for (final target in entry.value.values) {
        expect(
          graph.containsKey(target),
          isTrue,
          reason: '${entry.key} exit to unknown $target',
        );
      }
    }
  });
}
