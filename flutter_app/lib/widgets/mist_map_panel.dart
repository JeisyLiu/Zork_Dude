import 'package:flutter/material.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        border: Border.all(color: const Color(0xFF1E1E32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (final layer in MapLayer.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ChoiceChip(
                      label: Text(mapLayerLabels[layer]!, style: const TextStyle(fontSize: 11)),
                      selected: widget.controller.mapLayer == layer,
                      onSelected: (_) => widget.controller.setMapLayer(layer),
                    ),
                  ),
                const Spacer(),
                Text('已探索 ${vm.visitedCount}', style: const TextStyle(fontSize: 11, color: Colors.white54)),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_detail, style: const TextStyle(fontSize: 11, color: Colors.white70)),
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
      ..color = const Color(0xFF54A0FF)
      ..strokeWidth = 2;
    final edgePaintFog = Paint()
      ..color = const Color(0xFF576574)
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
          ? const Color(0xFF1A3050)
          : (n.fog ? const Color(0xFF121820) : const Color(0xFF1E2A4A));
      final stroke = n.isHere
          ? GameConstants.hero
          : (n.canWalk ? const Color(0xFF2ECC71) : const Color(0xFF3A4A6A));
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
