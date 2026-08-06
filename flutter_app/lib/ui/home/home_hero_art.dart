import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/home/pixel_tower_mark.dart';

/// Hero emblem with soft breathe, window glow, and star twinkle.
class HomeHeroArt extends StatefulWidget {
  const HomeHeroArt({super.key, required this.size});

  final double size;

  @override
  State<HomeHeroArt> createState() => _HomeHeroArtState();
}

class _HomeHeroArtState extends State<HomeHeroArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _useFallback = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);

    if (_useFallback) {
      return _wrapMotion(
        disable: disable,
        child: PixelTowerMark(size: widget.size),
      );
    }

    return _wrapMotion(
      disable: disable,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              HomeConstants.heroImagePath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_useFallback) {
                    setState(() => _useFallback = true);
                  }
                });
                return PixelTowerMark(size: widget.size);
              },
            ),
            if (!disable)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _HeroFxPainter(
                          t: _controller.value,
                          size: widget.size,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _wrapMotion({required bool disable, required Widget child}) {
    if (disable) return child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final breathe = 1.0 + (_controller.value - 0.5) * 0.028;
        final floatY = math.sin(_controller.value * math.pi) * 2.4;
        return Transform.translate(
          offset: Offset(0, -floatY),
          child: Transform.scale(
            scale: breathe,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _HeroFxPainter extends CustomPainter {
  _HeroFxPainter({required this.t, required this.size});

  final double t;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final cx = canvasSize.width * 0.5;
    // Warm window glow near upper-middle of the tower art.
    final windowCenter = Offset(cx, canvasSize.height * 0.42);
    final glowPulse = 0.55 + 0.45 * math.sin(t * math.pi);
    final glowR = size * (0.10 + 0.03 * glowPulse);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE6A0).withValues(alpha: 0.22 * glowPulse),
          const Color(0xFFC4A060).withValues(alpha: 0.08 * glowPulse),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: windowCenter, radius: glowR));
    canvas.drawCircle(windowCenter, glowR, glow);

    // Soft mist drift across lower third of the emblem.
    final mistAlpha = 0.04 + 0.03 * math.sin(t * math.pi * 2);
    final mist = Paint()
      ..color = HomeConstants.fogColor.withValues(alpha: mistAlpha);
    final mistY = canvasSize.height * (0.62 + 0.02 * math.sin(t * math.pi));
    canvas.drawRect(
      Rect.fromLTWH(
        -canvasSize.width * 0.1 + t * canvasSize.width * 0.15,
        mistY,
        canvasSize.width * 1.2,
        canvasSize.height * 0.12,
      ),
      mist,
    );

    // Tiny star twinkles around the tower silhouette.
    const stars = <Offset>[
      Offset(0.18, 0.16),
      Offset(0.82, 0.22),
      Offset(0.12, 0.38),
      Offset(0.88, 0.40),
      Offset(0.22, 0.58),
      Offset(0.78, 0.62),
    ];
    for (var i = 0; i < stars.length; i++) {
      final p = Offset(
        stars[i].dx * canvasSize.width,
        stars[i].dy * canvasSize.height,
      );
      final phase = (i * 0.37) % 1.0;
      final twinkle =
          (0.35 + 0.65 * math.sin((t + phase) * math.pi * 2)).clamp(0.0, 1.0);
      final r = 0.8 + (i % 3) * 0.35;
      canvas.drawCircle(
        p,
        r,
        Paint()
          ..color = HomeConstants.particleColor.withValues(alpha: 0.18 * twinkle),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeroFxPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.size != size;
  }
}
