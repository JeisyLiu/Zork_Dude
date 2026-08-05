import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/domain/models/enums.dart';
import 'package:zork_dude/state/game_controller.dart';

/// Desktop keyboard movement for exploration: arrows/WASD + PageUp/Down for U/D.
/// Skips handling while a text field is focused so typing commands still works.
class ExplorationKeyboardScope extends StatefulWidget {
  const ExplorationKeyboardScope({
    super.key,
    required this.controller,
    required this.commandFocus,
    required this.child,
  });

  final GameController controller;
  final FocusNode commandFocus;
  final Widget child;

  @override
  State<ExplorationKeyboardScope> createState() => _ExplorationKeyboardScopeState();
}

class _ExplorationKeyboardScopeState extends State<ExplorationKeyboardScope> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (widget.commandFocus.hasFocus) return false;
    if (!mounted) return false;

    final session = widget.controller.session;
    if (session == null || session.inCombat || session.gameOver) {
      return false;
    }

    final dir = _directionFor(event.logicalKey);
    if (dir == null) return false;

    widget.controller.move(dir);
    return true;
  }

  Direction? _directionFor(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      return Direction.north;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
      return Direction.south;
    }
    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
      return Direction.west;
    }
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
      return Direction.east;
    }
    if (key == LogicalKeyboardKey.pageUp || key == LogicalKeyboardKey.keyQ) {
      return Direction.up;
    }
    if (key == LogicalKeyboardKey.pageDown || key == LogicalKeyboardKey.keyE) {
      return Direction.down;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
