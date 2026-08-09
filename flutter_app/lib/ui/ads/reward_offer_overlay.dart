import 'package:flutter/material.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

class RewardOfferOverlay extends StatefulWidget {
  const RewardOfferOverlay({super.key, required this.gold});

  final int gold;

  static Future<bool> show(BuildContext context, int gold) async {
    return await Navigator.of(context).push<bool>(
          PageRouteBuilder<bool>(
            opaque: false,
            barrierDismissible: false,
            pageBuilder: (_, animation, secondaryAnimation) =>
                RewardOfferOverlay(gold: gold),
            transitionsBuilder: (_, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ) ??
        false;
  }

  @override
  State<RewardOfferOverlay> createState() => _RewardOfferOverlayState();
}

class _RewardOfferOverlayState extends State<RewardOfferOverlay> {
  bool _loading = false;
  bool _failed = false;

  Future<void> _watch() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _failed = false;
    });
    final earned = await OffpackAds.instance.showRewarded(
      OffpackRewardPlacement.loot,
    );
    if (!mounted) return;
    if (earned) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.black.withValues(alpha: 0.78),
      child: SafeArea(
        child: Center(
          child: Container(
            width: 360,
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
            decoration: BoxDecoration(
              color: HomeConstants.bgBottom,
              border: Border.all(color: HomeConstants.subtitleColor, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GameOutlinedText(
                  l10n.rewardOfferTitle,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: HomeConstants.titleColor,
                  strokeWidth: 0,
                  letterSpacing: 1.5,
                ),
                const SizedBox(height: 8),
                GameOutlinedText(
                  l10n.rewardOfferGold(widget.gold, widget.gold * 2),
                  textAlign: TextAlign.center,
                  fontSize: 13,
                  color: HomeConstants.bodyColor,
                  strokeWidth: 0,
                ),
                if (_failed) ...[
                  const SizedBox(height: 6),
                  GameOutlinedText(
                    l10n.rewardOfferUnavailable,
                    fontSize: 10,
                    color: HomeConstants.hintColor,
                    strokeWidth: 0,
                  ),
                ],
                const SizedBox(height: 14),
                GameButton(
                  width: 190,
                  height: 42,
                  compact: true,
                  accent: true,
                  enabled: !_loading,
                  label: _loading ? l10n.rewardOfferLoading : l10n.rewardOfferWatch,
                  onPressed: _loading ? null : _watch,
                ),
                const SizedBox(height: 8),
                GameButton(
                  width: 190,
                  height: 38,
                  compact: true,
                  label: l10n.continueAdventure,
                  onPressed: _loading
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
