import 'dart:io';

typedef FullAdCallback = void Function(
  bool isFullAd,
  String? network,
  bool fromCache,
  bool fromLib,
  bool fromApi,
);

abstract class PlatformAdOption {
  PlatformAdOption({
    this.impressionToken,
    this.fullAdCallback,
  });

  final String? impressionToken;
  final FullAdCallback? fullAdCallback;
}

class AndroidAdOptions extends PlatformAdOption {
  AndroidAdOptions({
    super.impressionToken,
    super.fullAdCallback,
  });
}

class IOSAdOptions extends PlatformAdOption {
  IOSAdOptions({
    super.impressionToken,
    super.fullAdCallback,
  });
}

class AdOptions {
  AdOptions({
    this.androidAdOptions,
    this.iosAdOptions,
  });

  final AndroidAdOptions? androidAdOptions;
  final IOSAdOptions? iosAdOptions;

  String? get impressionToken =>
      (Platform.isAndroid ? androidAdOptions : iosAdOptions)?.impressionToken;

  FullAdCallback? get fullAdCallback =>
      (Platform.isAndroid ? androidAdOptions : iosAdOptions)?.fullAdCallback;
}
