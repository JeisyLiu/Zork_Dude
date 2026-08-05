import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatRoundLog extends StatelessWidget {
  const CombatRoundLog({
    super.key,
    required this.messages,
    this.steps = const [],
  });

  final List<String> messages;
  final List<CombatActionStep> steps;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final lines = <String>[...messages];
    for (final s in steps) {
      if (s.message.isNotEmpty) lines.add(s.message);
    }

    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GameOutlinedText('战报 Log', fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: GameOutlinedText(
                  lines[i],
                  fontSize: 10,
                  color: d.textPrimary,
                  strokeWidth: 0,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
