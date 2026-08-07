import 'package:flutter/material.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

enum SaveSlotPickerMode { read, write }

/// 4x2 save-slot grid; slot content is emoji + numbers only.
abstract final class SaveSlotPicker {
  static Future<int?> show({
    required BuildContext context,
    required SaveSlotPickerMode mode,
    required List<SaveSlotInfo?> slots,
    GameUiSkin skin = GameUiSkin.fantasy,
  }) {
    final title = mode == SaveSlotPickerMode.read ? '📂' : '💾';
    return LandscapeOverlay.show<int>(
      context: context,
      title: title,
      skin: skin,
      child: _SaveSlotGrid(mode: mode, slots: slots),
    );
  }
}

class _SaveSlotGrid extends StatelessWidget {
  const _SaveSlotGrid({
    required this.mode,
    required this.slots,
  });

  final SaveSlotPickerMode mode;
  final List<SaveSlotInfo?> slots;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemCount: SaveRepository.maxSlots,
      itemBuilder: (context, index) {
        final info = index < slots.length ? slots[index] : null;
        final occupied = info != null;
        final enabled = mode == SaveSlotPickerMode.write || occupied;
        return _SlotTile(
          index: index,
          info: info,
          enabled: enabled,
          onTap: enabled
              ? () => Navigator.of(context).pop(index)
              : null,
        );
      },
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.index,
    required this.info,
    required this.enabled,
    this.onTap,
  });

  final int index;
  final SaveSlotInfo? info;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = GameUiTheme.of(context);
    final marker = SaveSlotInfo.slotMarkers[index.clamp(0, 7)];

    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: GamePanel(
            dark: true,
            withBorder: true,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: info == null
                ? _emptySlot(marker, theme)
                : _filledSlot(info!, marker, theme),
          ),
        ),
      ),
    );
  }

  Widget _emptySlot(String marker, GameUiSkinData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GameOutlinedText(
          marker,
          fontSize: 12,
          color: theme.textMuted,
          strokeWidth: 0,
        ),
        const SizedBox(height: 4),
        const Text('➕', style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _filledSlot(SaveSlotInfo info, String marker, GameUiSkinData theme) {
    final time = SaveSlotInfo.formatRelativeTime(info.savedAt);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(marker, style: TextStyle(fontSize: 10, color: theme.textMuted)),
          Text('⭐${info.score}', style: const TextStyle(fontSize: 11)),
          Text('❤️${info.playerHp}/${info.playerMaxHp}', style: const TextStyle(fontSize: 10)),
          if (info.layerEmojiLine.isNotEmpty)
            Text(info.layerEmojiLine, style: const TextStyle(fontSize: 11)),
          Text('🕐$time', style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}
