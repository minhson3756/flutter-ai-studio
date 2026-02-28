import 'dart:async';

import 'package:flutter_ads/ads_flutter.dart';

import '../../../src/config/di/di.dart';
import '../../../src/config/navigation/app_router.dart';
import '../../remote_config/remote_config.dart';
import '../model/ad_config/ad_config.dart';

class InterAdUtil {
  InterAdUtil._();

  static InterAdUtil instance = InterAdUtil._();

  Future<void> showInterAd({
    required AdUnitConfig adConfig,
    bool forceShow = false,
    bool showNativeFull = true,
    bool isSplash = false,
    bool checkReduceAd = false,
  }) async {
    if (checkReduceAd && RemoteConfigManager.instance.isReduceAd) {
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
        completer.complete();
      },
      onFailed: () {
        completer.complete();
      },
      onNoInternet: () {
        completer.complete();
      },
    );
    return completer.future;
  }
}
