import 'package:flutter/foundation.dart';

/// Analytics data state
class AnalyticsState {
  final DateTime selectedDate;
  final CompareMode compareMode;
  final BillStatus billStatus;
  final AnalyticsValues values;
  final List<ChartPoint> chartPointsToday;
  final List<ChartPoint> chartPointsPreviousDay;
  final bool isLoading;

  const AnalyticsState({
    required this.selectedDate,
    required this.compareMode,
    required this.billStatus,
    required this.values,
    this.chartPointsToday = const [],
    this.chartPointsPreviousDay = const [],
    this.isLoading = false,
  });

  AnalyticsState copyWith({
    DateTime? selectedDate,
    CompareMode? compareMode,
    BillStatus? billStatus,
    AnalyticsValues? values,
    List<ChartPoint>? chartPointsToday,
    List<ChartPoint>? chartPointsPreviousDay,
    bool? isLoading,
  }) {
    return AnalyticsState(
      selectedDate: selectedDate ?? this.selectedDate,
      compareMode: compareMode ?? this.compareMode,
      billStatus: billStatus ?? this.billStatus,
      values: values ?? this.values,
      chartPointsToday: chartPointsToday ?? this.chartPointsToday,
      chartPointsPreviousDay:
          chartPointsPreviousDay ?? this.chartPointsPreviousDay,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Analytics metric values
class AnalyticsValues {
  final double netSales;
  final double grossSales;
  final double labourPercent;
  final double compsDiscounts;
  final int transactions;
  final double avgSale;
  final double tips;
  final String? netSalesDelta;
  final String? grossSalesDelta;
  final String? labourPercentDelta;
  final String? compsDiscountsDelta;
  final String? transactionsDelta;
  final String? avgSaleDelta;
  final String? tipsDelta;

  const AnalyticsValues({
    this.netSales = 0.0,
    this.grossSales = 0.0,
    this.labourPercent = 0.0,
    this.compsDiscounts = 0.0,
    this.transactions = 0,
    this.avgSale = 0.0,
    this.tips = 0.0,
    this.netSalesDelta,
    this.grossSalesDelta,
    this.labourPercentDelta,
    this.compsDiscountsDelta,
    this.transactionsDelta,
    this.avgSaleDelta,
    this.tipsDelta,
  });
}

/// Chart data point
class ChartPoint {
  final DateTime time;
  final double value;

  const ChartPoint({required this.time, required this.value});
}

/// Compare mode options
enum CompareMode { priorDay, priorWeek, priorMonth, none }

extension CompareModeExtension on CompareMode {
  String get label {
    switch (this) {
      case CompareMode.priorDay:
        return 'vs. Prior day';
      case CompareMode.priorWeek:
        return 'vs. Prior week';
      case CompareMode.priorMonth:
        return 'vs. Prior month';
      case CompareMode.none:
        return 'No comparison';
    }
  }
}

/// Bill status filter
enum BillStatus { all, closed, open }

extension BillStatusExtension on BillStatus {
  String get label {
    switch (this) {
      case BillStatus.all:
        return 'Bills | All';
      case BillStatus.closed:
        return 'Bills | Closed';
      case BillStatus.open:
        return 'Bills | Open';
    }
  }
}
