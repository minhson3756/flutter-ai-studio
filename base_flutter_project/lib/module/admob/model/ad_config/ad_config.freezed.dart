// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdUnitConfig {

 String get id; String get id2; bool get enable; double get id2RequestPercentage; Map<String, bool>? get extraKeys;
/// Create a copy of AdUnitConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<AdUnitConfig> get copyWith => _$AdUnitConfigCopyWithImpl<AdUnitConfig>(this as AdUnitConfig, _$identity);

  /// Serializes this AdUnitConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdUnitConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.id2, id2) || other.id2 == id2)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.id2RequestPercentage, id2RequestPercentage) || other.id2RequestPercentage == id2RequestPercentage)&&const DeepCollectionEquality().equals(other.extraKeys, extraKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,id2,enable,id2RequestPercentage,const DeepCollectionEquality().hash(extraKeys));

@override
String toString() {
  return 'AdUnitConfig(id: $id, id2: $id2, enable: $enable, id2RequestPercentage: $id2RequestPercentage, extraKeys: $extraKeys)';
}


}

/// @nodoc
abstract mixin class $AdUnitConfigCopyWith<$Res>  {
  factory $AdUnitConfigCopyWith(AdUnitConfig value, $Res Function(AdUnitConfig) _then) = _$AdUnitConfigCopyWithImpl;
@useResult
$Res call({
 String id, String id2, bool enable, double id2RequestPercentage, Map<String, bool>? extraKeys
});




}
/// @nodoc
class _$AdUnitConfigCopyWithImpl<$Res>
    implements $AdUnitConfigCopyWith<$Res> {
  _$AdUnitConfigCopyWithImpl(this._self, this._then);

  final AdUnitConfig _self;
  final $Res Function(AdUnitConfig) _then;

/// Create a copy of AdUnitConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? id2 = null,Object? enable = null,Object? id2RequestPercentage = null,Object? extraKeys = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,id2: null == id2 ? _self.id2 : id2 // ignore: cast_nullable_to_non_nullable
as String,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,id2RequestPercentage: null == id2RequestPercentage ? _self.id2RequestPercentage : id2RequestPercentage // ignore: cast_nullable_to_non_nullable
as double,extraKeys: freezed == extraKeys ? _self.extraKeys : extraKeys // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdUnitConfig].
extension AdUnitConfigPatterns on AdUnitConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdUnitConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdUnitConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdUnitConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdUnitConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdUnitConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdUnitConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String id2,  bool enable,  double id2RequestPercentage,  Map<String, bool>? extraKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdUnitConfig() when $default != null:
return $default(_that.id,_that.id2,_that.enable,_that.id2RequestPercentage,_that.extraKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String id2,  bool enable,  double id2RequestPercentage,  Map<String, bool>? extraKeys)  $default,) {final _that = this;
switch (_that) {
case _AdUnitConfig():
return $default(_that.id,_that.id2,_that.enable,_that.id2RequestPercentage,_that.extraKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String id2,  bool enable,  double id2RequestPercentage,  Map<String, bool>? extraKeys)?  $default,) {final _that = this;
switch (_that) {
case _AdUnitConfig() when $default != null:
return $default(_that.id,_that.id2,_that.enable,_that.id2RequestPercentage,_that.extraKeys);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AdUnitConfig implements AdUnitConfig {
  const _AdUnitConfig({this.id = '', this.id2 = '', this.enable = true, this.id2RequestPercentage = 100, final  Map<String, bool>? extraKeys}): _extraKeys = extraKeys;
  factory _AdUnitConfig.fromJson(Map<String, dynamic> json) => _$AdUnitConfigFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String id2;
@override@JsonKey() final  bool enable;
@override@JsonKey() final  double id2RequestPercentage;
 final  Map<String, bool>? _extraKeys;
@override Map<String, bool>? get extraKeys {
  final value = _extraKeys;
  if (value == null) return null;
  if (_extraKeys is EqualUnmodifiableMapView) return _extraKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AdUnitConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdUnitConfigCopyWith<_AdUnitConfig> get copyWith => __$AdUnitConfigCopyWithImpl<_AdUnitConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdUnitConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdUnitConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.id2, id2) || other.id2 == id2)&&(identical(other.enable, enable) || other.enable == enable)&&(identical(other.id2RequestPercentage, id2RequestPercentage) || other.id2RequestPercentage == id2RequestPercentage)&&const DeepCollectionEquality().equals(other._extraKeys, _extraKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,id2,enable,id2RequestPercentage,const DeepCollectionEquality().hash(_extraKeys));

@override
String toString() {
  return 'AdUnitConfig(id: $id, id2: $id2, enable: $enable, id2RequestPercentage: $id2RequestPercentage, extraKeys: $extraKeys)';
}


}

/// @nodoc
abstract mixin class _$AdUnitConfigCopyWith<$Res> implements $AdUnitConfigCopyWith<$Res> {
  factory _$AdUnitConfigCopyWith(_AdUnitConfig value, $Res Function(_AdUnitConfig) _then) = __$AdUnitConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String id2, bool enable, double id2RequestPercentage, Map<String, bool>? extraKeys
});




}
/// @nodoc
class __$AdUnitConfigCopyWithImpl<$Res>
    implements _$AdUnitConfigCopyWith<$Res> {
  __$AdUnitConfigCopyWithImpl(this._self, this._then);

  final _AdUnitConfig _self;
  final $Res Function(_AdUnitConfig) _then;

/// Create a copy of AdUnitConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? id2 = null,Object? enable = null,Object? id2RequestPercentage = null,Object? extraKeys = freezed,}) {
  return _then(_AdUnitConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,id2: null == id2 ? _self.id2 : id2 // ignore: cast_nullable_to_non_nullable
as String,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,id2RequestPercentage: null == id2RequestPercentage ? _self.id2RequestPercentage : id2RequestPercentage // ignore: cast_nullable_to_non_nullable
as double,extraKeys: freezed == extraKeys ? _self._extraKeys : extraKeys // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}


}


/// @nodoc
mixin _$AdUnitsConfig {

 AdUnitConfig get openOnResumeSplash; AdUnitConfig get interSplash; AdUnitConfig get openResume; AdUnitConfig get interAll; AdUnitConfig get nativeLanguage; AdUnitConfig get nativeLanguageSelect; AdUnitConfig get nativeIntro1; AdUnitConfig get nativeIntro2; AdUnitConfig get nativeFullIntro2; AdUnitConfig get nativeIntro3; AdUnitConfig get nativeFullIntro3; AdUnitConfig get nativeIntro4; AdUnitConfig get nativeHome; AdUnitConfig get interBack; AdUnitConfig get interClosePremium; AdUnitConfig get interHome; AdUnitConfig get interTab; AdUnitConfig get nativeAll; AdUnitConfig get interIntro;
/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdUnitsConfigCopyWith<AdUnitsConfig> get copyWith => _$AdUnitsConfigCopyWithImpl<AdUnitsConfig>(this as AdUnitsConfig, _$identity);

  /// Serializes this AdUnitsConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdUnitsConfig&&(identical(other.openOnResumeSplash, openOnResumeSplash) || other.openOnResumeSplash == openOnResumeSplash)&&(identical(other.interSplash, interSplash) || other.interSplash == interSplash)&&(identical(other.openResume, openResume) || other.openResume == openResume)&&(identical(other.interAll, interAll) || other.interAll == interAll)&&(identical(other.nativeLanguage, nativeLanguage) || other.nativeLanguage == nativeLanguage)&&(identical(other.nativeLanguageSelect, nativeLanguageSelect) || other.nativeLanguageSelect == nativeLanguageSelect)&&(identical(other.nativeIntro1, nativeIntro1) || other.nativeIntro1 == nativeIntro1)&&(identical(other.nativeIntro2, nativeIntro2) || other.nativeIntro2 == nativeIntro2)&&(identical(other.nativeFullIntro2, nativeFullIntro2) || other.nativeFullIntro2 == nativeFullIntro2)&&(identical(other.nativeIntro3, nativeIntro3) || other.nativeIntro3 == nativeIntro3)&&(identical(other.nativeFullIntro3, nativeFullIntro3) || other.nativeFullIntro3 == nativeFullIntro3)&&(identical(other.nativeIntro4, nativeIntro4) || other.nativeIntro4 == nativeIntro4)&&(identical(other.nativeHome, nativeHome) || other.nativeHome == nativeHome)&&(identical(other.interBack, interBack) || other.interBack == interBack)&&(identical(other.interClosePremium, interClosePremium) || other.interClosePremium == interClosePremium)&&(identical(other.interHome, interHome) || other.interHome == interHome)&&(identical(other.interTab, interTab) || other.interTab == interTab)&&(identical(other.nativeAll, nativeAll) || other.nativeAll == nativeAll)&&(identical(other.interIntro, interIntro) || other.interIntro == interIntro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,openOnResumeSplash,interSplash,openResume,interAll,nativeLanguage,nativeLanguageSelect,nativeIntro1,nativeIntro2,nativeFullIntro2,nativeIntro3,nativeFullIntro3,nativeIntro4,nativeHome,interBack,interClosePremium,interHome,interTab,nativeAll,interIntro]);

@override
String toString() {
  return 'AdUnitsConfig(openOnResumeSplash: $openOnResumeSplash, interSplash: $interSplash, openResume: $openResume, interAll: $interAll, nativeLanguage: $nativeLanguage, nativeLanguageSelect: $nativeLanguageSelect, nativeIntro1: $nativeIntro1, nativeIntro2: $nativeIntro2, nativeFullIntro2: $nativeFullIntro2, nativeIntro3: $nativeIntro3, nativeFullIntro3: $nativeFullIntro3, nativeIntro4: $nativeIntro4, nativeHome: $nativeHome, interBack: $interBack, interClosePremium: $interClosePremium, interHome: $interHome, interTab: $interTab, nativeAll: $nativeAll, interIntro: $interIntro)';
}


}

/// @nodoc
abstract mixin class $AdUnitsConfigCopyWith<$Res>  {
  factory $AdUnitsConfigCopyWith(AdUnitsConfig value, $Res Function(AdUnitsConfig) _then) = _$AdUnitsConfigCopyWithImpl;
@useResult
$Res call({
 AdUnitConfig openOnResumeSplash, AdUnitConfig interSplash, AdUnitConfig openResume, AdUnitConfig interAll, AdUnitConfig nativeLanguage, AdUnitConfig nativeLanguageSelect, AdUnitConfig nativeIntro1, AdUnitConfig nativeIntro2, AdUnitConfig nativeFullIntro2, AdUnitConfig nativeIntro3, AdUnitConfig nativeFullIntro3, AdUnitConfig nativeIntro4, AdUnitConfig nativeHome, AdUnitConfig interBack, AdUnitConfig interClosePremium, AdUnitConfig interHome, AdUnitConfig interTab, AdUnitConfig nativeAll, AdUnitConfig interIntro
});


$AdUnitConfigCopyWith<$Res> get openOnResumeSplash;$AdUnitConfigCopyWith<$Res> get interSplash;$AdUnitConfigCopyWith<$Res> get openResume;$AdUnitConfigCopyWith<$Res> get interAll;$AdUnitConfigCopyWith<$Res> get nativeLanguage;$AdUnitConfigCopyWith<$Res> get nativeLanguageSelect;$AdUnitConfigCopyWith<$Res> get nativeIntro1;$AdUnitConfigCopyWith<$Res> get nativeIntro2;$AdUnitConfigCopyWith<$Res> get nativeFullIntro2;$AdUnitConfigCopyWith<$Res> get nativeIntro3;$AdUnitConfigCopyWith<$Res> get nativeFullIntro3;$AdUnitConfigCopyWith<$Res> get nativeIntro4;$AdUnitConfigCopyWith<$Res> get nativeHome;$AdUnitConfigCopyWith<$Res> get interBack;$AdUnitConfigCopyWith<$Res> get interClosePremium;$AdUnitConfigCopyWith<$Res> get interHome;$AdUnitConfigCopyWith<$Res> get interTab;$AdUnitConfigCopyWith<$Res> get nativeAll;$AdUnitConfigCopyWith<$Res> get interIntro;

}
/// @nodoc
class _$AdUnitsConfigCopyWithImpl<$Res>
    implements $AdUnitsConfigCopyWith<$Res> {
  _$AdUnitsConfigCopyWithImpl(this._self, this._then);

  final AdUnitsConfig _self;
  final $Res Function(AdUnitsConfig) _then;

/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openOnResumeSplash = null,Object? interSplash = null,Object? openResume = null,Object? interAll = null,Object? nativeLanguage = null,Object? nativeLanguageSelect = null,Object? nativeIntro1 = null,Object? nativeIntro2 = null,Object? nativeFullIntro2 = null,Object? nativeIntro3 = null,Object? nativeFullIntro3 = null,Object? nativeIntro4 = null,Object? nativeHome = null,Object? interBack = null,Object? interClosePremium = null,Object? interHome = null,Object? interTab = null,Object? nativeAll = null,Object? interIntro = null,}) {
  return _then(_self.copyWith(
openOnResumeSplash: null == openOnResumeSplash ? _self.openOnResumeSplash : openOnResumeSplash // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interSplash: null == interSplash ? _self.interSplash : interSplash // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,openResume: null == openResume ? _self.openResume : openResume // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interAll: null == interAll ? _self.interAll : interAll // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeLanguage: null == nativeLanguage ? _self.nativeLanguage : nativeLanguage // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeLanguageSelect: null == nativeLanguageSelect ? _self.nativeLanguageSelect : nativeLanguageSelect // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro1: null == nativeIntro1 ? _self.nativeIntro1 : nativeIntro1 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro2: null == nativeIntro2 ? _self.nativeIntro2 : nativeIntro2 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeFullIntro2: null == nativeFullIntro2 ? _self.nativeFullIntro2 : nativeFullIntro2 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro3: null == nativeIntro3 ? _self.nativeIntro3 : nativeIntro3 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeFullIntro3: null == nativeFullIntro3 ? _self.nativeFullIntro3 : nativeFullIntro3 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro4: null == nativeIntro4 ? _self.nativeIntro4 : nativeIntro4 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeHome: null == nativeHome ? _self.nativeHome : nativeHome // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interBack: null == interBack ? _self.interBack : interBack // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interClosePremium: null == interClosePremium ? _self.interClosePremium : interClosePremium // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interHome: null == interHome ? _self.interHome : interHome // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interTab: null == interTab ? _self.interTab : interTab // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeAll: null == nativeAll ? _self.nativeAll : nativeAll // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interIntro: null == interIntro ? _self.interIntro : interIntro // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,
  ));
}
/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get openOnResumeSplash {
  
  return $AdUnitConfigCopyWith<$Res>(_self.openOnResumeSplash, (value) {
    return _then(_self.copyWith(openOnResumeSplash: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interSplash {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interSplash, (value) {
    return _then(_self.copyWith(interSplash: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get openResume {
  
  return $AdUnitConfigCopyWith<$Res>(_self.openResume, (value) {
    return _then(_self.copyWith(openResume: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interAll {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interAll, (value) {
    return _then(_self.copyWith(interAll: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeLanguage {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeLanguage, (value) {
    return _then(_self.copyWith(nativeLanguage: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeLanguageSelect {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeLanguageSelect, (value) {
    return _then(_self.copyWith(nativeLanguageSelect: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro1 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro1, (value) {
    return _then(_self.copyWith(nativeIntro1: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro2 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro2, (value) {
    return _then(_self.copyWith(nativeIntro2: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeFullIntro2 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeFullIntro2, (value) {
    return _then(_self.copyWith(nativeFullIntro2: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro3 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro3, (value) {
    return _then(_self.copyWith(nativeIntro3: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeFullIntro3 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeFullIntro3, (value) {
    return _then(_self.copyWith(nativeFullIntro3: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro4 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro4, (value) {
    return _then(_self.copyWith(nativeIntro4: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeHome {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeHome, (value) {
    return _then(_self.copyWith(nativeHome: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interBack {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interBack, (value) {
    return _then(_self.copyWith(interBack: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interClosePremium {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interClosePremium, (value) {
    return _then(_self.copyWith(interClosePremium: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interHome {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interHome, (value) {
    return _then(_self.copyWith(interHome: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interTab {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interTab, (value) {
    return _then(_self.copyWith(interTab: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeAll {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeAll, (value) {
    return _then(_self.copyWith(nativeAll: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interIntro {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interIntro, (value) {
    return _then(_self.copyWith(interIntro: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdUnitsConfig].
extension AdUnitsConfigPatterns on AdUnitsConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdUnitsConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdUnitsConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdUnitsConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdUnitsConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdUnitsConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdUnitsConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdUnitConfig openOnResumeSplash,  AdUnitConfig interSplash,  AdUnitConfig openResume,  AdUnitConfig interAll,  AdUnitConfig nativeLanguage,  AdUnitConfig nativeLanguageSelect,  AdUnitConfig nativeIntro1,  AdUnitConfig nativeIntro2,  AdUnitConfig nativeFullIntro2,  AdUnitConfig nativeIntro3,  AdUnitConfig nativeFullIntro3,  AdUnitConfig nativeIntro4,  AdUnitConfig nativeHome,  AdUnitConfig interBack,  AdUnitConfig interClosePremium,  AdUnitConfig interHome,  AdUnitConfig interTab,  AdUnitConfig nativeAll,  AdUnitConfig interIntro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdUnitsConfig() when $default != null:
return $default(_that.openOnResumeSplash,_that.interSplash,_that.openResume,_that.interAll,_that.nativeLanguage,_that.nativeLanguageSelect,_that.nativeIntro1,_that.nativeIntro2,_that.nativeFullIntro2,_that.nativeIntro3,_that.nativeFullIntro3,_that.nativeIntro4,_that.nativeHome,_that.interBack,_that.interClosePremium,_that.interHome,_that.interTab,_that.nativeAll,_that.interIntro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdUnitConfig openOnResumeSplash,  AdUnitConfig interSplash,  AdUnitConfig openResume,  AdUnitConfig interAll,  AdUnitConfig nativeLanguage,  AdUnitConfig nativeLanguageSelect,  AdUnitConfig nativeIntro1,  AdUnitConfig nativeIntro2,  AdUnitConfig nativeFullIntro2,  AdUnitConfig nativeIntro3,  AdUnitConfig nativeFullIntro3,  AdUnitConfig nativeIntro4,  AdUnitConfig nativeHome,  AdUnitConfig interBack,  AdUnitConfig interClosePremium,  AdUnitConfig interHome,  AdUnitConfig interTab,  AdUnitConfig nativeAll,  AdUnitConfig interIntro)  $default,) {final _that = this;
switch (_that) {
case _AdUnitsConfig():
return $default(_that.openOnResumeSplash,_that.interSplash,_that.openResume,_that.interAll,_that.nativeLanguage,_that.nativeLanguageSelect,_that.nativeIntro1,_that.nativeIntro2,_that.nativeFullIntro2,_that.nativeIntro3,_that.nativeFullIntro3,_that.nativeIntro4,_that.nativeHome,_that.interBack,_that.interClosePremium,_that.interHome,_that.interTab,_that.nativeAll,_that.interIntro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdUnitConfig openOnResumeSplash,  AdUnitConfig interSplash,  AdUnitConfig openResume,  AdUnitConfig interAll,  AdUnitConfig nativeLanguage,  AdUnitConfig nativeLanguageSelect,  AdUnitConfig nativeIntro1,  AdUnitConfig nativeIntro2,  AdUnitConfig nativeFullIntro2,  AdUnitConfig nativeIntro3,  AdUnitConfig nativeFullIntro3,  AdUnitConfig nativeIntro4,  AdUnitConfig nativeHome,  AdUnitConfig interBack,  AdUnitConfig interClosePremium,  AdUnitConfig interHome,  AdUnitConfig interTab,  AdUnitConfig nativeAll,  AdUnitConfig interIntro)?  $default,) {final _that = this;
switch (_that) {
case _AdUnitsConfig() when $default != null:
return $default(_that.openOnResumeSplash,_that.interSplash,_that.openResume,_that.interAll,_that.nativeLanguage,_that.nativeLanguageSelect,_that.nativeIntro1,_that.nativeIntro2,_that.nativeFullIntro2,_that.nativeIntro3,_that.nativeFullIntro3,_that.nativeIntro4,_that.nativeHome,_that.interBack,_that.interClosePremium,_that.interHome,_that.interTab,_that.nativeAll,_that.interIntro);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AdUnitsConfig implements AdUnitsConfig {
  const _AdUnitsConfig({this.openOnResumeSplash = const AdUnitConfig(), this.interSplash = const AdUnitConfig(), this.openResume = const AdUnitConfig(), this.interAll = const AdUnitConfig(), this.nativeLanguage = const AdUnitConfig(), this.nativeLanguageSelect = const AdUnitConfig(), this.nativeIntro1 = const AdUnitConfig(), this.nativeIntro2 = const AdUnitConfig(), this.nativeFullIntro2 = const AdUnitConfig(), this.nativeIntro3 = const AdUnitConfig(), this.nativeFullIntro3 = const AdUnitConfig(), this.nativeIntro4 = const AdUnitConfig(), this.nativeHome = const AdUnitConfig(), this.interBack = const AdUnitConfig(), this.interClosePremium = const AdUnitConfig(), this.interHome = const AdUnitConfig(), this.interTab = const AdUnitConfig(), this.nativeAll = const AdUnitConfig(), this.interIntro = const AdUnitConfig()});
  factory _AdUnitsConfig.fromJson(Map<String, dynamic> json) => _$AdUnitsConfigFromJson(json);

@override@JsonKey() final  AdUnitConfig openOnResumeSplash;
@override@JsonKey() final  AdUnitConfig interSplash;
@override@JsonKey() final  AdUnitConfig openResume;
@override@JsonKey() final  AdUnitConfig interAll;
@override@JsonKey() final  AdUnitConfig nativeLanguage;
@override@JsonKey() final  AdUnitConfig nativeLanguageSelect;
@override@JsonKey() final  AdUnitConfig nativeIntro1;
@override@JsonKey() final  AdUnitConfig nativeIntro2;
@override@JsonKey() final  AdUnitConfig nativeFullIntro2;
@override@JsonKey() final  AdUnitConfig nativeIntro3;
@override@JsonKey() final  AdUnitConfig nativeFullIntro3;
@override@JsonKey() final  AdUnitConfig nativeIntro4;
@override@JsonKey() final  AdUnitConfig nativeHome;
@override@JsonKey() final  AdUnitConfig interBack;
@override@JsonKey() final  AdUnitConfig interClosePremium;
@override@JsonKey() final  AdUnitConfig interHome;
@override@JsonKey() final  AdUnitConfig interTab;
@override@JsonKey() final  AdUnitConfig nativeAll;
@override@JsonKey() final  AdUnitConfig interIntro;

/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdUnitsConfigCopyWith<_AdUnitsConfig> get copyWith => __$AdUnitsConfigCopyWithImpl<_AdUnitsConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdUnitsConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdUnitsConfig&&(identical(other.openOnResumeSplash, openOnResumeSplash) || other.openOnResumeSplash == openOnResumeSplash)&&(identical(other.interSplash, interSplash) || other.interSplash == interSplash)&&(identical(other.openResume, openResume) || other.openResume == openResume)&&(identical(other.interAll, interAll) || other.interAll == interAll)&&(identical(other.nativeLanguage, nativeLanguage) || other.nativeLanguage == nativeLanguage)&&(identical(other.nativeLanguageSelect, nativeLanguageSelect) || other.nativeLanguageSelect == nativeLanguageSelect)&&(identical(other.nativeIntro1, nativeIntro1) || other.nativeIntro1 == nativeIntro1)&&(identical(other.nativeIntro2, nativeIntro2) || other.nativeIntro2 == nativeIntro2)&&(identical(other.nativeFullIntro2, nativeFullIntro2) || other.nativeFullIntro2 == nativeFullIntro2)&&(identical(other.nativeIntro3, nativeIntro3) || other.nativeIntro3 == nativeIntro3)&&(identical(other.nativeFullIntro3, nativeFullIntro3) || other.nativeFullIntro3 == nativeFullIntro3)&&(identical(other.nativeIntro4, nativeIntro4) || other.nativeIntro4 == nativeIntro4)&&(identical(other.nativeHome, nativeHome) || other.nativeHome == nativeHome)&&(identical(other.interBack, interBack) || other.interBack == interBack)&&(identical(other.interClosePremium, interClosePremium) || other.interClosePremium == interClosePremium)&&(identical(other.interHome, interHome) || other.interHome == interHome)&&(identical(other.interTab, interTab) || other.interTab == interTab)&&(identical(other.nativeAll, nativeAll) || other.nativeAll == nativeAll)&&(identical(other.interIntro, interIntro) || other.interIntro == interIntro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,openOnResumeSplash,interSplash,openResume,interAll,nativeLanguage,nativeLanguageSelect,nativeIntro1,nativeIntro2,nativeFullIntro2,nativeIntro3,nativeFullIntro3,nativeIntro4,nativeHome,interBack,interClosePremium,interHome,interTab,nativeAll,interIntro]);

@override
String toString() {
  return 'AdUnitsConfig(openOnResumeSplash: $openOnResumeSplash, interSplash: $interSplash, openResume: $openResume, interAll: $interAll, nativeLanguage: $nativeLanguage, nativeLanguageSelect: $nativeLanguageSelect, nativeIntro1: $nativeIntro1, nativeIntro2: $nativeIntro2, nativeFullIntro2: $nativeFullIntro2, nativeIntro3: $nativeIntro3, nativeFullIntro3: $nativeFullIntro3, nativeIntro4: $nativeIntro4, nativeHome: $nativeHome, interBack: $interBack, interClosePremium: $interClosePremium, interHome: $interHome, interTab: $interTab, nativeAll: $nativeAll, interIntro: $interIntro)';
}


}

/// @nodoc
abstract mixin class _$AdUnitsConfigCopyWith<$Res> implements $AdUnitsConfigCopyWith<$Res> {
  factory _$AdUnitsConfigCopyWith(_AdUnitsConfig value, $Res Function(_AdUnitsConfig) _then) = __$AdUnitsConfigCopyWithImpl;
@override @useResult
$Res call({
 AdUnitConfig openOnResumeSplash, AdUnitConfig interSplash, AdUnitConfig openResume, AdUnitConfig interAll, AdUnitConfig nativeLanguage, AdUnitConfig nativeLanguageSelect, AdUnitConfig nativeIntro1, AdUnitConfig nativeIntro2, AdUnitConfig nativeFullIntro2, AdUnitConfig nativeIntro3, AdUnitConfig nativeFullIntro3, AdUnitConfig nativeIntro4, AdUnitConfig nativeHome, AdUnitConfig interBack, AdUnitConfig interClosePremium, AdUnitConfig interHome, AdUnitConfig interTab, AdUnitConfig nativeAll, AdUnitConfig interIntro
});


@override $AdUnitConfigCopyWith<$Res> get openOnResumeSplash;@override $AdUnitConfigCopyWith<$Res> get interSplash;@override $AdUnitConfigCopyWith<$Res> get openResume;@override $AdUnitConfigCopyWith<$Res> get interAll;@override $AdUnitConfigCopyWith<$Res> get nativeLanguage;@override $AdUnitConfigCopyWith<$Res> get nativeLanguageSelect;@override $AdUnitConfigCopyWith<$Res> get nativeIntro1;@override $AdUnitConfigCopyWith<$Res> get nativeIntro2;@override $AdUnitConfigCopyWith<$Res> get nativeFullIntro2;@override $AdUnitConfigCopyWith<$Res> get nativeIntro3;@override $AdUnitConfigCopyWith<$Res> get nativeFullIntro3;@override $AdUnitConfigCopyWith<$Res> get nativeIntro4;@override $AdUnitConfigCopyWith<$Res> get nativeHome;@override $AdUnitConfigCopyWith<$Res> get interBack;@override $AdUnitConfigCopyWith<$Res> get interClosePremium;@override $AdUnitConfigCopyWith<$Res> get interHome;@override $AdUnitConfigCopyWith<$Res> get interTab;@override $AdUnitConfigCopyWith<$Res> get nativeAll;@override $AdUnitConfigCopyWith<$Res> get interIntro;

}
/// @nodoc
class __$AdUnitsConfigCopyWithImpl<$Res>
    implements _$AdUnitsConfigCopyWith<$Res> {
  __$AdUnitsConfigCopyWithImpl(this._self, this._then);

  final _AdUnitsConfig _self;
  final $Res Function(_AdUnitsConfig) _then;

/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openOnResumeSplash = null,Object? interSplash = null,Object? openResume = null,Object? interAll = null,Object? nativeLanguage = null,Object? nativeLanguageSelect = null,Object? nativeIntro1 = null,Object? nativeIntro2 = null,Object? nativeFullIntro2 = null,Object? nativeIntro3 = null,Object? nativeFullIntro3 = null,Object? nativeIntro4 = null,Object? nativeHome = null,Object? interBack = null,Object? interClosePremium = null,Object? interHome = null,Object? interTab = null,Object? nativeAll = null,Object? interIntro = null,}) {
  return _then(_AdUnitsConfig(
openOnResumeSplash: null == openOnResumeSplash ? _self.openOnResumeSplash : openOnResumeSplash // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interSplash: null == interSplash ? _self.interSplash : interSplash // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,openResume: null == openResume ? _self.openResume : openResume // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interAll: null == interAll ? _self.interAll : interAll // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeLanguage: null == nativeLanguage ? _self.nativeLanguage : nativeLanguage // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeLanguageSelect: null == nativeLanguageSelect ? _self.nativeLanguageSelect : nativeLanguageSelect // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro1: null == nativeIntro1 ? _self.nativeIntro1 : nativeIntro1 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro2: null == nativeIntro2 ? _self.nativeIntro2 : nativeIntro2 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeFullIntro2: null == nativeFullIntro2 ? _self.nativeFullIntro2 : nativeFullIntro2 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro3: null == nativeIntro3 ? _self.nativeIntro3 : nativeIntro3 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeFullIntro3: null == nativeFullIntro3 ? _self.nativeFullIntro3 : nativeFullIntro3 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeIntro4: null == nativeIntro4 ? _self.nativeIntro4 : nativeIntro4 // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeHome: null == nativeHome ? _self.nativeHome : nativeHome // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interBack: null == interBack ? _self.interBack : interBack // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interClosePremium: null == interClosePremium ? _self.interClosePremium : interClosePremium // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interHome: null == interHome ? _self.interHome : interHome // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interTab: null == interTab ? _self.interTab : interTab // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,nativeAll: null == nativeAll ? _self.nativeAll : nativeAll // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,interIntro: null == interIntro ? _self.interIntro : interIntro // ignore: cast_nullable_to_non_nullable
as AdUnitConfig,
  ));
}

/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get openOnResumeSplash {
  
  return $AdUnitConfigCopyWith<$Res>(_self.openOnResumeSplash, (value) {
    return _then(_self.copyWith(openOnResumeSplash: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interSplash {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interSplash, (value) {
    return _then(_self.copyWith(interSplash: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get openResume {
  
  return $AdUnitConfigCopyWith<$Res>(_self.openResume, (value) {
    return _then(_self.copyWith(openResume: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interAll {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interAll, (value) {
    return _then(_self.copyWith(interAll: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeLanguage {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeLanguage, (value) {
    return _then(_self.copyWith(nativeLanguage: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeLanguageSelect {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeLanguageSelect, (value) {
    return _then(_self.copyWith(nativeLanguageSelect: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro1 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro1, (value) {
    return _then(_self.copyWith(nativeIntro1: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro2 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro2, (value) {
    return _then(_self.copyWith(nativeIntro2: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeFullIntro2 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeFullIntro2, (value) {
    return _then(_self.copyWith(nativeFullIntro2: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro3 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro3, (value) {
    return _then(_self.copyWith(nativeIntro3: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeFullIntro3 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeFullIntro3, (value) {
    return _then(_self.copyWith(nativeFullIntro3: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeIntro4 {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeIntro4, (value) {
    return _then(_self.copyWith(nativeIntro4: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeHome {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeHome, (value) {
    return _then(_self.copyWith(nativeHome: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interBack {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interBack, (value) {
    return _then(_self.copyWith(interBack: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interClosePremium {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interClosePremium, (value) {
    return _then(_self.copyWith(interClosePremium: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interHome {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interHome, (value) {
    return _then(_self.copyWith(interHome: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interTab {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interTab, (value) {
    return _then(_self.copyWith(interTab: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get nativeAll {
  
  return $AdUnitConfigCopyWith<$Res>(_self.nativeAll, (value) {
    return _then(_self.copyWith(nativeAll: value));
  });
}/// Create a copy of AdUnitsConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitConfigCopyWith<$Res> get interIntro {
  
  return $AdUnitConfigCopyWith<$Res>(_self.interIntro, (value) {
    return _then(_self.copyWith(interIntro: value));
  });
}
}


/// @nodoc
mixin _$AdsRemoteConfig {

 AdUnitsConfig get adUnitsConfig; bool get showAllAds; bool get showTopButton; int get nativeFullDisplayMode; int get interInterval; int get id2RequestTimeout;
/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdsRemoteConfigCopyWith<AdsRemoteConfig> get copyWith => _$AdsRemoteConfigCopyWithImpl<AdsRemoteConfig>(this as AdsRemoteConfig, _$identity);

  /// Serializes this AdsRemoteConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdsRemoteConfig&&(identical(other.adUnitsConfig, adUnitsConfig) || other.adUnitsConfig == adUnitsConfig)&&(identical(other.showAllAds, showAllAds) || other.showAllAds == showAllAds)&&(identical(other.showTopButton, showTopButton) || other.showTopButton == showTopButton)&&(identical(other.nativeFullDisplayMode, nativeFullDisplayMode) || other.nativeFullDisplayMode == nativeFullDisplayMode)&&(identical(other.interInterval, interInterval) || other.interInterval == interInterval)&&(identical(other.id2RequestTimeout, id2RequestTimeout) || other.id2RequestTimeout == id2RequestTimeout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adUnitsConfig,showAllAds,showTopButton,nativeFullDisplayMode,interInterval,id2RequestTimeout);

@override
String toString() {
  return 'AdsRemoteConfig(adUnitsConfig: $adUnitsConfig, showAllAds: $showAllAds, showTopButton: $showTopButton, nativeFullDisplayMode: $nativeFullDisplayMode, interInterval: $interInterval, id2RequestTimeout: $id2RequestTimeout)';
}


}

/// @nodoc
abstract mixin class $AdsRemoteConfigCopyWith<$Res>  {
  factory $AdsRemoteConfigCopyWith(AdsRemoteConfig value, $Res Function(AdsRemoteConfig) _then) = _$AdsRemoteConfigCopyWithImpl;
@useResult
$Res call({
 AdUnitsConfig adUnitsConfig, bool showAllAds, bool showTopButton, int nativeFullDisplayMode, int interInterval, int id2RequestTimeout
});


$AdUnitsConfigCopyWith<$Res> get adUnitsConfig;

}
/// @nodoc
class _$AdsRemoteConfigCopyWithImpl<$Res>
    implements $AdsRemoteConfigCopyWith<$Res> {
  _$AdsRemoteConfigCopyWithImpl(this._self, this._then);

  final AdsRemoteConfig _self;
  final $Res Function(AdsRemoteConfig) _then;

/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adUnitsConfig = null,Object? showAllAds = null,Object? showTopButton = null,Object? nativeFullDisplayMode = null,Object? interInterval = null,Object? id2RequestTimeout = null,}) {
  return _then(_self.copyWith(
adUnitsConfig: null == adUnitsConfig ? _self.adUnitsConfig : adUnitsConfig // ignore: cast_nullable_to_non_nullable
as AdUnitsConfig,showAllAds: null == showAllAds ? _self.showAllAds : showAllAds // ignore: cast_nullable_to_non_nullable
as bool,showTopButton: null == showTopButton ? _self.showTopButton : showTopButton // ignore: cast_nullable_to_non_nullable
as bool,nativeFullDisplayMode: null == nativeFullDisplayMode ? _self.nativeFullDisplayMode : nativeFullDisplayMode // ignore: cast_nullable_to_non_nullable
as int,interInterval: null == interInterval ? _self.interInterval : interInterval // ignore: cast_nullable_to_non_nullable
as int,id2RequestTimeout: null == id2RequestTimeout ? _self.id2RequestTimeout : id2RequestTimeout // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitsConfigCopyWith<$Res> get adUnitsConfig {
  
  return $AdUnitsConfigCopyWith<$Res>(_self.adUnitsConfig, (value) {
    return _then(_self.copyWith(adUnitsConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdsRemoteConfig].
extension AdsRemoteConfigPatterns on AdsRemoteConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdsRemoteConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdsRemoteConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdsRemoteConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdsRemoteConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdsRemoteConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdsRemoteConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdUnitsConfig adUnitsConfig,  bool showAllAds,  bool showTopButton,  int nativeFullDisplayMode,  int interInterval,  int id2RequestTimeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdsRemoteConfig() when $default != null:
return $default(_that.adUnitsConfig,_that.showAllAds,_that.showTopButton,_that.nativeFullDisplayMode,_that.interInterval,_that.id2RequestTimeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdUnitsConfig adUnitsConfig,  bool showAllAds,  bool showTopButton,  int nativeFullDisplayMode,  int interInterval,  int id2RequestTimeout)  $default,) {final _that = this;
switch (_that) {
case _AdsRemoteConfig():
return $default(_that.adUnitsConfig,_that.showAllAds,_that.showTopButton,_that.nativeFullDisplayMode,_that.interInterval,_that.id2RequestTimeout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdUnitsConfig adUnitsConfig,  bool showAllAds,  bool showTopButton,  int nativeFullDisplayMode,  int interInterval,  int id2RequestTimeout)?  $default,) {final _that = this;
switch (_that) {
case _AdsRemoteConfig() when $default != null:
return $default(_that.adUnitsConfig,_that.showAllAds,_that.showTopButton,_that.nativeFullDisplayMode,_that.interInterval,_that.id2RequestTimeout);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AdsRemoteConfig implements AdsRemoteConfig {
  const _AdsRemoteConfig({this.adUnitsConfig = const AdUnitsConfig(), this.showAllAds = true, this.showTopButton = true, this.nativeFullDisplayMode = 1, this.interInterval = 15, this.id2RequestTimeout = 0});
  factory _AdsRemoteConfig.fromJson(Map<String, dynamic> json) => _$AdsRemoteConfigFromJson(json);

@override@JsonKey() final  AdUnitsConfig adUnitsConfig;
@override@JsonKey() final  bool showAllAds;
@override@JsonKey() final  bool showTopButton;
@override@JsonKey() final  int nativeFullDisplayMode;
@override@JsonKey() final  int interInterval;
@override@JsonKey() final  int id2RequestTimeout;

/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdsRemoteConfigCopyWith<_AdsRemoteConfig> get copyWith => __$AdsRemoteConfigCopyWithImpl<_AdsRemoteConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdsRemoteConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdsRemoteConfig&&(identical(other.adUnitsConfig, adUnitsConfig) || other.adUnitsConfig == adUnitsConfig)&&(identical(other.showAllAds, showAllAds) || other.showAllAds == showAllAds)&&(identical(other.showTopButton, showTopButton) || other.showTopButton == showTopButton)&&(identical(other.nativeFullDisplayMode, nativeFullDisplayMode) || other.nativeFullDisplayMode == nativeFullDisplayMode)&&(identical(other.interInterval, interInterval) || other.interInterval == interInterval)&&(identical(other.id2RequestTimeout, id2RequestTimeout) || other.id2RequestTimeout == id2RequestTimeout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adUnitsConfig,showAllAds,showTopButton,nativeFullDisplayMode,interInterval,id2RequestTimeout);

@override
String toString() {
  return 'AdsRemoteConfig(adUnitsConfig: $adUnitsConfig, showAllAds: $showAllAds, showTopButton: $showTopButton, nativeFullDisplayMode: $nativeFullDisplayMode, interInterval: $interInterval, id2RequestTimeout: $id2RequestTimeout)';
}


}

/// @nodoc
abstract mixin class _$AdsRemoteConfigCopyWith<$Res> implements $AdsRemoteConfigCopyWith<$Res> {
  factory _$AdsRemoteConfigCopyWith(_AdsRemoteConfig value, $Res Function(_AdsRemoteConfig) _then) = __$AdsRemoteConfigCopyWithImpl;
@override @useResult
$Res call({
 AdUnitsConfig adUnitsConfig, bool showAllAds, bool showTopButton, int nativeFullDisplayMode, int interInterval, int id2RequestTimeout
});


@override $AdUnitsConfigCopyWith<$Res> get adUnitsConfig;

}
/// @nodoc
class __$AdsRemoteConfigCopyWithImpl<$Res>
    implements _$AdsRemoteConfigCopyWith<$Res> {
  __$AdsRemoteConfigCopyWithImpl(this._self, this._then);

  final _AdsRemoteConfig _self;
  final $Res Function(_AdsRemoteConfig) _then;

/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adUnitsConfig = null,Object? showAllAds = null,Object? showTopButton = null,Object? nativeFullDisplayMode = null,Object? interInterval = null,Object? id2RequestTimeout = null,}) {
  return _then(_AdsRemoteConfig(
adUnitsConfig: null == adUnitsConfig ? _self.adUnitsConfig : adUnitsConfig // ignore: cast_nullable_to_non_nullable
as AdUnitsConfig,showAllAds: null == showAllAds ? _self.showAllAds : showAllAds // ignore: cast_nullable_to_non_nullable
as bool,showTopButton: null == showTopButton ? _self.showTopButton : showTopButton // ignore: cast_nullable_to_non_nullable
as bool,nativeFullDisplayMode: null == nativeFullDisplayMode ? _self.nativeFullDisplayMode : nativeFullDisplayMode // ignore: cast_nullable_to_non_nullable
as int,interInterval: null == interInterval ? _self.interInterval : interInterval // ignore: cast_nullable_to_non_nullable
as int,id2RequestTimeout: null == id2RequestTimeout ? _self.id2RequestTimeout : id2RequestTimeout // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AdsRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdUnitsConfigCopyWith<$Res> get adUnitsConfig {
  
  return $AdUnitsConfigCopyWith<$Res>(_self.adUnitsConfig, (value) {
    return _then(_self.copyWith(adUnitsConfig: value));
  });
}
}

// dart format on
