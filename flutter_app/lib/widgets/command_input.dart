import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CommandInputRow extends StatefulWidget {
  const CommandInputRow({super.key, required this.controller});

  final GameController controller;

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: d.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: const [
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(1, 0)),
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(-1, 0)),
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(0, 1)),
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(0, -1)),
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(1, 1)),
                  Shadow(color: Colors.white, blurRadius: 0, offset: Offset(-1, -1)),
                ],
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '命令 cmd: look / take 1 / n …',
                hintStyle: TextStyle(
                  color: d.textMuted,
                  shadows: const [
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(1, 0)),
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(-1, 0)),
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(0, 1)),
                    Shadow(color: Colors.white, blurRadius: 0, offset: Offset(0, -1)),
                  ],
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          GameButton(
            label: '发送',
            subLabel: 'send',
            height: 32,
            width: 64,
            onPressed: _submit,
            semanticLabel: '发送命令',
          ),
        ],
      ),
    );
  }
}
