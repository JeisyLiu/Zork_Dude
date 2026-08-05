import 'package:flutter/material.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF12121E),
        border: Border.all(color: const Color(0xFF2A2A4A)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: GameConstants.accent, fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '命令 cmd: look / take 1 / n …',
                hintStyle: TextStyle(color: Color(0xFF7F8FA6)),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.send, color: GameConstants.hero, size: 20),
          ),
        ],
      ),
    );
  }
}
