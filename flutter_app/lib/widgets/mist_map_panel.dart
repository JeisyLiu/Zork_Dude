import 'package:flutter/material.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class MistMapPanel extends StatefulWidget {
  const MistMapPanel({super.key, required this.controller});

  final GameController controller;

  @override
  State<MistMapPanel> createState() => _MistMapPanelState();
}

class _MistMapPanelState extends State<MistMapPanel> {
  final _mapService = MapService();
  String _detail = '点击节点查看详情';

  @override
  Widget build(BuildContext context) {
    final s = widget.controller.session;
    if (s == null) return const SizedBox.shrink();
    widget.controller.syncMapLayerToPlayer();
    final vm = _mapService.buildView(s, widget.controller.mapLayer);
    final d = GameUiTheme.of(context);

    return GamePanel(
      dark: true,
      withBorder: true,
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final layer in MapLayer.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GameButton(
                      label: mapLayerLabels[layer]!,
                      height: 32,
                      width: 56,
                      onPressed: () => widget.controller.setMapLayer(layer),
                    ),
                  ),
                const SizedBox(width: 8),
                GameOutlinedText(
                  '已探索 ${vm.visitedCount}',
                  fontSize: 11,
                  color: d.textMuted,
                  strokeWidth: 2.2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.35,
                  child: Image.asset(
                    d.minimapRing,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                  ),
                ),
                InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 2.5,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final pos = details.localPosition;
                      for (final n in vm.nodes) {
                        final r = n.isHere ? 16.0 : (n.fog ? 11.0 : 13.0);
                        if ((pos - Offset(n.cx, n.cy)).distance <= r + 8) {
                          _onNodeTap(n);
                          return;
                        }
                      }
                    },
                    child: CustomPaint(
                      size: const Size(400, 320),
                      painter: MapGraphPainter(vm: vm),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GameOutlinedText(
              _detail,
              fontSize: 11,
              color: d.textPrimary,
              strokeWidth: 2.4,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  void _onNodeTap(MapNode node) {
    final s = widget.controller.session!;
    if (s.inCombat) {
      setState(() => _detail = '战斗中无法移动。');
      return;
    }
    final dir = _mapService.exitDirTo(s, node.id);
    if (dir != null) {
      widget.controller.move(dir);
      setState(() => _detail = '前往 ${mapDirLabel[dir]}…');
    } else {
      final rm = s.rooms[node.id];
      setState(() => _detail = rm != null ? '${rm.name} — 不相邻，无法直达' : node.id);
    }
  }
}

class MapGraphPainter extends CustomPainter {
  MapGraphPainter({required this.vm});

  final MapViewModel vm;

  @override
  void paint(Canvas canvas, Size size) {
    final nodeById = {for (final n in vm.nodes) n.id: n};
    final edgePaintKnown = Paint()
      ..color = const Color(0xFFA89060)
      ..strokeWidth = 2;
    final edgePaintFog = Paint()
      ..color = const Color(0xFF5A5040)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final e in vm.knownEdges) {
      final a = nodeById[e.from];
      final b = nodeById[e.to];
      if (a != null && b != null) {
        canvas.drawLine(Offset(a.cx, a.cy), Offset(b.cx, b.cy), edgePaintKnown);
      }
    }
    for (final e in vm.fogEdges) {
      final a = nodeById[e.from];
      final b = nodeById[e.to];
      if (a != null && b != null) {
        canvas.drawLine(Offset(a.cx, a.cy), Offset(b.cx, b.cy), edgePaintFog);
      }
    }

    for (final n in vm.nodes) {
      final r = n.isHere ? 16.0 : (n.fog ? 11.0 : 13.0);
      final fill = n.isHere
          ? const Color(0xFF3A2E1C)
          : (n.fog ? const Color(0xFF18140E) : const Color(0xFF2A2218));
      final stroke = n.isHere
          ? GameConstants.hero
          : (n.canWalk ? const Color(0xFF7A9A5A) : const Color(0xFF5A5040));
      canvas.drawCircle(Offset(n.cx, n.cy), r, Paint()..color = fill);
      canvas.drawCircle(
        Offset(n.cx, n.cy),
        r,
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final tp = TextPainter(
        text: TextSpan(text: n.shortLabel, style: const TextStyle(fontSize: 10, color: Colors.white)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(n.cx - tp.width / 2, n.cy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant MapGraphPainter oldDelegate) => true;
}
