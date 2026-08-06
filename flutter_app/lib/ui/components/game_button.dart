import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/ui/game_ui_assets.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';

/// Kenney button with optional bilingual label.
class GameButton extends StatefulWidget {
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
    this.useOutline = false,
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

  /// Compact style: slightly larger labels. Outline is off by default.
  final bool compact;
  final bool useOutline;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _pressed = false;

  bool get _active => widget.enabled && widget.onPressed != null;

  void _handleTap() {
    if (!_active) return;
    if (!kIsWeb) {
      HapticFeedback.selectionClick();
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    final img = widget.asset ?? (widget.accent ? d.buttonAccent : d.button);
    final labelSize = widget.compact
        ? (widget.height * 0.34).clamp(11.0, 16.0)
        : (widget.height * 0.34).clamp(10.0, 18.0);
    final subSize = (widget.height * 0.22).clamp(8.0, 12.0);
    final padH = widget.height >= 36 ? 8.0 : (widget.height >= 28 ? 6.0 : 4.0);
    final padV = widget.height >= 36 ? 6.0 : (widget.height >= 28 ? 4.0 : 2.0);

    return Semantics(
      button: true,
      label: widget.semanticLabel ?? widget.label,
      enabled: _active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _active ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _active ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _active ? () => setState(() => _pressed = false) : null,
        onTap: _active ? _handleTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          child: Opacity(
            opacity: _active ? 1 : 0.5,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
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
                  if (_pressed && _active)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  if (widget.label != null)
                    Padding(
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
                                widget.label!,
                                fontSize: labelSize,
                                fontWeight: FontWeight.w700,
                                color: d.textPrimary,
                                height: 1.05,
                                strokeWidth: widget.useOutline ? 1.2 : 0,
                                shadowColor: widget.useOutline
                                    ? null
                                    : Colors.black.withValues(alpha: 0.35),
                                shadowOffset: const Offset(0, 1),
                                shadowBlurRadius: 1.5,
                              ),
                              if (widget.subLabel != null)
                                GameOutlinedText(
                                  widget.subLabel!,
                                  fontSize: subSize,
                                  fontWeight: FontWeight.w500,
                                  color: d.textMuted,
                                  height: 1.0,
                                  strokeWidth: widget.useOutline ? 0.9 : 0,
                                  shadowColor: widget.useOutline
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
class GameIconButton extends StatefulWidget {
  const GameIconButton({
    super.key,
    required this.onPressed,
    this.size = 40,
    this.asset,
    this.child,
    this.semanticLabel,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final double size;
  final String? asset;
  final Widget? child;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<GameIconButton> createState() => _GameIconButtonState();
}

class _GameIconButtonState extends State<GameIconButton> {
  bool _pressed = false;

  bool get _active => widget.enabled && widget.onPressed != null;

  void _handleTap() {
    if (!_active) return;
    if (!kIsWeb) {
      HapticFeedback.selectionClick();
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: _active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _active ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _active ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _active ? () => setState(() => _pressed = false) : null,
        onTap: _active ? _handleTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          child: Opacity(
            opacity: _active ? 1 : 0.5,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.asset ?? d.roundButton,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                    gaplessPlayback: true,
                  ),
                  if (_pressed && _active)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (widget.child != null) Center(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
