import 'package:flutter/material.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Unified [Scaffold] + [SafeArea] + fixed 16:9 play canvas for landscape screens.
///
/// Extra width/height outside the canvas is letterboxed / pillarboxed so the
/// interactive UI keeps a stable 16:9 layout on ultrawide or tall devices.
/// [background] still paints edge-to-edge behind the bars.
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvas = LandscapeLayout.fitDesignAspect(constraints.biggest);
            final parentMq = MediaQuery.of(context);
            return Center(
              child: SizedBox(
                width: canvas.width,
                height: canvas.height,
                child: MediaQuery(
                  data: parentMq.copyWith(
                    size: canvas,
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                  ),
                  child: body,
                ),
              ),
            );
          },
        ),
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
