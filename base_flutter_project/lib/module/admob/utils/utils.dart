import '../../remote_config/remote_config.dart';
import '../model/ad_config/ad_config.dart';
import 'enum/ad_factory.dart';

class NativeAdSize {
  const NativeAdSize._();

  static const double large = 280;
  static const double medium = 170;
  static const double smallAd = 61;
}

String get largeNativeAdFactory {
  if (RemoteConfigManager.instance.adsRemoteConfig.showTopButton) {
    return AdFactory.topExtraNativeAd.name;
  } else {
    return AdFactory.bottomNormalNativeAd.name;
  }
}

AdUnitsConfig get adUnitsConfig =>
    RemoteConfigManager.instance.adsRemoteConfig.adUnitsConfig;
