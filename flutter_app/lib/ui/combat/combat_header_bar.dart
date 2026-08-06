import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_encounter.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatHeaderBar extends StatelessWidget {
  const CombatHeaderBar({
    super.key,
    required this.encounter,
    required this.phase,
    this.activeActorName,
    this.compact = false,
  });

  final CombatEncounter encounter;
  final CombatUiPhase phase;
  final String? activeActorName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final phaseText = switch (phase) {
      CombatUiPhase.pickingCommand => activeActorName != null ? '选择指令：$activeActorName' : '选择指令',
      CombatUiPhase.pickingTarget => '选择目标',
      CombatUiPhase.pickingItem => '选择道具与目标',
      CombatUiPhase.readyToExecute => '准备执行回合',
      CombatUiPhase.animating => '回合进行中…',
    };

    return ConstrainedBox(
      // Nine-patch panel borders need ≥32px; keep a readable header height.
      constraints: BoxConstraints(minHeight: compact ? 36 : 40),
      child: GamePanel(
        withBorder: true,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 8 : 10,
        ),
        child: Row(
          children: [
            GameOutlinedText(
              '第 ${encounter.roundNumber} 回合',
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.bold,
              color: d.textPrimary,
              strokeWidth: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GameOutlinedText(
                phaseText,
                fontSize: compact ? 9 : 10,
                color: d.textMuted,
                strokeWidth: 0,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
