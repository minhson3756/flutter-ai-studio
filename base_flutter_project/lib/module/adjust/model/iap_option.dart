import 'dart:io';

abstract class PlatformIapOption {
  PlatformIapOption({
    this.productRevenueTokens,
    this.totalRevenueToken,
  });

  /// Mỗi element trong [productRevenueTokens] sẽ có key là productId và value là event token
  ///
  /// Ví dụ {'com.example.weekly' : 'abc123'}
  final Map<String, String>? productRevenueTokens;
  final String? totalRevenueToken;
}

class AndroidIapOptions extends PlatformIapOption {
  AndroidIapOptions({
    super.productRevenueTokens,
    super.totalRevenueToken,
  });
}

class IOSIapOptions extends PlatformIapOption {
  IOSIapOptions({
    super.productRevenueTokens,
    super.totalRevenueToken,
  });
}

class IapOptions {
  IapOptions({
    this.androidOptions,
    this.iosOptions,
  });

  final AndroidIapOptions? androidOptions;
  final IOSIapOptions? iosOptions;

  Map<String, String>? get productRevenueTokens => Platform.isAndroid
      ? androidOptions?.productRevenueTokens
      : iosOptions?.productRevenueTokens;

  String? get totalRevenueToken => Platform.isAndroid
      ? androidOptions?.totalRevenueToken
      : iosOptions?.totalRevenueToken;

  Map<String, dynamic> toJson() {
    return {
      'productRevenueTokens': productRevenueTokens,
      'totalRevenueToken': totalRevenueToken,
    };
  }
}
