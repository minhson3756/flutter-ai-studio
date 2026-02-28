import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/palette.dart';
import '../../../gen/assets.gen.dart';
import '../../extension/context_extension.dart';

class RateSuccessDialog extends Dialog {
  const RateSuccessDialog(this.context, {super.key});

  final BuildContext context;

  @override
  Widget? get child => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.pinkHeart.image(width: 68),
            16.verticalSpace,
            Text(
              context.l10n.thank,
              style: const TextStyle(
                fontSize: 18,
                color: Palette.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
