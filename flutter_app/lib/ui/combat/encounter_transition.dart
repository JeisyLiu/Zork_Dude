import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/combat/encounter_assets.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';

/// Pokémon / Metal Max style wipe + ENCOUNTER / BATTLE START before combat.
class EncounterTransition extends StatefulWidget {
  const EncounterTransition({
    super.key,
    required this.onCompleted,
    this.enemyLabel = '',
  });

  final VoidCallback onCompleted;
  final String enemyLabel;

  @override
  State<EncounterTransition> createState() => _EncounterTransitionState();
}

class _EncounterTransitionState extends State<EncounterTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_notified) {
          _notified = true;
          widget.onCompleted();
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        if (!_notified) {
          _notified = true;
          widget.onCompleted();
        }
        return;
      }
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return const SizedBox.shrink();
    }

    return AbsorbPointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _EncounterWipePainter(t: t),
                child: const SizedBox.expand(),
              ),
              Center(
                child: _EncounterTitles(
                  t: t,
                  enemyLabel: widget.enemyLabel,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EncounterTitles extends StatelessWidget {
  const _EncounterTitles({required this.t, required this.enemyLabel});

  final double t;
  final String enemyLabel;

  @override
  Widget build(BuildContext context) {
    // 0.00–0.18 wipe
    // 0.18–0.55 ENCOUNTER
    // 0.50–0.85 BATTLE START
    final screen = MediaQuery.sizeOf(context);
    final bannerW = (screen.width * 0.9).clamp(280.0, 720.0);
    final encounterH = (bannerW * 0.30).clamp(88.0, 160.0);
    final battleH = (bannerW * 0.38).clamp(110.0, 200.0);
    final labelSize = screen.shortestSide < 420 ? 13.0 : 15.0;

    final encounterOpacity = _range(t, 0.16, 0.28, 0.55, 0.68);
    final battleOpacity = _range(t, 0.48, 0.58, 0.82, 0.95);
    final encounterScale = 0.88 + 0.12 * Curves.easeOutBack.transform(
          ((t - 0.16) / 0.18).clamp(0.0, 1.0),
        );
    final battleScale = 0.9 + 0.1 * Curves.easeOut.transform(
          ((t - 0.48) / 0.14).clamp(0.0, 1.0),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: encounterOpacity,
          child: Transform.scale(
            scale: encounterScale,
            child: _BannerOrText(
              asset: EncounterAssets.encounterBanner,
              fallback: 'ENCOUNTER!',
              fontSize: 42,
              width: bannerW,
              height: encounterH,
            ),
          ),
        ),
        if (enemyLabel.isNotEmpty) ...[
          const SizedBox(height: 12),
          Opacity(
            opacity: encounterOpacity * 0.95,
            child: GameOutlinedText(
              enemyLabel,
              fontSize: labelSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF0E6D0),
              strokeWidth: 0,
              shadowColor: Colors.black.withValues(alpha: 0.55),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Opacity(
          opacity: battleOpacity,
          child: Transform.scale(
            scale: battleScale,
            child: _BannerOrText(
              asset: EncounterAssets.battleStartBanner,
              fallback: 'BATTLE START',
              fontSize: 34,
              width: bannerW,
              height: battleH,
            ),
          ),
        ),
      ],
    );
  }

  /// Fade in [a0→a1], hold, fade out [b0→b1].
  static double _range(double t, double a0, double a1, double b0, double b1) {
    if (t < a0) return 0;
    if (t < a1) return ((t - a0) / (a1 - a0)).clamp(0.0, 1.0);
    if (t < b0) return 1;
    if (t < b1) return (1 - (t - b0) / (b1 - b0)).clamp(0.0, 1.0);
    return 0;
  }
}

class _BannerOrText extends StatelessWidget {
  const _BannerOrText({
    required this.asset,
    required this.fallback,
    required this.fontSize,
    required this.width,
    required this.height,
  });

  final String asset;
  final String fallback;
  final double fontSize;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
        errorBuilder: (_, _, _) => Center(
          child: GameOutlinedText(
            fallback,
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFF5E6C0),
            letterSpacing: 3,
            strokeWidth: 0,
            shadowColor: Colors.black.withValues(alpha: 0.65),
            shadowOffset: const Offset(0, 2),
            shadowBlurRadius: 3,
          ),
        ),
      ),
    );
  }
}

class _EncounterWipePainter extends CustomPainter {
  _EncounterWipePainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Light mist veil — keep the exploration scene readable, not a blackout.
    final veil = Curves.easeOut.transform((t / 0.22).clamp(0.0, 1.0)) * 0.38;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF2A2418).withValues(alpha: veil),
    );

    // Soft alternating stripe wipe (lighter olive / parchment).
    final stripeProgress =
        Curves.easeInCubic.transform((t / 0.42).clamp(0.0, 1.0));
    const stripeCount = 9;
    final stripeH = h / stripeCount;
    for (var i = 0; i < stripeCount; i++) {
      final delay = i / stripeCount * 0.32;
      final p = ((stripeProgress - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final fromLeft = i.isEven;
      final cover = w * p;
      final rect = fromLeft
          ? Rect.fromLTWH(0, i * stripeH, cover, stripeH + 1)
          : Rect.fromLTWH(w - cover, i * stripeH, cover, stripeH + 1);
      final base = Color.lerp(
        const Color(0xFF6A6048),
        const Color(0xFFC4B48A),
        math.sin(i * 0.7) * 0.5 + 0.5,
      )!;
      canvas.drawRect(
        rect,
        Paint()..color = base.withValues(alpha: 0.42 + 0.12 * (i % 2)),
      );
    }

    // Brief warm flash when titles appear.
    if (t > 0.16 && t < 0.36) {
      final flash = (1 - ((t - 0.16) / 0.2).clamp(0.0, 1.0)) * 0.28;
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = const Color(0xFFE8DCC0).withValues(alpha: flash),
      );
    }

    // Late beat: titles linger while a horizontal rush hints at scene switch
    // (actual page slide continues in LandscapePageRoute.battle).
    if (t > 0.72) {
      final rush = Curves.easeIn.transform(((t - 0.72) / 0.28).clamp(0.0, 1.0));
      final bandH = h * 0.22;
      final bandY = h * 0.39;
      final cover = w * rush;
      canvas.drawRect(
        Rect.fromLTWH(w - cover, bandY, cover, bandH),
        Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0x00C4B48A),
              const Color(0xAAC4B48A),
              const Color(0xE8E8DCC0),
            ],
          ).createShader(Rect.fromLTWH(w - cover, bandY, cover, bandH)),
      );
    }

    // Ease veil back a bit near the end so combat entry isn't from pure black.
    if (t > 0.75) {
      final lift = ((t - 0.75) / 0.25).clamp(0.0, 1.0) * 0.12;
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Colors.white.withValues(alpha: lift),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EncounterWipePainter oldDelegate) =>
      oldDelegate.t != t;
}
