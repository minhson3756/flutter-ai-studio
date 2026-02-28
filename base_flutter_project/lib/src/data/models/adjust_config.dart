import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../module/adjust/model/fullads_option.dart';

part 'adjust_config.freezed.dart';
part 'adjust_config.g.dart';

@freezed
abstract class AdjustConfig with _$AdjustConfig {
  const factory AdjustConfig({
    @Default(FullAdsOption()) FullAdsOption fullAdsOption,
    String? apiToken,
    String? appToken,
    String? eventToken,
    String? event80Token,
  }) = _AdjustConfig;

  factory AdjustConfig.fromJson(Map<String, dynamic> json) =>
      _$AdjustConfigFromJson(json);
}
