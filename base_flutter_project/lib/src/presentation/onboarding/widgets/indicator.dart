import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/extension/context_extension.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    required this.length,
    required this.currentIndex,
  });

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.r,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            indicator(context, index == currentIndex),
        separatorBuilder: (context, index) => 8.horizontalSpace,
        itemCount: length,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }

  Widget indicator(BuildContext context, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4.r,
      width: isActive ? 32.r : 16.r,
      decoration: BoxDecoration(
        color: isActive
            ? context.colorScheme.primary
            : context.colorScheme.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
