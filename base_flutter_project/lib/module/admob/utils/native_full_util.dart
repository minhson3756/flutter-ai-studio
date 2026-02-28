import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../../src/shared/helpers/logger_utils.dart';
import '../../remote_config/remote_config.dart';
import '../widget/ads/full_native_ad.dart';
import 'native_ad_util.dart';

class NativeFullUtil extends CachedNativeAdUtil {
  NativeFullUtil({
    required super.adConfig,
    required super.factoryId,
    super.reloadOnImpression,
    super.checkReduceAd = true,
    super.adKey,
  });

  @override
  bool get visible {
    final displayMode =
        RemoteConfigManager.instance.adsRemoteConfig.nativeFullDisplayMode;

    final random = Random().nextInt(2);
    logger.i('Display mode: $displayMode, random: $random');
    return switch (displayMode) {
      0 => false,
      2 => random == 1, // random 0 hoặc 1, là 1 thì hiển thị quảng cáo
      _ => true,
    };
  }

  Future<void> show({VoidCallback? onClose}) {
    return showFullNativeAd(onClose: onClose, nativeAdUtil: this);
  }
}
