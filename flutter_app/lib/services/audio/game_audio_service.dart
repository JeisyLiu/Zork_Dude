import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/services/audio/audio_assets.dart';
import 'package:zork_dude/services/audio/audio_preferences.dart';

/// BGM + SFX playback. Missing asset files fail silently.
class GameAudioService {
  GameAudioService._();

  static final GameAudioService instance = GameAudioService._();

  final AudioPreferences _prefs = AudioPreferences.instance;
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final List<AudioPlayer> _sfxPlayers = List.generate(4, (_) => AudioPlayer());
  int _sfxIndex = 0;
  bool _initialized = false;
  bool _disabled = false;
  String? _currentBgm;
  void _onPrefsChanged() => _applyBgmVolume();

  /// Set to true in widget tests to skip native audio initialization.
  static bool disableForTest = false;

  bool get isActive => _initialized && !_disabled;

  Future<void> initialize() async {
    if (disableForTest) {
      _disabled = true;
      return;
    }
    if (_initialized || _disabled) return;
    try {
      await _prefs.load();
      if (!kIsWeb) {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
      }
      _prefs.addListener(_onPrefsChanged);
      _initialized = true;
    } catch (_) {
      _disabled = true;
    }
  }

  void _applyBgmVolume() {
    if (!_initialized) return;
    unawaited(_bgmPlayer.setVolume(_prefs.effectiveBgmVolume));
  }

  void refreshVolumes() => _applyBgmVolume();

  Future<void> playBgm(String assetPath, {bool loop = true}) async {
    if (!isActive || !_prefs.bgmEnabled) return;
    if (_currentBgm == assetPath && _bgmPlayer.playing) return;
    try {
      await _bgmPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _bgmPlayer.setAsset(assetPath);
      await _bgmPlayer.setVolume(_prefs.effectiveBgmVolume);
      _currentBgm = assetPath;
      await _bgmPlayer.play();
    } catch (_) {
      _currentBgm = null;
    }
  }

  Future<void> stopBgm() async {
    _currentBgm = null;
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  void playHomeBgm() => playBgm(AudioAssets.bgmHome);

  void playExplorationBgm(MapLayer layer) {
    final path = switch (layer) {
      MapLayer.surface => AudioAssets.bgmSurface,
      MapLayer.cave => AudioAssets.bgmCave,
      MapLayer.tower => AudioAssets.bgmTower,
      MapLayer.site => AudioAssets.bgmSite,
    };
    playBgm(path);
  }

  void playCombatBgm() => playBgm(AudioAssets.bgmCombat);

  void playEndingBgm() => playBgm(AudioAssets.bgmEnding, loop: false);

  void playSfx(GameSfx sfx) {
    if (!isActive || !_prefs.sfxEnabled) return;
    final path = sfx.path;
    try {
      final player = _sfxPlayers[_sfxIndex];
      _sfxIndex = (_sfxIndex + 1) % _sfxPlayers.length;
      unawaited(_playOnPlayer(player, path));
    } catch (_) {}
  }

  Future<void> _playOnPlayer(AudioPlayer player, String path) async {
    try {
      await player.stop();
      await player.setAsset(path);
      await player.setVolume(_prefs.effectiveSfxVolume);
      await player.play();
    } catch (_) {}
  }

  void playUiClick() => playSfx(GameSfx.uiClick);

  void playUiOpenPanel() => playSfx(GameSfx.uiOpenPanel);

  void playUiClosePanel() => playSfx(GameSfx.uiClosePanel);

  void playSfxForCombatStep(CombatActionStep step) {
    switch (step.kind) {
      case CombatActionKind.attack:
        playSfx(step.amount > 0 ? GameSfx.combatHit : GameSfx.combatMiss);
      case CombatActionKind.skill:
        playSfx(GameSfx.combatSkill);
      case CombatActionKind.heal:
        playSfx(GameSfx.combatHeal);
      case CombatActionKind.miss:
        playSfx(GameSfx.combatMiss);
      case CombatActionKind.fleeAttempt:
      case CombatActionKind.fleeSuccess:
        playSfx(GameSfx.combatFlee);
      case CombatActionKind.statusApply:
      case CombatActionKind.statusTick:
      case CombatActionKind.statusExpire:
      case CombatActionKind.statusResist:
        playSfx(GameSfx.combatStatus);
      case CombatActionKind.defend:
      case CombatActionKind.fleeFail:
      case CombatActionKind.death:
      case CombatActionKind.actionSkipped:
        break;
    }
  }

  void onCommandVerb(String verb) {
    switch (verb) {
      case 'take':
      case 'get':
        playSfx(GameSfx.explorePickup);
      case 'drop':
        playSfx(GameSfx.exploreDrop);
      case 'use':
        playSfx(GameSfx.exploreUseItem);
      case 'talk':
      case 'say':
        playSfx(GameSfx.exploreTalk);
      case 'north':
      case 'south':
      case 'east':
      case 'west':
      case 'up':
      case 'down':
      case 'n':
      case 's':
      case 'e':
      case 'w':
      case 'u':
      case 'd':
        playSfx(GameSfx.exploreFootstep);
      case 'flee':
      case 'run':
        playSfx(GameSfx.combatFlee);
      case 'attack':
        playSfx(GameSfx.combatAttack);
    }
  }

  Future<void> dispose() async {
    _prefs.removeListener(_onPrefsChanged);
    await _bgmPlayer.dispose();
    for (final p in _sfxPlayers) {
      await p.dispose();
    }
  }
}
