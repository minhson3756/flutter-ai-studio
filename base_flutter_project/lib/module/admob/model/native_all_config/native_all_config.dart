import 'package:freezed_annotation/freezed_annotation.dart';

part 'native_all_config.freezed.dart';
part 'native_all_config.g.dart';

@freezed
abstract class NativeAllConfig with _$NativeAllConfig {
  const factory NativeAllConfig({
    @Default(true) bool nativeLanguageSetting,
    @Default(true) bool nativeWifiDevices,
    @Default(true) bool nativeIrDevices,
    @Default(true) bool nativeSaveRemote,
    @Default(true) bool nativeHistory,
  }) = _NativeAllConfig;

  factory NativeAllConfig.fromJson(Map<String, dynamic> json) =>
      _$NativeAllConfigFromJson(json);
}
