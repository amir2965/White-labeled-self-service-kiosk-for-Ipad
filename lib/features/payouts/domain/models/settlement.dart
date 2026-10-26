import 'money.dart';
import 'payout_status.dart';

/// Represents a single settlement/payout to the merchant's bank account
class Settlement {
  final String id;
  final DateTime createdAt;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Money gross;
  final Money fees;
  final Money gst;
  final Money netPaid;
  final PayoutStatus status;
  final String destinationBankLast4;
  final String reference;
  final String? failureReason;

  const Settlement({
    required this.id,
    required this.createdAt,
    required this.periodStart,
    required this.periodEnd,
    required this.gross,
    required this.fees,
    required this.gst,
    required this.netPaid,
    required this.status,
    required this.destinationBankLast4,
    required this.reference,
    this.failureReason,
  });

  Settlement copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? periodStart,
    DateTime? periodEnd,
    Money? gross,
    Money? fees,
    Money? gst,
    Money? netPaid,
    PayoutStatus? status,
    String? destinationBankLast4,
    String? reference,
    String? failureReason,
  }) {
    return Settlement(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      gross: gross ?? this.gross,
      fees: fees ?? this.fees,
      gst: gst ?? this.gst,
      netPaid: netPaid ?? this.netPaid,
      status: status ?? this.status,
      destinationBankLast4: destinationBankLast4 ?? this.destinationBankLast4,
      reference: reference ?? this.reference,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}
