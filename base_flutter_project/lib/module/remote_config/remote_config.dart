import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../flavors.dart';
import '../../src/data/models/adjust_config.dart';
import '../../src/data/models/app_config_model.dart';
import '../../src/shared/helpers/logger_utils.dart';
import '../admob/model/ad_config/ad_config.dart';
import '../admob/model/native_all_config/native_all_config.dart';
import '../admob/utils/native_all_util.dart';
import 'default_values/dev_values.dart';
import 'default_values/prod_values.dart';

class RemoteConfigManager {
  RemoteConfigManager._privateConstructor();

  static final RemoteConfigManager instance =
      RemoteConfigManager._privateConstructor();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Config cho app
  AppConfigModel _appConfig = const AppConfigModel();

  AppConfigModel get appConfig => _appConfig;

  /// Config cho  quảng cáo
  AdsRemoteConfig _adsRemoteConfig = const AdsRemoteConfig();

  AdsRemoteConfig get adsRemoteConfig => _adsRemoteConfig;

  /// Config cho adjust
  AdjustConfig _adjustConfig = const AdjustConfig();

  AdjustConfig get adjustConfig => _adjustConfig;

  bool isReduceAd = false;

  bool get enableAllAds {
    if (purchasesManager.isPremium) {
      return false;
    }
    return adsRemoteConfig.showAllAds;
  }

  Future<void> initConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(
          seconds: 5,
        ), // a fetch will wait up to 5 seconds before timing out
        minimumFetchInterval: const Duration(
          seconds: 5,
        ), // fetch parameters will be cached for a maximum of 5 seconds
      ),
    );

    // Set default values for remote config
    await _remoteConfig.setDefaults(
      F.appFlavor == Flavor.dev ? devDefaultValues : prodDefaultValues,
    );
    await _fetchConfig();
    await Future.wait([_loadAdConfig(), _loadAppConfig(), _checkReduceAd()]);
    _loadAdjustConfig();
  }

  Future<void> _loadAdConfig() async {
    try {
      final String rawJson = _remoteConfig.getString('ad_config');
      _adsRemoteConfig = await compute((message) {
        final value = json.decode(message);
        return AdsRemoteConfig.fromJson(value);
      }, rawJson);

      // Load config cho native all
      final nativeAllConfigJson =
          _adsRemoteConfig.adUnitsConfig.nativeAll.extraKeys;
      if (nativeAllConfigJson != null && nativeAllConfigJson.isNotEmpty) {
        NativeAllUtil.instance.config = NativeAllConfig.fromJson(
          nativeAllConfigJson,
        );
      }
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> _loadAppConfig() async {
    try {
      final String rawJson = _remoteConfig.getString('app_config');
      _appConfig = await compute((message) {
        final value = json.decode(message);
        return AppConfigModel.fromJson(value);
      }, rawJson);
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> _loadAdjustConfig() async {
    try {
      final String rawJson = _remoteConfig.getString('adjust_config');
      final value = json.decode(rawJson);
      _adjustConfig = AdjustConfig.fromJson(value);
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> _fetchConfig([bool refresh = false]) async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      if (!refresh) {
        _fetchConfig(true);
      }
    }
  }

  Future<void> _checkReduceAd() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final reduceAdVersion = _remoteConfig.getString('reduce_ad_version');
    isReduceAd = currentVersion == reduceAdVersion;
  }
}
