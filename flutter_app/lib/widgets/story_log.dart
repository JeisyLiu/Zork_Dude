import 'package:flutter/material.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

class StoryLogView extends StatelessWidget {
  const StoryLogView({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        border: Border.all(color: const Color(0xFF1E1E32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.log.length,
        itemBuilder: (context, i) {
          final entry = controller.log[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              entry.isCommand ? '> ${entry.text.replaceFirst('> ', '')}' : entry.text,
              style: TextStyle(
                color: entry.isCommand ? GameConstants.hero : GameConstants.accent,
                height: 1.6,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }
}
