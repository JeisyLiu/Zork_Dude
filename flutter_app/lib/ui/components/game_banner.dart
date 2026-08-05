import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';

/// Title banner with overlaid text.
class GameBanner extends StatelessWidget {
  const GameBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 56,
    this.skin,
    this.titleSize = 18,
    this.subtitleSize = 10,
    this.asset,
  });

  final String title;
  final String? subtitle;
  final double height;
  final GameUiSkinData? skin;
  final double titleSize;
  final double subtitleSize;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final d = skin ?? GameUiTheme.of(context);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            asset ?? d.banner,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.none,
            centerSlice: GameUiAssets.sliceBanner,
            gaplessPlayback: true,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GameOutlinedText(
                      title,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: d.textPrimary,
                      letterSpacing: 2,
                      strokeWidth: titleSize > 22 ? 4.0 : 3.2,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      GameOutlinedText(
                        subtitle!,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w500,
                        color: d.textMuted,
                        strokeWidth: 2.6,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
