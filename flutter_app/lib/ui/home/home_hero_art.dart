import 'package:flutter/material.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/home/pixel_tower_mark.dart';

/// Hero emblem with image placeholder and pixel tower fallback.
class HomeHeroArt extends StatefulWidget {
  const HomeHeroArt({super.key, required this.size});

  final double size;

  @override
  State<HomeHeroArt> createState() => _HomeHeroArtState();
}

class _HomeHeroArtState extends State<HomeHeroArt> {
  bool _useFallback = false;

  @override
  Widget build(BuildContext context) {
    if (_useFallback) {
      return PixelTowerMark(size: widget.size);
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Image.asset(
        HomeConstants.heroImagePath,
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
    );
  }
}
