import 'dart:ui';

import '../../gen/assets.gen.dart';

enum Language {
  english(
    languageName: 'English',
    languageCode: 'en',
  ),
  spanish(
    languageName: 'Español',
    languageCode: 'es',
  ),
  french(
    languageName: 'Français',
    languageCode: 'fr',
  ),
  hindi(
    languageName: 'हिन्दी',
    languageCode: 'hi',
  ),
  portuguese(
    languageName: 'Português',
    languageCode: 'pt',
  ),
  ;

  const Language({
    required this.languageCode,
    required this.languageName,
  });

  final String languageCode;
  final String languageName;

  @override
  String toString() => languageName;
}

extension LanguageExtension on Language {
  String get flagPath {
    switch (this) {
      case Language.english:
        return Assets.images.languages.en.path;
      case Language.spanish:
        return Assets.images.languages.es.path;
      case Language.french:
        return Assets.images.languages.fr.path;
      case Language.hindi:
        return Assets.images.languages.hi.path;
      case Language.portuguese:
        return Assets.images.languages.pt.path;
    }
  }

  Locale get locale {
    switch (this) {
      case Language.english:
        return const Locale('en');
      case Language.french:
        return const Locale('fr');
      case Language.hindi:
        return const Locale('hi');
      case Language.spanish:
        return const Locale('es');
      case Language.portuguese:
        return const Locale('pt', 'PT');
    }
  }
}
