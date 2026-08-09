import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

class CreditLine {
  const CreditLine(this.role, this.name);

  final String role;
  final String name;
}

/// Movie-style scrolling credits after site finale.
class CreditsRoll extends StatefulWidget {
  const CreditsRoll({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<CreditsRoll> createState() => _CreditsRollState();
}

class _CreditsRollState extends State<CreditsRoll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scroll;
  bool _finished = false;

  List<CreditLine> _lines(AppLocalizations l10n) => [
        CreditLine(l10n.creditPresentedBy, 'Beatinghouse'),
        CreditLine(l10n.creditDirectedBy, 'Jeisy Liu'),
        CreditLine(l10n.creditWrittenBy, 'Jeisy Liu'),
        CreditLine(l10n.creditGameDesign, 'Jeisy Liu'),
        CreditLine(l10n.creditNarrativeDesign, 'Jeisy Liu'),
        CreditLine(l10n.creditArtDirection, 'Jeisy Liu'),
        CreditLine(l10n.creditLevelDesign, 'Jeisy Liu'),
        CreditLine(l10n.creditSystemsDesign, 'Jeisy Liu'),
        CreditLine(l10n.creditCombatDesign, 'Jeisy Liu'),
        CreditLine(l10n.creditSoundConcept, 'Jeisy Liu'),
        CreditLine(l10n.creditProducedBy, 'Jeisy Liu'),
        CreditLine(l10n.creditEngineering, 'Jeisy Liu'),
        CreditLine(l10n.creditQa, 'Jeisy Liu'),
        CreditLine(l10n.creditSpecialThanks, 'Jeisy Liu'),
        CreditLine(l10n.creditTechSupport, 'Anysphere, xAI'),
        const CreditLine('', 'Mist Tower'),
        CreditLine('', l10n.appTitle),
        const CreditLine('', 'A Beatinghouse Game'),
      ];

  @override
  void initState() {
    super.initState();
    _scroll = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    if (!mounted) return;
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) {
      _scroll.value = 1;
      return;
    }
    _scroll.duration = const Duration(seconds: 32);
    _scroll.forward().whenComplete(() {
      if (mounted) setState(() => _finished = true);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _skip() {
    if (_finished) return;
    _scroll.stop();
    setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final short = LandscapeLayout.isShort(size);
    final disable = MediaQuery.disableAnimationsOf(context);
    final btnW = short ? 148.0 : 168.0;
    final btnH = HomeConstants.buttonHeightFor(btnW);
    final l10n = AppLocalizations.of(context);
    final lines = _lines(l10n);

    return Material(
      color: HomeConstants.bgBottom,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!disable && !_finished)
            AnimatedBuilder(
              animation: _scroll,
              builder: (context, _) {
                final offset = size.height * (1.1 - _scroll.value * 1.8);
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: _CreditsColumn(lines: lines, short: short),
                );
              },
            )
          else
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _CreditsColumn(lines: lines, short: short),
              ),
            ),
          if (!_finished && !disable)
            Positioned(
              top: 8,
              right: 12,
              child: TextButton(
                onPressed: _skip,
                child: GameOutlinedText(
                  l10n.skip,
                  fontSize: 13,
                  color: HomeConstants.subtitleColor,
                  strokeWidth: 0,
                ),
              ),
            ),
          if (_finished || disable)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GameButton(
                      width: btnW,
                      height: btnH,
                      compact: true,
                      label: l10n.endingMainPrimary,
                      onPressed: widget.onFinished,
                    ),
                    const SizedBox(height: 8),
                    GameButton(
                      width: btnW,
                      height: btnH,
                      compact: true,
                      label: l10n.backToTitle,
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CreditsColumn extends StatelessWidget {
  const _CreditsColumn({required this.lines, required this.short});

  final List<CreditLine> lines;
  final bool short;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        for (final line in lines) ...[
          if (line.role.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: GameOutlinedText(
                line.role,
                fontSize: short ? 11 : 12,
                color: HomeConstants.subtitleColor,
                strokeWidth: 0,
                letterSpacing: 1.2,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: line.role.isEmpty ? 28 : 6),
            child: GameOutlinedText(
              line.name,
              fontSize: line.role.isEmpty ? (short ? 18 : 22) : (short ? 14 : 16),
              fontWeight: line.role.isEmpty ? FontWeight.w700 : FontWeight.w500,
              color: HomeConstants.titleColor,
              strokeWidth: 0,
              letterSpacing: line.role.isEmpty ? 2 : 0.5,
            ),
          ),
        ],
        const SizedBox(height: 120),
      ],
    );
  }
}
