import 'package:flutter/material.dart';
import 'package:zork_dude/state/ending_kind.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/ending/ending_assets.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';

/// Full-screen ending card with illustration, title, and action buttons.
class EndingOverlay extends StatefulWidget {
  const EndingOverlay({
    super.key,
    required this.kind,
    required this.onPrimary,
    this.onSecondary,
    this.primaryLabel,
    this.secondaryLabel,
  });

  final EndingKind kind;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final String? primaryLabel;
  final String? secondaryLabel;

  @override
  State<EndingOverlay> createState() => _EndingOverlayState();
}

class _EndingOverlayState extends State<EndingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      value: 0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animOff = MediaQuery.disableAnimationsOf(context);
      if (animOff) {
        _fade.value = 1;
      } else {
        _fade.forward();
      }
    });
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final short = LandscapeLayout.isShort(size);
    final meta = _metaFor(widget.kind);
    final btnW = short ? 148.0 : 168.0;
    final btnH = HomeConstants.buttonHeightFor(btnW);

    return Material(
      color: Colors.black.withValues(alpha: 0.88),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: LandscapeLayout.maxContentWidth,
                maxHeight: size.height * 0.92,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          EndingAssets.imageFor(widget.kind),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: size.width * 0.55,
                            height: size.height * 0.35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  HomeConstants.bgTop,
                                  HomeConstants.bgBottom,
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: GameOutlinedText(
                              meta.title,
                              fontSize: 22,
                              color: HomeConstants.titleColor,
                              strokeWidth: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GameOutlinedText(
                      meta.title,
                      fontSize: short ? 20 : 26,
                      fontWeight: FontWeight.w700,
                      color: HomeConstants.titleColor,
                      strokeWidth: 0,
                      letterSpacing: 1.5,
                    ),
                    const SizedBox(height: 8),
                    GameOutlinedText(
                      meta.subtitle,
                      textAlign: TextAlign.center,
                      fontSize: short ? 12 : 14,
                      color: HomeConstants.bodyColor,
                      strokeWidth: 0,
                      height: 1.45,
                    ),
                    SizedBox(height: short ? 12 : 18),
                    GameButton(
                      width: btnW,
                      height: btnH,
                      compact: true,
                      label: widget.primaryLabel ?? meta.primaryLabel,
                      onPressed: widget.onPrimary,
                    ),
                    if (widget.onSecondary != null) ...[
                      const SizedBox(height: 8),
                      GameButton(
                        width: btnW,
                        height: btnH,
                        compact: true,
                        label: widget.secondaryLabel ?? meta.secondaryLabel,
                        onPressed: widget.onSecondary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _EndingMeta _metaFor(EndingKind kind) {
    switch (kind) {
      case EndingKind.dragonClear:
        return const _EndingMeta(
          title: '幼龙已陨落',
          subtitle: '魔法宝石落入你手中。\n它既能打开墓地通往收容站的石门，也能在塔顶唤回失落的记忆。',
          primaryLabel: '继续探险',
          secondaryLabel: '返程完成旅行',
        );
      case EndingKind.mainClear:
        return const _EndingMeta(
          title: '迷雾消散',
          subtitle: '记忆涌回脑海，高塔的结界随之瓦解。\n你自由了——但收容站深处仍有未竟之事。',
          primaryLabel: '继续探索',
          secondaryLabel: '回标题',
        );
      case EndingKind.siteClear:
        return const _EndingMeta(
          title: '站点行动完成',
          subtitle: '终焉原型已被压制，收容库归于沉寂。\n一段漫长的旅途，即将迎来尾声。',
          primaryLabel: '观看职员表',
          secondaryLabel: '跳过',
        );
      case EndingKind.gameOver:
        return const _EndingMeta(
          title: '你倒下了',
          subtitle: '迷雾吞没了你的身影。\n你在上一处探索过的地点醒来，得分 -100（不低于 0）。',
          primaryLabel: '在上一地点醒来',
          secondaryLabel: '回标题',
        );
      case EndingKind.none:
        return const _EndingMeta(
          title: '',
          subtitle: '',
          primaryLabel: '继续',
          secondaryLabel: '关闭',
        );
    }
  }
}

class _EndingMeta {
  const _EndingMeta({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
}
