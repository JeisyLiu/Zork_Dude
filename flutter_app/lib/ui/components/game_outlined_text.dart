import 'package:flutter/material.dart';

/// Dark fill text with white outline for readability on light parchment UI art.
/// When [strokeWidth] is 0, renders a single layer with optional soft shadow.
class GameOutlinedText extends StatelessWidget {
  const GameOutlinedText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.color = const Color(0xFF1A1208),
    this.strokeColor = Colors.white,
    this.strokeWidth = 1.4,
    this.height = 1.15,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 1),
    this.shadowBlurRadius = 2,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  final double height;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );

    if (strokeWidth <= 0) {
      final shadows = shadowColor != null
          ? [
              Shadow(
                color: shadowColor!,
                offset: shadowOffset,
                blurRadius: shadowBlurRadius,
              ),
            ]
          : null;
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: base.copyWith(color: color, shadows: shadows),
      );
    }

    final align = switch (textAlign) {
      TextAlign.left || TextAlign.start => Alignment.centerLeft,
      TextAlign.right || TextAlign.end => Alignment.centerRight,
      _ => Alignment.center,
    };
    return Stack(
      alignment: align,
      children: [
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: base.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..strokeJoin = StrokeJoin.round,
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: base.copyWith(color: color),
        ),
      ],
    );
  }
}
