import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/game_session.dart';

/// Summary for save-slot picker UI (emoji-only display).
class SaveSlotInfo {
  const SaveSlotInfo({
    required this.slotIndex,
    required this.score,
    required this.playerHp,
    required this.playerMaxHp,
    required this.layersVisited,
    required this.savedAt,
  });

  final int slotIndex;
  final int score;
  final int playerHp;
  final int playerMaxHp;
  final List<String> layersVisited;
  final DateTime savedAt;

  static const slotMarkers = ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧'];

  static const layerEmoji = {
    'surface': '🌲',
    'cave': '🕳️',
    'tower': '🏰',
    'site': '☢️',
  };

  String get slotMarker => slotMarkers[slotIndex.clamp(0, 7)];

  String get layerEmojiLine {
    if (layersVisited.isEmpty) return '';
    return layersVisited.map((l) => layerEmoji[l] ?? '').join();
  }

  /// Relative time for picker: `5m`, `2h`, `3d`.
  static String formatRelativeTime(DateTime savedAt) {
    final diff = DateTime.now().toUtc().difference(savedAt.toUtc());
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  static SaveSlotInfo fromJson(int slotIndex, Map<String, dynamic> json) {
    final layersRaw = json['layersVisited'];
    final layers = <String>[];
    if (layersRaw is List) {
      for (final e in layersRaw) {
        layers.add(e.toString());
      }
    } else {
      layers.addAll(_inferLayersFromRooms(json));
    }
    final savedAtRaw = json['savedAt'] as String?;
    final savedAt = savedAtRaw != null
        ? DateTime.tryParse(savedAtRaw)?.toUtc() ?? DateTime.now().toUtc()
        : DateTime.now().toUtc();
    return SaveSlotInfo(
      slotIndex: slotIndex,
      score: (json['score'] as num?)?.toInt() ?? 0,
      playerHp: (json['playerHp'] as num?)?.toInt() ?? 0,
      playerMaxHp: (json['playerMaxHp'] as num?)?.toInt() ?? 0,
      layersVisited: layers,
      savedAt: savedAt,
    );
  }

  static List<String> _inferLayersFromRooms(Map<String, dynamic> json) {
    final rooms = json['rooms'] as Map?;
    if (rooms == null) return const [];
    final layers = <String>{};
    for (final entry in rooms.entries) {
      final room = entry.value;
      if (room is! Map) continue;
      if (room['visited'] != true) continue;
      final roomId = entry.key.toString();
      final layer = _layerForRoomId(roomId);
      if (layer != null) layers.add(layer);
    }
    const order = ['surface', 'cave', 'tower', 'site'];
    return order.where(layers.contains).toList();
  }

  static String? _layerForRoomId(String roomId) {
    if (roomId.startsWith('scp_') || roomId.startsWith('site_')) {
      return 'site';
    }
    if (roomId.startsWith('tower_')) return 'tower';
    if (roomId.startsWith('cave_') ||
        roomId.contains('goblin') ||
        roomId.contains('alchemist') ||
        roomId == 'underground_river') {
      return 'cave';
    }
    return 'surface';
  }
}

/// Eight-slot autosave backed by [SharedPreferences].
class SaveRepository {
  static const maxSlots = 8;
  static const legacySaveKey = 'mist_tower_save_v1';
  static const activeSlotKey = 'mist_tower_active_slot';

  static String slotKey(int index) => 'mist_tower_save_slot_$index';

  Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString(legacySaveKey);
    if (legacy == null || legacy.isEmpty) return;
    if (prefs.containsKey(slotKey(0))) {
      await prefs.remove(legacySaveKey);
      return;
    }
    await prefs.setString(slotKey(0), legacy);
    await prefs.setInt(activeSlotKey, 0);
    await prefs.remove(legacySaveKey);
  }

  Future<List<SaveSlotInfo?>> listSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final out = List<SaveSlotInfo?>.filled(maxSlots, null);
    for (var i = 0; i < maxSlots; i++) {
      final data = _decodeSlot(prefs.getString(slotKey(i)));
      if (data != null) {
        out[i] = SaveSlotInfo.fromJson(i, data);
      }
    }
    return out;
  }

  Future<int> occupiedCount() async {
    final slots = await listSlots();
    return slots.where((s) => s != null).length;
  }

  Future<int?> soleOccupiedIndex() async {
    final slots = await listSlots();
    int? found;
    for (var i = 0; i < maxSlots; i++) {
      if (slots[i] == null) continue;
      if (found != null) return null;
      found = i;
    }
    return found;
  }

  Future<int?> firstEmptyIndex() async {
    final slots = await listSlots();
    for (var i = 0; i < maxSlots; i++) {
      if (slots[i] == null) return i;
    }
    return null;
  }

  Future<bool> hasSave() async => (await occupiedCount()) > 0;

  Future<int?> getActiveSlot() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(activeSlotKey);
  }

  Future<void> setActiveSlot(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(activeSlotKey, index);
  }

  Future<Map<String, dynamic>?> loadSlot(int index) async {
    if (index < 0 || index >= maxSlots) return null;
    final prefs = await SharedPreferences.getInstance();
    return _decodeSlot(prefs.getString(slotKey(index)));
  }

  Future<void> saveSlot(int index, GameSession session) async {
    if (index < 0 || index >= maxSlots) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(slotKey(index), jsonEncode(session.toSaveJson()));
    await prefs.setInt(activeSlotKey, index);
  }

  Future<void> clearSlot(int index) async {
    if (index < 0 || index >= maxSlots) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(slotKey(index));
    final active = prefs.getInt(activeSlotKey);
    if (active == index) {
      await prefs.remove(activeSlotKey);
    }
  }

  Map<String, dynamic>? _decodeSlot(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['version'] != GameSession.saveVersion) return null;
      return data;
    } catch (_) {
      return null;
    }
  }
}
