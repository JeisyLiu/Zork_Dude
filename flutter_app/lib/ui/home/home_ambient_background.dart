import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

/// Pointer sample for reactive mist / particle FX.
class HomePointerSample {
  const HomePointerSample({
    required this.position,
    this.down = false,
  });

  final Offset position;
  final bool down;
}

/// Animated fog bands, dense drifting particles, pointer-reactive mist for home.
class HomeAmbientBackground extends StatefulWidget {
  const HomeAmbientBackground({
    super.key,
    this.pointerListenable,
  });

  /// When set, listens here instead of an internal [Listener]
  /// (so the home screen can capture pointers above the body layer).
  final ValueNotifier<HomePointerSample?>? pointerListenable;

  @override
  State<HomeAmbientBackground> createState() => _HomeAmbientBackgroundState();
}

class _HomeAmbientBackgroundState extends State<HomeAmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset? _pointer;
  Offset? _smoothed;
  Offset _velocity = Offset.zero;
  double _pointerStrength = 0;
  double _burst = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..addListener(_tickPointer);
    widget.pointerListenable?.addListener(_onExternalPointer);
  }

  @override
  void didUpdateWidget(covariant HomeAmbientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pointerListenable != widget.pointerListenable) {
      oldWidget.pointerListenable?.removeListener(_onExternalPointer);
      widget.pointerListenable?.addListener(_onExternalPointer);
    }
  }

  void _onExternalPointer() {
    final sample = widget.pointerListenable?.value;
    if (sample == null) {
      _pointer = null;
      return;
    }
    if (sample.down && _burst < 0.9) _burst = 1.0;
    _pointer = sample.position;
    if (_pointerStrength <= 0) {
      _pointerStrength = 0.35;
      _burst = math.max(_burst, 0.85);
    }
  }

  void _tickPointer() {
    if (_pointer != null) {
      final prev = _smoothed;
      _smoothed = prev == null
          ? _pointer
          : Offset.lerp(prev, _pointer, 0.18);
      if (prev != null && _smoothed != null) {
        final delta = _smoothed! - prev;
        _velocity = Offset.lerp(_velocity, delta * 18, 0.25)!;
      }
      _pointerStrength = math.min(1.0, _pointerStrength + 0.1);
      _burst = math.min(1.0, _burst + 0.035);
    } else if (_pointerStrength > 0) {
      _pointerStrength = math.max(0.0, _pointerStrength - 0.035);
      _burst = math.max(0.0, _burst - 0.05);
      _velocity = Offset.lerp(_velocity, Offset.zero, 0.12)!;
      if (_pointerStrength <= 0.01) {
        _smoothed = null;
        _pointerStrength = 0;
        _burst = 0;
        _velocity = Offset.zero;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) {
      _controller.stop();
      _controller.value = 0;
      _pointer = null;
      _smoothed = null;
      _pointerStrength = 0;
      _burst = 0;
      _velocity = Offset.zero;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    widget.pointerListenable?.removeListener(_onExternalPointer);
    _controller.removeListener(_tickPointer);
    _controller.dispose();
    super.dispose();
  }

  void _onPointer(Offset local, {bool down = false}) {
    if (MediaQuery.disableAnimationsOf(context)) return;
    if (down) _burst = 1.0;
    _pointer = local;
    if (_pointerStrength <= 0) {
      _pointerStrength = 0.35;
      _burst = math.max(_burst, 0.85);
    }
  }

  void _clearPointer() {
    _pointer = null;
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);
    final paint = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _HomeAmbientPainter(
              t: disable ? 0 : _controller.value,
              pointer: disable || _pointerStrength <= 0 ? null : _smoothed,
              pointerStrength: disable ? 0 : _pointerStrength,
              velocity: disable ? Offset.zero : _velocity,
              burst: disable ? 0 : _burst,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );

    if (widget.pointerListenable != null) return paint;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (e) => _onPointer(e.localPosition),
      onPointerMove: (e) => _onPointer(e.localPosition),
      onPointerDown: (e) => _onPointer(e.localPosition, down: true),
      onPointerUp: (_) => _clearPointer(),
      onPointerCancel: (_) => _clearPointer(),
      child: paint,
    );
  }
}

class _HomeAmbientPainter extends CustomPainter {
  _HomeAmbientPainter({
    required this.t,
    this.pointer,
    this.pointerStrength = 0,
    this.velocity = Offset.zero,
    this.burst = 0,
  });

  final double t;
  final Offset? pointer;
  final double pointerStrength;
  final Offset velocity;
  final double burst;

  static const _seed = 42;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final w = canvasSize.width;
    final h = canvasSize.height;

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
    if (pointer != null && pointerStrength > 0) {
      _drawPointerAura(canvas, w, h, pointer!, pointerStrength, burst);
    }
    _drawDustLayer(canvas, w, h);
    _drawSparkLayer(canvas, w, h);
    _drawEmberLayer(canvas, w, h);
    if (pointer != null && pointerStrength > 0) {
      _drawPointerOrbit(canvas, w, h, pointer!, pointerStrength, burst);
      _drawPointerTrail(canvas, pointer!, velocity, pointerStrength, burst);
      _drawPointerRings(canvas, pointer!, pointerStrength, burst);
    }
    _drawGrain(canvas, w, h);
    _drawVignette(canvas, w, h);
  }

  void _drawFogBands(Canvas canvas, double w, double h) {
    final fog1 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.18);
    final fog2 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.14);
    final fog3 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.11);
    final fog4 = Paint()..color = HomeConstants.fogColor.withValues(alpha: 0.08);

    final pointerPull = pointer == null
        ? 0.0
        : ((pointer!.dx / w) - 0.5) * 56 * pointerStrength;
    final pointerLift = pointer == null
        ? 0.0
        : ((pointer!.dy / h) - 0.5) * 22 * pointerStrength;

    final y1 = h * 0.28 + math.sin(t * math.pi * 2) * 12 + pointerLift * 0.4;
    final y2 = h * 0.48 + math.cos(t * math.pi * 2 * 0.75) * 14 + pointerLift;
    final y3 = h * 0.68 + math.sin(t * math.pi * 2 * 0.5 + 1.2) * 10;
    final y4 = h * 0.84 + math.cos(t * math.pi * 2 * 0.4 + 0.6) * 8;
    final shift1 = (t * w * 0.24 + pointerPull) % w;
    final shift2 = (t * w * 0.36 - pointerPull * 0.7) % w;
    final shift3 = (t * w * 0.16 + pointerPull * 0.35) % w;
    final shift4 = (t * w * 0.28 - pointerPull * 0.25) % w;

    void band(double shift, double y, double bandH, Paint paint) {
      canvas.drawRect(Rect.fromLTWH(-w + shift, y, w * 2.5, bandH), paint);
    }

    band(shift1, y1, h * 0.12, fog1);
    band(shift2, y2, h * 0.10, fog2);
    band(shift3, y3, h * 0.09, fog3);
    band(shift4, y4, h * 0.07, fog4);
  }

  Offset _react(double x, double y, double px, double py, double radius) {
    final dx = x - px;
    final dy = y - py;
    final dist = math.sqrt(dx * dx + dy * dy) + 0.001;
    if (dist > radius) return Offset(x, y);

    final falloff = 1 - dist / radius;
    final s = pointerStrength;
    final angle = math.atan2(dy, dx) + falloff * 1.35 * s;
    final swirl = falloff * 48 * s;
    final radial = falloff * (dist < radius * 0.35 ? 28 : -18) * s;
    final nx = math.cos(angle);
    final ny = math.sin(angle);
    return Offset(
      x + nx * (swirl + radial) + velocity.dx * falloff * 0.35,
      y + ny * (swirl + radial) + velocity.dy * falloff * 0.35,
    );
  }

  void _drawDustLayer(Canvas canvas, double w, double h) {
    final area = w * h;
    final count = (area / 5200).clamp(90.0, 160.0).round();
    final rng = math.Random(_seed);
    final px = pointer?.dx;
    final py = pointer?.dy;

    for (var i = 0; i < count; i++) {
      final baseX = rng.nextDouble() * w;
      final baseY = rng.nextDouble() * h;
      final speed = 0.04 + rng.nextDouble() * 0.10;
      final phase = rng.nextDouble();
      var x =
          (baseX + math.sin((t + phase) * math.pi * 2) * 28 + t * w * speed) %
              w;
      var y = (baseY + math.cos((t + phase) * math.pi * 2 * 0.55) * 18) % h;

      if (px != null && py != null && pointerStrength > 0) {
        final p = _react(x, y, px, py, 200);
        x = p.dx;
        y = p.dy;
      }

      final nearBoost = _nearBoost(x, y, px, py, 200);
      final twinkle = 0.45 + 0.55 * math.sin((t + phase) * math.pi * 5);
      final alpha =
          ((0.08 + rng.nextDouble() * 0.16) * twinkle * (1 + nearBoost * 1.8))
              .clamp(0.0, 0.55);
      final radius = 0.7 + rng.nextDouble() * 1.4 + nearBoost * 1.2;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = HomeConstants.particleColor.withValues(alpha: alpha),
      );
    }
  }

  void _drawSparkLayer(Canvas canvas, double w, double h) {
    final area = w * h;
    final count = (area / 9000).clamp(50.0, 90.0).round();
    final rng = math.Random(_seed + 3);
    final px = pointer?.dx;
    final py = pointer?.dy;

    for (var i = 0; i < count; i++) {
      final baseX = rng.nextDouble() * w;
      final baseY = rng.nextDouble() * h;
      final speed = 0.06 + rng.nextDouble() * 0.12;
      final phase = rng.nextDouble();
      var x = (baseX +
              math.cos((t + phase) * math.pi * 2 * 1.2) * 36 +
              t * w * speed) %
          w;
      var y = (baseY +
              math.sin((t + phase) * math.pi * 2 * 0.8) * 24 -
              t * h * 0.04) %
          h;
      if (y < 0) y += h;

      if (px != null && py != null && pointerStrength > 0) {
        final p = _react(x, y, px, py, 240);
        x = p.dx;
        y = p.dy;
      }

      final nearBoost = _nearBoost(x, y, px, py, 240);
      final twinkle = 0.35 + 0.65 * math.sin((t * 2 + phase) * math.pi * 6);
      final alpha =
          ((0.12 + rng.nextDouble() * 0.22) * twinkle * (1 + nearBoost * 2.2))
              .clamp(0.0, 0.72);
      final radius = 1.1 + rng.nextDouble() * 2.2 + nearBoost * 2.0;

      final color = Color.lerp(
        HomeConstants.particleColor,
        const Color(0xFFFFE6A8),
        nearBoost * 0.7,
      )!;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withValues(alpha: alpha),
      );

      if (alpha > 0.35) {
        canvas.drawCircle(
          Offset(x, y),
          radius * 2.4,
          Paint()..color = color.withValues(alpha: alpha * 0.18),
        );
      }
    }
  }

  void _drawEmberLayer(Canvas canvas, double w, double h) {
    final count = (math.min(w, h) / 14).clamp(18.0, 36.0).round();
    final rng = math.Random(_seed + 9);
    final px = pointer?.dx;
    final py = pointer?.dy;

    for (var i = 0; i < count; i++) {
      final phase = rng.nextDouble();
      final lane = rng.nextDouble();
      var x = (lane * w + math.sin((t * 1.4 + phase) * math.pi * 2) * 40) % w;
      var y = ((1 - ((t * 0.35 + phase) % 1.0)) * h +
              math.cos((t + phase) * math.pi * 2) * 10) %
          h;

      if (px != null && py != null && pointerStrength > 0) {
        final p = _react(x, y, px, py, 280);
        x = p.dx;
        y = p.dy;
      }

      final nearBoost = _nearBoost(x, y, px, py, 280);
      final pulse = 0.5 + 0.5 * math.sin((t * 3 + phase) * math.pi * 2);
      final alpha = (0.16 + pulse * 0.22 + nearBoost * 0.35).clamp(0.0, 0.85);
      final radius = 1.6 + pulse * 1.4 + nearBoost * 2.5;

      final color = Color.lerp(
        const Color(0xFFC4A060),
        const Color(0xFFFFF0C0),
        pulse * 0.5 + nearBoost * 0.5,
      )!;

      canvas.drawCircle(
        Offset(x, y),
        radius * 3.2,
        Paint()..color = color.withValues(alpha: alpha * 0.12),
      );
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  double _nearBoost(double x, double y, double? px, double? py, double radius) {
    if (px == null || py == null || pointerStrength <= 0) return 0;
    final dist = math.sqrt((x - px) * (x - px) + (y - py) * (y - py));
    if (dist > radius) return 0;
    return (1 - dist / radius) * pointerStrength;
  }

  void _drawPointerAura(
    Canvas canvas,
    double w,
    double h,
    Offset p,
    double strength,
    double burstAmt,
  ) {
    final radius = math.min(w, h) * (0.28 + 0.08 * burstAmt);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE6A8).withValues(alpha: 0.22 * strength),
          HomeConstants.particleColor.withValues(alpha: 0.16 * strength),
          HomeConstants.fogColor.withValues(alpha: 0.10 * strength),
          Colors.transparent,
        ],
        stops: const [0.0, 0.28, 0.58, 1.0],
      ).createShader(Rect.fromCircle(center: p, radius: radius));
    canvas.drawCircle(p, radius, paint);

    final mistR = radius * 0.85;
    canvas.drawCircle(
      p,
      mistR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            HomeConstants.fogColor.withValues(alpha: 0.18 * strength),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: p, radius: mistR)),
    );
  }

  void _drawPointerOrbit(
    Canvas canvas,
    double w,
    double h,
    Offset p,
    double strength,
    double burstAmt,
  ) {
    final count = (22 + burstAmt * 18).round();
    final baseR = math.min(w, h) * (0.08 + 0.04 * burstAmt);
    for (var i = 0; i < count; i++) {
      final phase = i / count;
      final spin = t * math.pi * 4 + phase * math.pi * 2;
      final arm = baseR * (0.7 + 0.55 * math.sin(spin * 1.7 + i));
      final x = p.dx + math.cos(spin) * arm;
      final y = p.dy + math.sin(spin) * arm * 0.72;
      final alpha = (0.25 + 0.45 * strength) * (0.5 + 0.5 * math.sin(spin * 2));
      final r = 1.2 + (i % 4) * 0.55 + burstAmt * 0.8;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color =
              const Color(0xFFFFE6A8).withValues(alpha: alpha.clamp(0.0, 0.9)),
      );
    }
  }

  void _drawPointerTrail(
    Canvas canvas,
    Offset p,
    Offset vel,
    double strength,
    double burstAmt,
  ) {
    final speed = vel.distance.clamp(0.0, 40.0);
    if (speed < 0.8 && burstAmt < 0.2) return;

    final dir = speed < 0.1 ? const Offset(-1, 0) : vel / speed;
    final sparks = (10 + speed * 0.7 + burstAmt * 14).round();
    final rng = math.Random((p.dx * 13 + p.dy * 7).floor());

    for (var i = 0; i < sparks; i++) {
      final along = (i + 1) / sparks;
      final spread = (rng.nextDouble() - 0.5) * 28 * along;
      final back = -dir * (12 + along * (28 + speed * 1.2));
      final side = Offset(-dir.dy, dir.dx) * spread;
      final pos = p + back + side;
      final alpha = (0.55 * strength * (1 - along) * (0.5 + burstAmt * 0.5))
          .clamp(0.0, 0.85);
      canvas.drawCircle(
        pos,
        1.0 + (1 - along) * 2.8,
        Paint()..color = const Color(0xFFFFF0C0).withValues(alpha: alpha),
      );
    }
  }

  void _drawPointerRings(
    Canvas canvas,
    Offset p,
    double strength,
    double burstAmt,
  ) {
    if (burstAmt < 0.05) return;
    for (var i = 0; i < 3; i++) {
      final wave = ((t * 2.2 + i * 0.33) % 1.0);
      final r = 18 + wave * (70 + burstAmt * 50);
      final alpha = (1 - wave) * 0.35 * strength * burstAmt;
      canvas.drawCircle(
        p,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2 + (1 - wave) * 1.6
          ..color = HomeConstants.particleColor.withValues(alpha: alpha),
      );
    }
  }

  void _drawGrain(Canvas canvas, double w, double h) {
    final rng = math.Random(_seed + 7 + (t * 10).floor());
    final count = (w * h / 7000).clamp(100.0, 220.0).round();
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.025);

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
          HomeConstants.vignetteColor.withValues(alpha: 0.18),
          HomeConstants.vignetteColor.withValues(alpha: 0.58),
        ],
        stops: const [0.42, 0.76, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Offset.zero & Size(w, h), paint);
  }

  @override
  bool shouldRepaint(covariant _HomeAmbientPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.pointer != pointer ||
        oldDelegate.pointerStrength != pointerStrength ||
        oldDelegate.velocity != velocity ||
        oldDelegate.burst != burst;
  }
}
