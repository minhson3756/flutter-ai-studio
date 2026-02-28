import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';

BuildContext get appContext => getIt<AppRouter>().navigatorKey.currentContext!;

void exitApp() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }
}

void hideNavigationBar() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
}
