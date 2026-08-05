import 'package:zork_dude/domain/models/enums.dart';

class MapPosition {
  final int x;
  final int y;
  final String shortLabel;

  const MapPosition({
    required this.x,
    required this.y,
    this.shortLabel = '',
  });
}

class RoomMapMeta {
  final Map<MapLayer, MapPosition>? layers;
  final MapLayer? layer;
  final int? x;
  final int? y;
  final String shortLabel;

  const RoomMapMeta({
    this.layers,
    this.layer,
    this.x,
    this.y,
    this.shortLabel = '',
  });

  factory RoomMapMeta.fromJson(Map<String, dynamic>? json, {String emoji = ''}) {
    if (json == null) {
      return RoomMapMeta(shortLabel: emoji);
    }
    if (json['layers'] is Map) {
      final layers = <MapLayer, MapPosition>{};
      for (final entry in (json['layers'] as Map).entries) {
        final layer = _layerFromString(entry.key.toString());
        final pos = entry.value as Map;
        layers[layer] = MapPosition(
          x: (pos['x'] as num).toInt(),
          y: (pos['y'] as num).toInt(),
          shortLabel: pos['emoji']?.toString() ?? emoji,
        );
      }
      return RoomMapMeta(layers: layers, shortLabel: emoji);
    }
    return RoomMapMeta(
      layer: _layerFromString(json['layer']?.toString() ?? 'surface'),
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      shortLabel: emoji,
    );
  }

  static MapLayer _layerFromString(String s) {
    switch (s) {
      case 'cave':
        return MapLayer.cave;
      case 'tower':
        return MapLayer.tower;
      case 'site':
        return MapLayer.site;
      default:
        return MapLayer.surface;
    }
  }
}

MapLayer mapLayerOfRoom(String roomId, Map<String, RoomMapMeta> meta) {
  if (roomId == 'tower_base') return MapLayer.surface;
  final m = meta[roomId];
  if (m == null) return MapLayer.surface;
  if (m.layer == MapLayer.tower) return MapLayer.tower;
  if (m.layer == MapLayer.site) return MapLayer.site;
  if (m.layers != null) return MapLayer.surface;
  return m.layer ?? MapLayer.surface;
}

MapPosition? mapPos(String roomId, MapLayer layer, Map<String, RoomMapMeta> meta) {
  final m = meta[roomId];
  if (m == null) return null;
  if (m.layers != null) return m.layers![layer];
  if (m.layer == layer && m.x != null && m.y != null) {
    return MapPosition(x: m.x!, y: m.y!, shortLabel: m.shortLabel);
  }
  return null;
}

Map<String, RoomMapMeta> buildMapMetaFromRooms(
  Iterable<({String id, String emoji, Map<String, dynamic>? map})> rooms,
) {
  final result = <String, RoomMapMeta>{};
  for (final r in rooms) {
    result[r.id] = RoomMapMeta.fromJson(r.map, emoji: r.emoji);
  }
  return result;
}
