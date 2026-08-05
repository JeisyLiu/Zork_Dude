import 'dart:ui' as ui;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

/// Runtime sprites: colored blocks or emoji (matching Web JSON art style).
abstract final class SpriteSheetFactory {
  static Future<ui.Image> createImage({
    required Color color,
    required Vector2 size,
    Color? borderColor,
    double borderWidth = 1,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.5), const Radius.circular(3)),
      Paint()..color = color,
    );

    if (borderColor != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(0.5), const Radius.circular(3)),
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }

    final picture = recorder.endRecording();
    return picture.toImage(size.x.ceil(), size.y.ceil());
  }

  /// Rasterize an emoji into a sprite image (Web-style placeholder art).
  static Future<ui.Image> emojiImage({
    required String emoji,
    required Vector2 size,
    Color? background,
    double scale = 1.0,
  }) async {
    final w = size.x.ceil().clamp(1, 512);
    final h = size.y.ceil().clamp(1, 512);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble());

    if (background != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(0.5), const Radius.circular(4)),
        Paint()..color = background,
      );
    }

    final fontSize = (h * 0.78 * scale).clamp(8.0, h.toDouble());
    final tp = TextPainter(
      text: TextSpan(
        text: emoji.isNotEmpty ? emoji : '❓',
        style: TextStyle(fontSize: fontSize, height: 1),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: w.toDouble());

    tp.paint(
      canvas,
      Offset((w - tp.width) / 2, (h - tp.height) / 2),
    );

    final picture = recorder.endRecording();
    return picture.toImage(w, h);
  }

  static Future<SpriteAnimation> solidAnimation({
    required Color color,
    required Vector2 size,
    Color? borderColor,
    double stepTime = 0.2,
  }) async {
    final image = await createImage(
      color: color,
      size: size,
      borderColor: borderColor,
    );
    return SpriteAnimation.spriteList(
      [Sprite(image)],
      stepTime: stepTime,
    );
  }

  static Future<SpriteAnimation> emojiAnimation({
    required String emoji,
    required Vector2 size,
    Color? background,
    double scale = 1.0,
    double stepTime = 0.25,
  }) async {
    final idle = await emojiImage(
      emoji: emoji,
      size: size,
      background: background,
      scale: scale,
    );
    final run = await emojiImage(
      emoji: emoji,
      size: size,
      background: background,
      scale: scale * 1.06,
    );
    return SpriteAnimation.spriteList(
      [Sprite(idle), Sprite(run)],
      stepTime: stepTime,
    );
  }

  static Future<SimpleDirectionAnimation> characterAnimation({
    required Color color,
    required Vector2 size,
    Color? borderColor,
  }) async {
    Future<SpriteAnimation> frame(Color c) => solidAnimation(
          color: c,
          size: size,
          borderColor: borderColor,
        );

    final idle = await frame(color);
    final run = await frame(Color.lerp(color, Colors.white, 0.15)!);

    return SimpleDirectionAnimation(
      idleRight: idle,
      runRight: run,
      idleLeft: await frame(color),
      runLeft: await frame(Color.lerp(color, Colors.white, 0.15)!),
      idleUp: await frame(color),
      runUp: await frame(Color.lerp(color, Colors.white, 0.12)!),
      idleDown: await frame(color),
      runDown: await frame(Color.lerp(color, Colors.white, 0.12)!),
    );
  }

  /// Directional animation driven by emoji (same glyph for all dirs).
  static Future<SimpleDirectionAnimation> emojiCharacterAnimation({
    required String emoji,
    required Vector2 size,
    Color? background,
  }) async {
    Future<SpriteAnimation> frame({double scale = 1.0}) => emojiAnimation(
          emoji: emoji,
          size: size,
          background: background,
          scale: scale,
        );

    final idle = await frame();
    final run = await frame(scale: 1.08);

    return SimpleDirectionAnimation(
      idleRight: idle,
      runRight: run,
      idleLeft: await frame(),
      runLeft: await frame(scale: 1.08),
      idleUp: await frame(),
      runUp: await frame(scale: 1.05),
      idleDown: await frame(),
      runDown: await frame(scale: 1.05),
    );
  }
}
