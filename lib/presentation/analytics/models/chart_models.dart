import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_models.freezed.dart';
part 'chart_models.g.dart';

/// Represents a single sales event/transaction for analytics
@freezed
class SalesEvent with _$SalesEvent {
  const factory SalesEvent({
    required String id,
    required DateTime timestampUTC,
    required double amountGross,
    required double amountNet,
    required double tax,
    required String paymentMethod,
    required SalesEventStatus status,
    String? deviceId,
    String? venueId,
    String? orderId,
  }) = _SalesEvent;

  factory SalesEvent.fromJson(Map<String, dynamic> json) =>
      _$SalesEventFromJson(json);
}

enum SalesEventStatus { paid, refunded, voided, pending }

/// A single point on a chart
@freezed
class ChartPoint with _$ChartPoint {
  const factory ChartPoint({
    required DateTime x,
    required double grossSales,
    required int paymentsCount,
    double? netSales,
    double? tax,
    String? label, // e.g., "10:00 AM" or "Monday"
  }) = _ChartPoint;

  factory ChartPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartPointFromJson(json);
}

/// Complete chart data for Sales Summary section
@freezed
class SalesSummaryChartsData with _$SalesSummaryChartsData {
  const factory SalesSummaryChartsData({
    // Time of Day chart (hourly 0-23)
    required List<ChartPoint> timeOfDaySelectedSeries,
    required List<ChartPoint> timeOfDayCompareSeries,

    // Period Trend chart (daily points across range)
    required List<ChartPoint> periodTrendSeries,
    List<ChartPoint>? periodTrendCompareSeries,

    // Day of Week chart (7 bars: Sun-Sat)
    required Map<int, double>
    dayOfWeekTotals, // weekday (1=Mon, 7=Sun) -> amount
    required Map<int, int> dayOfWeekPayments,

    // Metadata
    required DateTime lastUpdatedAt,
    required DateTime selectedStartDate,
    required DateTime selectedEndDate,
    DateTime? compareStartDate,
    DateTime? compareEndDate,

    // Summary stats
    required double totalGrossSales,
    required int totalPayments,
    double? compareTotalGrossSales,
    int? compareTotalPayments,
  }) = _SalesSummaryChartsData;

  factory SalesSummaryChartsData.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryChartsDataFromJson(json);
}

/// Chart display mode based on date selection
enum ChartDisplayMode {
  singleDay, // Show only Time of Day chart
  multiDay, // Show Period Trend + Day of Week + Time of Day
}

/// Time range selection on chart (brush selection)
@freezed
class TimeRangeSelection with _$TimeRangeSelection {
  const factory TimeRangeSelection({
    required int startHour, // 0-23
    required int endHour, // 0-23
    required double totalSales,
    required int paymentsCount,
  }) = _TimeRangeSelection;
}

/// Selected point for tooltip display
@freezed
class ChartPointSelection with _$ChartPointSelection {
  const factory ChartPointSelection({
    required ChartPoint point,
    ChartPoint? comparePoint,
    required String dateLabel,
    String? compareDateLabel,
  }) = _ChartPointSelection;
}
