import 'dart:io';

import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../global.dart';
import '../../presentation/permission/cubit/cubit.dart';
import '../../service/notification_service.dart';
import '../cubit/ad_visibility_cubit.dart';
import '../cubit/value_cubit.dart';
import 'method_channel/permission_channel.dart';
import 'utils.dart';

class PermissionUtil {
  PermissionUtil._();

  static final instance = PermissionUtil._();

  final photoPermissionCubit = StoragePermissionCubit();
  final cameraPermissionCubit = CameraPermissionCubit();
  final notificationPermissionCubit = NotificationPermissionCubit();

  Future<void> checkAllPermissions() async {
    await Future.wait([
      checkPermission(
        Global.instance.androidSdkVersion > 32
            ? Permission.photos
            : Permission.storage,
      ),
      checkPermission(Permission.camera),
      checkPermission(Permission.notification),
    ]);
  }

  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    final isGranted = status.isLimited || status.isGranted;
    permission.cubit?.update(isGranted);
    return isGranted;
  }

  Future<bool> requestPermission(
    Permission permission, {
    bool openSetting = true,
  }) async {
    // Ẩn ad native
    appContext.read<AdVisibilityCubit>().hide();
    PermissionStatus permissionStatus = PermissionStatus.denied;
    bool isGranted = false;
    final bool isPermanentlyDenied = await permission.isPermanentlyDenied;
    if (isPermanentlyDenied && openSetting) {
      // Mở setting nếu quyền bị từ chối vĩnh viễn
      MyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
      isGranted = await permission.openPermissionSetting();
    } else {
      // Mở popup yêu cầu quyền của hệ thống
      permissionStatus = await permission.request();
      isGranted = permissionStatus.isGranted || permissionStatus.isLimited;
    }
    // Hiện lại ad native
    appContext.read<AdVisibilityCubit>().show();
    permission.cubit?.update(isGranted);
    return isGranted;
  }

  Future<bool> requestPermissionNotificationDefault({
    bool openSetting = false,
  }) async {
    final bool isGranted = await requestPermission(
      Permission.notification,
      openSetting: openSetting,
    );
    if (isGranted) {
      NotificationService.instance.init();
    }
    return isGranted;
  }
}

extension PermissionExtension on Permission {
  ValueCubit? get cubit => switch (this) {
        Permission.photos ||
        Permission.storage =>
          PermissionUtil.instance.photoPermissionCubit,
        Permission.camera => PermissionUtil.instance.cameraPermissionCubit,
        Permission.notification =>
          PermissionUtil.instance.notificationPermissionCubit,
        _ => null,
      };

  Future<bool> openPermissionSetting() async {
    if (Platform.isIOS) {
      openAppSettings();
      return false;
    }
    switch (this) {
      case Permission.photos:
        return PermissionChannel.openPhotoSetting();
      case Permission.storage:
        return PermissionChannel.openStorageSetting();
      case Permission.camera:
        return PermissionChannel.openCameraSetting();
      case Permission.notification:
        return PermissionChannel.openNotificationSetting();
      default:
        return false;
    }
  }
}
