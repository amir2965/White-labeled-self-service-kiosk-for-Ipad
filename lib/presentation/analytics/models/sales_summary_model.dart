import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_summary_model.freezed.dart';
part 'sales_summary_model.g.dart';

/// Sales summary data model for daily analytics
@freezed
class SalesSummaryModel with _$SalesSummaryModel {
  const factory SalesSummaryModel({
    required DateTime selectedDate,
    DateTime? compareDate,
    required double grossSales,
    required double netSales,
    required double taxes,
    @Default(0.0) double discounts,
    @Default(0.0) double returns,
    @Default(0.0) double tips,
    @Default(0.0) double serviceCharges,
    required double totalSales,
    required double totalCollected,
    required PaymentsBreakdown paymentsBreakdown,
    @Default([]) List<HourlySalesPoint> hourlySalesPointsSelectedDay,
    @Default([]) List<HourlySalesPoint> hourlySalesPointsCompareDay,
    required DateTime lastUpdated,
    @Default(0) int totalOrders,
    @Default(0.0) double productSales,
    // Enhanced analytics
    @Default([]) List<PaymentMethodTrend> paymentMethodTrends,
    @Default([]) List<KioskPerformance> kioskPerformances,
    @Default(0.0) double averageOrderValue,
    @Default(0) int peakHour,
    @Default(0.0) double peakHourSales,
  }) = _SalesSummaryModel;

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryModelFromJson(json);
}

/// Payments breakdown by method
@freezed
class PaymentsBreakdown with _$PaymentsBreakdown {
  const factory PaymentsBreakdown({
    @Default(0.0) double card,
    @Default(0.0) double cash,
    @Default(0.0) double giftCard,
    @Default(0.0) double other,
    @Default(0.0) double fees,
    // Kiosk-specific breakdown
    @Default(0.0) double qrCode,
    @Default(0.0) double payAtCounter,
    @Default(0) int qrCodeCount,
    @Default(0) int payAtCounterCount,
  }) = _PaymentsBreakdown;

  factory PaymentsBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PaymentsBreakdownFromJson(json);
}

/// Payment method performance over time
@freezed
class PaymentMethodTrend with _$PaymentMethodTrend {
  const factory PaymentMethodTrend({
    required DateTime timestamp,
    required double qrCodeAmount,
    required double payAtCounterAmount,
    required int qrCodeCount,
    required int payAtCounterCount,
  }) = _PaymentMethodTrend;

  factory PaymentMethodTrend.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodTrendFromJson(json);
}

/// Kiosk performance data
@freezed
class KioskPerformance with _$KioskPerformance {
  const factory KioskPerformance({
    required String kioskId,
    required String kioskName,
    required double totalSales,
    required int transactionCount,
    required double averageOrderValue,
    required double qrCodeSales,
    required double payAtCounterSales,
  }) = _KioskPerformance;

  factory KioskPerformance.fromJson(Map<String, dynamic> json) =>
      _$KioskPerformanceFromJson(json);
}

/// Hourly sales data point for chart
@freezed
class HourlySalesPoint with _$HourlySalesPoint {
  const factory HourlySalesPoint({
    required int hour, // 0-23
    required double sales,
  }) = _HourlySalesPoint;

  factory HourlySalesPoint.fromJson(Map<String, dynamic> json) =>
      _$HourlySalesPointFromJson(json);
}

/// Empty/initial state
extension SalesSummaryModelX on SalesSummaryModel {
  static SalesSummaryModel empty() {
    return SalesSummaryModel(
      selectedDate: DateTime.now(),
      grossSales: 0.0,
      netSales: 0.0,
      taxes: 0.0,
      totalSales: 0.0,
      totalCollected: 0.0,
      paymentsBreakdown: const PaymentsBreakdown(),
      lastUpdated: DateTime.now(),
      productSales: 0.0,
    );
  }
}
