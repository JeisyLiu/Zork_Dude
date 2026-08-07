import 'package:zork_dude/domain/game_session.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/domain/models/map_meta.dart';

const mapCell = 52.0;
const mapPad = 36.0;

const mapLayerLabels = {
  MapLayer.surface: '地表',
  MapLayer.cave: '洞穴',
  MapLayer.tower: '高塔',
  MapLayer.site: '设施',
};

const mapDirLabel = {
  Direction.north: '北',
  Direction.south: '南',
  Direction.east: '东',
  Direction.west: '西',
  Direction.up: '上',
  Direction.down: '下',
};

const mapDirOffset = {
  Direction.north: [0.0, -0.42],
  Direction.south: [0.0, 0.42],
  Direction.east: [0.42, 0.0],
  Direction.west: [-0.42, 0.0],
  Direction.up: [-0.18, -0.42],
  Direction.down: [0.18, 0.42],
};

class MapEdge {
  final String from;
  final String to;
  final Direction? dir;
  final String kind;

  const MapEdge({required this.from, required this.to, this.dir, required this.kind});
}

class MapPortal {
  final String from;
  final String to;
  final Direction dir;
  final double ox;
  final double oy;
  final MapLayer targetLayer;
  final bool visited;

  const MapPortal({
    required this.from,
    required this.to,
    required this.dir,
    required this.ox,
    required this.oy,
    required this.targetLayer,
    required this.visited,
  });
}

class MapNode {
  final String id;
  final double cx;
  final double cy;
  final String shortLabel;
  final bool fog;
  final bool isHere;
  final bool canWalk;

  const MapNode({
    required this.id,
    required this.cx,
    required this.cy,
    required this.shortLabel,
    this.fog = false,
    this.isHere = false,
    this.canWalk = false,
  });
}

class MapViewModel {
  final MapLayer layer;
  final List<MapNode> nodes;
  final List<MapEdge> knownEdges;
  final List<MapEdge> fogEdges;
  final List<MapPortal> portals;
  final int visitedCount;

  const MapViewModel({
    required this.layer,
    required this.nodes,
    required this.knownEdges,
    required this.fogEdges,
    required this.portals,
    required this.visitedCount,
  });
}

class MapService {
  List<String> roomsOnLayer(GameSession session, MapLayer layer) {
    return session.rooms.keys
        .where((id) => mapPos(id, layer, session.mapMeta) != null)
        .toList();
  }

  List<String> visitedOnLayer(GameSession session, MapLayer layer) {
    return session.rooms.keys.where((id) {
      final rm = session.rooms[id];
      return rm != null && rm.visited && mapPos(id, layer, session.mapMeta) != null;
    }).toList();
  }

  String roomShortName(GameSession session, String roomId) {
    final m = session.mapMeta[roomId];
    if (m == null) return session.rooms[roomId]?.emoji ?? session.rooms[roomId]?.name ?? roomId;
    if (m.shortLabel.isNotEmpty) return m.shortLabel;
    if (m.layers != null) {
      return m.layers![MapLayer.surface]?.shortLabel ??
          m.layers![MapLayer.tower]?.shortLabel ??
          roomId;
    }
    return roomId;
  }

  Direction? exitDirTo(GameSession session, String roomId) {
    if (roomId == session.currentRoomId) return null;
    final rm = session.rooms[session.currentRoomId];
    if (rm == null) return null;
    for (final e in rm.exits.entries) {
      if (e.value == roomId) return e.key;
    }
    return null;
  }

  ({List<MapEdge> known, List<MapEdge> fog, List<MapPortal> portals}) mapEdgesForLayer(
    GameSession session,
    MapLayer layer, {
    bool revealAll = false,
  }) {
    final known = <MapEdge>[];
    final fog = <MapEdge>[];
    final portals = <MapPortal>[];
    final seen = <String>{};
    final roomIds =
        revealAll ? roomsOnLayer(session, layer) : visitedOnLayer(session, layer);
    for (final id in roomIds) {
      final rm = session.rooms[id]!;
      final fromPos = mapPos(id, layer, session.mapMeta);
      if (fromPos == null) continue;
      for (final e in rm.exits.entries) {
        final tid = e.value;
        final tr = session.rooms[tid];
        if (tr == null) continue;
        final toPos = mapPos(tid, layer, session.mapMeta);
        if (toPos != null) {
          final key = [id, tid]..sort();
          final k = key.join('|');
          if (seen.contains(k)) continue;
          seen.add(k);
          if (revealAll || tr.visited) {
            known.add(MapEdge(from: id, to: tid, kind: 'known'));
          } else {
            fog.add(MapEdge(from: id, to: tid, dir: e.key, kind: 'fog'));
          }
        } else {
          final off = mapDirOffset[e.key] ?? [0.35, 0.0];
          portals.add(MapPortal(
            from: id,
            to: tid,
            dir: e.key,
            ox: off[0],
            oy: off[1],
            targetLayer: mapLayerOfRoom(tid, session.mapMeta),
            visited: revealAll || tr.visited,
          ));
        }
      }
    }
    return (known: known, fog: fog, portals: portals);
  }

  MapViewModel buildView(
    GameSession session,
    MapLayer layer, {
    bool revealAll = false,
  }) {
    final ids = revealAll ? roomsOnLayer(session, layer) : visitedOnLayer(session, layer);
    final edges = mapEdgesForLayer(session, layer, revealAll: revealAll);
    final fogIds = revealAll ? const <String>{} : edges.fog.map((e) => e.to).toSet();
    final pts = <String, MapNode>{};
    void addPt(String id, MapPosition p, {required bool fog}) {
      final cx = mapPad + p.x * mapCell;
      final cy = mapPad + p.y * mapCell;
      final isHere = id == session.currentRoomId && !fog;
      final canWalk = !session.inCombat && exitDirTo(session, id) != null;
      pts[id] = MapNode(
        id: id,
        cx: cx,
        cy: cy,
        shortLabel: fog ? '❓' : p.shortLabel.isNotEmpty ? p.shortLabel : roomShortName(session, id),
        fog: fog,
        isHere: isHere,
        canWalk: canWalk,
      );
    }

    for (final id in ids) {
      final p = mapPos(id, layer, session.mapMeta);
      if (p != null) addPt(id, p, fog: false);
    }
    for (final id in fogIds) {
      final p = mapPos(id, layer, session.mapMeta);
      if (p != null) addPt(id, p, fog: true);
    }

    return MapViewModel(
      layer: layer,
      nodes: pts.values.toList(),
      knownEdges: edges.known,
      fogEdges: edges.fog,
      portals: edges.portals,
      visitedCount: session.visitedCount(),
    );
  }
}
