import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee_models.freezed.dart';
part 'fee_models.g.dart';

/// Summary of service fees for a given period
@freezed
class FeeSummary with _$FeeSummary {
  const factory FeeSummary({
    /// Total service fees deducted
    required double totalServiceFees,

    /// Average fee percentage across all transactions
    required double averageFeePercent,

    /// Effective fee rate (total fees / total sales)
    required double effectiveFeeRate,

    /// Total gross sales in the period
    required double grossSales,

    /// Net amount before GST (gross - fees)
    required double netBeforeGst,
  }) = _FeeSummary;

  factory FeeSummary.fromJson(Map<String, dynamic> json) =>
      _$FeeSummaryFromJson(json);
}

/// Detailed breakdown of fees and sales
@freezed
class FeeBreakdown with _$FeeBreakdown {
  const factory FeeBreakdown({
    /// Gross sales amount
    required double grossSales,

    /// Platform fee amount (negative value for display)
    required double platformFee,

    /// Platform fee percentage
    required double feePercent,

    /// Net amount before GST (gross - fees)
    required double netBeforeGst,
  }) = _FeeBreakdown;

  factory FeeBreakdown.fromJson(Map<String, dynamic> json) =>
      _$FeeBreakdownFromJson(json);
}

/// Individual transaction with fee details
@freezed
class FeeTransaction with _$FeeTransaction {
  const factory FeeTransaction({
    /// Transaction date
    required DateTime date,

    /// Order ID or transaction reference
    required String orderId,

    /// Gross transaction amount
    required double grossAmount,

    /// Service fee deducted
    required double serviceFee,

    /// Fee percentage for this transaction
    required double feePercent,
  }) = _FeeTransaction;

  factory FeeTransaction.fromJson(Map<String, dynamic> json) =>
      _$FeeTransactionFromJson(json);
}

/// Complete service fees data for the page
@freezed
class ServiceFeesData with _$ServiceFeesData {
  const factory ServiceFeesData({
    required FeeSummary summary,
    required FeeBreakdown breakdown,
    required List<FeeTransaction> transactions,
  }) = _ServiceFeesData;

  factory ServiceFeesData.fromJson(Map<String, dynamic> json) =>
      _$ServiceFeesDataFromJson(json);
}
