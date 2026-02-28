import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../module/remote_config/remote_config.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/dialog/rate_dialog.dart';
import 'widgets/item_setting.dart';

@RoutePage()
class SettingScreen extends StatefulLoggableWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSharing = false;

  Future<void> _launchUrl(String url) async {
    MyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ');
    }
  }

  Future<void> shareApp(BuildContext context) async {
    if (isSharing) {
      return;
    }
    isSharing = true;
    try {
      final String appLink = Platform.isAndroid
          ? AppConstants.appAndroidUrl
          : AppConstants.appIOSUrl;

      MyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        appLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } finally {
      isSharing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.setting)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32),
          ItemSetting(
            text: context.l10n.language,
            onTap: () => context.pushRoute(LanguageRoute()),
          ),
          Builder(builder: (context) {
            return ItemSetting(
              text: context.l10n.share,
              onTap: () => shareApp(context),
            );
          }),
          ItemSetting(
            text: context.l10n.rateUs,
            onTap: () => showRatingDialog(fromSetting: true),
          ),
          ItemSetting(
            text: context.l10n.policy,
            onTap: () =>
                _launchUrl(RemoteConfigManager.instance.appConfig.urlPolicy),
          ),
        ],
      ),
    );
  }
}
