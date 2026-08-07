import 'package:flutter/material.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

/// HP / progress bar: outer tube + clipped inner pattern.
class GameProgressBar extends StatelessWidget {
  const GameProgressBar({
    super.key,
    required this.value,
    this.width = 80,
    this.height = 16,
    this.small = true,
    this.skin,
  });

  final double value;
  final double width;
  final double height;
  final bool small;
  final GameUiSkinData? skin;

  @override
  Widget build(BuildContext context) {
    final d = skin ?? GameUiTheme.of(context);
    final border = small ? d.progressBorderSmall : d.progressBorder;
    final fill = small ? d.progressFillSmall : d.progressFill;
    final ratio = value.clamp(0.0, 1.0);
    // Mist tube has thick rounded caps + recessed channel; inset fill into trough.
    final insetH = (width * 0.045).clamp(2.0, 8.0);
    final insetV = (height * 0.22).clamp(1.5, 5.0);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            border,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(insetH, insetV, insetH, insetV),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio,
                child: Image.asset(
                  fill,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
