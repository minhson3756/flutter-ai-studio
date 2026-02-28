import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ads/ads_flutter.dart';

import '../../../../module/admob/utils/inter_ad_util.dart';
import '../../../../module/admob/utils/utils.dart';
import '../../../../module/remote_config/remote_config.dart';
import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import 'intro_ad_util.dart';

class OnboardingController {
  OnboardingController() {
    IntroAdUtil.instance.initNativeAd();
  }

  final PageController pageController = PageController();
  NativeAdController? languageController;
  NativeAdController? languageSelectController;

  final int totalPage = 4;

  void pressNextButton(int currentIndex) {
    if (currentIndex < totalPage - 1) {
      swipeToNextPage();
    } else {
      goToNextScreen();
    }
  }

  Future<void> _showInterIntro() async {
    if (!RemoteConfigManager.instance.isReduceAd) {
      await InterAdUtil.instance.showInterAd(
        adConfig: adUnitsConfig.interIntro,
      );
    }
  }

  void swipeToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> goToNextScreen() async {
    await _showInterIntro();
    SharedPreferencesManager.instance.markScreenAsShown(OnBoardingRoute.name);
    getIt<AppRouter>().replace(const HomeRoute());
  }

  void dispose() {
    IntroAdUtil.instance.disposeAds();
  }
}
