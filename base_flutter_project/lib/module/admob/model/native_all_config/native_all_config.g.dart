// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'native_all_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NativeAllConfig _$NativeAllConfigFromJson(Map<String, dynamic> json) =>
    _NativeAllConfig(
      nativeLanguageSetting: json['nativeLanguageSetting'] as bool? ?? true,
      nativeWifiDevices: json['nativeWifiDevices'] as bool? ?? true,
      nativeIrDevices: json['nativeIrDevices'] as bool? ?? true,
      nativeSaveRemote: json['nativeSaveRemote'] as bool? ?? true,
      nativeHistory: json['nativeHistory'] as bool? ?? true,
    );

Map<String, dynamic> _$NativeAllConfigToJson(_NativeAllConfig instance) =>
    <String, dynamic>{
      'nativeLanguageSetting': instance.nativeLanguageSetting,
      'nativeWifiDevices': instance.nativeWifiDevices,
      'nativeIrDevices': instance.nativeIrDevices,
      'nativeSaveRemote': instance.nativeSaveRemote,
      'nativeHistory': instance.nativeHistory,
    };
