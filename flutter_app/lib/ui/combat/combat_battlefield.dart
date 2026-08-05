import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/game_progress_bar.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatUnitCard extends StatelessWidget {
  const CombatUnitCard({
    super.key,
    required this.actor,
    this.selected = false,
    this.targetable = false,
    this.compact = false,
    this.onTap,
    this.flashDamage = false,
    this.flashHeal = false,
  });

  final CombatActor actor;
  final bool selected;
  final bool targetable;
  final bool compact;
  final VoidCallback? onTap;
  final bool flashDamage;
  final bool flashHeal;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final size = compact ? CombatLayoutConstants.unitSlotCompact : CombatLayoutConstants.unitSlotWidth;
    final borderColor = selected
        ? const Color(0xFFE8B84A)
        : targetable
            ? const Color(0xFF6EC1FF)
            : Colors.transparent;

    return Semantics(
      label: '${actor.name} HP ${actor.hp}/${actor.maxHp}',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: selected || targetable ? 2 : 0),
            borderRadius: BorderRadius.circular(6),
            color: flashDamage
                ? const Color(0x55FF4444)
                : flashHeal
                    ? const Color(0x5544FF88)
                    : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actor.emoji.isNotEmpty ? actor.emoji : (actor.isEnemy ? '👾' : '🧙'),
                style: TextStyle(fontSize: compact ? 22 : 28),
              ),
              const SizedBox(height: 2),
              GameOutlinedText(
                actor.name,
                fontSize: compact ? 9 : 10,
                color: d.textPrimary,
                strokeWidth: 0.8,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              GameProgressBar(
                value: actor.maxHp > 0 ? actor.hp / actor.maxHp : 0,
                height: compact ? 8 : 10,
                width: size - 8,
              ),
              if (actor.defending)
                GameOutlinedText(
                  '防御',
                  fontSize: 8,
                  color: d.textMuted,
                  strokeWidth: 0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CombatBattlefield extends StatelessWidget {
  const CombatBattlefield({
    super.key,
    required this.allies,
    required this.enemies,
    this.selectedActorId,
    this.highlightedTargetId,
    this.targetableSide,
    this.compact = false,
    this.flashIds = const {},
    this.onActorTap,
  });

  final List<CombatActor> allies;
  final List<CombatActor> enemies;
  final String? selectedActorId;
  final String? highlightedTargetId;
  final bool? targetableSide; // true = enemies targetable, false = allies
  final bool compact;
  final Set<String> flashIds;
  final void Function(CombatActor actor)? onActorTap;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      withBorder: true,
      padding: GamePanel.compactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row(
            context,
            label: '敌人 Enemies',
            actors: enemies,
            targetable: targetableSide == true,
          ),
          const SizedBox(height: 10),
          _row(
            context,
            label: '队伍 Party',
            actors: allies,
            targetable: targetableSide == false,
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String label,
    required List<CombatActor> actors,
    required bool targetable,
  }) {
    final d = GameUiTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameOutlinedText(label, fontSize: 10, color: d.textMuted, strokeWidth: 0.8),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final a in actors)
                if (a.alive)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CombatUnitCard(
                      actor: a,
                      compact: compact,
                      selected: a.instanceId == selectedActorId || a.instanceId == highlightedTargetId,
                      targetable: targetable,
                      flashDamage: flashIds.contains('${a.instanceId}_dmg'),
                      flashHeal: flashIds.contains('${a.instanceId}_heal'),
                      onTap: onActorTap == null ? null : () => onActorTap!(a),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
