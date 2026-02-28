import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../config/theme/palette.dart';
import '../../../gen/assets.gen.dart';
import '../../constants/app_constants.dart';
import '../../extension/context_extension.dart';
import '../../helpers/permission_util.dart';
import '../custom_switch.dart';

class NotificationPermissionDialog extends StatefulWidget {
  const NotificationPermissionDialog({super.key});

  static Future<bool?> show() {
    return showDialog<bool>(
      context: getIt<AppRouter>().navigatorKey.currentContext!,
      builder: (context) => const NotificationPermissionDialog(),
    );
  }

  @override
  State<NotificationPermissionDialog> createState() =>
      _NotificationPermissionDialogState();
}

class _NotificationPermissionDialogState
    extends State<NotificationPermissionDialog> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: 1,
    upperBound: 1.05,
  )
    ..addListener(
      () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else if (_animationController.isDismissed) {
          _animationController.forward();
        }
      },
    )
    ..forward();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0).r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12).h,
              child: Text(
                context.l10n.allowNotifications,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'description',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffC5C5C5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Center(child: _NotificationImage()),
            32.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animationController.value,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ).w,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          )),
                      onPressed: requestPermission,
                      child: Text(
                        context.l10n.continueText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: context.maybePop,
              child: Text(
                context.l10n.later,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  color: const Color(0xffA6A6A6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    context.maybePop();
    PermissionUtil.instance
        .requestPermissionNotificationDefault(openSetting: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _NotificationImage extends StatelessWidget {
  const _NotificationImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.r,
      width: 266.r,
      child: Stack(
        children: [
          Center(
            child: Assets.images.phone.image(),
          ),
          Positioned(
            top: 45.r,
            left: 40.r,
            right: 40.r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.logo.logo.image(
                  height: 36.r,
                  width: 36.r,
                ),
                16.horizontalSpace,
                Expanded(
                  child: Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40.r,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
                border: Border.all(
                  width: 1.5.r,
                  color: context.colorScheme.primary,
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: Row(
                spacing: 8.r,
                children: [
                  Assets.icons.bell.svg(
                    width: 24.r,
                    colorFilter: const ColorFilter.mode(
                      Palette.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.l10n.notifications,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CustomSwitch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
