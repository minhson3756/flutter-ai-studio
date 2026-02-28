import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import 'button/custom_button.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.titleText,
    this.titleWidget,
    this.style,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
    this.leadingWidth,
    this.onBackButtonPressed,
  });

  final Widget? titleWidget;
  final String? titleText;
  final TextStyle? style;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool? centerTitle;
  final double? leadingWidth;
  final VoidCallback? onBackButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: IgnorePointer(
        child:
            titleWidget ??
            Text(
              titleText ?? '',
              style:
                  style ??
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
      ),
      toolbarHeight: 80.h,
      scrolledUnderElevation: 0,
      actions: actions ?? [],
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth ?? 60.w,
      leading: showBackButton
          ? CustomButton(
              padding: const EdgeInsets.symmetric(horizontal: 16).r,
              onTap: onBackButtonPressed ?? getIt<AppRouter>().maybePop,
              child: Icon(Icons.keyboard_arrow_left_rounded, size: 24.r),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
