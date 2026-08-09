import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/services/audio/audio_preferences.dart';
import 'package:zork_dude/services/audio/game_audio_service.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/exploration_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Opens the global settings overlay from any screen.
abstract final class SettingsEntry {
  static Future<void> open(
    BuildContext context, {
    GameUiSkin skin = GameUiSkin.fantasy,
  }) {
    GameAudioService.instance.playUiOpenPanel();
    return LandscapeOverlay.show<void>(
      context: context,
      title: AppLocalizations.of(context).settingsTitle,
      skin: skin,
      onDismiss: GameAudioService.instance.playUiClosePanel,
      child: const SettingsPanel(),
    );
  }
}

/// Gear icon entry point (home / exploration status bar).
class SettingsGearButton extends StatelessWidget {
  const SettingsGearButton({
    super.key,
    this.skin = GameUiSkin.fantasy,
    this.size,
  });

  final GameUiSkin skin;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final btnSize = size ?? LandscapeLayout.minTouch(context, 32);
    final d = GameUiTheme.dataFor(skin);
    return GameIconButton(
      size: btnSize,
      semanticLabel: l10n.settingsGearSemantics,
      onPressed: () => SettingsEntry.open(context, skin: skin),
      child: Icon(Icons.settings, size: btnSize * 0.45, color: d.textPrimary),
    );
  }
}

/// Settings panel body (audio toggles + privacy).
class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final _prefs = AudioPreferences.instance;

  @override
  void initState() {
    super.initState();
    _prefs.addListener(_onPrefsChanged);
    if (!_prefs.loaded) {
      unawaited(_prefs.load());
    }
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() {
    if (mounted) setState(() {});
    GameAudioService.instance.refreshVolumes();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = GameUiTheme.of(context);
    final btnH = ExplorationLayoutConstants.chipHeightFor(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toggleRow(
          context,
          label: l10n.settingsBgmEnabled,
          value: _prefs.bgmEnabled,
          onChanged: (v) async {
            await _prefs.setBgmEnabled(v);
            if (!v) {
              await GameAudioService.instance.stopBgm();
            }
          },
        ),
        const SizedBox(height: 12),
        _toggleRow(
          context,
          label: l10n.settingsSfxEnabled,
          value: _prefs.sfxEnabled,
          onChanged: _prefs.setSfxEnabled,
        ),
        if (OffpackAds.instance.privacyOptionsRequired) ...[
          const SizedBox(height: 16),
          GameButton(
            width: double.infinity,
            height: btnH,
            label: l10n.privacySettings,
            subLabel: 'privacy',
            onPressed: OffpackAds.instance.showPrivacyOptions,
          ),
        ],
        const SizedBox(height: 8),
        GameOutlinedText(
          l10n.settingsHint,
          fontSize: 11,
          color: d.textMuted,
          strokeWidth: 0,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _toggleRow(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final d = GameUiTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: GameOutlinedText(
            label,
            fontSize: 12,
            color: d.textPrimary,
            strokeWidth: 0,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: d.textPrimary,
        ),
      ],
    );
  }
}
