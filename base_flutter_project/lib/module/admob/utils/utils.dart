import '../../../src/shared/global.dart';
import '../../remote_config/remote_config.dart';
import '../model/ad_config/ad_config.dart';
import 'enum/ad_factory.dart';
import 'native_full_util.dart';

class NativeAdSize {
  const NativeAdSize._();

  static const double large = 280;
  static const double medium = 170;
  static const double smallAd = 61;
}

String get largeNativeAdFactory {
  if (Global.instance.isFullAds &&
      RemoteConfigManager.instance.adsRemoteConfig.showTopButton) {
    return AdFactory.topExtraNativeAd.name;
  } else {
    return AdFactory.bottomNormalNativeAd.name;
  }
}

AdUnitsConfig get adUnitsConfig =>
    RemoteConfigManager.instance.adsRemoteConfig.adUnitsConfig;

final nativeFullSplashUtil = NativeFullUtil(
  adConfig: adUnitsConfig.nativeFullSplash,
  factoryId: AdFactory.fullNativeAd.name,
  adKey: 'native_full_splash',
);
