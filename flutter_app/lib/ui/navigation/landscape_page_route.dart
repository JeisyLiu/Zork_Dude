import 'package:flutter/material.dart';

/// Landscape-friendly page transition: short slide from right + fade.
abstract final class LandscapePageRoute {
  static const Duration _duration = Duration(milliseconds: 250);

  static Route<T> of<T>(BuildContext context, Widget child) {
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    final duration = disableMotion ? Duration.zero : _duration;

    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (disableMotion) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }
}
