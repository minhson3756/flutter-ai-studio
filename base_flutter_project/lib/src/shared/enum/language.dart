import 'dart:ui';


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

