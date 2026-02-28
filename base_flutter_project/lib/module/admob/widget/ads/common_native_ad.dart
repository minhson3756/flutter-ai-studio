import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';

import '../../../../src/config/theme/palette.dart';
import '../../../../src/shared/cubit/ad_visibility_cubit.dart';
import '../../../../src/shared/global.dart';
import '../../model/ad_config/ad_config.dart';
import '../../utils/enum/ad_factory.dart';
import '../../utils/utils.dart';
import '../loading/ad_loading.dart';

class CommonNativeAd extends StatefulWidget {
  const CommonNativeAd({
    super.key,
    this.adConfig,
    this.height = NativeAdSize.medium,
    this.borderRadius,
    this.factoryId,
    this.border,
    this.padding,
    this.margin,
    this.ignoreCubit = false,
    this.hideMaintainSize = false,
    this.placeholderHeight,
    this.backgroundColor,
    this.customOptions,
    this.customLoading,
  }) : controller = null;

  const CommonNativeAd.control({
    super.key,
    this.controller,
    this.height = NativeAdSize.medium,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.ignoreCubit = false,
    this.hideMaintainSize = false,
    this.placeholderHeight,
    this.backgroundColor,
    this.customLoading,
  }) : adConfig = null,
       factoryId = null,
       customOptions = null;

  final AdUnitConfig? adConfig;
  final String? factoryId;
  final NativeAdController? controller;
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
  final Widget? customLoading;

  @override
  State<CommonNativeAd> createState() => _CommonNativeAdState();
}

class _CommonNativeAdState extends State<CommonNativeAd> {
  bool isAdEnabled = false;

  @override
  void initState() {
    if (widget.controller != null) {
      isAdEnabled = true;
    } else {
      isAdEnabled = widget.adConfig?.isEnable ?? false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdEnabled) {
      return SizedBox(height: widget.placeholderHeight);
    }
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.placeholderHeight ?? 0),
      child: IAPBuilder(
        builder: (context, state, isPremium) {
          if (isPremium) {
            return const SizedBox();
          }
          if (widget.ignoreCubit) {
            return buildAd();
          }
          final isShow = context.watch<AdVisibilityCubit>().state;
          return Visibility(
            visible: isAdEnabled && isShow,
            maintainState: true,
            maintainAnimation: widget.hideMaintainSize,
            maintainSize: widget.hideMaintainSize,
            child: buildAd(),
          );
        },
      ),
    );
  }

  Widget buildAd() {
    String? factoryId;
    if (widget.controller == null) {
      factoryId = widget.factoryId ?? AdFactory.homeNativeAd.name;
    }
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Palette.adBackground,
        borderRadius:
            widget.borderRadius ??
            const BorderRadius.vertical(top: Radius.circular(10)),
        border: widget.border ?? Border.all(color: Palette.adBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildNativeAd(factoryId),
    );
  }

  Widget _buildNativeAd(String? factoryId) {
    final loadingWidget = widget.height <= NativeAdSize.medium
        ? CustomMediumAdLoading(height: widget.height)
        : CustomLargeAdLoading(height: widget.height);
    return widget.controller == null
        ? MyNativeAd(
            factoryId: factoryId,
            adId: widget.adConfig!.id,
            adId2: widget.adConfig!.id2,
            adId2RequestPercentage: widget.adConfig!.id2RequestPercentage,
            height: widget.height,
            loadingWidget: widget.customLoading ?? loadingWidget,
            customOptions: widget.customOptions,
          )
        : MyNativeAd.control(
            height: widget.height,
            controller: widget.controller,
            loadingWidget: widget.customLoading ?? loadingWidget,
          );
  }
}
