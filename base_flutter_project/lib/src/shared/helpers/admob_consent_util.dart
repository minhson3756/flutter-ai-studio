import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_ads/ads_flutter.dart';

class AdmobConsentUtil {
  AdmobConsentUtil._();

  static ConsentStatus _status = ConsentStatus.unknown;
  static bool _canShowPersonalized = false;

  static Future<void> initialize({
    bool underAge = false,
    List<String> testDeviceIds = const ['19D8E27F194BB895488CEADD5DB99D62'],
    bool forceDebugGeographyEea = true,
  }) async {
    try {
      final params = ConsentRequestParameters(
        tagForUnderAgeOfConsent: underAge,
        consentDebugSettings: _buildDebugSettings(
          testDeviceIds: testDeviceIds,
          forceDebugGeographyEea: forceDebugGeographyEea,
        ),
      );

      final infoUpdate = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        // onSuccess
        () => infoUpdate.complete(),
        // onFailure
        (FormError error) => infoUpdate.completeError(error),
      );
      await infoUpdate.future;

      final available = await ConsentInformation.instance
          .isConsentFormAvailable();
      if (available) {
        final showForm = Completer<void>();
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            showForm.completeError(error);
          } else {
            showForm.complete();
          }
        });
        await showForm.future;
      }

      _status = await ConsentInformation.instance.getConsentStatus();

      _canShowPersonalized = _evaluatePersonalizationAllowed(_status);
    } catch (_) {
      _status = ConsentStatus.unknown;
      _canShowPersonalized = false;
    }
  }

  static ConsentStatus get consentStatus => _status;

  static bool get canShowPersonalizedAds => _canShowPersonalized;

  /// Xây AdRequest phản ánh consent hiện tại.
  static AdRequest adRequest({Map<String, String>? extraNetworkExtras}) {
    if (_canShowPersonalized) {
      return AdRequest(nonPersonalizedAds: false, extras: extraNetworkExtras);
    } else {
      final merged = <String, String>{'npa': '1', ...?extraNetworkExtras};
      return AdRequest(nonPersonalizedAds: true, extras: merged);
    }
  }

  /// Cho phép người dùng mở lại form consent từ màn hình Privacy.
  static Future<bool> presentPrivacyOptions() async {
    try {
      final available = await ConsentInformation.instance
          .isConsentFormAvailable();
      if (available) {
        final showForm = Completer<void>();
        ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
          if (error != null) {
            showForm.completeError(error);
          } else {
            showForm.complete();
          }
        });
        await showForm.future;
      }
      _status = await ConsentInformation.instance.getConsentStatus();
      final before = _canShowPersonalized;
      _canShowPersonalized = _evaluatePersonalizationAllowed(_status);
      return _canShowPersonalized && !before;
    } catch (_) {
      return false;
    }
  }

  static Future<void> resetConsentForDebug() async {
    if (!kDebugMode) return;
    try {
      await ConsentInformation.instance.reset();
      _status = ConsentStatus.unknown;
      _canShowPersonalized = false;
    } catch (_) {}
  }

  static bool _evaluatePersonalizationAllowed(ConsentStatus status) {
    switch (status) {
      case ConsentStatus.obtained:
        return true; // người dùng đã chọn qua UMP
      case ConsentStatus.notRequired:
        return true; // thường là ngoài EEA
      case ConsentStatus.required:
      case ConsentStatus.unknown:
        return false; // chưa/không có consent → chỉ NPA
    }
  }

  static ConsentDebugSettings? _buildDebugSettings({
    required List<String> testDeviceIds,
    required bool forceDebugGeographyEea,
  }) {
    if (!kDebugMode) return null;

    DebugGeography? geography;
    if (forceDebugGeographyEea) {
      geography = DebugGeography.debugGeographyEea;
    }

    return ConsentDebugSettings(
      debugGeography: geography,
      testIdentifiers: testDeviceIds,
    );
  }

  static String statusLabel() {
    switch (_status) {
      case ConsentStatus.obtained:
        return 'obtained';
      case ConsentStatus.required:
        return 'required';
      case ConsentStatus.notRequired:
        return 'notRequired';
      case ConsentStatus.unknown:
        return 'unknown';
    }
  }
}
