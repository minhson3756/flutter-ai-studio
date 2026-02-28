import 'package:flutter_ads/ads_flutter.dart';

import '../../../src/shared/global.dart';
import '../model/ad_config/ad_config.dart';
import 'enum/ad_factory.dart';

class ReloadAdUtil {
  ReloadAdUtil._();

  static final ReloadAdUtil instance = ReloadAdUtil._();

  AdUnitConfig? adConfig;

  NativeAdController? controller;

  Future<void> loadAd() async {
    if (controller == null && adConfig != null && Global.instance.isFullAds) {
      controller = NativeAdController(
        adId: adConfig!.id,
        adId2: adConfig!.id2,
        adId2RequestPercentage: adConfig!.id2RequestPercentage,
        factoryId: AdFactory.topExtraNativeAd.name,
        adKey: 'reload_ad',
      );
      controller?.load();
    }
  }
}
