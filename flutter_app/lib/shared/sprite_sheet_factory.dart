import 'dart:ui' as ui;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

/// Builds simple colored sprites at runtime so the scaffold runs without art packs.
/// Replace with real sprite sheets under `assets/images/` when ready.
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
}
