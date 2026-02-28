# Flutter Base

## Information

Flutter version: `3.27.x`

### Base Flutter with:

- State management: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- Asset management: [flutter_gen](https://pub.dev/packages/flutter_gen)
- Flavor management: [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr)
- Evironment management: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- Route management: [auto_route](https://pub.dev/packages/auto_route)
- Dependencies
  Injection: [get_it](https://pub.dev/packages/get_it) + [injectable](https://pub.dev/packages/injectable)
- Responsiveness: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
-

Localization: [flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)

### and Boilerplate code for:

- Screen: Splash, Intro, Language, Settings
- Firebase: Remote config, Analytics
- Admob intergration & meta ads mediation & mintegral + app lovin
- AppsFlyers SDK
- IAP (optional) --> later

## Usage

### Setup

```console
flutter pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
```

### Set up quảng cáo

- Meta ads: Android: thay ClientToken & ApplicationId trong Android Manifest, iOS: thay CLIENT-TOKEN
  và APP-ID tương ứng
