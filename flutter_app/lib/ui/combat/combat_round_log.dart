import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_action_step.dart';
import 'package:zork_dude/domain/combat/combat_types.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatRoundLog extends StatelessWidget {
  const CombatRoundLog({
    super.key,
    required this.messages,
    this.steps = const [],
    this.compact = false,
  });

  final List<String> messages;
  final List<CombatActionStep> steps;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final titleSize = compact ? 12.0 : 14.0;
    final bodySize = compact ? 12.0 : 14.0;
    final lines = <_LogLine>[
      for (final m in messages) _LogLine(text: m),
      for (final s in steps)
        if (s.message.isNotEmpty) _LogLine(text: s.message, kind: s.kind),
    ];

    return Semantics(
      liveRegion: true,
      child: GamePanel(
        withBorder: true,
        padding: GamePanel.compactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GameOutlinedText(
              '战报 Log',
              fontSize: titleSize,
              color: d.textMuted,
              strokeWidth: 0,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: lines.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: GameOutlinedText(
                    lines[i].text,
                    fontSize: bodySize,
                    color: _colorFor(lines[i].kind, d),
                    strokeWidth: 0,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(CombatActionKind? kind, GameUiSkinData d) {
    if (kind == null) return d.textPrimary;
    return switch (kind) {
      CombatActionKind.attack ||
      CombatActionKind.skill ||
      CombatActionKind.statusTick =>
        const Color(0xFFFF8888),
      CombatActionKind.heal => const Color(0xFF88FFAA),
      CombatActionKind.statusApply => const Color(0xFF88CCFF),
      CombatActionKind.statusExpire || CombatActionKind.statusResist => d.textMuted,
      CombatActionKind.actionSkipped => const Color(0xFFCCCCCC),
      CombatActionKind.death => const Color(0xFFFF6666),
      _ => d.textPrimary,
    };
  }
}

class _LogLine {
  const _LogLine({required this.text, this.kind});

  final String text;
  final CombatActionKind? kind;
}
