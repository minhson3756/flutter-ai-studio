import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adjust/flutter_adjust.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';

import '../../../module/admob/model/ad_config/ad_config.dart';
import '../../../module/admob/utils/utils.dart';
import '../../../module/remote_config/remote_config.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/theme/palette.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/string_extension.dart';
import '../../shared/global.dart';
import '../../shared/helpers/admob_consent_util.dart';
import '../../shared/helpers/logger_utils.dart';
import '../../shared/helpers/my_completer.dart';
import '../../shared/helpers/permission_util.dart';
import '../../shared/widgets/custom_fade_in_image.dart';
import 'update_dialog.dart';

@RoutePage()
class SplashScreen extends StatefulLoggableWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController = AnimationController(
    vsync: this,
    value: 0,
    duration: const Duration(seconds: 1),
  );

  final Upgrader upgrader = Upgrader(
    // TODO(all): uncomment to check upgrader
    // debugDisplayAlways: true,
    debugLogging: true,
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomFadeInImage(
                    image: Assets.images.logo.logo.provider(),
                    width: 145.r,
                    height: 145.r,
                    fit: BoxFit.contain,
                  ),
                  16.verticalSpace,
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: context.colorScheme.primary,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                animation: loadingController,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.loading(
                          (loadingController.value * 100).toStringAsFixed(0),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF627689),
                        ),
                      ),
                      2.verticalSpace,
                      SizedBox(
                        width: 200,
                        height: 6,
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(4),
                          color: Palette.primary,
                          value: loadingController.value.clamp(0, .99),
                          backgroundColor: const Color(0xffd1d1d1),
                        ),
                      ),
                    ],
                  );
                },
              ),
              15.verticalSpace,
              Text(
                context.l10n.thisActionCanContainAds,
                style: const TextStyle(color: Palette.primary),
              ),
            ],
          ),
          40.verticalSpace,
        ],
      ),
    );
  }

  @override
  void dispose() {
    loadingController.dispose();
    Global.instance.didLeaveSplash = true;
    initAdOpen();
    super.dispose();
  }

  Future<void> _init() async {
    if (!kDebugMode) {
      initCrashlytics();
    }
    loadingController.animateTo(0.16);
    await AdmobConsentUtil.initialize();
    loadingController.animateTo(.45);
    await Future.wait([configureAd(), upgrader.initialize()]);
    loadingController.animateTo(.71);
    await initUpgrader();
    loadingController.animateTo(0.99);
    PermissionUtil.instance.checkAllPermissions();
    await showSplashInter();
    goToNextScreen();
  }

  void initCrashlytics() {
    FlutterError.onError = (errorDetails) {
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      } on Exception catch (e) {
        logger.e(e);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } on Exception catch (e) {
        logger.e(e);
      }
      return true;
    };
  }

  Future<bool> configureAd() async {
    final bool isShowAd = RemoteConfigManager.instance.enableAllAds;
    //init and show ad
    if (mounted && isShowAd) {
      await MyAds.instance.initialize(
        navigatorKey: getIt<AppRouter>().navigatorKey,
        enableShowRateLogger: true,
        interIntervalInSeconds:
            RemoteConfigManager.instance.adsRemoteConfig.interInterval,
        id2RequestTimeout:
            RemoteConfigManager.instance.adsRemoteConfig.id2RequestTimeout,
      );
      MyAds.instance.events.listen((event) {
        if (event.status.isPaid &&
            event.valueMicros != null &&
            event.currencyCode != null) {
          final value = event.valueMicros! / 1000000;
          AdjustUtil.instance.trackAdRevenue(
            value: value,
            currencyCode: event.currencyCode!,
          );
          AdjustUtil.instance.trackImpressionEvent(
            value: value,
            currencyCode: event.currencyCode!,
          );
          final event80Token =
              RemoteConfigManager.instance.adjustConfig.event80Token;
          if (event80Token.isValid) {
            final AdjustEvent event80 = AdjustEvent(event80Token!);
            event80.setRevenue(value * 0.8, event.currencyCode!);
            AdjustUtil.instance.trackEvent(event80);
          }
        }
      });
    }
    return true;
  }

  Future<void> initAdOpen() async {
    //set up ad open
    if (adUnitsConfig.openResume.isEnable) {
      await MyAds.instance.initAppOpenAd(
        appOpenAdUnitId: adUnitsConfig.openResume.id,
        appOpenAdUnitId2: adUnitsConfig.openResume.id2,
        adId2RequestPercentage: adUnitsConfig.openResume.id2RequestPercentage,
      );
    }
  }

  Future<void> goToNextScreen() async {
    // if (purchasesManager.isPremium) {
    //   context.replaceRoute(PremiumRoute(nextRoute: const HomeRoute()));
    //   return;
    // }
    final isLanguageScreenShown = SharedPreferencesManager.instance
        .shouldShowScreen(LanguageRoute.name);
    final enableSecondLanguage =
        RemoteConfigManager.instance.appConfig.screenFlow.enableSecondLanguage;
    final isIntroScreenShown = SharedPreferencesManager.instance
        .shouldShowScreen(OnBoardingRoute.name);
    final enableSecondIntro =
        RemoteConfigManager.instance.appConfig.screenFlow.enableSecondIntro;
    if (isLanguageScreenShown || enableSecondLanguage) {
      context.replaceRoute(LanguageRoute(isFirst: true));
    } else if (isIntroScreenShown || enableSecondIntro) {
      context.replaceRoute(OnBoardingRoute(fromSplash: true));
    } else {
      context.replaceRoute(const HomeRoute());
    }
  }

  Future<void> initUpgrader() async {
    final Completer completer = Completer();
    final bool forceUpdate =
        RemoteConfigManager.instance.appConfig.isForceUpdate;
    if (!upgrader.shouldDisplayUpgrade()) {
      completer.complete();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: UpdateDialog(
            upgrader: upgrader,
            showLater: !forceUpdate,
            onLater: completer.complete,
          ),
        ),
      );
    }
    return completer.future;
  }

  void configureEasyLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorWidget = const CircularProgressIndicator(
        color: Palette.primary,
        strokeCap: StrokeCap.round,
        strokeWidth: 6,
      )
      ..indicatorColor = Palette.primary
      ..maskType = EasyLoadingMaskType.black
      ..backgroundColor = Colors.transparent
      ..boxShadow = []
      ..textColor = Palette.primary
      ..dismissOnTap = false;
    Global.instance.initEasyLoading = true;
  }

  Future<void> showSplashInter() async {
    final adConfig = RemoteConfigManager.instance.appConfig.useInterSplash
        ? adUnitsConfig.interSplash
        : adUnitsConfig.openOnResumeSplash;

    if (!adConfig.isEnable || RemoteConfigManager.instance.isReduceAd) {
      return;
    }
    final completer = MyCompleter();
    MyAds.instance.showSplashAd(
      getIt<AppRouter>().navigatorKey.currentContext!,
      adId: adConfig.id,
      adId2: adConfig.id2,
      adId2RequestPercentage: adConfig.id2RequestPercentage,
      useInterAd: RemoteConfigManager.instance.appConfig.useInterSplash,
      showLoading: false,
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
