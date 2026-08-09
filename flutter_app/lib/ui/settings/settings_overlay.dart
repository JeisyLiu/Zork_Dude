import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/l10n/locale_tag.dart';
import 'package:zork_dude/services/audio/audio_preferences.dart';
import 'package:zork_dude/services/audio/game_audio_service.dart';
import 'package:zork_dude/services/locale_preferences.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
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
      child: SettingsPanel(skin: skin),
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

/// Settings panel body (audio toggles, language, privacy).
class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key, this.skin = GameUiSkin.fantasy});

  final GameUiSkin skin;

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final _audioPrefs = AudioPreferences.instance;
  final _localePrefs = LocalePreferences.instance;
  late String _selectedLocaleTag;

  @override
  void initState() {
    super.initState();
    _selectedLocaleTag = _localePrefs.effectiveTag;
    _audioPrefs.addListener(_onAudioPrefsChanged);
    _localePrefs.addListener(_onLocalePrefsChanged);
    if (!_audioPrefs.loaded) {
      unawaited(_audioPrefs.load());
    }
    if (!_localePrefs.loaded) {
      unawaited(_localePrefs.load());
    }
  }

  @override
  void dispose() {
    _audioPrefs.removeListener(_onAudioPrefsChanged);
    _localePrefs.removeListener(_onLocalePrefsChanged);
    super.dispose();
  }

  void _onAudioPrefsChanged() {
    if (mounted) setState(() {});
    GameAudioService.instance.refreshVolumes();
  }

  void _onLocalePrefsChanged() {
    if (mounted) {
      setState(() => _selectedLocaleTag = _localePrefs.effectiveTag);
    }
  }

  Future<void> _onLanguageChanged(String? tag) async {
    if (tag == null || tag == _localePrefs.effectiveTag) return;
    final previous = _selectedLocaleTag;
    setState(() => _selectedLocaleTag = tag);

    final l10n = AppLocalizations.of(context);
    final confirmed = await GameConfirmDialog.show(
      context: context,
      title: l10n.languageRestartTitle,
      message: l10n.languageRestartMessage,
      confirmLabel: l10n.languageRestartConfirm,
      confirmSubLabel: 'restart',
      skin: widget.skin,
    );
    if (!confirmed || !mounted) {
      setState(() => _selectedLocaleTag = previous);
      return;
    }

    await _localePrefs.setTag(tag);
    if (!mounted) return;
    Navigator.of(context).pop();
    _localePrefs.softRelaunch();
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
          value: _audioPrefs.bgmEnabled,
          onChanged: (v) async {
            await _audioPrefs.setBgmEnabled(v);
            if (!v) {
              await GameAudioService.instance.stopBgm();
            }
          },
        ),
        const SizedBox(height: 12),
        _toggleRow(
          context,
          label: l10n.settingsSfxEnabled,
          value: _audioPrefs.sfxEnabled,
          onChanged: _audioPrefs.setSfxEnabled,
        ),
        const SizedBox(height: 12),
        _languageRow(context, l10n.settingsLanguage),
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
      ],
    );
  }

  Widget _languageRow(BuildContext context, String label) {
    final d = GameUiTheme.of(context);
    // Closed control sits on a dark panel → light ink.
    // Menu popup uses parchment cream → dark ink (fantasy panel contrast).
    const parchment = Color(0xFFE8D9B8);
    const parchmentBorder = Color(0xFF8A7048);
    return Row(
      children: [
        Expanded(
          child: GameOutlinedText(
            label,
            fontSize: 12,
            color: d.logText,
            strokeWidth: 0,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: parchment,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: parchmentBorder, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocaleTag,
                isDense: true,
                dropdownColor: parchment,
                iconEnabledColor: d.textPrimary,
                iconDisabledColor: d.textMuted,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: d.textPrimary,
                ),
                items: [
                  for (final tag in LocaleTag.all)
                    DropdownMenuItem(
                      value: tag,
                      child: Text(
                        LocalePreferences.displayNames[tag] ?? tag,
                        style: TextStyle(
                          fontSize: 12,
                          color: d.textPrimary,
                        ),
                      ),
                    ),
                ],
                onChanged: _onLanguageChanged,
              ),
            ),
          ),
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
