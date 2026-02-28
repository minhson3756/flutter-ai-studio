import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../module/admob/model/ad_config/ad_config.dart';
import '../../../module/admob/utils/utils.dart';
import '../../../module/admob/widget/ads/common_native_ad.dart';
import '../../../module/tracking_screen/loggable_widget.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../shared/global.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/permission_util.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/custom_switch.dart';
import 'cubit/cubit.dart';

part 'widget/permission_body.dart';

@RoutePage()
class PermissionScreen extends StatefulLoggableWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  NativeAdController? controller;
  NativeAdController? storageController;

  @override
  void initState() {
    if (adUnitsConfig.nativePermission.isEnable) {
      controller = NativeAdController(
        adId: adUnitsConfig.nativePermission.id,
        adId2: adUnitsConfig.nativePermission.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativePermission.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_permission',
      );
      controller!.load();
    }

    if (adUnitsConfig.nativePermissionStorage.isEnable) {
      storageController = NativeAdController(
        adId: adUnitsConfig.nativePermissionStorage.id,
        adId2: adUnitsConfig.nativePermissionStorage.id2,
        adId2RequestPercentage:
            adUnitsConfig.nativePermissionStorage.id2RequestPercentage,
        factoryId: largeNativeAdFactory,
        adKey: 'native_permission_storage',
      );
    }
    super.initState();
  }

  void switchAdController(NativeAdController? value) {
    if (value == null) {
      return;
    }
    if (!value.status.isLoading) {
      value.reload();
    }
    setState(() {
      controller = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoragePermissionCubit, bool>(
          listenWhen: (previous, current) => current,
          listener: (context, state) {
            switchAdController(storageController);
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppbar(
          titleText: context.l10n.permission,
        ),
        body: SafeArea(
          child: PermissionBody(
            adController: controller,
          ),
        ),
      ),
    );
  }
}
