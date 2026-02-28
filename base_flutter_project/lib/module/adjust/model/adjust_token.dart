import 'dart:io';

class AdjustToken {
  AdjustToken({
    this.androidToken,
    this.iosToken,
  });

  final String? androidToken;
  final String? iosToken;

  String? get platformToken => Platform.isAndroid ? androidToken : iosToken;
}
