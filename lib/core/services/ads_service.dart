import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';

/// Ads Service - Crash-proof, Play Store ready.
/// If AndroidManifest APPLICATION_ID missing, it will NOT crash app.

class AdsService {
  AdsService._();
  static final instance = AdsService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      // This can throw if AndroidManifest missing APPLICATION_ID
      await MobileAds.instance.initialize();
      _initialized = true;
      debugPrint('Ads initialized');
      // Load ads after init, fire-and-forget
      _safeLoadInterstitial();
      _safeLoadRewarded();
    } catch (e, s) {
      debugPrint('Ads init FAILED - app will continue without ads: $e\n$s');
      _initialized = false;
      // DO NOT rethrow - prevent app auto-close
    }
  }

  void _safeLoadInterstitial() {
    try {
      InterstitialAd.load(
        adUnitId: AppConstants.testInterstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialReady = true;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                try {
                  ad.dispose();
                } catch (_) {}
                _isInterstitialReady = false;
                _safeLoadInterstitial();
              },
              onAdFailedToShowFullScreenContent: (ad, err) {
                try {
                  ad.dispose();
                } catch (_) {}
                _isInterstitialReady = false;
                _safeLoadInterstitial();
              },
            );
          },
          onAdFailedToLoad: (err) {
            debugPrint('Interstitial failed $err');
            _isInterstitialReady = false;
          },
        ),
      );
    } catch (e) {
      debugPrint('Interstitial load exception $e');
    }
  }

  void _safeLoadRewarded() {
    try {
      RewardedAd.load(
        adUnitId: AppConstants.testRewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isRewardedReady = true;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                try {
                  ad.dispose();
                } catch (_) {}
                _isRewardedReady = false;
                _safeLoadRewarded();
              },
              onAdFailedToShowFullScreenContent: (ad, err) {
                try {
                  ad.dispose();
                } catch (_) {}
                _isRewardedReady = false;
                _safeLoadRewarded();
              },
            );
          },
          onAdFailedToLoad: (err) {
            debugPrint('Rewarded failed $err');
            _isRewardedReady = false;
          },
        ),
      );
    } catch (e) {
      debugPrint('Rewarded load exception $e');
    }
  }

  BannerAd? createBannerAd() {
    if (!_initialized) return null;
    try {
      return BannerAd(
        adUnitId: AppConstants.testBannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, err) {
            try {
              ad.dispose();
            } catch (_) {}
          },
        ),
      )..load();
    } catch (e) {
      debugPrint('Banner create failed $e');
      return null;
    }
  }

  Future<void> showInterstitialIfReady() async {
    if (!_isInterstitialReady || _interstitialAd == null) return;
    try {
      await _interstitialAd!.show();
    } catch (e) {
      debugPrint('Show interstitial failed $e');
    }
  }

  Future<bool> showRewardedAd(
      {required Function(int reward) onRewarded}) async {
    if (!_isRewardedReady || _rewardedAd == null) return false;
    bool rewarded = false;
    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          rewarded = true;
          try {
            onRewarded(reward.amount.toInt());
          } catch (_) {}
        },
      );
      return rewarded;
    } catch (e) {
      debugPrint('Show rewarded failed $e');
      return false;
    }
  }

  void dispose() {
    try {
      _interstitialAd?.dispose();
    } catch (_) {}
    try {
      _rewardedAd?.dispose();
    } catch (_) {}
  }
}
