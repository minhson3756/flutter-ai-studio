import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../src/shared/helpers/logger_utils.dart';
import 'model/ad_option.dart';
import 'model/adjust_event.dart';
import 'model/adjust_token.dart';
import 'model/fullads_option.dart';
import 'model/iap_option.dart';

enum AdjustEnvironment { production, sandbox }

class AdjustUtil {
  AdjustUtil._();

  static final AdjustUtil instance = AdjustUtil._();

  static const MethodChannel _channel = MethodChannel('com.adjust.sdk/api');

  bool isInitialized = false;
  bool _handlerSet = false;
  FullAdCallback? _fullAdCallback; // <- giữ callback hiện tại

  SharedPreferences? _preferences;

  Future<void> initialize({
    required AdjustEnvironment environment,
    required AdjustToken appToken,
    required FullAdsOption fullAdsOption,
    AdOptions? adOptions,
    IapOptions? iapOptions,
    String? apiToken,
  }) async {
    _fullAdCallback = adOptions?.fullAdCallback;

    _preferences = await SharedPreferences.getInstance();
    final isFullAds = _preferences?.getBool('isFullAds');
    if (isFullAds != null) {
      adOptions?.fullAdCallback?.call(isFullAds, null, true, false, false);
    } else {
      _ensureChannelHandler();
    }
    if (isInitialized) {
      logger.w('Adjust SDK is already initialized.');
      return;
    }
    try {
      final token = appToken.platformToken;
      await _channel.invokeMethod('initSdk', {
        'environment': environment.name,
        'appToken': token,
        'apiToken': apiToken,
        'fullAdsOption': fullAdsOption.toJson(),
        'iapOptions': iapOptions?.toJson(),
        'impressionToken': adOptions?.impressionToken,
      });
    } on Exception catch (e) {
      logger.e(e);
    }
    isInitialized = true;
  }

  Future<void> trackAdRevenue({
    required double value,
    required String currencyCode,
  }) async {
    try {
      await _channel.invokeMethod('trackAdRevenue', {
        'value': value,
        'currencyCode': currencyCode,
      });
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> trackImpressionEvent({
    required double value,
    required String currencyCode,
  }) async {
    try {
      await _channel.invokeMethod('trackImpressionEvent', {
        'value': value,
        'currencyCode': currencyCode,
      });
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> trackEvent(AdjustEvent event) async {
    try {
      await _channel.invokeMethod('trackEvent', event.toMap());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> trackSubscriptionRevenue({
    required String productId,
    required double price,
    required String currencyCode,
  }) async {
    try {
      await _channel.invokeMethod('trackSubscriptionRevenue', {
        'productId': productId,
        'price': price,
        'currencyCode': currencyCode,
      });
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> trackTotalIapRevenue({
    required String productId,
    required double price,
    required String currencyCode,
  }) async {
    try {
      await _channel.invokeMethod('trackTotalIapRevenue', {
        'productId': productId,
        'price': price,
        'currencyCode': currencyCode,
      });
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  void _ensureChannelHandler() {
    if (_handlerSet) {
      return;
    }
    _handlerSet = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onFullAdCallback') {
        final params = Map<String, dynamic>.from(call.arguments);
        final isFullAd = params['isFullAds'] as bool?;
        final network = params['network'] as String?;
        final fromCache = params['fromCache'] as bool? ?? false;
        final fromLib = params['fromLib'] as bool? ?? false;
        final fromApi = params['fromApi'] as bool? ?? false;
        if (isFullAd != null) {
          _preferences?.setBool('isFullAds', isFullAd);
          _fullAdCallback?.call(isFullAd, network, fromCache, fromLib, fromApi);
        }
      }
    });
  }
}
