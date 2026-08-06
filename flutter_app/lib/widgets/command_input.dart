import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

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
    return GamePanel(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
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
