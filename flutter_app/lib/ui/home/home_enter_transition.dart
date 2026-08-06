import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

/// Full-screen mist close / fade used before leaving the home screen.
class HomeEnterTransition extends StatefulWidget {
  const HomeEnterTransition({
    super.key,
    required this.onCompleted,
  });

  final VoidCallback onCompleted;

  @override
  State<HomeEnterTransition> createState() => _HomeEnterTransitionState();
}

class _HomeEnterTransitionState extends State<HomeEnterTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
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

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _EnterMistPainter(t: _controller.value),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _EnterMistPainter extends CustomPainter {
  _EnterMistPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ease = Curves.easeInCubic.transform(t);

    // Side curtains closing toward center.
    final curtainW = w * 0.55 * ease;
    final left = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          HomeConstants.bgBottom.withValues(alpha: 0.92 * ease),
          HomeConstants.fogColor.withValues(alpha: 0.55 * ease),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, curtainW, h));
    final right = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          HomeConstants.bgBottom.withValues(alpha: 0.92 * ease),
          HomeConstants.fogColor.withValues(alpha: 0.55 * ease),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(w - curtainW, 0, curtainW, h));

    canvas.drawRect(Rect.fromLTWH(0, 0, curtainW, h), left);
    canvas.drawRect(Rect.fromLTWH(w - curtainW, 0, curtainW, h), right);

    // Rising ground fog.
    final fogH = h * (0.35 + 0.45 * ease);
    final ground = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          HomeConstants.bgBottom.withValues(alpha: 0.88 * ease),
          HomeConstants.fogColor.withValues(alpha: 0.35 * ease),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, h - fogH, w, fogH));
    canvas.drawRect(Rect.fromLTWH(0, h - fogH, w, fogH), ground);

    // Center swirl particles.
    final rng = math.Random(11);
    final count = 36;
    for (var i = 0; i < count; i++) {
      final px = rng.nextDouble() * w;
      final baseY = rng.nextDouble() * h;
      final y = (baseY - ease * h * 0.35) % h;
      final alpha = (0.08 + rng.nextDouble() * 0.18) * ease;
      canvas.drawCircle(
        Offset(px, y),
        1.2 + rng.nextDouble() * 2.4,
        Paint()..color = HomeConstants.particleColor.withValues(alpha: alpha),
      );
    }

    // Final full fade to dark so the route push is seamless.
    if (ease > 0.55) {
      final fade = ((ease - 0.55) / 0.45).clamp(0.0, 1.0);
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = HomeConstants.bgBottom.withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnterMistPainter oldDelegate) =>
      oldDelegate.t != t;
}
