// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'native_all_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NativeAllConfig {

 bool get nativeLanguageSetting; bool get nativeWifiDevices; bool get nativeIrDevices; bool get nativeSaveRemote; bool get nativeHistory;
/// Create a copy of NativeAllConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NativeAllConfigCopyWith<NativeAllConfig> get copyWith => _$NativeAllConfigCopyWithImpl<NativeAllConfig>(this as NativeAllConfig, _$identity);

  /// Serializes this NativeAllConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NativeAllConfig&&(identical(other.nativeLanguageSetting, nativeLanguageSetting) || other.nativeLanguageSetting == nativeLanguageSetting)&&(identical(other.nativeWifiDevices, nativeWifiDevices) || other.nativeWifiDevices == nativeWifiDevices)&&(identical(other.nativeIrDevices, nativeIrDevices) || other.nativeIrDevices == nativeIrDevices)&&(identical(other.nativeSaveRemote, nativeSaveRemote) || other.nativeSaveRemote == nativeSaveRemote)&&(identical(other.nativeHistory, nativeHistory) || other.nativeHistory == nativeHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nativeLanguageSetting,nativeWifiDevices,nativeIrDevices,nativeSaveRemote,nativeHistory);

@override
String toString() {
  return 'NativeAllConfig(nativeLanguageSetting: $nativeLanguageSetting, nativeWifiDevices: $nativeWifiDevices, nativeIrDevices: $nativeIrDevices, nativeSaveRemote: $nativeSaveRemote, nativeHistory: $nativeHistory)';
}


}

/// @nodoc
abstract mixin class $NativeAllConfigCopyWith<$Res>  {
  factory $NativeAllConfigCopyWith(NativeAllConfig value, $Res Function(NativeAllConfig) _then) = _$NativeAllConfigCopyWithImpl;
@useResult
$Res call({
 bool nativeLanguageSetting, bool nativeWifiDevices, bool nativeIrDevices, bool nativeSaveRemote, bool nativeHistory
});




}
/// @nodoc
class _$NativeAllConfigCopyWithImpl<$Res>
    implements $NativeAllConfigCopyWith<$Res> {
  _$NativeAllConfigCopyWithImpl(this._self, this._then);

  final NativeAllConfig _self;
  final $Res Function(NativeAllConfig) _then;

/// Create a copy of NativeAllConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nativeLanguageSetting = null,Object? nativeWifiDevices = null,Object? nativeIrDevices = null,Object? nativeSaveRemote = null,Object? nativeHistory = null,}) {
  return _then(_self.copyWith(
nativeLanguageSetting: null == nativeLanguageSetting ? _self.nativeLanguageSetting : nativeLanguageSetting // ignore: cast_nullable_to_non_nullable
as bool,nativeWifiDevices: null == nativeWifiDevices ? _self.nativeWifiDevices : nativeWifiDevices // ignore: cast_nullable_to_non_nullable
as bool,nativeIrDevices: null == nativeIrDevices ? _self.nativeIrDevices : nativeIrDevices // ignore: cast_nullable_to_non_nullable
as bool,nativeSaveRemote: null == nativeSaveRemote ? _self.nativeSaveRemote : nativeSaveRemote // ignore: cast_nullable_to_non_nullable
as bool,nativeHistory: null == nativeHistory ? _self.nativeHistory : nativeHistory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NativeAllConfig].
extension NativeAllConfigPatterns on NativeAllConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NativeAllConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NativeAllConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NativeAllConfig value)  $default,){
final _that = this;
switch (_that) {
case _NativeAllConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NativeAllConfig value)?  $default,){
final _that = this;
switch (_that) {
case _NativeAllConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool nativeLanguageSetting,  bool nativeWifiDevices,  bool nativeIrDevices,  bool nativeSaveRemote,  bool nativeHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NativeAllConfig() when $default != null:
return $default(_that.nativeLanguageSetting,_that.nativeWifiDevices,_that.nativeIrDevices,_that.nativeSaveRemote,_that.nativeHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool nativeLanguageSetting,  bool nativeWifiDevices,  bool nativeIrDevices,  bool nativeSaveRemote,  bool nativeHistory)  $default,) {final _that = this;
switch (_that) {
case _NativeAllConfig():
return $default(_that.nativeLanguageSetting,_that.nativeWifiDevices,_that.nativeIrDevices,_that.nativeSaveRemote,_that.nativeHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool nativeLanguageSetting,  bool nativeWifiDevices,  bool nativeIrDevices,  bool nativeSaveRemote,  bool nativeHistory)?  $default,) {final _that = this;
switch (_that) {
case _NativeAllConfig() when $default != null:
return $default(_that.nativeLanguageSetting,_that.nativeWifiDevices,_that.nativeIrDevices,_that.nativeSaveRemote,_that.nativeHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NativeAllConfig implements NativeAllConfig {
  const _NativeAllConfig({this.nativeLanguageSetting = true, this.nativeWifiDevices = true, this.nativeIrDevices = true, this.nativeSaveRemote = true, this.nativeHistory = true});
  factory _NativeAllConfig.fromJson(Map<String, dynamic> json) => _$NativeAllConfigFromJson(json);

@override@JsonKey() final  bool nativeLanguageSetting;
@override@JsonKey() final  bool nativeWifiDevices;
@override@JsonKey() final  bool nativeIrDevices;
@override@JsonKey() final  bool nativeSaveRemote;
@override@JsonKey() final  bool nativeHistory;

/// Create a copy of NativeAllConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NativeAllConfigCopyWith<_NativeAllConfig> get copyWith => __$NativeAllConfigCopyWithImpl<_NativeAllConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NativeAllConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NativeAllConfig&&(identical(other.nativeLanguageSetting, nativeLanguageSetting) || other.nativeLanguageSetting == nativeLanguageSetting)&&(identical(other.nativeWifiDevices, nativeWifiDevices) || other.nativeWifiDevices == nativeWifiDevices)&&(identical(other.nativeIrDevices, nativeIrDevices) || other.nativeIrDevices == nativeIrDevices)&&(identical(other.nativeSaveRemote, nativeSaveRemote) || other.nativeSaveRemote == nativeSaveRemote)&&(identical(other.nativeHistory, nativeHistory) || other.nativeHistory == nativeHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nativeLanguageSetting,nativeWifiDevices,nativeIrDevices,nativeSaveRemote,nativeHistory);

@override
String toString() {
  return 'NativeAllConfig(nativeLanguageSetting: $nativeLanguageSetting, nativeWifiDevices: $nativeWifiDevices, nativeIrDevices: $nativeIrDevices, nativeSaveRemote: $nativeSaveRemote, nativeHistory: $nativeHistory)';
}


}

/// @nodoc
abstract mixin class _$NativeAllConfigCopyWith<$Res> implements $NativeAllConfigCopyWith<$Res> {
  factory _$NativeAllConfigCopyWith(_NativeAllConfig value, $Res Function(_NativeAllConfig) _then) = __$NativeAllConfigCopyWithImpl;
@override @useResult
$Res call({
 bool nativeLanguageSetting, bool nativeWifiDevices, bool nativeIrDevices, bool nativeSaveRemote, bool nativeHistory
});




}
/// @nodoc
class __$NativeAllConfigCopyWithImpl<$Res>
    implements _$NativeAllConfigCopyWith<$Res> {
  __$NativeAllConfigCopyWithImpl(this._self, this._then);

  final _NativeAllConfig _self;
  final $Res Function(_NativeAllConfig) _then;

/// Create a copy of NativeAllConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nativeLanguageSetting = null,Object? nativeWifiDevices = null,Object? nativeIrDevices = null,Object? nativeSaveRemote = null,Object? nativeHistory = null,}) {
  return _then(_NativeAllConfig(
nativeLanguageSetting: null == nativeLanguageSetting ? _self.nativeLanguageSetting : nativeLanguageSetting // ignore: cast_nullable_to_non_nullable
as bool,nativeWifiDevices: null == nativeWifiDevices ? _self.nativeWifiDevices : nativeWifiDevices // ignore: cast_nullable_to_non_nullable
as bool,nativeIrDevices: null == nativeIrDevices ? _self.nativeIrDevices : nativeIrDevices // ignore: cast_nullable_to_non_nullable
as bool,nativeSaveRemote: null == nativeSaveRemote ? _self.nativeSaveRemote : nativeSaveRemote // ignore: cast_nullable_to_non_nullable
as bool,nativeHistory: null == nativeHistory ? _self.nativeHistory : nativeHistory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
