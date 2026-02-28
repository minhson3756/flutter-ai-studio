// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_base/module/iap/firebase_event_service.dart' as _i319;
import 'package:flutter_base/src/config/navigation/app_router.dart' as _i680;
import 'package:flutter_base/src/shared/cubit/language_cubit.dart' as _i303;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i319.FirebaseEventService>(
      () => _i319.FirebaseEventService(),
    );
    gh.singleton<_i680.AppRouter>(() => _i680.AppRouter());
    gh.lazySingleton<_i303.LanguageCubit>(() => _i303.LanguageCubit());
    return this;
  }
}
