import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/domain/game_session.dart';

/// Single-slot autosave backed by [SharedPreferences].
class SaveRepository {
  static const saveKey = 'mist_tower_save_v1';

  Future<bool> hasSave() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(saveKey);
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(saveKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['version'] != GameSession.saveVersion) return null;
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(GameSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(saveKey, jsonEncode(session.toSaveJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(saveKey);
  }
}
