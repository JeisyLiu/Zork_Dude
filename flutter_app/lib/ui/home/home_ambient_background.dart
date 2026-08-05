import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

/// Animated fog bands, particles, vignette and grain for the home screen.
class HomeAmbientBackground extends StatefulWidget {
  const HomeAmbientBackground({super.key});

  @override
  State<HomeAmbientBackground> createState() => _HomeAmbientBackgroundState();
}

class _HomeAmbientBackgroundState extends State<HomeAmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disable = MediaQuery.of(context).disableAnimations;
    if (disable) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.of(context).disableAnimations;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _HomeAmbientPainter(
              t: disable ? 0 : _controller.value,
              size: MediaQuery.sizeOf(context),
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _HomeAmbientPainter extends CustomPainter {
  _HomeAmbientPainter({required this.t, required this.size});

  final double t;
  final Size size;

  static const _seed = 42;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;

    // Base gradient.
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HomeConstants.bgTop,
          HomeConstants.bgMid,
          HomeConstants.bgBottom,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Offset.zero & canvasSize, bg);

    _drawFogBands(canvas, w, h);
    _drawParticles(canvas, w, h);
    _drawGrain(canvas, w, h);
    _drawVignette(canvas, w, h);
  }

  void _drawFogBands(Canvas canvas, double w, double h) {
    final fog1 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.08);
    final fog2 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.06);

    final y1 = h * 0.38 + math.sin(t * math.pi * 2) * 6;
    final y2 = h * 0.62 + math.cos(t * math.pi * 2 * 0.7) * 8;
    final shift1 = (t * w * 0.15) % w;
    final shift2 = (t * w * 0.22) % w;

    for (final shift in [shift1, shift2]) {
      final paint = shift == shift1 ? fog1 : fog2;
      final y = shift == shift1 ? y1 : y2;
      final bandH = shift == shift1 ? h * 0.09 : h * 0.07;
      canvas.drawRect(Rect.fromLTWH(-w + shift, y, w * 2, bandH), paint);
    }
  }

  void _drawParticles(Canvas canvas, double w, double h) {
    final area = w * h;
    final count = (area / 22000).clamp(24.0, 36.0).round();
    final rng = math.Random(_seed);

    for (var i = 0; i < count; i++) {
      final baseX = rng.nextDouble() * w;
      final baseY = rng.nextDouble() * h;
      final speed = 0.04 + rng.nextDouble() * 0.06;
      final phase = rng.nextDouble();
      final x = (baseX + math.sin((t + phase) * math.pi * 2) * 18 + t * w * speed) % w;
      final y = (baseY + math.cos((t + phase) * math.pi * 2 * 0.6) * 10) % h;
      final alpha = (0.06 + rng.nextDouble() * 0.12).clamp(0.0, 0.18);
      final radius = 0.8 + rng.nextDouble() * 1.2;

      final paint = Paint()
        ..color = HomeConstants.particleColor.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawGrain(Canvas canvas, double w, double h) {
    final rng = math.Random(_seed + 7);
    final count = (w * h / 9000).clamp(80.0, 180.0).round();
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.018);

    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * w;
      final y = rng.nextDouble() * h;
      canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
    }
  }

  void _drawVignette(Canvas canvas, double w, double h) {
    final center = Offset(w / 2, h / 2);
    final radius = math.max(w, h) * 0.72;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          HomeConstants.vignetteColor.withValues(alpha: 0.15),
          HomeConstants.vignetteColor.withValues(alpha: 0.55),
        ],
        stops: const [0.45, 0.78, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Offset.zero & Size(w, h), paint);
  }

  @override
  bool shouldRepaint(covariant _HomeAmbientPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.size != size;
  }
}
