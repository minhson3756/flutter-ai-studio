// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adjust_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdjustConfig implements DiagnosticableTreeMixin {

 FullAdsOption get fullAdsOption; String? get apiToken; String? get appToken; String? get eventToken; String? get event80Token;
/// Create a copy of AdjustConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdjustConfigCopyWith<AdjustConfig> get copyWith => _$AdjustConfigCopyWithImpl<AdjustConfig>(this as AdjustConfig, _$identity);

  /// Serializes this AdjustConfig to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AdjustConfig'))
    ..add(DiagnosticsProperty('fullAdsOption', fullAdsOption))..add(DiagnosticsProperty('apiToken', apiToken))..add(DiagnosticsProperty('appToken', appToken))..add(DiagnosticsProperty('eventToken', eventToken))..add(DiagnosticsProperty('event80Token', event80Token));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdjustConfig&&(identical(other.fullAdsOption, fullAdsOption) || other.fullAdsOption == fullAdsOption)&&(identical(other.apiToken, apiToken) || other.apiToken == apiToken)&&(identical(other.appToken, appToken) || other.appToken == appToken)&&(identical(other.eventToken, eventToken) || other.eventToken == eventToken)&&(identical(other.event80Token, event80Token) || other.event80Token == event80Token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullAdsOption,apiToken,appToken,eventToken,event80Token);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AdjustConfig(fullAdsOption: $fullAdsOption, apiToken: $apiToken, appToken: $appToken, eventToken: $eventToken, event80Token: $event80Token)';
}


}

/// @nodoc
abstract mixin class $AdjustConfigCopyWith<$Res>  {
  factory $AdjustConfigCopyWith(AdjustConfig value, $Res Function(AdjustConfig) _then) = _$AdjustConfigCopyWithImpl;
@useResult
$Res call({
 FullAdsOption fullAdsOption, String? apiToken, String? appToken, String? eventToken, String? event80Token
});




}
/// @nodoc
class _$AdjustConfigCopyWithImpl<$Res>
    implements $AdjustConfigCopyWith<$Res> {
  _$AdjustConfigCopyWithImpl(this._self, this._then);

  final AdjustConfig _self;
  final $Res Function(AdjustConfig) _then;

/// Create a copy of AdjustConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullAdsOption = null,Object? apiToken = freezed,Object? appToken = freezed,Object? eventToken = freezed,Object? event80Token = freezed,}) {
  return _then(_self.copyWith(
fullAdsOption: null == fullAdsOption ? _self.fullAdsOption : fullAdsOption // ignore: cast_nullable_to_non_nullable
as FullAdsOption,apiToken: freezed == apiToken ? _self.apiToken : apiToken // ignore: cast_nullable_to_non_nullable
as String?,appToken: freezed == appToken ? _self.appToken : appToken // ignore: cast_nullable_to_non_nullable
as String?,eventToken: freezed == eventToken ? _self.eventToken : eventToken // ignore: cast_nullable_to_non_nullable
as String?,event80Token: freezed == event80Token ? _self.event80Token : event80Token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdjustConfig].
extension AdjustConfigPatterns on AdjustConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdjustConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdjustConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdjustConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdjustConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdjustConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdjustConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FullAdsOption fullAdsOption,  String? apiToken,  String? appToken,  String? eventToken,  String? event80Token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdjustConfig() when $default != null:
return $default(_that.fullAdsOption,_that.apiToken,_that.appToken,_that.eventToken,_that.event80Token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FullAdsOption fullAdsOption,  String? apiToken,  String? appToken,  String? eventToken,  String? event80Token)  $default,) {final _that = this;
switch (_that) {
case _AdjustConfig():
return $default(_that.fullAdsOption,_that.apiToken,_that.appToken,_that.eventToken,_that.event80Token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FullAdsOption fullAdsOption,  String? apiToken,  String? appToken,  String? eventToken,  String? event80Token)?  $default,) {final _that = this;
switch (_that) {
case _AdjustConfig() when $default != null:
return $default(_that.fullAdsOption,_that.apiToken,_that.appToken,_that.eventToken,_that.event80Token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdjustConfig with DiagnosticableTreeMixin implements AdjustConfig {
  const _AdjustConfig({this.fullAdsOption = const FullAdsOption(), this.apiToken, this.appToken, this.eventToken, this.event80Token});
  factory _AdjustConfig.fromJson(Map<String, dynamic> json) => _$AdjustConfigFromJson(json);

@override@JsonKey() final  FullAdsOption fullAdsOption;
@override final  String? apiToken;
@override final  String? appToken;
@override final  String? eventToken;
@override final  String? event80Token;

/// Create a copy of AdjustConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustConfigCopyWith<_AdjustConfig> get copyWith => __$AdjustConfigCopyWithImpl<_AdjustConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdjustConfigToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AdjustConfig'))
    ..add(DiagnosticsProperty('fullAdsOption', fullAdsOption))..add(DiagnosticsProperty('apiToken', apiToken))..add(DiagnosticsProperty('appToken', appToken))..add(DiagnosticsProperty('eventToken', eventToken))..add(DiagnosticsProperty('event80Token', event80Token));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdjustConfig&&(identical(other.fullAdsOption, fullAdsOption) || other.fullAdsOption == fullAdsOption)&&(identical(other.apiToken, apiToken) || other.apiToken == apiToken)&&(identical(other.appToken, appToken) || other.appToken == appToken)&&(identical(other.eventToken, eventToken) || other.eventToken == eventToken)&&(identical(other.event80Token, event80Token) || other.event80Token == event80Token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullAdsOption,apiToken,appToken,eventToken,event80Token);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AdjustConfig(fullAdsOption: $fullAdsOption, apiToken: $apiToken, appToken: $appToken, eventToken: $eventToken, event80Token: $event80Token)';
}


}

/// @nodoc
abstract mixin class _$AdjustConfigCopyWith<$Res> implements $AdjustConfigCopyWith<$Res> {
  factory _$AdjustConfigCopyWith(_AdjustConfig value, $Res Function(_AdjustConfig) _then) = __$AdjustConfigCopyWithImpl;
@override @useResult
$Res call({
 FullAdsOption fullAdsOption, String? apiToken, String? appToken, String? eventToken, String? event80Token
});




}
/// @nodoc
class __$AdjustConfigCopyWithImpl<$Res>
    implements _$AdjustConfigCopyWith<$Res> {
  __$AdjustConfigCopyWithImpl(this._self, this._then);

  final _AdjustConfig _self;
  final $Res Function(_AdjustConfig) _then;

/// Create a copy of AdjustConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullAdsOption = null,Object? apiToken = freezed,Object? appToken = freezed,Object? eventToken = freezed,Object? event80Token = freezed,}) {
  return _then(_AdjustConfig(
fullAdsOption: null == fullAdsOption ? _self.fullAdsOption : fullAdsOption // ignore: cast_nullable_to_non_nullable
as FullAdsOption,apiToken: freezed == apiToken ? _self.apiToken : apiToken // ignore: cast_nullable_to_non_nullable
as String?,appToken: freezed == appToken ? _self.appToken : appToken // ignore: cast_nullable_to_non_nullable
as String?,eventToken: freezed == eventToken ? _self.eventToken : eventToken // ignore: cast_nullable_to_non_nullable
as String?,event80Token: freezed == event80Token ? _self.event80Token : event80Token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
