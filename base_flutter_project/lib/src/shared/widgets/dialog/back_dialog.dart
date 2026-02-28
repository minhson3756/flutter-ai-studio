import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../module/admob/model/ad_config/ad_config.dart';
import '../../../../module/admob/widget/ads/common_native_ad.dart';
import '../../extension/context_extension.dart';

class BackDialog extends StatelessWidget {
  const BackDialog({
    super.key,
    required this.title,
    this.subTitle,
    this.adConfig,
  });

  final String title;
  final String? subTitle;
  final AdUnitConfig? adConfig;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // update color theo design
      backgroundColor: const Color(0xFF272727),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16.h,
          ),
          Text(
            title,
            // update textStyle theo design
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subTitle != null)
            Text(
              subTitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          SizedBox(
            height: 16.h,
          ),
          CommonNativeAd(
            adConfig: adConfig,
            padding: EdgeInsets.only(bottom: 10.h),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildButton(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                    backgroundColor: const Color(0xFF535353),
                    onTap: () {
                      context.maybePop(true);
                    },
                    title: context.l10n.yes,
                  ),
                ),
                SizedBox(
                  width: 16.h,
                ),
                Expanded(
                  child: _buildButton(
                    backgroundColor: context.colorScheme.primary,
                    title: context.l10n.no,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                    onTap: () {
                      context.maybePop();
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    Function()? onTap,
    required String title,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 33.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ??
              BorderRadius.all(
                Radius.circular(5.r),
              ),
        ),
        child: Text(
          title,
          // update textStyle theo design
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
