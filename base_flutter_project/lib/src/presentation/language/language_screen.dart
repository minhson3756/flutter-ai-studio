import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../module/admob/model/ad_config/ad_config.dart';
import '../../../module/admob/utils/native_all_util.dart';
import '../../../module/admob/utils/reload_ad_util.dart';
import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/admob/widget/ads/native_all_ad.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../config/theme/palette.dart';
import '../../gen/assets.gen.dart';
import '../../shared/cubit/language_cubit.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/language.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/number_extension.dart';
import '../../shared/global.dart';
import '../../shared/widgets/button/custom_button.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/custom_radio.dart';
import '../onboarding/utils/intro_ad_util.dart';

part 'widget/body.dart';
part 'widget/item.dart';

@RoutePage()
class LanguageScreen extends StatefulLoggableWidget
    implements AutoRouteWrapper {
  const LanguageScreen({super.key, this.isFirst = false});

  final bool isFirst;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    final Language currentLanguage = context.read<LanguageCubit>().state;
    return BlocProvider(
      create: (context) =>
          ValueCubit<Language?>(isFirst ? null : currentLanguage),
      child: this,
    );
  }
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {
  NativeAdController? nativeAdControllerLanguage;
  NativeAdController? nativeAdControllerLanguageSelect;
  late final ValueNotifier<NativeAdController?> adControllerNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.isFirst) {
      _preloadLanguageAd();
      _initLanguageAd();
      streamLanguageSelectCtrl();
    }
  }

  void _goToNextScreen() {
    final Language? selectedLanguage = context
        .read<ValueCubit<Language?>>()
        .state;
    if (selectedLanguage == null) {
      Fluttertoast.showToast(
        msg: context.l10n.selectLanguageGuide,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    context.read<LanguageCubit>().update(selectedLanguage);
    if (widget.isFirst) {
      context.replaceRoute(const OnBoardingRoute());
      return;
    }

    // trường hợp ở màn language setting
    if (Global.instance.isFullAds) {
      IntroAdUtil.instance.preloadAd1();
      context.router.replaceAll([const OnBoardingRoute()]);
    } else {
      context.router.popUntilRouteWithName(HomeRoute.name);
    }
  }

  void streamLanguageSelectCtrl() {
    if (nativeAdControllerLanguageSelect != null && Global.instance.isFullAds) {
      nativeAdControllerLanguageSelect!.onAdClicked = (ad) {
        _goToNextScreen();
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValueCubit<Language?>, Language?>(
      listenWhen: (previous, current) {
        return previous == null;
      },
      listener: (context, state) {
        if (state != null && widget.isFirst) {
          adControllerNotifier.value = nativeAdControllerLanguageSelect;
          IntroAdUtil.instance.preloadAd1();
        }
      },
      child: Scaffold(
        appBar: CustomAppbar(
          showBackButton: !widget.isFirst,
          titleText: context.l10n.language,
          actions: [_buildAcceptButton()],
        ),
        body: Column(
          children: [
            Expanded(child: _BodyWidget(isFirst: widget.isFirst)),
            _buildAd(),
          ],
        ),
      ),
    );
  }

  Widget _buildAd() {
    return widget.isFirst
        ? ValueListenableBuilder(
            valueListenable: adControllerNotifier,
            builder: (context, value, child) {
              return CommonNativeAd.control(
                key: ValueKey(value?.controllerId),
                height: NativeAdSize.large,
                controller: value,
              );
            },
          )
        : NativeAllAd(
            isAdEnabled: NativeAllUtil.instance.config.nativeLanguageSetting,
          );
  }

  Builder _buildAcceptButton() {
    return Builder(
      builder: (context) {
        final Language? selectedLanguage = context
            .watch<ValueCubit<Language?>>()
            .state;
        if (selectedLanguage == null && widget.isFirst) {
          return const SizedBox();
        }
        return CustomButton(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          onTap: _goToNextScreen,
          child: const Icon(Icons.check, color: Colors.black),
        );
      },
    );
  }

  void _initLanguageAd() {
    if (Global.instance.isFullAds) {
      // Hiển thị ad native được load trước ở splash khi sang màn language
      adControllerNotifier = ValueNotifier<NativeAdController?>(
        ReloadAdUtil.instance.controller,
      );
      // Show native full splash
      Future.delayed(Duration.zero, showNativeFull);
      ReloadAdUtil.instance.controller?.onAdImpression = (_) {
        adControllerNotifier.value = nativeAdControllerLanguage;
      };

      ReloadAdUtil.instance.controller?.onAdFailedToLoad = (_, _) {
        adControllerNotifier.value = nativeAdControllerLanguage;
      };
    } else {
      adControllerNotifier = ValueNotifier<NativeAdController?>(
        nativeAdControllerLanguage,
      );
    }
  }

  void showNativeFull() {
    nativeFullSplashUtil.show(
      onClose: () {
        adControllerNotifier.value = nativeAdControllerLanguage;
      },
    );
  }

  void _preloadLanguageAd() {
    if (adUnitsConfig.nativeLanguage.isEnable) {
      nativeAdControllerLanguage = NativeAdController(
        adId: adUnitsConfig.nativeLanguage.id,
        adId2: adUnitsConfig.nativeLanguage.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativeLanguage.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_language',
      );
      nativeAdControllerLanguage?.load();
    }
    if (adUnitsConfig.nativeLanguageSelect.isEnable) {
      nativeAdControllerLanguageSelect = NativeAdController(
        adId: adUnitsConfig.nativeLanguageSelect.id,
        adId2: adUnitsConfig.nativeLanguageSelect.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativeLanguageSelect.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_language_select',
      );
      nativeAdControllerLanguageSelect?.load();
    }
  }
}
