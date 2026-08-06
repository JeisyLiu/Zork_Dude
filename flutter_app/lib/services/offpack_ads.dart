import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum OffpackRewardPlacement { revive, loot }

/// Owns consent, SDK initialization, and the only production ad units allowed
/// by this app. All production unit names contain "offpack".
final class OffpackAds extends ChangeNotifier {
  OffpackAds._();

  static final instance = OffpackAds._();

  static const _productionBannerUnitId = String.fromEnvironment(
    'ADMOB_BANNER_OFFPACK_UNIT_ID',
  );
  static const _productionReviveUnitId = String.fromEnvironment(
    'ADMOB_REVIVE_OFFPACK_UNIT_ID',
  );
  static const _productionLootUnitId = String.fromEnvironment(
    'ADMOB_LOOT_OFFPACK_UNIT_ID',
  );
  static const _testBannerUnitId = String.fromEnvironment(
    'ADMOB_TEST_BANNER_UNIT_ID',
  );
  static const _testRewardedUnitId = String.fromEnvironment(
    'ADMOB_TEST_REWARDED_UNIT_ID',
  );

  bool _initializing = false;
  bool _sdkInitialized = false;
  bool _canRequestAds = false;
  bool _privacyOptionsRequired = false;
  RewardedAd? _reviveAd;
  RewardedAd? _lootAd;
  bool _reviveLoading = false;
  bool _lootLoading = false;
  Timer? _reviveRetry;
  Timer? _lootRetry;

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  bool get hasConfiguration => kReleaseMode
      ? _productionBannerUnitId.isNotEmpty &&
            _productionReviveUnitId.isNotEmpty &&
            _productionLootUnitId.isNotEmpty
      : _testBannerUnitId.isNotEmpty && _testRewardedUnitId.isNotEmpty;
  bool get canRequestAds => isSupported && _canRequestAds;
  bool get privacyOptionsRequired => isSupported && _privacyOptionsRequired;
  String get bannerUnitId =>
      kReleaseMode ? _productionBannerUnitId : _testBannerUnitId;

  bool rewardReady(OffpackRewardPlacement placement) {
    if (!canRequestAds) return false;
    return switch (placement) {
      OffpackRewardPlacement.revive => _reviveAd != null,
      OffpackRewardPlacement.loot => _lootAd != null,
    };
  }

  Future<void> initialize() async {
    if (!isSupported || !hasConfiguration || _initializing || _sdkInitialized) {
      return;
    }
    _initializing = true;
    try {
      await _gatherConsent();
      _privacyOptionsRequired =
          await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
      _canRequestAds = await ConsentInformation.instance.canRequestAds();
      await _startSdkIfAllowed();
    } catch (_) {
      _canRequestAds = false;
      _disposeRewardedAds();
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> _gatherConsent() async {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((_) {
          if (!done.isCompleted) done.complete();
        });
      },
      (_) {
        // A previous valid consent choice may still allow requests.
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future;
  }

  Future<void> showPrivacyOptions() async {
    if (!privacyOptionsRequired) return;
    final done = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((_) {
      if (!done.isCompleted) done.complete();
    });
    await done.future;
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    if (_canRequestAds) {
      await _startSdkIfAllowed();
    } else {
      _disposeRewardedAds();
    }
    notifyListeners();
  }

  Future<void> _startSdkIfAllowed() async {
    if (!_canRequestAds) return;
    if (!_sdkInitialized) {
      await MobileAds.instance.initialize();
      _sdkInitialized = true;
    }
    _preload(OffpackRewardPlacement.revive);
    _preload(OffpackRewardPlacement.loot);
  }

  void _disposeRewardedAds() {
    _reviveRetry?.cancel();
    _lootRetry?.cancel();
    _reviveAd?.dispose();
    _lootAd?.dispose();
    _reviveAd = null;
    _lootAd = null;
    _reviveLoading = false;
    _lootLoading = false;
  }

  void _preload(OffpackRewardPlacement placement) {
    if (!_sdkInitialized || !canRequestAds) return;
    if (placement == OffpackRewardPlacement.revive) {
      if (_reviveAd != null || _reviveLoading) return;
      _reviveLoading = true;
    } else {
      if (_lootAd != null || _lootLoading) return;
      _lootLoading = true;
    }

    RewardedAd.load(
      adUnitId: _rewardedUnitId(placement),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!canRequestAds) {
            ad.dispose();
            _reviveLoading = false;
            _lootLoading = false;
            notifyListeners();
            return;
          }
          if (placement == OffpackRewardPlacement.revive) {
            _reviveRetry?.cancel();
            _reviveLoading = false;
            _reviveAd = ad;
          } else {
            _lootRetry?.cancel();
            _lootLoading = false;
            _lootAd = ad;
          }
          notifyListeners();
        },
        onAdFailedToLoad: (_) {
          if (placement == OffpackRewardPlacement.revive) {
            _reviveLoading = false;
          } else {
            _lootLoading = false;
          }
          _scheduleRetry(placement);
          notifyListeners();
        },
      ),
    );
  }

  void _scheduleRetry(OffpackRewardPlacement placement) {
    final timer = Timer(const Duration(seconds: 30), () => _preload(placement));
    if (placement == OffpackRewardPlacement.revive) {
      _reviveRetry?.cancel();
      _reviveRetry = timer;
    } else {
      _lootRetry?.cancel();
      _lootRetry = timer;
    }
  }

  String _rewardedUnitId(OffpackRewardPlacement placement) {
    if (!kReleaseMode) return _testRewardedUnitId;
    return switch (placement) {
      OffpackRewardPlacement.revive => _productionReviveUnitId,
      OffpackRewardPlacement.loot => _productionLootUnitId,
    };
  }

  Future<bool> showRewarded(OffpackRewardPlacement placement) async {
    if (!rewardReady(placement)) return false;
    final ad = placement == OffpackRewardPlacement.revive ? _reviveAd : _lootAd;
    if (placement == OffpackRewardPlacement.revive) {
      _reviveAd = null;
    } else {
      _lootAd = null;
    }
    notifyListeners();
    if (ad == null) return false;

    final completion = Completer<bool>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!completion.isCompleted) completion.complete(earned);
        _preload(placement);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!completion.isCompleted) completion.complete(false);
        _preload(placement);
      },
    );
    ad.show(onUserEarnedReward: (_, reward) => earned = true);
    return completion.future;
  }
}
