// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    _AppConfigModel(
      screenFlow: json['screen_flow'] == null
          ? const ScreenFlow()
          : ScreenFlow.fromJson(json['screen_flow'] as Map<String, dynamic>),
      notificationConfig: json['notification_config'] == null
          ? const NotificationConfig()
          : NotificationConfig.fromJson(
              json['notification_config'] as Map<String, dynamic>,
            ),
      isForceUpdate: json['is_force_update'] as bool? ?? true,
      logNetwork: json['log_network'] as bool? ?? false,
      useInterSplash: json['use_inter_splash'] as bool? ?? true,
      urlPolicy: json['url_policy'] as String? ?? AppConstants.urlPolicy,
    );

Map<String, dynamic> _$AppConfigModelToJson(_AppConfigModel instance) =>
    <String, dynamic>{
      'screen_flow': instance.screenFlow.toJson(),
      'notification_config': instance.notificationConfig.toJson(),
      'is_force_update': instance.isForceUpdate,
      'log_network': instance.logNetwork,
      'use_inter_splash': instance.useInterSplash,
      'url_policy': instance.urlPolicy,
    };

_ScreenFlow _$ScreenFlowFromJson(Map<String, dynamic> json) => _ScreenFlow(
  introType: json['intro_type'] == null
      ? IntroType.nativeFullSwipe
      : const IntroTypeConverter().fromJson(
          (json['intro_type'] as num).toInt(),
        ),
  enableSecondLanguage: json['enable_second_language'] as bool? ?? true,
  enableSecondIntro: json['enable_second_intro'] as bool? ?? true,
);

Map<String, dynamic> _$ScreenFlowToJson(_ScreenFlow instance) =>
    <String, dynamic>{
      'intro_type': const IntroTypeConverter().toJson(instance.introType),
      'enable_second_language': instance.enableSecondLanguage,
      'enable_second_intro': instance.enableSecondIntro,
    };

_NotificationConfig _$NotificationConfigFromJson(
  Map<String, dynamic> json,
) => _NotificationConfig(
  recent: json['recent'] == null
      ? null
      : NotificationItem.fromJson(json['recent'] as Map<String, dynamic>),
  after5min: json['after5min'] == null
      ? null
      : NotificationItem.fromJson(json['after5min'] as Map<String, dynamic>),
  after30min: json['after30min'] == null
      ? null
      : NotificationItem.fromJson(json['after30min'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationConfigToJson(_NotificationConfig instance) =>
    <String, dynamic>{
      'recent': instance.recent?.toJson(),
      'after5min': instance.after5min?.toJson(),
      'after30min': instance.after30min?.toJson(),
    };

_NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    _NotificationItem(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      enableNotification: json['enable_notification'] as bool? ?? false,
      delayInSecond: (json['delay_in_second'] as num?)?.toInt() ?? 0,
      triggerInterval: (json['trigger_interval'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NotificationItemToJson(_NotificationItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'enable_notification': instance.enableNotification,
      'delay_in_second': instance.delayInSecond,
      'trigger_interval': instance.triggerInterval,
    };
