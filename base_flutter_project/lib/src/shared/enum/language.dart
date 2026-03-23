import 'dart:ui';

enum Language {
  english(languageName: 'English', languageCode: 'en'),
  chineseSimplified(languageName: '中文（简体）', languageCode: 'zh', scriptCode: 'Hans'),
  chineseTraditional(languageName: '中文（繁體）', languageCode: 'zh', scriptCode: 'Hant'),
  hindi(languageName: 'हिंदी भाषा', languageCode: 'hi'),
  spanish(languageName: 'Español', languageCode: 'es'),
  portugueseBrazil(languageName: 'Português (Brasil)', languageCode: 'pt', countryCode: 'BR'),
  portuguesePortugal(languageName: 'Português (Portugal)', languageCode: 'pt', countryCode: 'PT'),
  french(languageName: 'Français', languageCode: 'fr'),
  arabic(languageName: 'عربي', languageCode: 'ar'),
  bengali(languageName: 'বাংলা', languageCode: 'bn'),
  russian(languageName: 'Русский', languageCode: 'ru'),
  german(languageName: 'Deutsch', languageCode: 'de'),
  japanese(languageName: '日本語', languageCode: 'ja'),
  turkish(languageName: 'Turkish', languageCode: 'tr'),
  korean(languageName: '한국인', languageCode: 'ko'),
  indonesian(languageName: 'Indonesian', languageCode: 'id'),
  ;

  const Language({
    required this.languageName,
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  });

  final String languageName;
  final String languageCode;
  final String? scriptCode;
  final String? countryCode;

  @override
  String toString() => languageName;

  Locale get locale => Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: scriptCode,
        countryCode: countryCode,
      );
}
