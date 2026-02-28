import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';

import '../../../../src/config/theme/palette.dart';

class CustomMediumAdLoading extends MediumAdLoading {
  const CustomMediumAdLoading({
    super.key,
    super.height,
    super.padding,
  });

  @override
  Color? get shimmerBaseColor => Palette.primary.withValues(alpha: .05);

  @override
  Color? get shimmerHighlightColor => Palette.primary.withValues(alpha: .2);

  @override
  Color get backgroundColor => Palette.adBackground;
}

class CustomLargeAdLoading extends LargeAdLoading {
  const CustomLargeAdLoading({
    super.key,
    super.height,
    super.padding,
  });

  @override
  Color? get shimmerBaseColor => Palette.primary.withValues(alpha: .05);

  @override
  Color? get shimmerHighlightColor => Palette.primary.withValues(alpha: .2);

  @override
  Color get backgroundColor => Palette.adBackground;
}

class CustomBannerAdLoading extends BannerAdLoading {
  const CustomBannerAdLoading({
    super.key,
    super.height,
  });

  @override
  Color? get shimmerBaseColor => Palette.primary.withValues(alpha: .05);

  @override
  Color? get shimmerHighlightColor => Palette.primary.withValues(alpha: .2);

  @override
  Color get backgroundColor => Palette.adBackground;
}
