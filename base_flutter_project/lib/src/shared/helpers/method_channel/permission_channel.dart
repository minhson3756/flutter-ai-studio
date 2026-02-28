import 'package:flutter/services.dart';

import '../logger_utils.dart';

class PermissionChannel {
  PermissionChannel._();

  static const _channel = MethodChannel('com.app.permission/request');

  static Future<bool> openStorageSetting() async {
    try {
      return await _channel.invokeMethod<bool>('openStorageSetting') ?? false;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<bool> openCameraSetting() async {
    try {
      return await _channel.invokeMethod<bool>('openCameraSetting') ?? false;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<bool> openPhotoSetting() async {
    try {
      return await _channel.invokeMethod<bool>('openPhotoSetting') ?? false;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  static Future<bool> openNotificationSetting() async {
    try {
      return await _channel.invokeMethod<bool>('openNotificationSetting') ??
          false;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }
}
