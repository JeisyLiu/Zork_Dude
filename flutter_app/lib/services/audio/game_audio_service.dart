import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/services/audio/audio_assets.dart';
import 'package:zork_dude/services/audio/audio_preferences.dart';

/// BGM + SFX playback. Missing assets and unsupported platforms fail silently.
class GameAudioService {
  GameAudioService._();

  static final GameAudioService instance = GameAudioService._();

  final AudioPreferences _prefs = AudioPreferences.instance;
  AudioPlayer? _bgmPlayer;
  List<AudioPlayer>? _sfxPlayers;
  int _sfxIndex = 0;
  bool _initialized = false;
  bool _disabled = false;
  String? _currentBgm;
  void _onPrefsChanged() => _applyBgmVolume();

  /// Set to true in widget tests to skip native audio initialization.
  static bool disableForTest = false;

  /// just_audio ships implementations for Android / iOS / macOS / web only.
  static bool get isPlatformSupported {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS =>
        true,
      _ => false,
    };
  }

  bool get isActive => _initialized && !_disabled && _bgmPlayer != null;

  Future<void> initialize() async {
    if (disableForTest || !isPlatformSupported) {
      _disabled = true;
      await _prefs.load();
      return;
    }
    if (_initialized || _disabled) return;
    try {
      await _prefs.load();
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      _bgmPlayer = AudioPlayer();
      _sfxPlayers = List.generate(4, (_) => AudioPlayer());
      _prefs.addListener(_onPrefsChanged);
      _initialized = true;
    } catch (_) {
      _disabled = true;
      await _safeDisposePlayers();
    }
  }

  void _applyBgmVolume() {
    final player = _bgmPlayer;
    if (!isActive || player == null) return;
    unawaited(player.setVolume(_prefs.effectiveBgmVolume));
  }

  void refreshVolumes() => _applyBgmVolume();

  Future<void> playBgm(String assetPath, {bool loop = true}) async {
    final player = _bgmPlayer;
    if (!isActive || player == null || !_prefs.bgmEnabled) return;
    if (_currentBgm == assetPath && player.playing) return;
    try {
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await player.setAsset(assetPath);
      await player.setVolume(_prefs.effectiveBgmVolume);
      _currentBgm = assetPath;
      await player.play();
    } catch (_) {
      _currentBgm = null;
    }
  }

  Future<void> stopBgm() async {
    _currentBgm = null;
    final player = _bgmPlayer;
    if (player == null) return;
    try {
      await player.stop();
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
    final players = _sfxPlayers;
    if (!isActive || players == null || !_prefs.sfxEnabled) return;
    try {
      final player = players[_sfxIndex];
      _sfxIndex = (_sfxIndex + 1) % players.length;
      unawaited(_playOnPlayer(player, sfx.path));
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

  Future<void> _safeDisposePlayers() async {
    final bgm = _bgmPlayer;
    final sfx = _sfxPlayers;
    _bgmPlayer = null;
    _sfxPlayers = null;
    try {
      if (bgm != null) await bgm.dispose();
    } catch (_) {}
    if (sfx != null) {
      for (final p in sfx) {
        try {
          await p.dispose();
        } catch (_) {}
      }
    }
  }

  Future<void> dispose() async {
    _prefs.removeListener(_onPrefsChanged);
    await _safeDisposePlayers();
  }
}
