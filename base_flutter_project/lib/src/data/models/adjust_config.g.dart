// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjust_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdjustConfig _$AdjustConfigFromJson(Map<String, dynamic> json) =>
    _AdjustConfig(
      fullAdsOption: json['fullAdsOption'] == null
          ? const FullAdsOption()
          : FullAdsOption.fromJson(
              json['fullAdsOption'] as Map<String, dynamic>,
            ),
      apiToken: json['apiToken'] as String?,
      appToken: json['appToken'] as String?,
      eventToken: json['eventToken'] as String?,
      event80Token: json['event80Token'] as String?,
    );

Map<String, dynamic> _$AdjustConfigToJson(_AdjustConfig instance) =>
    <String, dynamic>{
      'fullAdsOption': instance.fullAdsOption,
      'apiToken': instance.apiToken,
      'appToken': instance.appToken,
      'eventToken': instance.eventToken,
      'event80Token': instance.event80Token,
    };
