import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../remote_config/remote_config.dart';

part 'ad_config.freezed.dart';

part 'ad_config.g.dart';

@freezed
abstract class AdUnitConfig with _$AdUnitConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdUnitConfig({
    @Default('') String id,
    @Default('') String id2,
    @Default(true) bool enable,
    @Default(100) double id2RequestPercentage,
    Map<String, bool>? extraKeys,
  }) = _AdUnitConfig;

  factory AdUnitConfig.fromJson(Map<String, dynamic> json) =>
      _$AdUnitConfigFromJson(json);
}

extension AdUnitConfigExtension on AdUnitConfig {
  bool get isEnable => RemoteConfigManager.instance.enableAllAds && enable;
}

@freezed
abstract class AdUnitsConfig with _$AdUnitsConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdUnitsConfig({
    @Default(AdUnitConfig()) AdUnitConfig openOnResume,
    @Default(AdUnitConfig()) AdUnitConfig interSplash,
    @Default(AdUnitConfig()) AdUnitConfig bannerAll,
    @Default(AdUnitConfig()) AdUnitConfig nativeAll,
    @Default(AdUnitConfig()) AdUnitConfig nativeLanguage,
    @Default(AdUnitConfig()) AdUnitConfig nativeLanguageSelect,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro1,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro2,
    @Default(AdUnitConfig()) AdUnitConfig nativeFullIntro2,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro3,
    @Default(AdUnitConfig()) AdUnitConfig nativeFullIntro3,
    @Default(AdUnitConfig()) AdUnitConfig nativeIntro4,
    @Default(AdUnitConfig()) AdUnitConfig interIntro,
    @Default(AdUnitConfig()) AdUnitConfig nativePermission,
    @Default(AdUnitConfig()) AdUnitConfig nativePermissionStorage,
    @Default(AdUnitConfig()) AdUnitConfig nativeFull,
    @Default(AdUnitConfig()) AdUnitConfig nativeFullSplash,
    @Default(AdUnitConfig()) AdUnitConfig interSplashUninstall,
    @Default(AdUnitConfig()) AdUnitConfig interUninstall,
    @Default(AdUnitConfig()) AdUnitConfig nativeUninstall,
    @Default(AdUnitConfig()) AdUnitConfig nativeExit,
  }) = _AdUnitsConfig;

  factory AdUnitsConfig.fromJson(Map<String, dynamic> json) =>
      _$AdUnitsConfigFromJson(json);
}

@freezed
abstract class AdsRemoteConfig with _$AdsRemoteConfig {
  @JsonSerializable(explicitToJson: true)
  const factory AdsRemoteConfig({
    @Default(AdUnitsConfig()) AdUnitsConfig adUnitsConfig,
    @Default(true) bool showAllAds,
    @Default(true) bool showTopButton,
    @Default(1) int nativeFullDisplayMode,
    @Default(15) int interInterval,
    @Default(0) int id2RequestTimeout,
  }) = _AdsRemoteConfig;

  factory AdsRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$AdsRemoteConfigFromJson(json);
}
