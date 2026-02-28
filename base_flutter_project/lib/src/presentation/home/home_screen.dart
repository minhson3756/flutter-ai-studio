import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../shared/helpers/permission_util.dart';

@RoutePage()
class HomeScreen extends StatefulLoggableWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PermissionUtil.instance.requestPermissionNotificationDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Expanded(child: Center(child: Text('Home'))),
          CommonNativeAd(adConfig: adUnitsConfig.nativeAll),
        ],
      ),
    );
  }
}
