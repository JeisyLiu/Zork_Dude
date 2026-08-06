import 'package:flutter/material.dart';

/// Landscape-friendly page transitions.
abstract final class LandscapePageRoute {
  static const Duration _duration = Duration(milliseconds: 250);
  static const Duration _battleDuration = Duration(milliseconds: 420);

  /// Mild slide + fade (home → exploration, general pushes).
  static Route<T> of<T>(BuildContext context, Widget child) {
    return _build<T>(
      context,
      child,
      duration: _duration,
      beginSlideX: 0.08,
      fadeIn: true,
      coveredSlideX: -0.18,
    );
  }

  /// Full horizontal scene switch into combat (exploration slides out, battle slides in).
  static Route<T> battle<T>(BuildContext context, Widget child) {
    return _build<T>(
      context,
      child,
      duration: _battleDuration,
      beginSlideX: 1.0,
      fadeIn: false,
      coveredSlideX: -0.35,
    );
  }

  static Route<T> _build<T>(
    BuildContext context,
    Widget child, {
    required Duration duration,
    required double beginSlideX,
    required bool fadeIn,
    required double coveredSlideX,
  }) {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final resolved = disableMotion ? Duration.zero : duration;

    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: resolved,
      reverseTransitionDuration: resolved,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        if (disableMotion) return page;

        final incoming = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
          reverseCurve: Curves.easeInOutCubic,
        );
        final covered = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInOutCubic,
        );

        Widget content = page;
        if (fadeIn) {
          content = FadeTransition(opacity: incoming, child: content);
        }
        // New page slides in from the right.
        content = SlideTransition(
          position: Tween<Offset>(
            begin: Offset(beginSlideX, 0),
            end: Offset.zero,
          ).animate(incoming),
          child: content,
        );
        // When another route is pushed on top, this page slides left.
        content = SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: Offset(coveredSlideX, 0),
          ).animate(covered),
          child: content,
        );
        return content;
      },
    );
  }
}
