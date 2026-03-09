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
  openOnResume: json['openOnResume'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['openOnResume'] as Map<String, dynamic>),
  interSplash: json['interSplash'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interSplash'] as Map<String, dynamic>),
  bannerAll: json['bannerAll'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['bannerAll'] as Map<String, dynamic>),
  nativeAll: json['nativeAll'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeAll'] as Map<String, dynamic>),
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
  interIntro: json['interIntro'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interIntro'] as Map<String, dynamic>),
  nativePermission: json['nativePermission'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativePermission'] as Map<String, dynamic>),
  nativePermissionStorage: json['nativePermissionStorage'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(
          json['nativePermissionStorage'] as Map<String, dynamic>,
        ),
  nativeFull: json['nativeFull'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeFull'] as Map<String, dynamic>),
  nativeFullSplash: json['nativeFullSplash'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeFullSplash'] as Map<String, dynamic>),
  interSplashUninstall: json['interSplashUninstall'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(
          json['interSplashUninstall'] as Map<String, dynamic>,
        ),
  interUninstall: json['interUninstall'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['interUninstall'] as Map<String, dynamic>),
  nativeUninstall: json['nativeUninstall'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeUninstall'] as Map<String, dynamic>),
  nativeExit: json['nativeExit'] == null
      ? const AdUnitConfig()
      : AdUnitConfig.fromJson(json['nativeExit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdUnitsConfigToJson(_AdUnitsConfig instance) =>
    <String, dynamic>{
      'openOnResume': instance.openOnResume.toJson(),
      'interSplash': instance.interSplash.toJson(),
      'bannerAll': instance.bannerAll.toJson(),
      'nativeAll': instance.nativeAll.toJson(),
      'nativeLanguage': instance.nativeLanguage.toJson(),
      'nativeLanguageSelect': instance.nativeLanguageSelect.toJson(),
      'nativeIntro1': instance.nativeIntro1.toJson(),
      'nativeIntro2': instance.nativeIntro2.toJson(),
      'nativeFullIntro2': instance.nativeFullIntro2.toJson(),
      'nativeIntro3': instance.nativeIntro3.toJson(),
      'nativeFullIntro3': instance.nativeFullIntro3.toJson(),
      'nativeIntro4': instance.nativeIntro4.toJson(),
      'interIntro': instance.interIntro.toJson(),
      'nativePermission': instance.nativePermission.toJson(),
      'nativePermissionStorage': instance.nativePermissionStorage.toJson(),
      'nativeFull': instance.nativeFull.toJson(),
      'nativeFullSplash': instance.nativeFullSplash.toJson(),
      'interSplashUninstall': instance.interSplashUninstall.toJson(),
      'interUninstall': instance.interUninstall.toJson(),
      'nativeUninstall': instance.nativeUninstall.toJson(),
      'nativeExit': instance.nativeExit.toJson(),
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
