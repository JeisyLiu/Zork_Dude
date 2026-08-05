import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_actor.dart';
import 'package:zork_dude/domain/combat/combat_command.dart';
import 'package:zork_dude/domain/combat/status_effect.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/components/game_progress_bar.dart';
import 'package:zork_dude/ui/combat/combat_command_labels.dart';
import 'package:zork_dude/ui/combat/combat_status_chips.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class CombatUnitCard extends StatelessWidget {
  const CombatUnitCard({
    super.key,
    required this.actor,
    required this.statusRegistry,
    this.selected = false,
    this.targetable = false,
    this.compact = false,
    this.onTap,
    this.flashDamage = false,
    this.flashHeal = false,
    this.commandBadge,
  });

  final CombatActor actor;
  final StatusEffectRegistry statusRegistry;
  final bool selected;
  final bool targetable;
  final bool compact;
  final VoidCallback? onTap;
  final bool flashDamage;
  final bool flashHeal;
  final CombatCommand? commandBadge;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final borderColor = selected
        ? const Color(0xFFE8B84A)
        : targetable
            ? const Color(0xFF6EC1FF)
            : Colors.transparent;

    final atk = actor.effectiveAttack(statusRegistry);
    final def = actor.effectiveDefense(statusRegistry);
    final spd = actor.effectiveSpeed(statusRegistry);

    return Semantics(
      label: '${actor.name} HP ${actor.hp}/${actor.maxHp} 攻击 $atk 防御 $def 速度 $spd',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 2 : 4,
            vertical: compact ? 2 : 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: selected || targetable ? 2 : 1),
            borderRadius: BorderRadius.circular(6),
            color: flashDamage
                ? const Color(0x55FF4444)
                : flashHeal
                    ? const Color(0x5544FF88)
                    : const Color(0x22000000),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Text(
                      actor.emoji.isNotEmpty ? actor.emoji : (actor.isEnemy ? '👾' : '🧙'),
                      style: TextStyle(fontSize: compact ? 26 : 34),
                    ),
                    if (commandBadge != null)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xCC1A1208),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: GameOutlinedText(
                            CombatCommandLabels.shortLabel(commandBadge!.type),
                            fontSize: 7,
                            color: const Color(0xFFE8B84A),
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                GameOutlinedText(
                  actor.name,
                  fontSize: compact ? 10 : 12,
                  color: d.textPrimary,
                  strokeWidth: 0.8,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GameProgressBar(
                      value: actor.maxHp > 0 ? actor.hp / actor.maxHp : 0,
                      height: compact ? 8 : 10,
                      width: constraints.maxWidth.clamp(24, 120),
                    );
                  },
                ),
                GameOutlinedText(
                  '${actor.hp}/${actor.maxHp}',
                  fontSize: compact ? 8 : 9,
                  color: d.textPrimary,
                  strokeWidth: 0,
                ),
                const SizedBox(height: 2),
                GameOutlinedText(
                  '⚔$atk 🛡$def 💨$spd',
                  fontSize: compact ? 7 : 8,
                  color: d.textMuted,
                  strokeWidth: 0,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CombatStatusChips(actor: actor, registry: statusRegistry, compact: compact),
              ],
            ),
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
    required this.statusRegistry,
    this.pendingCommands = const {},
    this.selectedActorId,
    this.highlightedTargetId,
    this.targetableSide,
    this.compact = false,
    this.flashIds = const {},
    this.onActorTap,
  });

  final List<CombatActor> allies;
  final List<CombatActor> enemies;
  final StatusEffectRegistry statusRegistry;
  final Map<String, CombatCommand> pendingCommands;
  final String? selectedActorId;
  final String? highlightedTargetId;
  final bool? targetableSide;
  final bool compact;
  final Set<String> flashIds;
  final void Function(CombatActor actor)? onActorTap;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      withBorder: true,
      padding: EdgeInsets.fromLTRB(
        compact ? 8 : 10,
        compact ? 6 : 8,
        compact ? 8 : 10,
        compact ? 6 : 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _row(
              context,
              label: '敌人 Enemies',
              actors: enemies,
              targetable: targetableSide == true,
            ),
          ),
          SizedBox(height: compact ? 4 : 6),
          Expanded(
            child: _row(
              context,
              label: '队伍 Party',
              actors: allies,
              targetable: targetableSide == false,
            ),
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
    final living = actors.where((a) => a.alive).toList(growable: false);
    // Keep at least 1 slot so Expanded layout stays stable with empty side.
    final slotCount = living.isEmpty ? 1 : living.length.clamp(1, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameOutlinedText(label, fontSize: compact ? 9 : 10, color: d.textMuted, strokeWidth: 0.8),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < slotCount; i++) ...[
                if (i > 0) SizedBox(width: compact ? 4 : 6),
                Expanded(
                  child: i < living.length
                      ? CombatUnitCard(
                          actor: living[i],
                          statusRegistry: statusRegistry,
                          compact: compact,
                          selected: living[i].instanceId == selectedActorId ||
                              living[i].instanceId == highlightedTargetId,
                          targetable: targetable,
                          commandBadge: pendingCommands[living[i].instanceId],
                          flashDamage: flashIds.contains('${living[i].instanceId}_dmg'),
                          flashHeal: flashIds.contains('${living[i].instanceId}_heal'),
                          onTap: onActorTap == null ? null : () => onActorTap!(living[i]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
