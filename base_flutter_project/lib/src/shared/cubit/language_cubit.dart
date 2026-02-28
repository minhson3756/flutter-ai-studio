import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../enum/language.dart';
import 'value_cubit.dart';

@lazySingleton
class LanguageCubit extends ValueCubit<Language> with HydratedMixin {
  LanguageCubit() : super(Language.english) {
    hydrate();
  }

  @override
  Language fromJson(Map<String, dynamic> json) {
    for (final element in Language.values) {
      final locale = element.locale;
      if (locale.languageCode == json['languageCode'] &&
          locale.countryCode == json['countryCode'] &&
          locale.scriptCode == json['stripCode']) {
        return element;
      }
    }
    return Language.english;
  }

  @override
  Map<String, dynamic> toJson(Language? state) {
    final locale = state?.locale;
    return {
      'languageCode': state?.locale.languageCode,
      'stripCode': state?.locale.scriptCode,
      'countryCode': state?.locale.countryCode,
    };
  }
}
