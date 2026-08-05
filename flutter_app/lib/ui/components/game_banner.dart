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
    final hasSubtitle = subtitle != null;
    final compact = height < 48;
    final effectiveTitleSize =
        (compact ? titleSize.clamp(0, 14) : titleSize).toDouble();
    final effectiveSubtitleSize =
        (compact ? subtitleSize.clamp(0, 9) : subtitleSize).toDouble();
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
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 40 : 36,
                vertical: compact ? 4 : (height >= 56 ? 10 : 8),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GameOutlinedText(
                      title,
                      fontSize: effectiveTitleSize,
                      fontWeight: FontWeight.bold,
                      color: d.textPrimary,
                      letterSpacing: compact ? 1 : 2,
                      height: 1.0,
                      strokeWidth: effectiveTitleSize > 22 ? 2.0 : 1.2,
                    ),
                    if (hasSubtitle) ...[
                      const SizedBox(height: 1),
                      GameOutlinedText(
                        subtitle!,
                        fontSize: effectiveSubtitleSize,
                        fontWeight: FontWeight.w500,
                        color: d.textMuted,
                        height: 1.0,
                        strokeWidth: 0.9,
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
