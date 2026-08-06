import 'package:flutter/material.dart';
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
  static const _lines = <CreditLine>[
    CreditLine('出品 / Presented by', 'Beatinghouse'),
    CreditLine('导演 / Directed by', 'Jeisy Liu'),
    CreditLine('编剧 / Written by', 'Jeisy Liu'),
    CreditLine('游戏设计 / Game Design', 'Jeisy Liu'),
    CreditLine('叙事设计 / Narrative Design', 'Jeisy Liu'),
    CreditLine('美术指导 / Art Direction', 'Jeisy Liu'),
    CreditLine('关卡设计 / Level Design', 'Jeisy Liu'),
    CreditLine('系统设计 / Systems Design', 'Jeisy Liu'),
    CreditLine('战斗设计 / Combat Design', 'Jeisy Liu'),
    CreditLine('音效构想 / Sound Concept', 'Jeisy Liu'),
    CreditLine('制作人 / Produced by', 'Jeisy Liu'),
    CreditLine('程序 / Engineering', 'Jeisy Liu'),
    CreditLine('QA / Quality Assurance', 'Jeisy Liu'),
    CreditLine('特别鸣谢 / Special Thanks', 'Jeisy Liu'),
    CreditLine('技术支持 / Technology Support', 'Anysphere, xAI'),
    CreditLine('', 'Mist Tower'),
    CreditLine('', '迷雾之塔'),
    CreditLine('', 'A Beatinghouse Game'),
  ];

  late final AnimationController _scroll;
  bool _finished = false;

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
                  child: _CreditsColumn(lines: _lines, short: short),
                );
              },
            )
          else
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _CreditsColumn(lines: _lines, short: short),
              ),
            ),
          if (!_finished && !disable)
            Positioned(
              top: 8,
              right: 12,
              child: TextButton(
                onPressed: _skip,
                child: const GameOutlinedText(
                  '跳过',
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
                      label: '继续探索',
                      onPressed: widget.onFinished,
                    ),
                    const SizedBox(height: 8),
                    GameButton(
                      width: btnW,
                      height: btnH,
                      compact: true,
                      label: '回标题',
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
