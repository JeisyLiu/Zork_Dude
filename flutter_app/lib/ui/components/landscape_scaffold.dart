import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Unified [Scaffold] + [SafeArea] + outer padding for landscape play screens.
class LandscapeScaffold extends StatelessWidget {
  const LandscapeScaffold({
    super.key,
    required this.backgroundColor,
    required this.body,
    this.background,
    this.minimum,
    this.padding,
  });

  final Color backgroundColor;
  final Widget body;
  final Widget? background;
  final EdgeInsets? minimum;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final mqPadding = MediaQuery.paddingOf(context);
    final resolvedPadding = padding ??
        EdgeInsets.all(LandscapeLayout.outerPadding(size, padding: mqPadding));
    final safeBody = SafeArea(
      minimum: minimum ?? LandscapeLayout.playSafeMinimum(size, mqPadding),
      child: Padding(
        padding: resolvedPadding,
        child: body,
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: background == null
          ? safeBody
          : Stack(
              fit: StackFit.expand,
              children: [
                background!,
                safeBody,
              ],
            ),
    );
  }
}
