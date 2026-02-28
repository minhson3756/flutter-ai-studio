import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_iap/flutter_iap.dart';

import '../../../../src/shared/global.dart';
import '../../model/ad_config/ad_config.dart';
import '../../utils/reload_timer_util.dart';
import '../loading/ad_loading.dart';

class AutoReloadBannerAd extends StatefulWidget {
  const AutoReloadBannerAd({
    super.key,
    this.adConfig,
    this.isCollapsible,
    this.controller,
    this.maintainSize = false,
  });

  final AdUnitConfig? adConfig;
  final bool? isCollapsible;
  final BannerAdController? controller;
  final bool maintainSize;

  @override
  State<AutoReloadBannerAd> createState() => _AutoReloadBannerAdState();
}

class _AutoReloadBannerAdState extends State<AutoReloadBannerAd>
    with AutoRouteAware {
  bool visible = false;
  BannerAdController? controller;
  ReloadTimerService? reloadTimerService;

  AppLifecycleListener? appLifecycleListener;
  bool isPaused = false;
  bool isCurrentScreen = false;
  AutoRouteObserver? _observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouterScope exposes the list of provided observers
    // including inherited observers
    _observer =
        RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
    if (_observer != null) {
      // we subscribe to the observer by passing our
      // AutoRouteAware state and the scoped routeData
      _observer?.subscribe(this, context.routeData);
    }
  }

  @override
  void didPushNext() {
    if (controller?.isCollapsible ?? false) {
      isCurrentScreen = false;
      controller?.disposeAd();
      reloadTimerService?.pause();
    }
    super.didPushNext();
  }

  @override
  void didPopNext() {
    if (controller?.isCollapsible ?? false) {
      isCurrentScreen = true;
      controller?.load();
      reloadTimerService?.resume();
    }
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller;
      visible = true;
    } else if (widget.adConfig?.isEnable ?? false) {
      controller = BannerAdController(
        adId: widget.adConfig!.id,
        adId2: widget.adConfig!.id2,
        isCollapsible: widget.isCollapsible ?? false,
        adId2RequestPercentage: widget.adConfig!.id2RequestPercentage,
      );
      controller?.load();
      visible = true;
    }
    autoReload();
  }

  void autoReload() {
    if (!(controller?.isCollapsible ?? false)) {
      return;
    }
    reloadTimerService = ReloadTimerService();
    reloadTimerService?.start(
      // TODO(all): Sửa lại thành giá trị từ remote config
      interval: 15,
      onReset: () {
        if (Global.instance.allowReloadBanner) {
          controller?.reload();
        }
      },
    );
    controller?.stream.listen(
      (event) {
        if (event.isLoading) {
          reloadTimerService?.pause();
        } else if ((event.isImpression || event.isLoadFailed) && !isPaused) {
          reloadTimerService?.reset();
        }
      },
    );
    appLifecycleListener = AppLifecycleListener(
      onStateChange: (value) {
        if (!isCurrentScreen) {
          return;
        }
        if (value == AppLifecycleState.resumed) {
          isPaused = false;
          reloadTimerService?.resume();
        } else if (value == AppLifecycleState.paused) {
          isPaused = true;
          reloadTimerService?.pause();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return SizedBox(
        height: widget.maintainSize ? 60 : 0,
      );
    }
    return IAPBuilder(builder: (context, state, isPremium) {
      if (isPremium) {
        return const SizedBox();
      }
      return MyBannerAd.control(
        controller: controller,
        loadingWidget: CustomBannerAdLoading(
          height: controller?.adSize?.height.toDouble() ?? 60,
        ),
      );
    });
  }

  @override
  void dispose() {
    reloadTimerService?.dispose();
    if (widget.controller == null) {
      controller?.dispose();
    }
    _observer?.unsubscribe(this);
    super.dispose();
  }
}
