import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../module/admob/utils/inter_ad_util.dart';
import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../config/theme/palette.dart';
import '../../gen/assets.gen.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/number_extension.dart';
import '../../shared/global.dart';
import '../../shared/widgets/button/custom_button.dart';
import '../../shared/widgets/custom_radio.dart';
import '../../shared/widgets/marquee_text.dart';

part 'widget/item_card.dart';
part 'widget/problem_page.dart';
part 'widget/uninstall_page.dart';

@RoutePage()
class UninstallScreen extends StatefulLoggableWidget {
  const UninstallScreen({super.key});

  @override
  State<UninstallScreen> createState() => _UninstallScreenState();
}

class _UninstallScreenState extends State<UninstallScreen> {
  final pageController = PageController();
  final pageCubit = ValueCubit<int>(0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.replaceRoute(const HomeRoute());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leadingWidth: 56.r,
          leading: CustomButton(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 5.r),
            onTap: () {
              if (pageCubit.state == 0) {
                context.router.maybePop();
              } else {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: SafeArea(
          top: false,
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              pageCubit.update(value);
            },
            children: const [_ProblemPage(), _UninstallPage()],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).w,
          child: BlocBuilder<ValueCubit<int>, int>(
            bloc: pageCubit,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (state == 0) {
                        context.maybePop();
                      } else {
                        FirebaseAnalytics.instance.logEvent(
                          name: 'tap_uninstall_2',
                        );
                        MyAds.instance.appLifecycleReactor?.setIsExcludeScreen(
                          true,
                        );
                        openAppSettings();
                      }
                    },
                    child: Text(
                      switch (state) {
                        0 => context.l10n.dontUninstallYet,
                        _ => context.l10n.stillWantToUninstall,
                      },
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      if (state == 0) {
                        await InterAdUtil.instance.showInterAd(
                          adConfig: adUnitsConfig.interUninstall,
                          forceShow: true,
                          fullAdsOnly: true,
                        );
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        FirebaseAnalytics.instance.logEvent(
                          name: 'tap_uninstall_1',
                        );
                      } else {
                        context.replaceRoute(const HomeRoute());
                      }
                    },
                    child: Text(switch (state) {
                      0 => context.l10n.stillWantToUninstall,
                      _ => context.l10n.cancel,
                    }),
                  ),
                  30.verticalSpace,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
