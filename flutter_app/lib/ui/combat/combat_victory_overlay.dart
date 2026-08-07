import 'package:flutter/material.dart';
import 'package:zork_dude/domain/combat/combat_reward.dart';
import 'package:zork_dude/ui/combat/encounter_assets.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Victory loot summary. Tap anywhere to continue — left art, right text.
class CombatVictoryOverlay extends StatefulWidget {
  const CombatVictoryOverlay({
    super.key,
    required this.reward,
    required this.onContinue,
  });

  final CombatReward reward;
  final VoidCallback onContinue;

  @override
  State<CombatVictoryOverlay> createState() => _CombatVictoryOverlayState();
}

class _CombatVictoryOverlayState extends State<CombatVictoryOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _fade.value = 1;
      } else {
        _fade.forward();
      }
    });
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  void _continue() {
    if (_closed) return;
    _closed = true;
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final short = LandscapeLayout.isShort(size);
    final reward = widget.reward;
    const titleColor = Color(0xFFF2E6C8);
    const mutedColor = Color(0xFFC8B896);

    return Material(
      color: Colors.black.withValues(alpha: 0.82),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _continue,
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: short ? 16 : 24,
                vertical: short ? 8 : 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: short ? 5 : 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.asset(
                          EncounterAssets.combatVictory,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: short ? 10 : 16),
                  Expanded(
                    flex: short ? 5 : 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GameOutlinedText(
                                '战斗胜利',
                                fontSize: short ? 20 : 26,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                                letterSpacing: 2,
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: short ? 2 : 4),
                              const GameOutlinedText(
                                'VICTORY',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: mutedColor,
                                letterSpacing: 3,
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: short ? 10 : 14),
                              if (reward.defeatedNames.isNotEmpty) ...[
                                const _SectionLabel('击败'),
                                for (final name in reward.defeatedNames)
                                  _RewardLine(text: name),
                                const SizedBox(height: 10),
                              ],
                              if (reward.hasLoot) ...[
                                const _SectionLabel('战利品'),
                                for (final loot in reward.lootLabels)
                                  _RewardLine(text: loot, accent: true),
                                const SizedBox(height: 10),
                              ],
                              if (reward.hasCurrency) ...[
                                const _SectionLabel('收获'),
                                if (reward.gold > 0)
                                  _RewardLine(text: '💰 金币 +${reward.gold}'),
                                if (reward.exp > 0)
                                  _RewardLine(text: '⭐ 经验 +${reward.exp}'),
                                const SizedBox(height: 10),
                              ],
                              for (final note in reward.notes)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: GameOutlinedText(
                                    note,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: titleColor,
                                    height: 1.35,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              if (reward.banter != null) ...[
                                const SizedBox(height: 4),
                                GameOutlinedText(
                                  reward.banter!,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: mutedColor,
                                  height: 1.35,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                              SizedBox(height: short ? 12 : 16),
                              const GameOutlinedText(
                                '点击继续',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: mutedColor,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GameOutlinedText(
        text,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF9A8A6A),
        letterSpacing: 1.5,
        textAlign: TextAlign.right,
      ),
    );
  }
}

class _RewardLine extends StatelessWidget {
  const _RewardLine({required this.text, this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GameOutlinedText(
        text,
        fontSize: accent ? 14 : 13,
        fontWeight: accent ? FontWeight.w600 : FontWeight.w500,
        color: accent ? const Color(0xFFE8D59A) : const Color(0xFFF2E6C8),
        textAlign: TextAlign.right,
      ),
    );
  }
}
