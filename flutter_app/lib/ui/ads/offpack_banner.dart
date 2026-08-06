import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/home/home_constants.dart';

/// A compact, fixed-height banner slot that does not move the home content
/// when the ad finishes loading.
class OffpackHomeBanner extends StatefulWidget {
  const OffpackHomeBanner({super.key});

  @override
  State<OffpackHomeBanner> createState() => _OffpackHomeBannerState();
}

class _OffpackHomeBannerState extends State<OffpackHomeBanner> {
  BannerAd? _ad;
  bool _loading = false;
  Timer? _retry;

  @override
  void initState() {
    super.initState();
    OffpackAds.instance.addListener(_onAdsChanged);
    _loadIfAllowed();
  }

  void _onAdsChanged() {
    if (!OffpackAds.instance.canRequestAds) {
      _retry?.cancel();
      _ad?.dispose();
      _ad = null;
    }
    _loadIfAllowed();
    if (mounted) setState(() {});
  }

  void _loadIfAllowed() {
    if (!OffpackAds.instance.canRequestAds || _ad != null || _loading) return;
    _loading = true;
    final ad = BannerAd(
      adUnitId: OffpackAds.instance.bannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (loaded) {
          if (!mounted || !OffpackAds.instance.canRequestAds) {
            loaded.dispose();
            _loading = false;
            return;
          }
          setState(() {
            _retry?.cancel();
            _loading = false;
            _ad = loaded as BannerAd;
          });
        },
        onAdFailedToLoad: (failed, _) {
          failed.dispose();
          if (mounted) {
            setState(() => _loading = false);
            _retry?.cancel();
            _retry = Timer(const Duration(seconds: 30), _loadIfAllowed);
          }
        },
      ),
    );
    ad.load();
  }

  @override
  void dispose() {
    OffpackAds.instance.removeListener(_onAdsChanged);
    _retry?.cancel();
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!OffpackAds.instance.canRequestAds) return const SizedBox.shrink();
    final ad = _ad;
    return SizedBox(
      width: 324,
      height: 54,
      child: ad == null
          ? const SizedBox.shrink()
          : Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: HomeConstants.bgBottom.withValues(alpha: 0.82),
                border: Border.all(
                  color: HomeConstants.subtitleColor.withValues(alpha: 0.45),
                ),
              ),
              child: AdWidget(ad: ad),
            ),
    );
  }
}

class OffpackPrivacyButton extends StatelessWidget {
  const OffpackPrivacyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OffpackAds.instance,
      builder: (context, _) {
        if (!OffpackAds.instance.privacyOptionsRequired) {
          return const SizedBox.shrink();
        }
        return Semantics(
          button: true,
          label: '隐私设置',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: OffpackAds.instance.showPrivacyOptions,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: GameOutlinedText(
                '隐私设置 · privacy',
                fontSize: 10,
                color: HomeConstants.hintColor,
                strokeWidth: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}
