import 'package:flutter/cupertino.dart';
import 'package:flutter_ads/ads_flutter.dart';

import '../../../../module/admob/model/ad_config/ad_config.dart';
import '../../../../module/admob/utils/enum/ad_factory.dart';
import '../../../../module/admob/utils/utils.dart';
import '../../../../module/remote_config/remote_config.dart';
import '../../../shared/enum/intro_type.dart';
import '../../../shared/global.dart';

class IntroAdUtil {
  IntroAdUtil._();

  static IntroAdUtil instance = IntroAdUtil._();

  NativeAdController? nativeController1;
  NativeAdController? nativeController2;
  NativeAdController? nativeController2Full;
  NativeAdController? nativeController3;
  NativeAdController? nativeController3Full;
  NativeAdController? nativeController4;

  void listenClickAdEvent({required ValueChanged<bool> onAdClicked}) {
    final nativeControllers = [
      nativeController1,
      nativeController2,
      nativeController2Full,
      nativeController3,
      nativeController3Full,
      nativeController4,
    ];
    for (final controller in nativeControllers) {
      controller?.onAdClicked = (ad) {
        onAdClicked(controller == nativeController4);
      };
    }
  }

  IntroType get introType =>
      RemoteConfigManager.instance.appConfig.screenFlow.introType;

  NativeAdController? _createController({
    required bool condition,
    required AdUnitConfig config,
    required String factoryId,
    required String adKey,
  }) {
    if (condition && config.isEnable) {
      return NativeAdController(
        factoryId: factoryId,
        adId: config.id,
        adId2: config.id2,
        adId2RequestPercentage: config.id2RequestPercentage,
        adKey: adKey,
      );
    }
    return null;
  }

  void initNativeAd() {
    nativeController2 = _createController(
      condition:
          !RemoteConfigManager.instance.isReduceAd &&
          introType.hasNativeBottomAd,
      config: adUnitsConfig.nativeIntro2,
      factoryId: largeNativeAdFactory,
      adKey: 'native_intro2',
    );

    nativeController2Full = _createController(
      condition:
          !RemoteConfigManager.instance.isReduceAd && introType.hasNativeFullAd,
      config: adUnitsConfig.nativeFullIntro2,
      factoryId: AdFactory.fullNativeAd.name,
      adKey: 'native_intro2_full',
    );

    nativeController3 = _createController(
      condition:
          !RemoteConfigManager.instance.isReduceAd &&
          introType.hasNativeBottomAd,
      config: adUnitsConfig.nativeIntro3,
      factoryId: largeNativeAdFactory,
      adKey: 'native_intro3',
    );

    nativeController3Full = _createController(
      condition:
          !RemoteConfigManager.instance.isReduceAd && introType.hasNativeFullAd,
      config: adUnitsConfig.nativeFullIntro3,
      factoryId: AdFactory.fullNativeAd.name,
      adKey: 'native_intro3_full',
    );

    nativeController4 = _createController(
      condition: !RemoteConfigManager.instance.isReduceAd,
      config: adUnitsConfig.nativeIntro4,
      factoryId: largeNativeAdFactory,
      adKey: 'native_intro4',
    );
  }

  void preloadAd1() {
    if (nativeController1 == null) {
      nativeController1 = _createController(
        condition: true,
        config: adUnitsConfig.nativeIntro1,
        factoryId: largeNativeAdFactory,
        adKey: 'native_intro1',
      );
      nativeController1?.load();
    }
  }

  void disposeAds() {
    nativeController1?.dispose();
    nativeController2?.dispose();
    nativeController2Full?.dispose();
    nativeController3?.dispose();
    nativeController3Full?.dispose();
    nativeController4?.dispose();

    nativeController1 = null;
    nativeController2 = null;
    nativeController2Full = null;
    nativeController3 = null;
    nativeController3Full = null;
    nativeController4 = null;
  }
}

extension NativeAdControllerExtension on NativeAdController {
  Future<void> preloadAd() async {
    if (!status.isLoading && !status.isShowOnScreen) {
      await load();
    }
  }
}
