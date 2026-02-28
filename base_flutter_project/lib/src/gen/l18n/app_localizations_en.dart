// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Flutter Base';

  @override
  String get language => 'Language';

  @override
  String get thisActionCanContainAds => 'This action can contain ads';

  @override
  String get next => 'Next';

  @override
  String get thank => 'Thank you!';

  @override
  String get start => 'Start';

  @override
  String get go => 'Go';

  @override
  String get permission => 'Permission';

  @override
  String get rate => 'Rate';

  @override
  String get share => 'Share';

  @override
  String get policy => 'Privacy Policy';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get setting => 'Setting';

  @override
  String get unexpectedError => 'An unexpected error occurred!';

  @override
  String get alreadyOwnError =>
      'Looks like you already owned this item.\nPlease click \"Restore purchase\" to continue.';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get backToHomescreen => 'Back to Homescreen';

  @override
  String get exitApp => 'Exit app';

  @override
  String get areYouSureYouWantToExitApp =>
      'Are you sure you want to exit the app?';

  @override
  String get continueText => 'Continue';

  @override
  String get grantPermissionLater => 'Grant permission later';

  @override
  String loading(String percent) {
    return 'Loading($percent%)...';
  }

  @override
  String get explore => 'Explore';

  @override
  String get dontUninstallYet => 'Don’t uninstall yet';

  @override
  String get stillWantToUninstall => 'Still want to uninstall?';

  @override
  String whyUninstallApp(String appName) {
    return 'Why uninstall $appName?';
  }

  @override
  String get difficultToUse => 'Difficult to use';

  @override
  String get tooManyAds => 'Too many ads';

  @override
  String get others => 'Others';

  @override
  String get whatProblemsYouEncounterDuringUse =>
      'What problems do you encounter during use?';

  @override
  String get notCurrentlyAvailableForUse => 'Not currently available for use.';

  @override
  String get uninstall => 'Uninstall';

  @override
  String get cancel => 'Cancel';

  @override
  String pleaseEnterReasonForUninstallingApp(String appName) {
    return 'Please enter the reason why you are uninstalling $appName.';
  }

  @override
  String get selectLanguageGuide => 'Please select a language to continue';

  @override
  String get allowNotifications => 'Allow notifications?';

  @override
  String get later => 'Later';

  @override
  String get notifications => 'Notifications';
}
