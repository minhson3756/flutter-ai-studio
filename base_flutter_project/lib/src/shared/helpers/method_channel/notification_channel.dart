import 'dart:io';

import 'package:flutter/services.dart';

import '../../../data/models/app_config_model.dart';
import '../logger_utils.dart';

class NotificationChannel {
  NotificationChannel._();

  static const _channel = MethodChannel('com.notification.helper/api');

  static Future<void> enableNotification([bool isEnable = true]) async {
    if (Platform.isIOS) {
      return;
    }
    try {
      _channel.invokeMethod('enableNotification', {'isEnable': isEnable});
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> openNotificationSettings() async {
    if (Platform.isIOS) {
      return;
    }
    try {
      await _channel.invokeMethod('openNotificationSettings');
    } catch (e) {
      logger.e(e);
    }
  }

  /// Đặt nội dung cho thông báo
  static Future<void> setNotificationContent(
    NotificationConfig notificationConfig,
  ) async {
    if (Platform.isIOS) {
      return;
    }
    try {
      if (notificationConfig.recent?.enableNotification ?? false) {
        _channel.invokeMethod(
          'setRecentContent',
          notificationConfig.recent?.toJson(),
        );
      }
      if (notificationConfig.after5min?.enableNotification ?? false) {
        _channel.invokeMethod(
          'setAfter5mContent',
          notificationConfig.after5min?.toJson(),
        );
      }
      if (notificationConfig.after30min?.enableNotification ?? false) {
        _channel.invokeMethod(
          'setAfter30mContent',
          notificationConfig.after30min?.toJson(),
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }

  static void setMethodCallHandler() {
    if (Platform.isIOS) {
      return;
    }
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'openNotify':
          final bool fromSplash = call.arguments['fromSplash'] ?? false;
          if (!fromSplash) {}
          break;
        default:
          break;
      }
    });
  }
}
