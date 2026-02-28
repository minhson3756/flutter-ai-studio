import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/constants/app_constants.dart';
import '../../shared/enum/intro_type.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

@freezed
abstract class AppConfigModel with _$AppConfigModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AppConfigModel({
    @Default(ScreenFlow()) ScreenFlow screenFlow,
    @Default(NotificationConfig()) NotificationConfig notificationConfig,
    @Default(true) bool isForceUpdate,
    @Default(false) bool logNetwork,
    @Default(AppConstants.urlPolicy) String urlPolicy,
  }) = _AppConfigModel;
 
  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);
}

@freezed
abstract class ScreenFlow with _$ScreenFlow {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ScreenFlow({
    @IntroTypeConverter()
    @Default(IntroType.nativeFullSwipe)
    IntroType introType,
    @Default(true) bool enableFirstPermission,
    @Default(true) bool enableInAppPermission,
  }) = _ScreenFlow;

  factory ScreenFlow.fromJson(Map<String, dynamic> json) =>
      _$ScreenFlowFromJson(json);
}

class IntroTypeConverter implements JsonConverter<IntroType, int> {
  const IntroTypeConverter();

  @override
  IntroType fromJson(int json) {
    return IntroType.values.firstWhere(
      (e) => e.index == json,
      orElse: () => IntroType.nativeFullSwipe,
    );
  }

  @override
  int toJson(IntroType object) => object.index;
}

@freezed
abstract class NotificationConfig with _$NotificationConfig {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory NotificationConfig({
    NotificationItem? recent,
    NotificationItem? after5min,
    NotificationItem? after30min,
  }) = _NotificationConfig;

  factory NotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$NotificationConfigFromJson(json);
}

@freezed
abstract class NotificationItem with _$NotificationItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NotificationItem({
    @Default('') String title,
    @Default('') String content,
    @Default(false) bool enableNotification,
    @Default(0) int delayInSecond,
    @Default(0) int triggerInterval,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
