// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdUnitConfig _$AdUnitConfigFromJson(Map<String, dynamic> json) =>
    _AdUnitConfig(
      id: json['id'] as String? ?? '',
      id2: json['id2'] as String? ?? '',
      enable: json['enable'] as bool? ?? true,
      id2RequestPercentage:
          (json['id2RequestPercentage'] as num?)?.toDouble() ?? 100,
      extraKeys: (json['extraKeys'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
    );

Map<String, dynamic> _$AdUnitConfigToJson(_AdUnitConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id2': instance.id2,
      'enable': instance.enable,
      'id2RequestPercentage': instance.id2RequestPercentage,
      'extraKeys': instance.extraKeys,
    };

_AdUnitsConfig _$AdUnitsConfigFromJson(
  Map<String, dynamic> json,
) => _AdUnitsConfig(
  openOnResumeSplash: json['openOnResumeSplash'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(
          json['openOnResumeSplash'] as Map<String, dynamic>,
        ),
  interSplash: json['interSplash'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interSplash'] as Map<String, dynamic>),
  openResume: json['openResume'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['openResume'] as Map<String, dynamic>),
  interAll: json['interAll'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interAll'] as Map<String, dynamic>),
  nativeLanguage: json['nativeLanguage'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeLanguage'] as Map<String, dynamic>),
  nativeLanguageSelect: json['nativeLanguageSelect'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(
          json['nativeLanguageSelect'] as Map<String, dynamic>,
        ),
  nativeIntro1: json['nativeIntro1'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeIntro1'] as Map<String, dynamic>),
  nativeIntro2: json['nativeIntro2'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeIntro2'] as Map<String, dynamic>),
  nativeFullIntro2: json['nativeFullIntro2'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeFullIntro2'] as Map<String, dynamic>),
  nativeIntro3: json['nativeIntro3'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeIntro3'] as Map<String, dynamic>),
  nativeFullIntro3: json['nativeFullIntro3'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeFullIntro3'] as Map<String, dynamic>),
  nativeIntro4: json['nativeIntro4'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeIntro4'] as Map<String, dynamic>),
  nativeHome: json['nativeHome'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeHome'] as Map<String, dynamic>),
  interBack: json['interBack'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interBack'] as Map<String, dynamic>),
  interClosePremium: json['interClosePremium'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(
          json['interClosePremium'] as Map<String, dynamic>,
        ),
  interHome: json['interHome'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interHome'] as Map<String, dynamic>),
  interTab: json['interTab'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interTab'] as Map<String, dynamic>),
  nativeAll: json['nativeAll'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeAll'] as Map<String, dynamic>),
  interIntro: json['interIntro'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interIntro'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdUnitsConfigToJson(_AdUnitsConfig instance) =>
    <String, dynamic>{
      'openOnResumeSplash': instance.openOnResumeSplash.toJson(),
      'interSplash': instance.interSplash.toJson(),
      'openResume': instance.openResume.toJson(),
      'interAll': instance.interAll.toJson(),
      'nativeLanguage': instance.nativeLanguage.toJson(),
      'nativeLanguageSelect': instance.nativeLanguageSelect.toJson(),
      'nativeIntro1': instance.nativeIntro1.toJson(),
      'nativeIntro2': instance.nativeIntro2.toJson(),
      'nativeFullIntro2': instance.nativeFullIntro2.toJson(),
      'nativeIntro3': instance.nativeIntro3.toJson(),
      'nativeFullIntro3': instance.nativeFullIntro3.toJson(),
      'nativeIntro4': instance.nativeIntro4.toJson(),
      'nativeHome': instance.nativeHome.toJson(),
      'interBack': instance.interBack.toJson(),
      'interClosePremium': instance.interClosePremium.toJson(),
      'interHome': instance.interHome.toJson(),
      'interTab': instance.interTab.toJson(),
      'nativeAll': instance.nativeAll.toJson(),
      'interIntro': instance.interIntro.toJson(),
    };

_AdsRemoteConfig _$AdsRemoteConfigFromJson(
  Map<String, dynamic> json,
) => _AdsRemoteConfig(
  adUnitsConfig: json['adUnitsConfig'] == null
      ? const AdUnitsConfig()
      : AdUnitsConfig.fromJson(json['adUnitsConfig'] as Map<String, dynamic>),
  showAllAds: json['showAllAds'] as bool? ?? true,
  showTopButton: json['showTopButton'] as bool? ?? true,
  nativeFullDisplayMode: (json['nativeFullDisplayMode'] as num?)?.toInt() ?? 1,
  interInterval: (json['interInterval'] as num?)?.toInt() ?? 15,
  id2RequestTimeout: (json['id2RequestTimeout'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdsRemoteConfigToJson(_AdsRemoteConfig instance) =>
    <String, dynamic>{
      'adUnitsConfig': instance.adUnitsConfig.toJson(),
      'showAllAds': instance.showAllAds,
      'showTopButton': instance.showTopButton,
      'nativeFullDisplayMode': instance.nativeFullDisplayMode,
      'interInterval': instance.interInterval,
      'id2RequestTimeout': instance.id2RequestTimeout,
    };
