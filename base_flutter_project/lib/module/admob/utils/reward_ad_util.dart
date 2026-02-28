import 'dart:async';

import 'package:flutter_ads/ads_flutter.dart';

import '../../../src/config/di/di.dart';
import '../../../src/config/navigation/app_router.dart';
import '../../../src/shared/helpers/my_completer.dart';
import '../model/ad_config/ad_config.dart';

class RewardAdUtil {
  RewardAdUtil._();

  static RewardAdUtil instance = RewardAdUtil._();

  Future<bool> show({required AdUnitConfig adConfig, String? adKey}) async {
    if (!adConfig.isEnable) {
      return true;
    }
    final completer = MyCompleter<bool>();
    bool earnedReward = false;
    MyAds.instance.showRewardAd(
      adKey: adKey,
      getIt<AppRouter>().navigatorKey.currentContext!,
      adId: adConfig.id,
      adId2: adConfig.id2,
      adId2RequestPercentage: adConfig.id2RequestPercentage,
      adDismissed: () {
        completer.complete(earnedReward);
      },
      onUserEarnedReward: () {
        earnedReward = true;
      },
      onFailed: () {
        completer.complete(true);
      },
    );
    return completer.future;
  }
}
