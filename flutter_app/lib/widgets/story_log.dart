import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class StoryLogView extends StatelessWidget {
  const StoryLogView({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    return GamePanel(
      dark: true,
      withBorder: true,
      padding: const EdgeInsets.all(4),
      child: RawScrollbar(
        thumbVisibility: true,
        thickness: 8,
        radius: const Radius.circular(4),
        thumbColor: d.textMuted.withValues(alpha: 0.6),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.log.length,
          itemBuilder: (context, i) {
            final entry = controller.log[i];
            final text = entry.isCommand
                ? '> ${entry.text.replaceFirst('> ', '')}'
                : entry.text;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GameOutlinedText(
                  text,
                  fontSize: 13,
                  fontWeight: entry.isCommand ? FontWeight.w600 : FontWeight.w500,
                  color: entry.isCommand ? const Color(0xFF5C4018) : d.textPrimary,
                  strokeWidth: 2.6,
                  height: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
