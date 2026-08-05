import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';

/// Kenney button with optional bilingual label.
class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.onPressed,
    this.label,
    this.subLabel,
    this.asset,
    this.width,
    this.height = 36,
    this.accent = false,
    this.enabled = true,
    this.semanticLabel,
    this.compact = false,
    this.useOutline = true,
  });

  final VoidCallback? onPressed;
  final String? label;
  final String? subLabel;
  final String? asset;
  final double? width;
  final double height;
  final bool accent;
  final bool enabled;
  final String? semanticLabel;

  /// Home-screen compact style: darker text, no white stroke, slightly larger labels.
  final bool compact;
  final bool useOutline;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final img = asset ?? (accent ? d.buttonAccent : d.button);
    final active = enabled && onPressed != null;
    final labelSize = compact
        ? (height * 0.34).clamp(11.0, 14.0)
        : (height * 0.34).clamp(9.0, 14.0);
    final subSize = (height * 0.22).clamp(7.0, 10.0);
    final padH = height >= 36 ? 8.0 : (height >= 28 ? 6.0 : 4.0);
    final padV = height >= 36 ? 6.0 : (height >= 28 ? 4.0 : 2.0);

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      enabled: active,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: active ? onPressed : null,
          child: Opacity(
            opacity: active ? 1 : 0.5,
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    img,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.none,
                    centerSlice: GameUiAssets.sliceButton,
                    gaplessPlayback: true,
                  ),
                  if (label != null)
                    Padding(
                      // Kenney button bevels (~8px); keep glyphs inside the fill.
                      padding: EdgeInsets.symmetric(
                        horizontal: padH,
                        vertical: padV,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GameOutlinedText(
                                label!,
                                fontSize: labelSize,
                                fontWeight: FontWeight.w700,
                                color: d.textPrimary,
                                height: 1.05,
                                strokeWidth: useOutline ? 1.2 : 0,
                                shadowColor: useOutline
                                    ? null
                                    : Colors.black.withValues(alpha: 0.35),
                                shadowOffset: const Offset(0, 1),
                                shadowBlurRadius: 1.5,
                              ),
                              if (subLabel != null)
                                GameOutlinedText(
                                  subLabel!,
                                  fontSize: subSize,
                                  fontWeight: FontWeight.w500,
                                  color: d.textMuted,
                                  height: 1.0,
                                  strokeWidth: useOutline ? 0.9 : 0,
                                  shadowColor: useOutline
                                      ? null
                                      : Colors.black.withValues(alpha: 0.25),
                                  shadowOffset: const Offset(0, 1),
                                  shadowBlurRadius: 1,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fixed-size icon button on round/hex asset.
class GameIconButton extends StatelessWidget {
  const GameIconButton({
    super.key,
    required this.onPressed,
    this.size = 40,
    this.asset,
    this.child,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final double size;
  final String? asset;
  final Widget? child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  asset ?? d.roundButton,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  gaplessPlayback: true,
                ),
                if (child != null) Center(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
