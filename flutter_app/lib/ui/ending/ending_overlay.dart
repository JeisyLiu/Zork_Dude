import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
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
    this.onRewarded,
    this.onRewardEarned,
    this.rewardLabel,
    this.rewardSubLabel,
  });

  final EndingKind kind;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final String? primaryLabel;
  final String? secondaryLabel;
  final Future<bool> Function()? onRewarded;
  final VoidCallback? onRewardEarned;
  final String? rewardLabel;
  final String? rewardSubLabel;

  @override
  State<EndingOverlay> createState() => _EndingOverlayState();
}

class _EndingOverlayState extends State<EndingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  bool _rewardLoading = false;
  bool _rewardFailed = false;

  Future<void> _watchReward() async {
    if (_rewardLoading || widget.onRewarded == null) return;
    setState(() {
      _rewardLoading = true;
      _rewardFailed = false;
    });
    final earned = await widget.onRewarded!();
    if (!mounted) return;
    if (earned) {
      widget.onRewardEarned?.call();
      return;
    }
    setState(() {
      _rewardLoading = false;
      _rewardFailed = true;
    });
  }

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
    final l10n = AppLocalizations.of(context);
    final meta = _metaFor(widget.kind, l10n);
    final btnW = short ? 148.0 : 168.0;
    final btnH = HomeConstants.buttonHeightFor(btnW);

    if (widget.kind == EndingKind.gameOver) {
      return Material(
        color: Colors.black,
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Center(
                child: Image.asset(
                  EndingAssets.imageFor(widget.kind),
                  width: size.width,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Colors.black),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: short ? 12 : 20,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      GameOutlinedText(
                        meta.title,
                        fontSize: short ? 20 : 26,
                        fontWeight: FontWeight.w700,
                        color: HomeConstants.titleColor,
                        strokeWidth: 0,
                        letterSpacing: 1.5,
                        shadowColor: Colors.black.withValues(alpha: 0.7),
                        shadowBlurRadius: 6,
                      ),
                      const SizedBox(height: 8),
                      GameOutlinedText(
                        meta.subtitle,
                        textAlign: TextAlign.center,
                        fontSize: short ? 12 : 14,
                        color: HomeConstants.bodyColor,
                        strokeWidth: 0,
                        height: 1.45,
                        shadowColor: Colors.black.withValues(alpha: 0.65),
                        shadowBlurRadius: 4,
                      ),
                      SizedBox(height: short ? 12 : 18),
                      if (widget.onRewarded != null) ...[
                        GameButton(
                          width: btnW,
                          height: btnH,
                          compact: true,
                          accent: true,
                          enabled: !_rewardLoading,
                          label: _rewardLoading
                              ? l10n.summoningGlimmer
                              : widget.rewardLabel ?? l10n.watchAd,
                          subLabel: _rewardLoading
                              ? null
                              : widget.rewardSubLabel,
                          onPressed: _rewardLoading ? null : _watchReward,
                        ),
                        if (_rewardFailed) ...[
                          const SizedBox(height: 5),
                          GameOutlinedText(
                            l10n.glimmerNoResponse,
                            fontSize: 10,
                            color: HomeConstants.hintColor,
                            strokeWidth: 0,
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
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
            ],
          ),
        ),
      );
    }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
                    if (widget.onRewarded != null) ...[
                      GameButton(
                        width: btnW,
                        height: btnH,
                        compact: true,
                        accent: true,
                        enabled: !_rewardLoading,
                        label: _rewardLoading
                            ? l10n.summoningGlimmer
                            : widget.rewardLabel ?? l10n.watchAd,
                        subLabel: _rewardLoading ? null : widget.rewardSubLabel,
                        onPressed: _rewardLoading ? null : _watchReward,
                      ),
                      if (_rewardFailed) ...[
                        const SizedBox(height: 5),
                        GameOutlinedText(
                          l10n.glimmerNoResponse,
                          fontSize: 10,
                          color: HomeConstants.hintColor,
                          strokeWidth: 0,
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
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

  _EndingMeta _metaFor(EndingKind kind, AppLocalizations l10n) {
    switch (kind) {
      case EndingKind.dragonClear:
        return _EndingMeta(
          title: l10n.endingDragonTitle,
          subtitle: l10n.endingDragonSubtitle,
          primaryLabel: l10n.endingDragonPrimary,
          secondaryLabel: l10n.endingDragonSecondary,
        );
      case EndingKind.mainClear:
        return _EndingMeta(
          title: l10n.endingMainTitle,
          subtitle: l10n.endingMainSubtitle,
          primaryLabel: l10n.endingMainPrimary,
          secondaryLabel: l10n.backToTitle,
        );
      case EndingKind.siteClear:
        return _EndingMeta(
          title: l10n.endingSiteTitle,
          subtitle: l10n.endingSiteSubtitle,
          primaryLabel: l10n.endingSitePrimary,
          secondaryLabel: l10n.skip,
        );
      case EndingKind.gameOver:
        return _EndingMeta(
          title: l10n.endingGameOverTitle,
          subtitle: l10n.endingGameOverSubtitle,
          primaryLabel: l10n.endingGameOverPrimary,
          secondaryLabel: l10n.backToTitle,
        );
      case EndingKind.none:
        return _EndingMeta(
          title: '',
          subtitle: '',
          primaryLabel: l10n.continueAction,
          secondaryLabel: l10n.close,
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
