import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../module/admob/utils/utils.dart';
import '../../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/global.dart';
import '../../../shared/widgets/custom_fade_in_image.dart';
import '../onboarding_screen.dart';
import '../utils/onboarding_controller.dart';

class ContentPageWidget extends StatefulWidget {
  const ContentPageWidget({
    super.key,
    required this.image,
    this.fullImage,
    required this.title,
    required this.description,
    required this.pageController,
    this.adController,
    required this.index,
    this.titleStyle,
    this.descriptionStyle,
    this.onInit,
  });

  final AssetGenImage image;
  final AssetGenImage? fullImage;
  final String title;
  final TextStyle? titleStyle;
  final String description;
  final TextStyle? descriptionStyle;
  final PageController pageController;
  final NativeAdController? adController;
  final int index;
  final VoidCallback? onInit;

  @override
  State<ContentPageWidget> createState() => _ContentPageWidgetState();
}

class _ContentPageWidgetState extends State<ContentPageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: CustomFadeInImage(
                  image: widget.image.provider(),
                  fit: BoxFit.cover,
                ),
              ),
              buildDescription(),
              24.verticalSpace,
              PageAction(
                activeIndex: widget.index,
                pageController: widget.pageController,
                onNextTap: () => context
                    .read<OnboardingController>()
                    .pressNextButton(widget.index),
              ),
            ],
          ),
        ),
        _buildAds(),
      ],
    );
  }

  Widget _buildAds() {
    if (widget.adController != null) {
      return CommonNativeAd.control(
        key: ValueKey(widget.adController?.controllerId),
        controller: widget.adController,
        placeholderHeight: 160.h,
        height: NativeAdSize.large,
        margin: const EdgeInsets.only(top: 10).h,
      );
    } else if (Global.instance.isFullAds) {
      return Container(
        height: 140.h,
        alignment: Alignment.center,
        child: Lottie.asset(
          Assets.lottie.slideLeft.path,
          height: 80.h,
        ),
      );
    }
    return 60.verticalSpace;
  }

  Widget buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: widget.titleStyle ??
                TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: widget.descriptionStyle ??
                TextStyle(
                  fontSize: 17.sp,
                ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
