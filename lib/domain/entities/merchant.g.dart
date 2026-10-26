// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchantImpl _$$MerchantImplFromJson(Map<String, dynamic> json) =>
    _$MerchantImpl(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      abn: json['abn'] as String?,
      contactEmail: json['contactEmail'] as String,
      businessType: $enumDecode(_$BusinessTypeEnumMap, json['businessType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool,
      paymentConfig: json['paymentConfig'] == null
          ? null
          : PaymentConfig.fromJson(
              json['paymentConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MerchantImplToJson(_$MerchantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessName': instance.businessName,
      'abn': instance.abn,
      'contactEmail': instance.contactEmail,
      'businessType': _$BusinessTypeEnumMap[instance.businessType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
      'paymentConfig': instance.paymentConfig,
    };

const _$BusinessTypeEnumMap = {
  BusinessType.restaurant: 'restaurant',
  BusinessType.cafe: 'cafe',
  BusinessType.retail: 'retail',
  BusinessType.clinic: 'clinic',
  BusinessType.other: 'other',
};

_$PaymentConfigImpl _$$PaymentConfigImplFromJson(Map<String, dynamic> json) =>
    _$PaymentConfigImpl(
      payAtCounterEnabled: json['payAtCounterEnabled'] as bool,
      qrPayEnabled: json['qrPayEnabled'] as bool,
      serviceFeePercent: (json['serviceFeePercent'] as num?)?.toDouble() ?? 2.0,
      serviceFeeFixed: (json['serviceFeeFixed'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PaymentConfigImplToJson(_$PaymentConfigImpl instance) =>
    <String, dynamic>{
      'payAtCounterEnabled': instance.payAtCounterEnabled,
      'qrPayEnabled': instance.qrPayEnabled,
      'serviceFeePercent': instance.serviceFeePercent,
      'serviceFeeFixed': instance.serviceFeeFixed,
    };
