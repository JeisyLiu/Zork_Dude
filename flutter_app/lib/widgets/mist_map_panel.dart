import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zork_dude/domain/map_service.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/shared/game_constants.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Mist scrap map: free pan/zoom camera + tap adjacent node to move.
class MistMapPanel extends StatefulWidget {
  const MistMapPanel({super.key, required this.controller});

  final GameController controller;

  @override
  State<MistMapPanel> createState() => _MistMapPanelState();
}

class _MistMapPanelState extends State<MistMapPanel> {
  static const _minScale = 0.45;
  static const _maxScale = 3.0;

  final _mapService = MapService();
  final _transform = TransformationController();

  String _detail = '拖拽平移 · 滚轮/双指缩放 · 点击相邻节点移动';
  MapLayer? _boundLayer;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _syncLayerCamera(MapLayer layer) {
    if (_boundLayer == layer) return;
    _boundLayer = layer;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _boundLayer != layer) return;
      _transform.value = Matrix4.identity();
    });
  }

  Size _canvasSize(MapViewModel vm) {
    if (vm.nodes.isEmpty) return const Size(400, 320);
    var maxX = 0.0;
    var maxY = 0.0;
    for (final n in vm.nodes) {
      if (n.cx > maxX) maxX = n.cx;
      if (n.cy > maxY) maxY = n.cy;
    }
    return Size(
      (maxX + mapPad + 28).clamp(400.0, 2400.0),
      (maxY + mapPad + 28).clamp(320.0, 2400.0),
    );
  }

  void _onScrollZoom(PointerScrollEvent event) {
    final scale = _transform.value.getMaxScaleOnAxis();
    final zoom = math.exp(-event.scrollDelta.dy * 0.0018);
    final next = (scale * zoom).clamp(_minScale, _maxScale);
    if ((next - scale).abs() < 1e-4) return;

    final focal = _transform.toScene(event.localPosition);
    final matrix = _transform.value.clone()
      ..translate(focal.dx, focal.dy)
      ..scale(next / scale)
      ..translate(-focal.dx, -focal.dy);
    _transform.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.controller.session;
    if (s == null) return const SizedBox.shrink();
    // Do not sync layer here — setMapLayer must stick until the player moves.
    final layer = widget.controller.mapLayer;
    _syncLayerCamera(layer);
    final vm = _mapService.buildView(
      s,
      layer,
      revealAll: widget.controller.developerMode,
    );
    final canvas = _canvasSize(vm);
    final d = GameUiTheme.of(context);

    return GamePanel(
      dark: true,
      withBorder: true,
      sceneBackdrop: true,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final l in MapLayer.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GameButton(
                      label: mapLayerLabels[l]!,
                      width: 56,
                      height: LandscapeLayout.heightFromWidth(56),
                      onPressed: () => widget.controller.setMapLayer(l),
                    ),
                  ),
                const SizedBox(width: 8),
                if (widget.controller.developerMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GameOutlinedText(
                      'DEV · 全图',
                      fontSize: 11,
                      color: GameConstants.hero,
                      strokeWidth: 1.0,
                      strokeColor: Colors.black.withValues(alpha: 0.75),
                    ),
                  ),
                GameOutlinedText(
                  widget.controller.developerMode
                      ? '全图 ${vm.nodes.length}'
                      : '已探索 ${vm.visitedCount}',
                  fontSize: 11,
                  color: d.logMuted,
                  strokeWidth: 1.0,
                  strokeColor: Colors.black.withValues(alpha: 0.75),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  IgnorePointer(
                    child: Opacity(
                      opacity: 0.22,
                      child: Image.asset(
                        d.minimapRing,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ),
                  Listener(
                    onPointerSignal: (signal) {
                      if (signal is PointerScrollEvent) {
                        _onScrollZoom(signal);
                      }
                    },
                    child: InteractiveViewer(
                      transformationController: _transform,
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(180),
                      minScale: _minScale,
                      maxScale: _maxScale,
                      panEnabled: true,
                      scaleEnabled: true,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: canvas.width,
                        height: canvas.height,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) => _onCanvasTap(vm, details.localPosition),
                          child: CustomPaint(
                            size: canvas,
                            painter: MapGraphPainter(vm: vm),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GameOutlinedText(
              _detail,
              fontSize: 11,
              color: d.logText,
              strokeWidth: 1.0,
              strokeColor: Colors.black.withValues(alpha: 0.75),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  void _onCanvasTap(MapViewModel vm, Offset pos) {
    for (final n in vm.nodes) {
      final r = n.isHere ? 24.0 : (n.fog ? 17.0 : 20.0);
      if ((pos - Offset(n.cx, n.cy)).distance <= r + 10) {
        _onNodeTap(n);
        return;
      }
    }
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
      final r = n.isHere ? 24.0 : (n.fog ? 17.0 : 20.0);
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
          ..strokeWidth = 2.5,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: n.shortLabel,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(n.cx - tp.width / 2, n.cy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant MapGraphPainter oldDelegate) =>
      oldDelegate.vm != vm;
}
