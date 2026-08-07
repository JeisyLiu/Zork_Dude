// Render rooms.json as ASCII maps + connectivity/heuristic report.
// Run: dart run tool/render_room_map.dart
import 'dart:convert';
import 'dart:io';

const startRoomId = 'forest_entrance';

const dynamicExits = <String, Map<String, String>>{
  'haunted_graveyard': {'east': 'scp_site_gate'},
  'scp_682_pit': {'east': 'scp_001_vault'},
  'ancient_ruins': {'north': 'hidden_passage'},
  'tower_base': {'up': 'tower_foyer'},
  'tower_ritual': {'up': 'tower_top'},
};

const layerNames = ['surface', 'cave', 'tower', 'site'];
const layerAbbr = {'surface': 'S', 'cave': 'C', 'tower': 'T', 'site': 'F'};

void main() {
  final script = File(Platform.script.toFilePath());
  final appRoot = script.parent.parent;
  final roomsFile = File('${appRoot.path}/assets/data/rooms.json');
  if (!roomsFile.existsSync()) {
    stderr.writeln('Not found: ${roomsFile.path}');
    exit(2);
  }

  final list = jsonDecode(roomsFile.readAsStringSync()) as List<dynamic>;
  final rooms = <String, _Room>{};
  for (final raw in list) {
    final m = raw as Map<String, dynamic>;
    final id = m['id'] as String;
    final exitsRaw = m['exits'] as Map<String, dynamic>? ?? {};
    final exits = <String, String>{
      for (final e in exitsRaw.entries) e.key: e.value as String,
      ...?dynamicExits[id],
    };
    final positions = _parsePositions(m);
    rooms[id] = _Room(
      id: id,
      name: m['name'] as String? ?? id,
      emoji: m['emoji'] as String? ?? '?',
      exits: exits,
      positions: positions,
      dynamicDirs: dynamicExits[id]?.keys.toSet() ?? {},
    );
  }

  var hasError = false;
  stdout.writeln('=== Room map report (${rooms.length} rooms) ===\n');

  hasError = _printConnectivityReport(rooms) || hasError;
  stdout.writeln('');
  _printHeuristicReport(rooms);
  stdout.writeln('');

  for (final layer in layerNames) {
    _printLayerAscii(rooms, layer);
    stdout.writeln('');
  }

  exit(hasError ? 1 : 0);
}

class _Room {
  _Room({
    required this.id,
    required this.name,
    required this.emoji,
    required this.exits,
    required this.positions,
    required this.dynamicDirs,
  });

  final String id;
  final String name;
  final String emoji;
  final Map<String, String> exits;
  final Map<String, ({int x, int y})> positions;
  final Set<String> dynamicDirs;
}

Map<String, ({int x, int y})> _parsePositions(Map<String, dynamic> m) {
  final map = m['map'] as Map<String, dynamic>?;
  if (map == null) return {};
  final result = <String, ({int x, int y})>{};
  if (map['layers'] is Map) {
    for (final e in (map['layers'] as Map).entries) {
      final pos = e.value as Map;
      result[e.key.toString()] = (
        x: (pos['x'] as num).toInt(),
        y: (pos['y'] as num).toInt(),
      );
    }
  } else {
    final layer = map['layer']?.toString() ?? 'surface';
    result[layer] = (
      x: (map['x'] as num).toInt(),
      y: (map['y'] as num).toInt(),
    );
  }
  return result;
}

bool _printConnectivityReport(Map<String, _Room> rooms) {
  var hasError = false;
  stdout.writeln('--- Connectivity ---');

  for (final room in rooms.values) {
    for (final e in room.exits.entries) {
      if (!rooms.containsKey(e.value)) {
        stdout.writeln('  [ERROR] dangling exit: ${room.id} --${e.key}--> ${e.value}');
        hasError = true;
      }
    }
  }

  final visited = <String>{startRoomId};
  final queue = [startRoomId];
  while (queue.isNotEmpty) {
    final id = queue.removeAt(0);
    for (final target in rooms[id]?.exits.values ?? const []) {
      if (visited.add(target)) queue.add(target);
    }
  }
  final unreachable = rooms.keys.where((id) => !visited.contains(id)).toList()..sort();
  if (unreachable.isNotEmpty) {
    stdout.writeln('  [ERROR] unreachable from $startRoomId: ${unreachable.join(', ')}');
    hasError = true;
  } else {
    stdout.writeln('  [OK] all rooms reachable from $startRoomId (incl. dynamic exits)');
  }

  for (final layer in layerNames) {
    final byCell = <String, List<String>>{};
    for (final room in rooms.values) {
      final p = room.positions[layer];
      if (p == null) continue;
      final key = '${p.x},${p.y}';
      byCell.putIfAbsent(key, () => []).add(room.id);
    }
    for (final e in byCell.entries) {
      if (e.value.length > 1) {
        stdout.writeln('  [WARN] $layer coord ${e.key} overlap: ${e.value.join(', ')}');
      }
    }
  }

  return hasError;
}

bool _printHeuristicReport(Map<String, _Room> rooms) {
  stdout.writeln('--- Design heuristics ---');

  final inDegree = <String, int>{for (final id in rooms.keys) id: 0};
  final outDegree = <String, int>{for (final id in rooms.keys) id: 0};
  for (final room in rooms.values) {
    outDegree[room.id] = room.exits.length;
    for (final target in room.exits.values) {
      inDegree[target] = (inDegree[target] ?? 0) + 1;
    }
  }

  final deadEnds = rooms.keys
      .where((id) => (outDegree[id] ?? 0) <= 1)
      .toList()
    ..sort();
  stdout.writeln('  Dead ends (out-degree <= 1): ${deadEnds.length}');
  for (final id in deadEnds) {
    stdout.writeln('    - $id (${rooms[id]!.name})');
  }

  final hubs = rooms.keys
      .where((id) => (inDegree[id]! + outDegree[id]!) >= 6)
      .toList()
    ..sort();
  if (hubs.isNotEmpty) {
    stdout.writeln('  Hubs (in+out >= 6): ${hubs.join(', ')}');
  }

  for (final room in rooms.values) {
    for (final e in room.exits.entries) {
      final target = rooms[e.value];
      if (target == null) continue;
      for (final layer in layerNames) {
        final from = room.positions[layer];
        final to = target.positions[layer];
        if (from == null || to == null) continue;
        if (!_directionConsistent(e.key, from, to)) {
          stdout.writeln(
            '  [WARN] $layer direction mismatch: ${room.id} --${e.key}--> ${e.value} '
            '(${from.x},${from.y}) -> (${to.x},${to.y})',
          );
        }
      }
    }
  }

  final oneWay = <String>[];
  for (final room in rooms.values) {
    for (final e in room.exits.entries) {
      final target = rooms[e.value];
      if (target == null) continue;
      final reverse = _reverseDir(e.key);
      if (reverse == null) continue;
      if (target.exits[reverse] != room.id) {
        oneWay.add('${room.id} --${e.key}--> ${e.value}');
      }
    }
  }
  stdout.writeln('  One-way exits (same layer pairs): ${oneWay.length}');
  for (final line in oneWay.take(12)) {
    stdout.writeln('    - $line');
  }
  if (oneWay.length > 12) {
    stdout.writeln('    ... and ${oneWay.length - 12} more');
  }

  return false;
}

bool _directionConsistent(String dir, ({int x, int y}) from, ({int x, int y}) to) {
  switch (dir) {
    case 'north':
      return to.y < from.y;
    case 'south':
      return to.y > from.y;
    case 'east':
      return to.x > from.x;
    case 'west':
      return to.x < from.x;
    default:
      return true;
  }
}

String? _reverseDir(String dir) {
  switch (dir) {
    case 'north':
      return 'south';
    case 'south':
      return 'north';
    case 'east':
      return 'west';
    case 'west':
      return 'east';
    case 'up':
      return 'down';
    case 'down':
      return 'up';
    default:
      return null;
  }
}

void _printLayerAscii(Map<String, _Room> rooms, String layer) {
  final onLayer = rooms.values.where((r) => r.positions.containsKey(layer)).toList();
  if (onLayer.isEmpty) return;

  stdout.writeln('=== Layer: $layer (${onLayer.length} rooms) ===');

  var minX = 999, maxX = -999, minY = 999, maxY = -999;
  for (final r in onLayer) {
    final p = r.positions[layer]!;
    if (p.x < minX) minX = p.x;
    if (p.x > maxX) maxX = p.x;
    if (p.y < minY) minY = p.y;
    if (p.y > maxY) maxY = p.y;
  }

  const cellW = 5;
  const cellH = 3;
  final gridW = (maxX - minX + 1) * cellW;
  final gridH = (maxY - minY + 1) * cellH;
  final grid = List.generate(gridH, (_) => List.filled(gridW, ' '));

  void setChar(int gx, int gy, String ch) {
    if (gy < 0 || gy >= gridH || gx < 0 || gx >= gridW) return;
    grid[gy][gx] = ch;
  }

  int baseX(int x) => (x - minX) * cellW;
  int baseY(int y) => (y - minY) * cellH;

  for (final room in onLayer) {
    final p = room.positions[layer]!;
    final bx = baseX(p.x);
    final by = baseY(p.y);
    final label = room.emoji.isNotEmpty ? room.emoji : room.id.substring(0, 1);
    setChar(bx + 2, by + 1, label);
  }

  for (final room in onLayer) {
    final from = room.positions[layer]!;
    final fx = baseX(from.x) + 2;
    final fy = baseY(from.y) + 1;
    for (final e in room.exits.entries) {
      final target = rooms[e.value];
      if (target == null) continue;
      final toPos = target.positions[layer];
      if (toPos != null) {
        final tx = baseX(toPos.x) + 2;
        final ty = baseY(toPos.y) + 1;
        if (fx == tx) {
          final step = ty > fy ? 1 : -1;
          for (var y = fy + step; y != ty; y += step) {
            setChar(fx, y, '|');
          }
        } else if (fy == ty) {
          final step = tx > fx ? 1 : -1;
          final rev = target.exits[_reverseDir(e.key) ?? ''] == room.id;
          final ch = rev ? '-' : (step > 0 ? '<' : '>');
          for (var x = fx + step; x != tx; x += step) {
            setChar(x, fy, ch);
          }
        }
      }
    }
  }

  for (final line in grid) {
    stdout.writeln(line.join());
  }

  final portals = <String>[];
  for (final room in onLayer) {
    for (final e in room.exits.entries) {
      final target = rooms[e.value];
      if (target == null) continue;
      if (target.positions.containsKey(layer)) continue;
      final otherLayer = target.positions.keys.firstWhere(
        (l) => l != layer,
        orElse: () => '?',
      );
      final dyn = room.dynamicDirs.contains(e.key) ? ' [dynamic]' : '';
      portals.add(
        '  ${room.id} --${e.key}--> ${e.value} (${layerAbbr[otherLayer] ?? otherLayer})$dyn',
      );
    }
  }
  if (portals.isNotEmpty) {
    stdout.writeln('  Portals:');
    for (final p in portals) {
      stdout.writeln(p);
    }
  }

  stdout.writeln('  Rooms:');
  for (final room in onLayer) {
    final p = room.positions[layer]!;
    stdout.writeln('    (${p.x},${p.y}) ${room.emoji} ${room.id}');
  }
}
