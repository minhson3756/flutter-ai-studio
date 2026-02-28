import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';

import '../../../../src/config/theme/palette.dart';
import '../../../../src/shared/cubit/ad_visibility_cubit.dart';
import '../../../../src/shared/global.dart';
import '../../utils/native_all_util.dart';
import '../../utils/utils.dart';
import '../loading/ad_loading.dart';

class NativeAllAd extends StatefulWidget {
  const NativeAllAd({
    super.key,
    this.isAdEnabled = true,
    this.height = NativeAdSize.medium,
    this.borderRadius,
    this.border,
    this.padding,
    this.loadingPadding,
    this.margin,
    this.ignoreCubit = false,
    this.hideMaintainSize = false,
    this.ignoreRouteObserver = false,
    this.fullAdsOnly = false,
    this.placeholderHeight,
  });

  final bool isAdEnabled;
  final bool hideMaintainSize;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? loadingPadding;
  final EdgeInsetsGeometry? margin;
  final bool ignoreCubit;
  final bool ignoreRouteObserver;
  final bool fullAdsOnly;
  final double? placeholderHeight;

  @override
  State<NativeAllAd> createState() => _NativeAllAdState();
}

class _NativeAllAdState extends State<NativeAllAd> with AutoRouteAware {
  NativeAdController? controller;
  late bool isAdEnabled = widget.isAdEnabled;
  AutoRouteObserver? _observer;

  @override
  void initState() {
    super.initState();
    if (isAdEnabled) {
      controller = NativeAllUtil.instance.getController(
        fullAdsOnly: widget.fullAdsOnly,
      );
      isAdEnabled = controller != null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.ignoreRouteObserver) {
      return;
    }
    _observer =
        RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
    if (_observer != null) {
      // we subscribe to the observer by passing our
      // AutoRouteAware state and the scoped routeData
      _observer?.subscribe(this, context.routeData);
    }
  }

  @override
  void didPopNext() {
    controller?.reload();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdEnabled) {
      return SizedBox(
        height: widget.placeholderHeight,
      );
    }
    if (widget.ignoreCubit) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.placeholderHeight ?? 0,
        ),
        child: buildAd(widget.height),
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
          final visible = context.watch<AdVisibilityCubit>().state;
          return Visibility(
            visible: visible,
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
        borderRadius: widget.borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
        border: widget.border,
        color: Palette.adBackground,
      ),
      clipBehavior: Clip.antiAlias,
      child: buildNativeAd(height),
    );
  }

  Widget buildNativeAd(double height) {
    return MyNativeAd.control(
      height: height,
      controller: controller,
      loadingWidget: CustomMediumAdLoading(
        height: widget.height,
        padding: widget.loadingPadding,
      ),
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      NativeAllUtil.instance.disposeController(controller!);
    }
    super.dispose();
    _observer?.unsubscribe(this);
  }
}
