import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

/// Integer-pixel tower silhouette used when the hero image is unavailable.
class PixelTowerMark extends StatelessWidget {
  const PixelTowerMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: _PixelTowerPainter(),
      ),
    );
  }
}

class _PixelTowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final unit = (size.width / 16).floorToDouble().clamp(4.0, 32.0);
    final ox = (size.width - unit * 16) / 2;
    final oy = (size.height - unit * 16) / 2;

    void px(int x, int y, Color color) {
      final paint = Paint()..color = color;
      canvas.drawRect(
        Rect.fromLTWH(ox + x * unit, oy + y * unit, unit, unit),
        paint,
      );
    }

    void block(int x, int y, int w, int h, Color color) {
      for (var row = y; row < y + h; row++) {
        for (var col = x; col < x + w; col++) {
          px(col, row, color);
        }
      }
    }

    // Mist rings (two horizontal bands).
    block(2, 10, 12, 1, HomeConstants.towerMist.withValues(alpha: 0.35));
    block(1, 11, 14, 1, HomeConstants.towerMist.withValues(alpha: 0.22));
    block(3, 7, 10, 1, HomeConstants.towerMist.withValues(alpha: 0.28));
    block(2, 8, 12, 1, HomeConstants.towerMist.withValues(alpha: 0.18));

    // Tower base.
    block(6, 12, 4, 3, HomeConstants.towerStone);
    block(5, 11, 6, 1, HomeConstants.towerStoneLight);

    // Tower body.
    block(7, 5, 2, 7, HomeConstants.towerStone);
    block(6, 6, 4, 1, HomeConstants.towerStoneLight);
    block(6, 9, 4, 1, HomeConstants.towerStoneLight);

    // Spire.
    block(7, 3, 2, 2, HomeConstants.towerStoneLight);
    px(7, 2, HomeConstants.towerStoneLight);
    px(8, 2, HomeConstants.towerStoneLight);
    px(7, 1, HomeConstants.towerRune.withValues(alpha: 0.7));

    // Tiny rune accents.
    px(6, 7, HomeConstants.towerRune.withValues(alpha: 0.55));
    px(9, 7, HomeConstants.towerRune.withValues(alpha: 0.55));
    px(7, 10, HomeConstants.towerRune.withValues(alpha: 0.45));
    px(8, 10, HomeConstants.towerRune.withValues(alpha: 0.45));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
