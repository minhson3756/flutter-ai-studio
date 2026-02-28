import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../flavors.dart';
import '../../src/config/di/di.dart';
import '../../src/config/navigation/app_router.dart';
import '../../src/data/local/shared_preferences_manager.dart';
import '../../src/shared/extension/context_extension.dart';
import '../../src/shared/global.dart';
import '../../src/shared/helpers/logger_utils.dart';
import '../adjust/adjust_util.dart';
import 'firebase_event_service.dart';

const String productKeyMonthly = 'com.zenity.remotetv.sub.monthly';
const String productKeyYearly = 'com.zenity.remotetv.sub.annual';

class MyPurchasesManager extends PurchasesManager {
  @override
  Set<String> productIds = <String>{
    productKeyMonthly,
    productKeyYearly,
  };

  @override
  Future<void> loadPurchases() async {
    if (F.appFlavor == Flavor.dev) {
      // tạo các mock product cho môi trường dev
      emit(state.copyWith(
        products: productIds
            .map((e) => PurchasableProduct(ProductDetails(
                  currencyCode: '',
                  description: '',
                  id: e,
                  price: r'1.00$',
                  rawPrice: 1,
                  title: 'aaa',
                )))
            .toList(),
        storeState: StoreState.available,
      ));
      return;
    }
    return super.loadPurchases();
  }

  /// Mua hàng
  @override
  Future<void> buy(PurchasableProduct product) async {
    if (F.appFlavor == Flavor.dev) {
      updateStatus(product.id, ProductStatus.purchased);
      MyAds.instance.appLifecycleReactor?.setShouldShow(false);
      return;
    }
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case productKeyMonthly:
      case productKeyYearly:
        await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
        return;
      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }

  /// Kiểm tra trạng thái premium từ SharedPreferences
  @override
  Future<void> checkLocalPurchase() async {
    for (final type in [
      PremiumType.isWeeklyPremium,
      PremiumType.isMonthlyPremium,
    ]) {
      if (SharedPreferencesManager.instance.getPremiumStatus(type)) {
        await restorePurchases();
        break;
      }
    }
  }

  /// Restore purchases
  @override
  Future<void> restorePurchases() async {
    showLoading();
    for (final type in [
      PremiumType.isWeeklyPremium,
      PremiumType.isMonthlyPremium,
    ]) {
      SharedPreferencesManager.instance.setPremiumStatus(type, false);
    }
    await iapConnection.restorePurchases();
    hideLoading();
  }

  /// Xử lý khi người dùng hủy giao dịch
  @override
  Future<void> handlePurchaseCanceled(PurchaseDetails purchaseDetails) async {
    hideLoading();
    final productStatusMap = {
      productKeyYearly: PremiumType.isWeeklyPremium,
      productKeyMonthly: PremiumType.isMonthlyPremium,
    };

    final premiumType = productStatusMap[purchaseDetails.productID];
    if (premiumType != null) {
      updateStatus(purchaseDetails.productID, ProductStatus.purchasable);
      SharedPreferencesManager.instance.setPremiumStatus(premiumType, false);
    }
  }

  /// Xử lý khi có lỗi trong quá trình mua hàng
  @override
  Future<void> handlePurchaseError(PurchaseDetails purchaseDetails) async {
    hideLoading();
    logger.e(purchaseDetails.error?.details);
    // Hiển thị thông báo lỗi
    await showDialog(
      context: getIt<AppRouter>().navigatorKey.currentContext!,
      builder: (BuildContext ctx) {
        String errorMessage = ctx.l10n.unexpectedError;
        if (purchaseDetails.error?.message ==
            'BillingResponse.itemAlreadyOwned') {
          errorMessage = ctx.l10n.alreadyOwnError;
        }
        return AlertDialog(
          content: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () {
                getIt<AppRouter>().maybePop();
              },
              child: Text(
                ctx.l10n.confirm,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (purchaseDetails.error?.message != 'BillingResponse.itemAlreadyOwned') {
      getIt<AppRouter>().maybePop();
    }
  }

  @override
  Future<void> handlePurchasePending(PurchaseDetails purchaseDetails) async {
    showLoading();
  }

  void showLoading() {
    if (Global.instance.didLeaveSplash) {
      EasyLoading.show();
    }
  }

  void hideLoading() {
    if (Global.instance.didLeaveSplash) {
      EasyLoading.dismiss();
    }
  }

  @override
  Future<void> handlePurchaseRestored(PurchaseDetails purchaseDetails) async {
    hideLoading();
    final purchaseDate = purchaseDetails.transactionDate != null
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(purchaseDetails.transactionDate!))
        : null;

    final productDurations = {
      productKeyYearly: const Duration(days: 365),
      productKeyMonthly: const Duration(days: 31),
    };

    final premiumTypes = {
      productKeyYearly: PremiumType.isWeeklyPremium,
      productKeyMonthly: PremiumType.isMonthlyPremium,
    };

    final duration = productDurations[purchaseDetails.productID];
    final premiumType = premiumTypes[purchaseDetails.productID];

    if (duration != null && premiumType != null) {
      if (purchaseDate == null ||
          DateTime.now().isBefore(purchaseDate.add(duration))) {
        updateStatus(purchaseDetails.productID, ProductStatus.purchased);
        hideAppOpenAd();
        SharedPreferencesManager.instance.setPremiumStatus(premiumType, true);
      }
    }
  }

  /// Xử lý khi người dùng mua thành công
  /// Log revenue lên Adjust (Optional)
  @override
  Future<void> handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    final product = state.products.firstWhere(
      (e) => e.id == purchaseDetails.productID,
    );
    // Log revenue của các product theo event token của product đó
    // (được khai báo ở productRevenueTokens khi khởi tạo AdjustUtil)
    AdjustUtil.instance.trackSubscriptionRevenue(
      price: product.productDetails.rawPrice,
      currencyCode: product.productDetails.currencyCode,
      productId: product.id,
    );

    // Log revenue của các product lên cùng 1 event token
    // (được khai báo ở totalRevenueToken khi khởi tạo AdjustUtil)
    AdjustUtil.instance.trackTotalIapRevenue(
      price: product.productDetails.rawPrice,
      currencyCode: product.productDetails.currencyCode,
      productId: product.id,
    );

    hideLoading();
    getIt<FirebaseEventService>().logUserPayment(purchaseDetails.productID);

    final premiumStatusMap = {
      productKeyYearly: PremiumType.isWeeklyPremium,
      productKeyMonthly: PremiumType.isMonthlyPremium,
    };

    final premiumType = premiumStatusMap[purchaseDetails.productID];
    if (premiumType != null) {
      updateStatus(purchaseDetails.productID, ProductStatus.purchased);
      hideAppOpenAd();
      SharedPreferencesManager.instance.setPremiumStatus(premiumType, true);
    }
  }

  /// Ẩn app open ad
  void hideAppOpenAd() {
    MyAds.instance.appLifecycleReactor?.setShouldShow(false);
  }
}

extension PurchasableProductsExtension on List<PurchasableProduct> {
  PurchasableProduct? get displayProduct {
    if (isEmpty) {
      return null;
    }
    return firstWhereOrNull(
      (element) => element.productDetails.rawPrice != 0,
    );
  }
}
