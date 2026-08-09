import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted audio on/off preferences (volume uses the OS mixer).
class AudioPreferences extends ChangeNotifier {
  AudioPreferences._();

  static final AudioPreferences instance = AudioPreferences._();

  static const _keyBgmEnabled = 'audio.bgm_enabled';
  static const _keySfxEnabled = 'audio.sfx_enabled';

  /// Fixed relative levels when enabled; system volume handles the rest.
  static const double _bgmLevel = 0.7;
  static const double _sfxLevel = 1.0;

  bool _bgmEnabled = true;
  bool _sfxEnabled = true;
  bool _loaded = false;

  bool get bgmEnabled => _bgmEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get loaded => _loaded;

  double get effectiveBgmVolume => _bgmEnabled ? _bgmLevel : 0.0;

  double get effectiveSfxVolume => _sfxEnabled ? _sfxLevel : 0.0;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _bgmEnabled = prefs.getBool(_keyBgmEnabled) ?? true;
      _sfxEnabled = prefs.getBool(_keySfxEnabled) ?? true;
    } catch (_) {}
    _loaded = true;
    notifyListeners();
  }

  Future<void> setBgmEnabled(bool value) async {
    _bgmEnabled = value;
    await _persist();
    notifyListeners();
  }

  Future<void> setSfxEnabled(bool value) async {
    _sfxEnabled = value;
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyBgmEnabled, _bgmEnabled);
      await prefs.setBool(_keySfxEnabled, _sfxEnabled);
    } catch (_) {}
  }

  @visibleForTesting
  void resetForTest() {
    _bgmEnabled = true;
    _sfxEnabled = true;
    _loaded = true;
  }
}
