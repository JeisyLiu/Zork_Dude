import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

class CommandInputRow extends StatefulWidget {
  const CommandInputRow({
    super.key,
    required this.controller,
    this.focusNode,
  });

  final GameController controller;
  final FocusNode? focusNode;

  @override
  State<CommandInputRow> createState() => _CommandInputRowState();
}

class _CommandInputRowState extends State<CommandInputRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.controller.executeCommand(text);
  }

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final short = LandscapeLayout.isShortOf(size, padding);
    final phoneShort = LandscapeLayout.isPhoneShortOf(size, padding);
    final panelPad = phoneShort
        ? const EdgeInsets.fromLTRB(10, 4, 8, 4)
        : (short
            ? const EdgeInsets.fromLTRB(12, 6, 8, 6)
            : const EdgeInsets.fromLTRB(14, 8, 10, 8));
    return GamePanel(
      padding: panelPad,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              style: TextStyle(
                color: d.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '命令 cmd: look / take 1 / n …',
                hintStyle: TextStyle(
                  color: d.textMuted,
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 4),
          GameIconButton(
            size: 36,
            semanticLabel: '发送命令',
            onPressed: _submit,
            child: Image.asset(
              GameUiAssets.arrowEast,
              width: 18,
              height: 18,
              filterQuality: FilterQuality.none,
            ),
          ),
        ],
      ),
    );
  }
}
