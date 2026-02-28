import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../shared/global.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/permission_util.dart';
import '../../shared/widgets/dialog/back_dialog.dart';
import '../../shared/widgets/dialog/notification_permission_dialog.dart';

@RoutePage()
class HomeScreen extends StatefulLoggableWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> requestPermissionNotification() async {
    if (Global.instance.requestedNotificationPermission) {
      return;
    }
    Global.instance.requestedNotificationPermission = true;
    final isGranted = await PermissionUtil.instance.checkPermission(
      Permission.notification,
    );
    if (isGranted) {
      return;
    }
    await NotificationPermissionDialog.show();
  }

  @override
  void initState() {
    super.initState();
    requestPermissionNotification();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        // Udpate Logic
        // showDialogExitApp();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('home'),
          actions: [
            IconButton(
              onPressed: () => context.pushRoute(const SettingRoute()),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text('Home'),
              ),
            ),
            CommonNativeAd(
              adConfig: adUnitsConfig.nativeAll,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDialogExitApp() async {
    if (Global.instance.isFullAds) {
      final result = await showDialog(
        context: context,
        builder: (_) {
          return BackDialog(
            // Update adID
            adConfig: adUnitsConfig.nativeExit,
            subTitle: context.l10n.areYouSureYouWantToExitApp,
            title: context.l10n.exitApp,
          );
        },
      );
      if (result == true) {
        exitApp();
      }
    } else {
      exitApp();
    }
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
}
