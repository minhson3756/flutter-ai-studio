// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:lottie/lottie.dart' as _lottie;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons/bell.svg');

  /// Directory path: assets/icons/rates
  $AssetsIconsRatesGen get rates => const $AssetsIconsRatesGen();

  /// File path: assets/icons/update.svg
  SvgGenImage get update => const SvgGenImage('assets/icons/update.svg');

  /// List of all assets
  List<SvgGenImage> get values => [bell, update];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/languages
  $AssetsImagesLanguagesGen get languages => const $AssetsImagesLanguagesGen();

  /// Directory path: assets/images/logo
  $AssetsImagesLogoGen get logo => const $AssetsImagesLogoGen();

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();

  /// File path: assets/images/phone.png
  AssetGenImage get phone => const AssetGenImage('assets/images/phone.png');

  /// File path: assets/images/pink_heart.png
  AssetGenImage get pinkHeart =>
      const AssetGenImage('assets/images/pink_heart.png');

  /// File path: assets/images/placeholder_image.png
  AssetGenImage get placeholderImage =>
      const AssetGenImage('assets/images/placeholder_image.png');

  /// List of all assets
  List<AssetGenImage> get values => [phone, pinkHeart, placeholderImage];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/slide_left.json
  LottieGenImage get slideLeft =>
      const LottieGenImage('assets/lottie/slide_left.json');

  /// File path: assets/lottie/tap.json
  LottieGenImage get tap => const LottieGenImage('assets/lottie/tap.json');

  /// List of all assets
  List<LottieGenImage> get values => [slideLeft, tap];
}

class $AssetsIconsRatesGen {
  const $AssetsIconsRatesGen();

  /// File path: assets/icons/rates/emotion1.png
  AssetGenImage get emotion1 =>
      const AssetGenImage('assets/icons/rates/emotion1.png');

  /// File path: assets/icons/rates/emotion2.png
  AssetGenImage get emotion2 =>
      const AssetGenImage('assets/icons/rates/emotion2.png');

  /// File path: assets/icons/rates/emotion3.png
  AssetGenImage get emotion3 =>
      const AssetGenImage('assets/icons/rates/emotion3.png');

  /// File path: assets/icons/rates/emotion4.png
  AssetGenImage get emotion4 =>
      const AssetGenImage('assets/icons/rates/emotion4.png');

  /// File path: assets/icons/rates/emotion5.png
  AssetGenImage get emotion5 =>
      const AssetGenImage('assets/icons/rates/emotion5.png');

  /// File path: assets/icons/rates/empty_star.svg
  SvgGenImage get emptyStar =>
      const SvgGenImage('assets/icons/rates/empty_star.svg');

  /// File path: assets/icons/rates/full_star.svg
  SvgGenImage get fullStar =>
      const SvgGenImage('assets/icons/rates/full_star.svg');

  /// List of all assets
  List<dynamic> get values => [
    emotion1,
    emotion2,
    emotion3,
    emotion4,
    emotion5,
    emptyStar,
    fullStar,
  ];
}

class $AssetsImagesLanguagesGen {
  const $AssetsImagesLanguagesGen();

  /// File path: assets/images/languages/en.png
  AssetGenImage get en => const AssetGenImage('assets/images/languages/en.png');

  /// File path: assets/images/languages/es.png
  AssetGenImage get es => const AssetGenImage('assets/images/languages/es.png');

  /// File path: assets/images/languages/fr.png
  AssetGenImage get fr => const AssetGenImage('assets/images/languages/fr.png');

  /// File path: assets/images/languages/hi.png
  AssetGenImage get hi => const AssetGenImage('assets/images/languages/hi.png');

  /// File path: assets/images/languages/pt.png
  AssetGenImage get pt => const AssetGenImage('assets/images/languages/pt.png');

  /// List of all assets
  List<AssetGenImage> get values => [en, es, fr, hi, pt];
}

class $AssetsImagesLogoGen {
  const $AssetsImagesLogoGen();

  /// File path: assets/images/logo/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo/logo.png');

  /// File path: assets/images/logo/rounded_logo.png
  AssetGenImage get roundedLogo =>
      const AssetGenImage('assets/images/logo/rounded_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo, roundedLogo];
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding/onboarding1.png');

  /// File path: assets/images/onboarding/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding/onboarding2.png');

  /// File path: assets/images/onboarding/onboarding3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/images/onboarding/onboarding3.png');

  /// List of all assets
  List<AssetGenImage> get values => [onboarding1, onboarding2, onboarding3];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
