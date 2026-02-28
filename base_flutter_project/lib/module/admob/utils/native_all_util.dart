import 'package:flutter_ads/ads_flutter.dart';

import '../../remote_config/remote_config.dart';
import '../model/ad_config/ad_config.dart';
import '../model/native_all_config/native_all_config.dart';
import 'enum/ad_factory.dart';
import 'utils.dart';

class NativeAllUtil {
  NativeAllUtil._();

  static final instance = NativeAllUtil._();

  // Các controller đã được load và đang đợi sử dụng
  final List<NativeAdController> _controllers = [];

  // Các controller đang được sử dụng
  final List<NativeAdController> _usedControllers = [];

  NativeAllConfig config = const NativeAllConfig();

  NativeAdController _createController() {
    final controller = NativeAdController(
      factoryId: AdFactory.homeNativeAd.name,
      adId: adUnitsConfig.nativeAll.id,
      adId2: adUnitsConfig.nativeAll.id2,
      adId2RequestPercentage: adUnitsConfig.nativeAll.id2RequestPercentage,
    );
    controller.load();

    return controller;
  }

  /// Load trước ad
  void preloadAd() {
    if (!adUnitsConfig.nativeAll.isEnable) {
      return;
    }
    // Kiểm tra xem trong danh sách controller có controller nào chưa impression
    // và không bị lỗi
    final hasWaitingController = _controllers.any(
      (element) => !element.isImpression && !element.status.isLoadFailed,
    );
    // Nếu đã có controller chưa impression thì không load nữa
    if (hasWaitingController) {
      return;
    }
    // Khi khong có controller nào chưa impression sẽ tạo 1 controller mới
    final NativeAdController controller = _createController();
    _controllers.add(controller);
    controller.onAdFailedToLoad = (ad, error) {
      _controllers.remove(controller);
    };
  }

  /// Lấy ra 1 controller trong danh sách [_controller] chưa impression
  NativeAdController? getController({bool checkReduceAd = false}) {
    if (checkReduceAd && RemoteConfigManager.instance.isReduceAd) {
      return null;
    }
    if (!adUnitsConfig.nativeAll.isEnable) {
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
      controller = _createController();
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
}
