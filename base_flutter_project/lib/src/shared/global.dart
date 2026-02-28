class Global {
  Global._privateConstructor();

  static final Global instance = Global._privateConstructor();
  String documentPath = '';
  String temporaryPath = '';
  int androidSdkVersion = 0;
  bool isExitApp = false;
  bool initEasyLoading = false;
  bool allowReloadBanner = true;

  bool requestedNotificationPermission = false;
  bool didLeaveSplash = false;
}
