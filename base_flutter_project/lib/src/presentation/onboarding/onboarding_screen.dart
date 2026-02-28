import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../module/remote_config/remote_config.dart';
import '../../../module/tracking_screen/screen_logger.dart';
import '../../gen/assets.gen.dart';
import '../../shared/enum/intro_type.dart';
import '../../shared/extension/context_extension.dart';
import 'utils/intro_ad_util.dart';
import 'utils/onboarding_controller.dart';
import 'widgets/full_screen_native_ad.dart';
import 'widgets/indicator.dart';
import 'widgets/page_widget.dart';

part 'widgets/page_action.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget implements AutoRouteWrapper {
  const OnBoardingScreen({super.key, this.fromSplash = false});

  final bool fromSplash;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final controller = OnboardingController();
    return RepositoryProvider(create: (context) => controller, child: this);
  }
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  IntroType get introType =>
      RemoteConfigManager.instance.appConfig.screenFlow.introType;

  late final OnboardingController onboardingController = context
      .read<OnboardingController>();

  @override
  void initState() {
    super.initState();
    if (RemoteConfigManager.instance.enableAllAds) {
      listenClickAdEvent();
    }
    IntroAdUtil.instance.initNativeAd();
    if (widget.fromSplash) {
      IntroAdUtil.instance.preloadAd1();
    }
  }

  void listenClickAdEvent() {
    IntroAdUtil.instance.listenClickAdEvent(
      onAdClicked: (isLastAd) {
        if (isLastAd) {
          onboardingController.goToNextScreen();
        } else {
          onboardingController.swipeToNextPage();
        }
      },
    );
  }

  Widget buildFullScreenAd({
    NativeAdController? controller,
    VoidCallback? onInit,
    VoidCallback? onFailed,
  }) {
    return FullScreenNativePage(
      controller: controller,
      onInit: onInit,
      onFailed: () {
        Future.delayed(Duration.zero, () {
          onFailed?.call();
        });
        onboardingController.swipeToNextPage();
      },
      onClose: () {
        onboardingController.swipeToNextPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: onboardingController.pageController,
        physics: introType.enableSwipe
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ContentPageWidget(
            image: Assets.images.onboarding.onboarding1,
            title: 'Title',
            description: 'Description',
            pageController: onboardingController.pageController,
            index: 0,
            adController: IntroAdUtil.instance.nativeController1,
            onInit: () {
              IntroAdUtil.instance.nativeController2?.load();
              AnalyticLogger.instance.logScreen('Intro1Screen');
            },
          ),
          ContentPageWidget(
            image: Assets.images.onboarding.onboarding2,
            title: 'Title',
            description: 'Description',
            pageController: onboardingController.pageController,
            index: 1,
            adController: IntroAdUtil.instance.nativeController2,
            onInit: () {
              if (IntroAdUtil.instance.nativeController2Full != null) {
                IntroAdUtil.instance.nativeController2Full?.preloadAd();
              } else {
                IntroAdUtil.instance.nativeController3?.preloadAd();
              }
              AnalyticLogger.instance.logScreen('Intro2Screen');
            },
          ),
          if (IntroAdUtil.instance.nativeController2Full != null)
            buildFullScreenAd(
              controller: IntroAdUtil.instance.nativeController2Full,
              onInit: () => IntroAdUtil.instance.nativeController3?.preloadAd(),
              onFailed: () {
                setState(() {
                  IntroAdUtil.instance.nativeController2Full = null;
                });
              },
            ),
          ContentPageWidget(
            image: Assets.images.onboarding.onboarding3,
            title: 'Title',
            description: 'Description',
            pageController: onboardingController.pageController,
            index: 2,
            adController: IntroAdUtil.instance.nativeController3,
            onInit: () {
              if (IntroAdUtil.instance.nativeController3Full != null) {
                IntroAdUtil.instance.nativeController3Full?.preloadAd();
              } else {
                IntroAdUtil.instance.nativeController4?.preloadAd();
              }
              AnalyticLogger.instance.logScreen('Intro3Screen');
            },
          ),
          if (IntroAdUtil.instance.nativeController3Full != null)
            buildFullScreenAd(
              controller: IntroAdUtil.instance.nativeController3Full,
              onInit: () => IntroAdUtil.instance.nativeController4?.preloadAd(),
              onFailed: () {
                setState(() {
                  IntroAdUtil.instance.nativeController3Full = null;
                });
              },
            ),
          ContentPageWidget(
            image: Assets.images.onboarding.onboarding3,
            title: 'Title',
            description: 'Description',
            pageController: onboardingController.pageController,
            index: 3,
            adController: IntroAdUtil.instance.nativeController4,
            onInit: () {
              AnalyticLogger.instance.logScreen('Intro4Screen');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    onboardingController.dispose();
    IntroAdUtil.instance.disposeAds();
    super.dispose();
  }
}
