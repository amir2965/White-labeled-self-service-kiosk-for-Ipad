import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant.freezed.dart';
part 'merchant.g.dart';

@freezed
class Merchant with _$Merchant {
  const factory Merchant({
    required String id,
    required String businessName,
    String? abn,
    required String contactEmail,
    required BusinessType businessType,
    required DateTime createdAt,
    required bool isActive,
    PaymentConfig? paymentConfig,
  }) = _Merchant;

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
}

enum BusinessType { restaurant, cafe, retail, clinic, other }

@freezed
class PaymentConfig with _$PaymentConfig {
  const factory PaymentConfig({
    required bool payAtCounterEnabled,
    required bool qrPayEnabled,
    @Default(2.0) double serviceFeePercent,
    @Default(0.0) double serviceFeeFixed,
  }) = _PaymentConfig;

  factory PaymentConfig.fromJson(Map<String, dynamic> json) =>
      _$PaymentConfigFromJson(json);
}
