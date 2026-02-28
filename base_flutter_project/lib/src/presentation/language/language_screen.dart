import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../module/admob/model/ad_config/ad_config.dart';
import '../../../module/admob/utils/native_all_util.dart';
import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/admob/widget/ads/native_all_ad.dart';
import '../../../module/remote_config/remote_config.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../config/theme/palette.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/assets.gen.dart';
import '../../shared/cubit/language_cubit.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/language.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/number_extension.dart';
import '../../shared/helpers/logger_utils.dart';
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
  NativeAdController? nativeLanguageController;
  NativeAdController? nativeLanguageSelectController;
  late final ValueNotifier<NativeAdController?> adControllerNotifier =
      ValueNotifier<NativeAdController?>(nativeLanguageController);
  final shouldShowOnboarding =
      SharedPreferencesManager.instance.shouldShowScreen(
        OnBoardingRoute.name,
      ) ||
      RemoteConfigManager.instance.appConfig.screenFlow.enableSecondIntro;

  final GlobalKey itemKey = GlobalKey();
  final GlobalKey continueKey = GlobalKey();
  Alignment? itemAlignment;
  Alignment? continueAlignment;
  Size screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    if (widget.isFirst) {
      _preloadLanguageAd();
      streamLanguageSelectCtrl();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        screenSize = MediaQuery.of(context).size;
        _calculatePositions();
      });
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
      SharedPreferencesManager.instance.markScreenAsShown(LanguageRoute.name);
      context.replaceRoute(OnBoardingRoute());
    } else {
      context.router.popUntilRoot();
    }
  }

  void streamLanguageSelectCtrl() {
    nativeLanguageSelectController?.onAdClicked = (ad) {
      _goToNextScreen();
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValueCubit<Language?>, Language?>(
      listenWhen: (previous, current) {
        return previous == null;
      },
      listener: (context, state) {
        if (state != null && widget.isFirst) {
          adControllerNotifier.value = nativeLanguageSelectController;
          if (shouldShowOnboarding) {
            IntroAdUtil.instance.preloadAd1();
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppbar(
              showBackButton: !widget.isFirst,
              titleText: context.l10n.language,
              actions: [_buildAcceptButton()],
            ),
            body: Column(
              children: [
                Expanded(
                  child: _BodyWidget(isFirst: widget.isFirst, itemKey: itemKey),
                ),
                _buildAd(),
              ],
            ),
          ),
          BlocBuilder<ValueCubit<Language?>, Language?>(
            builder: (context, state) {
              return AnimatedAlign(
                duration: const Duration(milliseconds: 800),
                alignment: state != null
                    ? continueAlignment ?? Alignment.center
                    : itemAlignment ?? Alignment.bottomCenter,
                child: IgnorePointer(
                  child: SizedBox.square(
                    dimension: 100.r,
                    child: Assets.lottie.tap.lottie(),
                  ),
                ),
              );
            },
          ),
        ],
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

  Widget _buildAcceptButton() {
    return Builder(
      key: continueKey,
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

  void _preloadLanguageAd() {
    if (adUnitsConfig.nativeLanguage.isEnable) {
      nativeLanguageController = NativeAdController(
        adId: adUnitsConfig.nativeLanguage.id,
        adId2: adUnitsConfig.nativeLanguage.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativeLanguage.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_language',
      );
      nativeLanguageController?.load();
    }
    if (adUnitsConfig.nativeLanguageSelect.isEnable) {
      nativeLanguageSelectController = NativeAdController(
        adId: adUnitsConfig.nativeLanguageSelect.id,
        adId2: adUnitsConfig.nativeLanguageSelect.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativeLanguageSelect.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_language_select',
      );
      nativeLanguageSelectController?.load();
    }
  }

  void _calculatePositions() {
    final renderBoxEnglish =
        itemKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBoxButton =
        continueKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBoxEnglish == null || renderBoxButton == null) {
      logger.w('RenderBox for English or Button is null');
      return;
    }

    final Offset englishCenter = renderBoxEnglish.localToGlobal(Offset.zero);
    final Offset buttonCenter = renderBoxButton.localToGlobal(Offset.zero);

    itemAlignment = Alignment(
      englishCenter.dx / (screenSize.width / 2) + 0.5,
      (englishCenter.dy / (screenSize.height / 2)) - 0.95,
    );
    continueAlignment = Alignment(
      (buttonCenter.dx / (screenSize.width / 2)) - .9,
      (buttonCenter.dy / (screenSize.height / 2)) - 1.1,
    );

    setState(() {});
  }
}
