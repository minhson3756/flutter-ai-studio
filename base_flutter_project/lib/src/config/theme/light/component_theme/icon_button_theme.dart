part of '../light_theme.dart';

class MyIconButtonTheme extends IconButtonThemeData {
  @override
  ButtonStyle? get style => IconButton.styleFrom(
        foregroundColor: Palette.primary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        iconSize: 24.r,
      );
}
