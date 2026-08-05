import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/ui/combat/combat_command_menu.dart';
import 'package:zork_dude/ui/combat/combat_layout_constants.dart';

typedef CombatKeyHandler = bool Function(LogicalKeyboardKey key);

/// Desktop keyboard navigation for turn combat.
class CombatKeyboardScope extends StatefulWidget {
  const CombatKeyboardScope({
    super.key,
    required this.enabled,
    required this.onKey,
    required this.child,
  });

  final bool enabled;
  final CombatKeyHandler onKey;
  final Widget child;

  @override
  State<CombatKeyboardScope> createState() => _CombatKeyboardScopeState();
}

class _CombatKeyboardScopeState extends State<CombatKeyboardScope> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handle);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handle);
    super.dispose();
  }

  bool _handle(KeyEvent event) {
    if (!widget.enabled) return false;
    if (event is! KeyDownEvent) return false;
    return widget.onKey(event.logicalKey);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

List<CombatCommandOption> get combatCommandOptions =>
    CombatCommandMenu.options.map((e) => e.$1).toList();
