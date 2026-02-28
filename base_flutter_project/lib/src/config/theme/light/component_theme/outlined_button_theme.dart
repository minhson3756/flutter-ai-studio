part of '../light_theme.dart';

class MyOutlinedButtonTheme extends OutlinedButtonThemeData {
  @override
  ButtonStyle? get style => OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Palette.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10).r,
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        foregroundColor: Palette.primary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
}
