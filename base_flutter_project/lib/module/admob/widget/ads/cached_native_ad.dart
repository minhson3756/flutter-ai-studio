import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';

import '../../../../src/config/theme/palette.dart';
import '../../../../src/shared/cubit/ad_visibility_cubit.dart';
import '../../../../src/shared/global.dart';
import '../../utils/native_ad_util.dart';
import '../../utils/utils.dart';
import '../loading/ad_loading.dart';

class CachedNativeAd extends StatefulWidget {
  const CachedNativeAd({
    super.key,
    this.visible = true,
    this.height = NativeAdSize.medium,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.ignoreCubit = false,
    this.hideMaintainSize = false,
    required this.nativeAdUtil,
    this.backgroundColor,
    this.placeholderHeight,
    this.customOptions,
  });

  final CachedNativeAdUtil nativeAdUtil;
  final bool visible;
  final bool hideMaintainSize;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool ignoreCubit;
  final double? placeholderHeight;
  final Map<String, Object>? customOptions;
  final Color? backgroundColor;

  @override
  State<CachedNativeAd> createState() => _CachedNativeAdState();
}

class _CachedNativeAdState extends State<CachedNativeAd> {
  NativeAdController? controller;
  bool isAdEnabled = false;

  @override
  void initState() {
    controller = widget.nativeAdUtil.getController();
    if (controller != null) {
      isAdEnabled = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdEnabled) {
      return SizedBox(
        height: widget.placeholderHeight,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.placeholderHeight ?? 0,
      ),
      child: IAPBuilder(
        builder: (context, state, isPremium) {
          if (isPremium) {
            return const SizedBox();
          }
          if (widget.ignoreCubit) {
            return buildAd(widget.height);
          }
          final isShow = context.watch<AdVisibilityCubit>().state;
          return Visibility(
            visible: isAdEnabled && isShow,
            maintainState: true,
            maintainAnimation: widget.hideMaintainSize,
            maintainSize: widget.hideMaintainSize,
            child: buildAd(widget.height),
          );
        },
      ),
    );
  }

  Widget buildAd(double height) {
    if (Global.instance.isFullAds) {
      return buildNativeAd(height);
    }
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Palette.adBackground,
        borderRadius: widget.borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
        border: widget.border ?? Border.all(color: Palette.adBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: buildNativeAd(height),
    );
  }

  Widget buildNativeAd(double height) {
    final loadingWidget = widget.height <= NativeAdSize.medium
        ? CustomMediumAdLoading(
            height: widget.height,
          )
        : CustomLargeAdLoading(
            height: widget.height,
          );
    return MyNativeAd.control(
      height: height,
      controller: controller,
      loadingWidget: loadingWidget,
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      widget.nativeAdUtil.disposeController(controller!);
    }
    super.dispose();
  }
}
