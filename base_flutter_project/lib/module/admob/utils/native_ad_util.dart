import 'package:flutter_ads/ads_flutter.dart';

import '../../remote_config/remote_config.dart';
import '../model/ad_config/ad_config.dart';

class CachedNativeAdUtil {
  CachedNativeAdUtil({
    required this.adConfig,
    required this.factoryId,
    this.reloadOnImpression = false,
    this.visible = true,
    this.checkReduceAd = false,
    this.adKey,
  });

  final AdUnitConfig adConfig;

  final String factoryId;
  final bool reloadOnImpression;
  final bool checkReduceAd;
  final bool visible;
  final String? adKey;

  // Các controller đã được load và đang đợi sử dụng
  final List<NativeAdController> _controllers = [];

  // Các controller đang được sử dụng
  final List<NativeAdController> _usedControllers = [];

  bool get isEnableAd {
    if (checkReduceAd && RemoteConfigManager.instance.isReduceAd) {
      return false;
    }
    return adConfig.isEnable && visible;
  }

  /// Load trước ad
  void preloadAd() {
    if (!isEnableAd) {
      return;
    }
    // Kiểm tra xem trong danh sách controller có controller nào chưa impression
    // và không bị lỗi
    final index = _controllers.indexWhere(
      (element) => !element.isImpression && !element.status.isLoadFailed,
    );
    // Nếu đã có controller chưa impression thì không load nữa
    if (index != -1) {
      return;
    }
    // Khi khong có controller nào chưa impression sẽ tạo 1 controller mới
    final NativeAdController controller = createNewController();
    _controllers.add(controller);
  }

  NativeAdController createNewController() {
    final NativeAdController controller = NativeAdController(
      factoryId: factoryId,
      adId: adConfig.id,
      adId2: adConfig.id2,
      adId2RequestPercentage: adConfig.id2RequestPercentage,
      adKey: adKey,
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.portrait,
        adChoicesPlacement: AdChoicesPlacement.bottomRightCorner,
      ),
    );

    if (reloadOnImpression) {
      controller.onAdImpression = (ad) {
        preloadAd();
      };
    }
    controller.load();
    return controller;
  }

  /// Lấy ra 1 controller trong danh sách [_controller] chưa impression
  NativeAdController? getController() {
    if (!isEnableAd) {
      return null;
    }
    // Kiểm tra xem trong danh sách controller có controller nào chưa impression
    // và không bị lỗi
    final index = _controllers.indexWhere(
      (element) => !element.isImpression && !element.status.isLoadFailed,
    );
    NativeAdController controller;
    if (index == -1) {
      // Tạo 1 controller mới nếu chưa có controller nào không impression
      controller = createNewController();
      _usedControllers.add(controller);
    } else {
      // chuyển controller chưa impression vào _usedControllers
      controller = _controllers[index];
      _usedControllers.add(controller);
      _controllers.removeAt(index);
    }
    return controller;
  }

  void disposeController(NativeAdController controller) {
    if (controller.isImpression) {
      // dispose controller và xoá khỏi danh sách nếu như controller đó đã impression
      controller.dispose();
      _usedControllers.remove(controller);
      return;
    }

    // chuyển lại controller về danh sách _controller nếu nó chưa impresssion
    // và không load lỗi
    if (controller.status.isLoadFailed) {
      controller.dispose();
    } else {
      _controllers.add(controller);
    }
    _usedControllers.remove(controller);
  }

  void reloadUsedAd() {
    if (!isEnableAd) {
      return;
    }
    for (var element in _usedControllers) {
      if (element.isImpression) {
        element.reload();
      }
    }
  }
}
