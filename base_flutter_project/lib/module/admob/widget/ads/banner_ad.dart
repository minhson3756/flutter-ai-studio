import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_iap/flutter_iap.dart';

import '../../model/ad_config/ad_config.dart';
import '../loading/ad_loading.dart';

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({
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
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd>
    with AutoRouteAwareStateMixin {
  bool visible = false;
  BannerAdController? controller;

  @override
  void didPushNext() {
    if (controller?.isCollapsible ?? false) {
      controller?.disposeAd();
    }
    super.didPushNext();
  }

  @override
  void didPopNext() {
    if (controller?.isCollapsible ?? false) {
      controller?.load();
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
  }

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return SizedBox(
        height: widget.maintainSize
            ? (MyAds.instance.bannerAdSize?.height ?? 60).toDouble()
            : 0,
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
    controller?.dispose();
    super.dispose();
  }
}
