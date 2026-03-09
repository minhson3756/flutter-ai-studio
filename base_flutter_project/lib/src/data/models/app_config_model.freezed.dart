// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfigModel {

 ScreenFlow get screenFlow; NotificationConfig get notificationConfig; bool get isForceUpdate; bool get logNetwork; String get urlPolicy;
/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigModelCopyWith<AppConfigModel> get copyWith => _$AppConfigModelCopyWithImpl<AppConfigModel>(this as AppConfigModel, _$identity);

  /// Serializes this AppConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigModel&&(identical(other.screenFlow, screenFlow) || other.screenFlow == screenFlow)&&(identical(other.notificationConfig, notificationConfig) || other.notificationConfig == notificationConfig)&&(identical(other.isForceUpdate, isForceUpdate) || other.isForceUpdate == isForceUpdate)&&(identical(other.logNetwork, logNetwork) || other.logNetwork == logNetwork)&&(identical(other.urlPolicy, urlPolicy) || other.urlPolicy == urlPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,screenFlow,notificationConfig,isForceUpdate,logNetwork,urlPolicy);

@override
String toString() {
  return 'AppConfigModel(screenFlow: $screenFlow, notificationConfig: $notificationConfig, isForceUpdate: $isForceUpdate, logNetwork: $logNetwork, urlPolicy: $urlPolicy)';
}


}

/// @nodoc
abstract mixin class $AppConfigModelCopyWith<$Res>  {
  factory $AppConfigModelCopyWith(AppConfigModel value, $Res Function(AppConfigModel) _then) = _$AppConfigModelCopyWithImpl;
@useResult
$Res call({
 ScreenFlow screenFlow, NotificationConfig notificationConfig, bool isForceUpdate, bool logNetwork, String urlPolicy
});


$ScreenFlowCopyWith<$Res> get screenFlow;$NotificationConfigCopyWith<$Res> get notificationConfig;

}
/// @nodoc
class _$AppConfigModelCopyWithImpl<$Res>
    implements $AppConfigModelCopyWith<$Res> {
  _$AppConfigModelCopyWithImpl(this._self, this._then);

  final AppConfigModel _self;
  final $Res Function(AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? screenFlow = null,Object? notificationConfig = null,Object? isForceUpdate = null,Object? logNetwork = null,Object? urlPolicy = null,}) {
  return _then(_self.copyWith(
screenFlow: null == screenFlow ? _self.screenFlow : screenFlow // ignore: cast_nullable_to_non_nullable
as ScreenFlow,notificationConfig: null == notificationConfig ? _self.notificationConfig : notificationConfig // ignore: cast_nullable_to_non_nullable
as NotificationConfig,isForceUpdate: null == isForceUpdate ? _self.isForceUpdate : isForceUpdate // ignore: cast_nullable_to_non_nullable
as bool,logNetwork: null == logNetwork ? _self.logNetwork : logNetwork // ignore: cast_nullable_to_non_nullable
as bool,urlPolicy: null == urlPolicy ? _self.urlPolicy : urlPolicy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenFlowCopyWith<$Res> get screenFlow {
  
  return $ScreenFlowCopyWith<$Res>(_self.screenFlow, (value) {
    return _then(_self.copyWith(screenFlow: value));
  });
}/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationConfigCopyWith<$Res> get notificationConfig {
  
  return $NotificationConfigCopyWith<$Res>(_self.notificationConfig, (value) {
    return _then(_self.copyWith(notificationConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppConfigModel].
extension AppConfigModelPatterns on AppConfigModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScreenFlow screenFlow,  NotificationConfig notificationConfig,  bool isForceUpdate,  bool logNetwork,  String urlPolicy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.screenFlow,_that.notificationConfig,_that.isForceUpdate,_that.logNetwork,_that.urlPolicy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScreenFlow screenFlow,  NotificationConfig notificationConfig,  bool isForceUpdate,  bool logNetwork,  String urlPolicy)  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel():
return $default(_that.screenFlow,_that.notificationConfig,_that.isForceUpdate,_that.logNetwork,_that.urlPolicy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScreenFlow screenFlow,  NotificationConfig notificationConfig,  bool isForceUpdate,  bool logNetwork,  String urlPolicy)?  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.screenFlow,_that.notificationConfig,_that.isForceUpdate,_that.logNetwork,_that.urlPolicy);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _AppConfigModel implements AppConfigModel {
  const _AppConfigModel({this.screenFlow = const ScreenFlow(), this.notificationConfig = const NotificationConfig(), this.isForceUpdate = true, this.logNetwork = false, this.urlPolicy = AppConstants.urlPolicy});
  factory _AppConfigModel.fromJson(Map<String, dynamic> json) => _$AppConfigModelFromJson(json);

@override@JsonKey() final  ScreenFlow screenFlow;
@override@JsonKey() final  NotificationConfig notificationConfig;
@override@JsonKey() final  bool isForceUpdate;
@override@JsonKey() final  bool logNetwork;
@override@JsonKey() final  String urlPolicy;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigModelCopyWith<_AppConfigModel> get copyWith => __$AppConfigModelCopyWithImpl<_AppConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfigModel&&(identical(other.screenFlow, screenFlow) || other.screenFlow == screenFlow)&&(identical(other.notificationConfig, notificationConfig) || other.notificationConfig == notificationConfig)&&(identical(other.isForceUpdate, isForceUpdate) || other.isForceUpdate == isForceUpdate)&&(identical(other.logNetwork, logNetwork) || other.logNetwork == logNetwork)&&(identical(other.urlPolicy, urlPolicy) || other.urlPolicy == urlPolicy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,screenFlow,notificationConfig,isForceUpdate,logNetwork,urlPolicy);

@override
String toString() {
  return 'AppConfigModel(screenFlow: $screenFlow, notificationConfig: $notificationConfig, isForceUpdate: $isForceUpdate, logNetwork: $logNetwork, urlPolicy: $urlPolicy)';
}


}

/// @nodoc
abstract mixin class _$AppConfigModelCopyWith<$Res> implements $AppConfigModelCopyWith<$Res> {
  factory _$AppConfigModelCopyWith(_AppConfigModel value, $Res Function(_AppConfigModel) _then) = __$AppConfigModelCopyWithImpl;
@override @useResult
$Res call({
 ScreenFlow screenFlow, NotificationConfig notificationConfig, bool isForceUpdate, bool logNetwork, String urlPolicy
});


@override $ScreenFlowCopyWith<$Res> get screenFlow;@override $NotificationConfigCopyWith<$Res> get notificationConfig;

}
/// @nodoc
class __$AppConfigModelCopyWithImpl<$Res>
    implements _$AppConfigModelCopyWith<$Res> {
  __$AppConfigModelCopyWithImpl(this._self, this._then);

  final _AppConfigModel _self;
  final $Res Function(_AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? screenFlow = null,Object? notificationConfig = null,Object? isForceUpdate = null,Object? logNetwork = null,Object? urlPolicy = null,}) {
  return _then(_AppConfigModel(
screenFlow: null == screenFlow ? _self.screenFlow : screenFlow // ignore: cast_nullable_to_non_nullable
as ScreenFlow,notificationConfig: null == notificationConfig ? _self.notificationConfig : notificationConfig // ignore: cast_nullable_to_non_nullable
as NotificationConfig,isForceUpdate: null == isForceUpdate ? _self.isForceUpdate : isForceUpdate // ignore: cast_nullable_to_non_nullable
as bool,logNetwork: null == logNetwork ? _self.logNetwork : logNetwork // ignore: cast_nullable_to_non_nullable
as bool,urlPolicy: null == urlPolicy ? _self.urlPolicy : urlPolicy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenFlowCopyWith<$Res> get screenFlow {
  
  return $ScreenFlowCopyWith<$Res>(_self.screenFlow, (value) {
    return _then(_self.copyWith(screenFlow: value));
  });
}/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationConfigCopyWith<$Res> get notificationConfig {
  
  return $NotificationConfigCopyWith<$Res>(_self.notificationConfig, (value) {
    return _then(_self.copyWith(notificationConfig: value));
  });
}
}


/// @nodoc
mixin _$ScreenFlow {

@IntroTypeConverter() IntroType get introType; bool get enableFirstPermission; bool get enableInAppPermission;
/// Create a copy of ScreenFlow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenFlowCopyWith<ScreenFlow> get copyWith => _$ScreenFlowCopyWithImpl<ScreenFlow>(this as ScreenFlow, _$identity);

  /// Serializes this ScreenFlow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenFlow&&(identical(other.introType, introType) || other.introType == introType)&&(identical(other.enableFirstPermission, enableFirstPermission) || other.enableFirstPermission == enableFirstPermission)&&(identical(other.enableInAppPermission, enableInAppPermission) || other.enableInAppPermission == enableInAppPermission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,introType,enableFirstPermission,enableInAppPermission);

@override
String toString() {
  return 'ScreenFlow(introType: $introType, enableFirstPermission: $enableFirstPermission, enableInAppPermission: $enableInAppPermission)';
}


}

/// @nodoc
abstract mixin class $ScreenFlowCopyWith<$Res>  {
  factory $ScreenFlowCopyWith(ScreenFlow value, $Res Function(ScreenFlow) _then) = _$ScreenFlowCopyWithImpl;
@useResult
$Res call({
@IntroTypeConverter() IntroType introType, bool enableFirstPermission, bool enableInAppPermission
});




}
/// @nodoc
class _$ScreenFlowCopyWithImpl<$Res>
    implements $ScreenFlowCopyWith<$Res> {
  _$ScreenFlowCopyWithImpl(this._self, this._then);

  final ScreenFlow _self;
  final $Res Function(ScreenFlow) _then;

/// Create a copy of ScreenFlow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? introType = null,Object? enableFirstPermission = null,Object? enableInAppPermission = null,}) {
  return _then(_self.copyWith(
introType: null == introType ? _self.introType : introType // ignore: cast_nullable_to_non_nullable
as IntroType,enableFirstPermission: null == enableFirstPermission ? _self.enableFirstPermission : enableFirstPermission // ignore: cast_nullable_to_non_nullable
as bool,enableInAppPermission: null == enableInAppPermission ? _self.enableInAppPermission : enableInAppPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenFlow].
extension ScreenFlowPatterns on ScreenFlow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenFlow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenFlow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenFlow value)  $default,){
final _that = this;
switch (_that) {
case _ScreenFlow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenFlow value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenFlow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntroTypeConverter()  IntroType introType,  bool enableFirstPermission,  bool enableInAppPermission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenFlow() when $default != null:
return $default(_that.introType,_that.enableFirstPermission,_that.enableInAppPermission);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntroTypeConverter()  IntroType introType,  bool enableFirstPermission,  bool enableInAppPermission)  $default,) {final _that = this;
switch (_that) {
case _ScreenFlow():
return $default(_that.introType,_that.enableFirstPermission,_that.enableInAppPermission);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntroTypeConverter()  IntroType introType,  bool enableFirstPermission,  bool enableInAppPermission)?  $default,) {final _that = this;
switch (_that) {
case _ScreenFlow() when $default != null:
return $default(_that.introType,_that.enableFirstPermission,_that.enableInAppPermission);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ScreenFlow implements ScreenFlow {
  const _ScreenFlow({@IntroTypeConverter() this.introType = IntroType.nativeFullSwipe, this.enableFirstPermission = true, this.enableInAppPermission = true});
  factory _ScreenFlow.fromJson(Map<String, dynamic> json) => _$ScreenFlowFromJson(json);

@override@JsonKey()@IntroTypeConverter() final  IntroType introType;
@override@JsonKey() final  bool enableFirstPermission;
@override@JsonKey() final  bool enableInAppPermission;

/// Create a copy of ScreenFlow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenFlowCopyWith<_ScreenFlow> get copyWith => __$ScreenFlowCopyWithImpl<_ScreenFlow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenFlowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenFlow&&(identical(other.introType, introType) || other.introType == introType)&&(identical(other.enableFirstPermission, enableFirstPermission) || other.enableFirstPermission == enableFirstPermission)&&(identical(other.enableInAppPermission, enableInAppPermission) || other.enableInAppPermission == enableInAppPermission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,introType,enableFirstPermission,enableInAppPermission);

@override
String toString() {
  return 'ScreenFlow(introType: $introType, enableFirstPermission: $enableFirstPermission, enableInAppPermission: $enableInAppPermission)';
}


}

/// @nodoc
abstract mixin class _$ScreenFlowCopyWith<$Res> implements $ScreenFlowCopyWith<$Res> {
  factory _$ScreenFlowCopyWith(_ScreenFlow value, $Res Function(_ScreenFlow) _then) = __$ScreenFlowCopyWithImpl;
@override @useResult
$Res call({
@IntroTypeConverter() IntroType introType, bool enableFirstPermission, bool enableInAppPermission
});




}
/// @nodoc
class __$ScreenFlowCopyWithImpl<$Res>
    implements _$ScreenFlowCopyWith<$Res> {
  __$ScreenFlowCopyWithImpl(this._self, this._then);

  final _ScreenFlow _self;
  final $Res Function(_ScreenFlow) _then;

/// Create a copy of ScreenFlow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? introType = null,Object? enableFirstPermission = null,Object? enableInAppPermission = null,}) {
  return _then(_ScreenFlow(
introType: null == introType ? _self.introType : introType // ignore: cast_nullable_to_non_nullable
as IntroType,enableFirstPermission: null == enableFirstPermission ? _self.enableFirstPermission : enableFirstPermission // ignore: cast_nullable_to_non_nullable
as bool,enableInAppPermission: null == enableInAppPermission ? _self.enableInAppPermission : enableInAppPermission // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NotificationConfig {

 NotificationItem? get recent; NotificationItem? get after5min; NotificationItem? get after30min;
/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationConfigCopyWith<NotificationConfig> get copyWith => _$NotificationConfigCopyWithImpl<NotificationConfig>(this as NotificationConfig, _$identity);

  /// Serializes this NotificationConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationConfig&&(identical(other.recent, recent) || other.recent == recent)&&(identical(other.after5min, after5min) || other.after5min == after5min)&&(identical(other.after30min, after30min) || other.after30min == after30min));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recent,after5min,after30min);

@override
String toString() {
  return 'NotificationConfig(recent: $recent, after5min: $after5min, after30min: $after30min)';
}


}

/// @nodoc
abstract mixin class $NotificationConfigCopyWith<$Res>  {
  factory $NotificationConfigCopyWith(NotificationConfig value, $Res Function(NotificationConfig) _then) = _$NotificationConfigCopyWithImpl;
@useResult
$Res call({
 NotificationItem? recent, NotificationItem? after5min, NotificationItem? after30min
});


$NotificationItemCopyWith<$Res>? get recent;$NotificationItemCopyWith<$Res>? get after5min;$NotificationItemCopyWith<$Res>? get after30min;

}
/// @nodoc
class _$NotificationConfigCopyWithImpl<$Res>
    implements $NotificationConfigCopyWith<$Res> {
  _$NotificationConfigCopyWithImpl(this._self, this._then);

  final NotificationConfig _self;
  final $Res Function(NotificationConfig) _then;

/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recent = freezed,Object? after5min = freezed,Object? after30min = freezed,}) {
  return _then(_self.copyWith(
recent: freezed == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as NotificationItem?,after5min: freezed == after5min ? _self.after5min : after5min // ignore: cast_nullable_to_non_nullable
as NotificationItem?,after30min: freezed == after30min ? _self.after30min : after30min // ignore: cast_nullable_to_non_nullable
as NotificationItem?,
  ));
}
/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get recent {
    if (_self.recent == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.recent!, (value) {
    return _then(_self.copyWith(recent: value));
  });
}/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get after5min {
    if (_self.after5min == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.after5min!, (value) {
    return _then(_self.copyWith(after5min: value));
  });
}/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get after30min {
    if (_self.after30min == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.after30min!, (value) {
    return _then(_self.copyWith(after30min: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationConfig].
extension NotificationConfigPatterns on NotificationConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationConfig value)  $default,){
final _that = this;
switch (_that) {
case _NotificationConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationConfig value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationItem? recent,  NotificationItem? after5min,  NotificationItem? after30min)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationConfig() when $default != null:
return $default(_that.recent,_that.after5min,_that.after30min);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationItem? recent,  NotificationItem? after5min,  NotificationItem? after30min)  $default,) {final _that = this;
switch (_that) {
case _NotificationConfig():
return $default(_that.recent,_that.after5min,_that.after30min);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationItem? recent,  NotificationItem? after5min,  NotificationItem? after30min)?  $default,) {final _that = this;
switch (_that) {
case _NotificationConfig() when $default != null:
return $default(_that.recent,_that.after5min,_that.after30min);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _NotificationConfig implements NotificationConfig {
  const _NotificationConfig({this.recent, this.after5min, this.after30min});
  factory _NotificationConfig.fromJson(Map<String, dynamic> json) => _$NotificationConfigFromJson(json);

@override final  NotificationItem? recent;
@override final  NotificationItem? after5min;
@override final  NotificationItem? after30min;

/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationConfigCopyWith<_NotificationConfig> get copyWith => __$NotificationConfigCopyWithImpl<_NotificationConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationConfig&&(identical(other.recent, recent) || other.recent == recent)&&(identical(other.after5min, after5min) || other.after5min == after5min)&&(identical(other.after30min, after30min) || other.after30min == after30min));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recent,after5min,after30min);

@override
String toString() {
  return 'NotificationConfig(recent: $recent, after5min: $after5min, after30min: $after30min)';
}


}

/// @nodoc
abstract mixin class _$NotificationConfigCopyWith<$Res> implements $NotificationConfigCopyWith<$Res> {
  factory _$NotificationConfigCopyWith(_NotificationConfig value, $Res Function(_NotificationConfig) _then) = __$NotificationConfigCopyWithImpl;
@override @useResult
$Res call({
 NotificationItem? recent, NotificationItem? after5min, NotificationItem? after30min
});


@override $NotificationItemCopyWith<$Res>? get recent;@override $NotificationItemCopyWith<$Res>? get after5min;@override $NotificationItemCopyWith<$Res>? get after30min;

}
/// @nodoc
class __$NotificationConfigCopyWithImpl<$Res>
    implements _$NotificationConfigCopyWith<$Res> {
  __$NotificationConfigCopyWithImpl(this._self, this._then);

  final _NotificationConfig _self;
  final $Res Function(_NotificationConfig) _then;

/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recent = freezed,Object? after5min = freezed,Object? after30min = freezed,}) {
  return _then(_NotificationConfig(
recent: freezed == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as NotificationItem?,after5min: freezed == after5min ? _self.after5min : after5min // ignore: cast_nullable_to_non_nullable
as NotificationItem?,after30min: freezed == after30min ? _self.after30min : after30min // ignore: cast_nullable_to_non_nullable
as NotificationItem?,
  ));
}

/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get recent {
    if (_self.recent == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.recent!, (value) {
    return _then(_self.copyWith(recent: value));
  });
}/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get after5min {
    if (_self.after5min == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.after5min!, (value) {
    return _then(_self.copyWith(after5min: value));
  });
}/// Create a copy of NotificationConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<$Res>? get after30min {
    if (_self.after30min == null) {
    return null;
  }

  return $NotificationItemCopyWith<$Res>(_self.after30min!, (value) {
    return _then(_self.copyWith(after30min: value));
  });
}
}


/// @nodoc
mixin _$NotificationItem {

 String get title; String get content; bool get enableNotification; int get delayInSecond; int get triggerInterval;
/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<NotificationItem> get copyWith => _$NotificationItemCopyWithImpl<NotificationItem>(this as NotificationItem, _$identity);

  /// Serializes this NotificationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItem&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.enableNotification, enableNotification) || other.enableNotification == enableNotification)&&(identical(other.delayInSecond, delayInSecond) || other.delayInSecond == delayInSecond)&&(identical(other.triggerInterval, triggerInterval) || other.triggerInterval == triggerInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,content,enableNotification,delayInSecond,triggerInterval);

@override
String toString() {
  return 'NotificationItem(title: $title, content: $content, enableNotification: $enableNotification, delayInSecond: $delayInSecond, triggerInterval: $triggerInterval)';
}


}

/// @nodoc
abstract mixin class $NotificationItemCopyWith<$Res>  {
  factory $NotificationItemCopyWith(NotificationItem value, $Res Function(NotificationItem) _then) = _$NotificationItemCopyWithImpl;
@useResult
$Res call({
 String title, String content, bool enableNotification, int delayInSecond, int triggerInterval
});




}
/// @nodoc
class _$NotificationItemCopyWithImpl<$Res>
    implements $NotificationItemCopyWith<$Res> {
  _$NotificationItemCopyWithImpl(this._self, this._then);

  final NotificationItem _self;
  final $Res Function(NotificationItem) _then;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,Object? enableNotification = null,Object? delayInSecond = null,Object? triggerInterval = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,enableNotification: null == enableNotification ? _self.enableNotification : enableNotification // ignore: cast_nullable_to_non_nullable
as bool,delayInSecond: null == delayInSecond ? _self.delayInSecond : delayInSecond // ignore: cast_nullable_to_non_nullable
as int,triggerInterval: null == triggerInterval ? _self.triggerInterval : triggerInterval // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationItem].
extension NotificationItemPatterns on NotificationItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationItem value)  $default,){
final _that = this;
switch (_that) {
case _NotificationItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationItem value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content,  bool enableNotification,  int delayInSecond,  int triggerInterval)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that.title,_that.content,_that.enableNotification,_that.delayInSecond,_that.triggerInterval);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content,  bool enableNotification,  int delayInSecond,  int triggerInterval)  $default,) {final _that = this;
switch (_that) {
case _NotificationItem():
return $default(_that.title,_that.content,_that.enableNotification,_that.delayInSecond,_that.triggerInterval);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content,  bool enableNotification,  int delayInSecond,  int triggerInterval)?  $default,) {final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that.title,_that.content,_that.enableNotification,_that.delayInSecond,_that.triggerInterval);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _NotificationItem implements NotificationItem {
  const _NotificationItem({this.title = '', this.content = '', this.enableNotification = false, this.delayInSecond = 0, this.triggerInterval = 0});
  factory _NotificationItem.fromJson(Map<String, dynamic> json) => _$NotificationItemFromJson(json);

@override@JsonKey() final  String title;
@override@JsonKey() final  String content;
@override@JsonKey() final  bool enableNotification;
@override@JsonKey() final  int delayInSecond;
@override@JsonKey() final  int triggerInterval;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationItemCopyWith<_NotificationItem> get copyWith => __$NotificationItemCopyWithImpl<_NotificationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationItem&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.enableNotification, enableNotification) || other.enableNotification == enableNotification)&&(identical(other.delayInSecond, delayInSecond) || other.delayInSecond == delayInSecond)&&(identical(other.triggerInterval, triggerInterval) || other.triggerInterval == triggerInterval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,content,enableNotification,delayInSecond,triggerInterval);

@override
String toString() {
  return 'NotificationItem(title: $title, content: $content, enableNotification: $enableNotification, delayInSecond: $delayInSecond, triggerInterval: $triggerInterval)';
}


}

/// @nodoc
abstract mixin class _$NotificationItemCopyWith<$Res> implements $NotificationItemCopyWith<$Res> {
  factory _$NotificationItemCopyWith(_NotificationItem value, $Res Function(_NotificationItem) _then) = __$NotificationItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String content, bool enableNotification, int delayInSecond, int triggerInterval
});




}
/// @nodoc
class __$NotificationItemCopyWithImpl<$Res>
    implements _$NotificationItemCopyWith<$Res> {
  __$NotificationItemCopyWithImpl(this._self, this._then);

  final _NotificationItem _self;
  final $Res Function(_NotificationItem) _then;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,Object? enableNotification = null,Object? delayInSecond = null,Object? triggerInterval = null,}) {
  return _then(_NotificationItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,enableNotification: null == enableNotification ? _self.enableNotification : enableNotification // ignore: cast_nullable_to_non_nullable
as bool,delayInSecond: null == delayInSecond ? _self.delayInSecond : delayInSecond // ignore: cast_nullable_to_non_nullable
as int,triggerInterval: null == triggerInterval ? _self.triggerInterval : triggerInterval // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
