import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/game_panel.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

class StoryLogView extends StatefulWidget {
  const StoryLogView({super.key, required this.controller});

  final GameController controller;

  @override
  State<StoryLogView> createState() => _StoryLogViewState();
}

class _StoryLogViewState extends State<StoryLogView> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    widget.controller.addListener(_onLogChanged);
    _scheduleScrollToBottom();
  }

  @override
  void didUpdateWidget(covariant StoryLogView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onLogChanged);
      widget.controller.addListener(_onLogChanged);
      _scheduleScrollToBottom();
    }
  }

  void _onLogChanged() => _scheduleScrollToBottom();

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      if (_scroll.offset != max) {
        _scroll.jumpTo(max);
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onLogChanged);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = GameUiTheme.of(context);
    return GamePanel(
      dark: true,
      withBorder: true,
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      child: RawScrollbar(
        controller: _scroll,
        thumbVisibility: true,
        thickness: 8,
        radius: const Radius.circular(4),
        thumbColor: d.textMuted.withValues(alpha: 0.6),
        child: ListView.builder(
          controller: _scroll,
          primary: false,
          padding: const EdgeInsets.fromLTRB(6, 4, 10, 8),
          itemCount: widget.controller.log.length,
          itemBuilder: (context, i) {
            final entry = widget.controller.log[i];
            final text = entry.isCommand
                ? '> ${entry.text.replaceFirst('> ', '')}'
                : entry.text;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GameOutlinedText(
                  text,
                  fontSize: 13,
                  fontWeight: entry.isCommand ? FontWeight.w600 : FontWeight.w500,
                  color: entry.isCommand ? const Color(0xFF5C4018) : d.textPrimary,
                  strokeWidth: entry.isCommand ? 1.0 : 0,
                  shadowColor: entry.isCommand
                      ? null
                      : Colors.black.withValues(alpha: 0.28),
                  shadowOffset: const Offset(0, 1),
                  shadowBlurRadius: 1.5,
                  height: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
