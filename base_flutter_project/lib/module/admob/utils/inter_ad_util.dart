import 'dart:async';

import 'package:flutter_ads/ads_flutter.dart';

import '../../../src/config/di/di.dart';
import '../../../src/config/navigation/app_router.dart';
import '../../../src/shared/global.dart';
import '../model/ad_config/ad_config.dart';
import '../widget/ads/full_native_ad.dart';

class InterAdUtil {
  InterAdUtil._();

  static InterAdUtil instance = InterAdUtil._();

  Future<void> showInterAd({
    required AdUnitConfig adConfig,
    bool forceShow = false,
    bool showNativeFull = true,
    bool isSplash = false,
    bool fullAdsOnly = false,
  }) async {
    if (fullAdsOnly && !Global.instance.isFullAds) {
      return;
    }
    if (!adConfig.isEnable) {
      return;
    }
    final completer = Completer();
    MyAds.instance.showInterstitialAd(
      getIt<AppRouter>().navigatorKey.currentContext!,
      adId: adConfig.id,
      adId2: adConfig.id2,
      adId2RequestPercentage: adConfig.id2RequestPercentage,
      forceShow: forceShow,
      onShowed: () {
        if (showNativeFull) {
          nativeFullUtil.preloadAd();
        }
        completer.complete();
      },
      onFailed: () {
        completer.complete();
      },
      onNoInternet: () {
        completer.complete();
      },
      adDismissed: () {
        if (showNativeFull) {
          nativeFullUtil.show();
        }
      },
    );
    return completer.future;
  }
}
