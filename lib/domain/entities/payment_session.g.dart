// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentSessionImpl _$$PaymentSessionImplFromJson(Map<String, dynamic> json) =>
    _$PaymentSessionImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      merchantId: json['merchantId'] as String,
      amountItems: (json['amountItems'] as num).toDouble(),
      feeAmount: (json['feeAmount'] as num).toDouble(),
      amountTotal: (json['amountTotal'] as num).toDouble(),
      status: $enumDecode(_$PaymentSessionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentIntentId: json['paymentIntentId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentSessionImplToJson(
        _$PaymentSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'merchantId': instance.merchantId,
      'amountItems': instance.amountItems,
      'feeAmount': instance.feeAmount,
      'amountTotal': instance.amountTotal,
      'status': _$PaymentSessionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentIntentId': instance.paymentIntentId,
      'metadata': instance.metadata,
    };

const _$PaymentSessionStatusEnumMap = {
  PaymentSessionStatus.created: 'created',
  PaymentSessionStatus.pending: 'pending',
  PaymentSessionStatus.paid: 'paid',
  PaymentSessionStatus.expired: 'expired',
  PaymentSessionStatus.cancelled: 'cancelled',
  PaymentSessionStatus.failed: 'failed',
};
