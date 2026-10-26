import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_session.freezed.dart';
part 'payment_session.g.dart';

@freezed
class PaymentSession with _$PaymentSession {
  const factory PaymentSession({
    required String id,
    required String orderId,
    required String merchantId,
    required double amountItems,
    required double feeAmount,
    required double amountTotal,
    required PaymentSessionStatus status,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? paidAt,
    String? paymentIntentId,
    Map<String, dynamic>? metadata,
  }) = _PaymentSession;

  factory PaymentSession.fromJson(Map<String, dynamic> json) =>
      _$PaymentSessionFromJson(json);
}

enum PaymentSessionStatus { created, pending, paid, expired, cancelled, failed }

extension PaymentSessionStatusX on PaymentSessionStatus {
  bool get isActive =>
      this == PaymentSessionStatus.created ||
      this == PaymentSessionStatus.pending;
  bool get isComplete => this == PaymentSessionStatus.paid;
  bool get isFailed =>
      this == PaymentSessionStatus.failed ||
      this == PaymentSessionStatus.expired ||
      this == PaymentSessionStatus.cancelled;
}
