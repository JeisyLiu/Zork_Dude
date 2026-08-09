import 'package:flutter/material.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
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
    GameController? controller,
  }) {
    final title = mode == SaveSlotPickerMode.read ? '📂' : '💾';
    return LandscapeOverlay.show<int>(
      context: context,
      title: title,
      skin: skin,
      child: _SaveSlotGrid(
        mode: mode,
        slots: slots,
        controller: controller,
        skin: skin,
      ),
    );
  }
}

class _SaveSlotGrid extends StatefulWidget {
  const _SaveSlotGrid({
    required this.mode,
    required this.slots,
    this.controller,
    this.skin = GameUiSkin.fantasy,
  });

  final SaveSlotPickerMode mode;
  final List<SaveSlotInfo?> slots;
  final GameController? controller;
  final GameUiSkin skin;

  @override
  State<_SaveSlotGrid> createState() => _SaveSlotGridState();
}

class _SaveSlotGridState extends State<_SaveSlotGrid> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  List<SaveSlotInfo?> get _slots => widget.controller?.slots ?? widget.slots;

  bool get _canDelete => widget.controller != null;

  Future<void> _confirmDelete(int index) async {
    final controller = widget.controller;
    if (controller == null || _slots[index] == null) return;
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final confirmed = await GameConfirmDialog.show(
      context: context,
      title: l10n.deleteSaveTitle,
      message: l10n.deleteSaveMessage,
      confirmLabel: l10n.deleteSaveConfirm,
      confirmSubLabel: 'delete',
      skin: widget.skin,
    );
    if (!confirmed || !mounted) return;
    await controller.deleteSlot(index);
    if (!mounted) return;
    if (widget.mode == SaveSlotPickerMode.read &&
        controller.occupiedCount == 0) {
      navigator.pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = _slots;
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
        final enabled = widget.mode == SaveSlotPickerMode.write || occupied;
        return _SlotTile(
          index: index,
          info: info,
          enabled: enabled,
          showDelete: _canDelete && occupied,
          onTap: enabled
              ? () => Navigator.of(context).pop(index)
              : null,
          onDelete: _canDelete && occupied ? () => _confirmDelete(index) : null,
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
    required this.showDelete,
    this.onTap,
    this.onDelete,
  });

  final int index;
  final SaveSlotInfo? info;
  final bool enabled;
  final bool showDelete;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = GameUiTheme.of(context);
    final marker = SaveSlotInfo.slotMarkers[index.clamp(0, 7)];
    final l10n = AppLocalizations.of(context);

    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(4),
                child: GamePanel(
                  dark: true,
                  withBorder: true,
                  padding: EdgeInsets.fromLTRB(
                    4,
                    4,
                    showDelete ? 22 : 4,
                    6,
                  ),
                  child: info == null
                      ? _emptySlot(marker, theme)
                      : _filledSlot(info!, marker, theme),
                ),
              ),
            ),
            if (showDelete && onDelete != null)
              Positioned(
                top: 2,
                right: 2,
                child: GameIconButton(
                  size: 20,
                  semanticLabel: l10n.deleteSaveSemantics,
                  onPressed: onDelete,
                  child: Icon(
                    Icons.delete_outline,
                    size: 12,
                    color: theme.textPrimary,
                  ),
                ),
              ),
          ],
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
