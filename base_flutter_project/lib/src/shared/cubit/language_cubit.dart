import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../enum/language.dart';
import 'value_cubit.dart';

@lazySingleton
class LanguageCubit extends Cubit<Language> with HydratedMixin {
  LanguageCubit() : super(Language.english) {
    hydrate();
  }

  void changeLanguage(Language language) {
    emit(language);
  }
  @override
  Language fromJson(Map<String, dynamic> json) {
    for (final element in Language.values) {
      final locale = element.locale;
      if (locale.languageCode == json['languageCode'] &&
          locale.countryCode == json['countryCode'] &&
          locale.scriptCode == json['scriptCode']) {
        return element;
      }
    }
    return Language.english;
  }

  @override
  Map<String, dynamic> toJson(Language? state) {
    return {
      'languageCode': state?.locale.languageCode,
      'scriptCode': state?.locale.scriptCode,
      'countryCode': state?.locale.countryCode,
    };
  }
}
