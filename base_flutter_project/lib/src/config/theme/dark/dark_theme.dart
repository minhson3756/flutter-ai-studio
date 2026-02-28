import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../palette.dart';

part 'component_theme/text_theme_dark.dart';

ThemeData darkThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Palette.primary,
  ),
  useMaterial3: true,
  textTheme: MyTextThemeDark(),
);
