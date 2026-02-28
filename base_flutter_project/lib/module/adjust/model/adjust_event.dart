//
//  adjust_event.dart
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 25th April 2018.
//  Copyright (c) 2018-Present Adjust GmbH. All rights reserved.
//

class AdjustEvent {
  AdjustEvent(
    this.eventToken, {
    this.revenue,
    this.currency,
    this.callbackId,
    this.deduplicationId,
    this.productId,
    this.callbackParameters,
    this.partnerParameters,
    this.transactionId,
    this.purchaseToken,
  });

  factory AdjustEvent.fromMap(Map<String, dynamic> map) {
    return AdjustEvent(
      map['eventToken'] as String,
      revenue: map['revenue'] as num,
      currency: map['currency'] as String,
      callbackId: map['callbackId'] as String,
      deduplicationId: map['deduplicationId'] as String,
      productId: map['productId'] as String,
      callbackParameters: map['callbackParameters'] as Map<String, String>,
      partnerParameters: map['partnerParameters'] as Map<String, String>,
      transactionId: map['transactionId'] as String,
      purchaseToken: map['purchaseToken'] as String,
    );
  }

  final String eventToken;
  final num? revenue;
  final String? currency;
  final String? callbackId;
  final String? deduplicationId;
  final String? productId;
  final Map<String, String>? callbackParameters;
  final Map<String, String>? partnerParameters;

  // ios only
  final String? transactionId;

  // android only
  final String? purchaseToken;

  Map<String, dynamic> toMap() {
    return {
      'eventToken': eventToken,
      'revenue': revenue,
      'currency': currency,
      'callbackId': callbackId,
      'deduplicationId': deduplicationId,
      'productId': productId,
      'callbackParameters': callbackParameters,
      'partnerParameters': partnerParameters,
      'transactionId': transactionId,
      'purchaseToken': purchaseToken,
    };
  }

  AdjustEvent copyWith({
    String? eventToken,
    num? revenue,
    String? currency,
    String? callbackId,
    String? deduplicationId,
    String? productId,
    Map<String, String>? callbackParameters,
    Map<String, String>? partnerParameters,
    String? transactionId,
    String? purchaseToken,
  }) {
    return AdjustEvent(
      eventToken ?? this.eventToken,
      revenue: revenue ?? this.revenue,
      currency: currency ?? this.currency,
      callbackId: callbackId ?? this.callbackId,
      deduplicationId: deduplicationId ?? this.deduplicationId,
      productId: productId ?? this.productId,
      callbackParameters: callbackParameters ?? this.callbackParameters,
      partnerParameters: partnerParameters ?? this.partnerParameters,
      transactionId: transactionId ?? this.transactionId,
      purchaseToken: purchaseToken ?? this.purchaseToken,
    );
  }
}
