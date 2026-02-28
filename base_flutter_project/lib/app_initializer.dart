import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'flavors.dart';
import 'module/adjust/adjust.dart';
import 'module/iap/my_purchase_manager.dart';
import 'module/remote_config/remote_config.dart';
import 'src/config/di/di.dart';
import 'src/data/local/shared_preferences_manager.dart';
import 'src/shared/global.dart';
import 'src/shared/helpers/method_channel/notification_channel.dart';
import 'src/shared/helpers/utils.dart';

class AppInitializer {
  AppInitializer._();

  static final AppInitializer instance = AppInitializer._();

  Future<void> init() async {
    configureDependencies();
    purchasesManager = MyPurchasesManager();
    await Future.wait([
      Firebase.initializeApp(),
      _initHydrateBlocStorage(),
      SharedPreferencesManager.instance.initialize(),
      initGlobalData(),
      // purchasesManager.init(),
    ]);
    await RemoteConfigManager.instance.initConfig();
    _initAdjust();

    _settingSystemUI();
  }

  Future<void> initGlobalData() async {
    final result = await Future.wait([
      getApplicationDocumentsDirectory(),
      getTemporaryDirectory(),
    ]);
    Global.instance.documentPath = result[0].path;
    Global.instance.temporaryPath = result[1].path;
    if (Platform.isAndroid) {
      Global.instance.androidSdkVersion =
          (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    }
  }

  Future<void> _initAdjust() {
    final adjustEnvironment = F.appFlavor == Flavor.dev || kDebugMode
        ? AdjustEnvironment.sandbox
        : AdjustEnvironment.production;
    if (const bool.hasEnvironment('FULL_ADS') && F.appFlavor == Flavor.dev) {
      Global.instance.isFullAds = const bool.fromEnvironment('FULL_ADS');
      NotificationChannel.enableNotification(Global.instance.isFullAds);
    }
    final adjustConfig = RemoteConfigManager.instance.adjustConfig;
    return AdjustUtil.instance.initialize(
      // Kiểm tra môi trường Adjust
      environment: adjustEnvironment,
      // Token app của Adjust
      appToken: AdjustToken(
        androidToken: adjustConfig.appToken,
        iosToken: adjustConfig.appToken,
      ),
      // Cấu hình cho ad
      adOptions: AdOptions(
        androidAdOptions: AndroidAdOptions(
          // Token event để log các sự kiện impression của ad lên Adjust
          impressionToken: adjustConfig.eventToken,
          // Callback khi ad kiểm tra xem có phải là full ad không
          fullAdCallback: (isFullAd, network, fromCache, fromLib, fromApi) {
            if (const bool.hasEnvironment('FULL_ADS')) {
              isFullAd = const bool.fromEnvironment('FULL_ADS');
            }
            Global.instance.isFullAds = isFullAd;
            NotificationChannel.enableNotification(isFullAd);
          },
        ),
      ),
      fullAdsOption: adjustConfig.fullAdsOption,
      apiToken: adjustConfig.apiToken,
    );
  }

  Future<HydratedStorage> _initHydrateBlocStorage() async {
    final Directory documentDir = await getApplicationDocumentsDirectory();
    return HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(documentDir.path),
    );
  }

  //show hide bottom navigation bar of device
  void _settingSystemUI() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      hideNavigationBar();
      SystemChrome.setSystemUIChangeCallback((
        bool systemOverlaysAreVisible,
      ) async {
        if (systemOverlaysAreVisible) {
          Future<void>.delayed(const Duration(seconds: 3), hideNavigationBar);
        }
      });
    }
  }
}
