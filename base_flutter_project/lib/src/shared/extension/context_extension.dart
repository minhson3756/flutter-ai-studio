import 'package:flutter/material.dart';

import '../../gen/l18n/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}
