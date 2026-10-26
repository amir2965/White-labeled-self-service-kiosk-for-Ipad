import 'package:intl/intl.dart';
import '../models/chart_models.dart';

/// Aggregates sales events into chart data structures
class SalesChartAggregator {
  /// Build complete charts data from sales events
  static SalesSummaryChartsData buildChartsData({
    required List<SalesEvent> selectedEvents,
    required DateTime selectedStartDate,
    required DateTime selectedEndDate,
    List<SalesEvent>? compareEvents,
    DateTime? compareStartDate,
    DateTime? compareEndDate,
    DateTime? reportingDayStart, // For custom business hours
  }) {
    // Filter valid events (exclude voids, handle refunds)
    final validEvents = _filterValidEvents(selectedEvents);
    final validCompareEvents = compareEvents != null
        ? _filterValidEvents(compareEvents)
        : <SalesEvent>[];

    // Build Time of Day series (hourly 0-23)
    final timeOfDaySelected = _buildHourlySeries(
      validEvents,
      selectedStartDate,
      selectedEndDate,
      reportingDayStart,
    );

    final timeOfDayCompare = _buildHourlySeries(
      validCompareEvents,
      compareStartDate ?? selectedStartDate,
      compareEndDate ?? selectedEndDate,
      reportingDayStart,
    );

    // Build Period Trend series (daily points)
    final periodTrend = _buildDailySeries(
      validEvents,
      selectedStartDate,
      selectedEndDate,
    );

    final periodTrendCompare = compareEvents != null
        ? _buildDailySeries(
            validCompareEvents,
            compareStartDate!,
            compareEndDate!,
          )
        : null;

    // Build Day of Week totals
    final dayOfWeekData = _buildDayOfWeekTotals(
      validEvents,
      selectedStartDate,
      selectedEndDate,
    );

    // Calculate summary stats
    final totalGross = validEvents.fold<double>(
      0,
      (sum, e) => sum + e.amountGross,
    );
    final totalPayments = validEvents.length;

    final compareTotalGross = validCompareEvents.isNotEmpty
        ? validCompareEvents.fold<double>(0, (sum, e) => sum + e.amountGross)
        : null;
    final compareTotalPayments = validCompareEvents.isNotEmpty
        ? validCompareEvents.length
        : null;

    return SalesSummaryChartsData(
      timeOfDaySelectedSeries: timeOfDaySelected,
      timeOfDayCompareSeries: timeOfDayCompare,
      periodTrendSeries: periodTrend,
      periodTrendCompareSeries: periodTrendCompare,
      dayOfWeekTotals: dayOfWeekData.totals,
      dayOfWeekPayments: dayOfWeekData.payments,
      lastUpdatedAt: DateTime.now(),
      selectedStartDate: selectedStartDate,
      selectedEndDate: selectedEndDate,
      compareStartDate: compareStartDate,
      compareEndDate: compareEndDate,
      totalGrossSales: totalGross,
      totalPayments: totalPayments,
      compareTotalGrossSales: compareTotalGross,
      compareTotalPayments: compareTotalPayments,
    );
  }

  /// Filter out invalid events (voids, optionally refunds)
  static List<SalesEvent> _filterValidEvents(List<SalesEvent> events) {
    return events.where((e) {
      // Exclude voids completely
      if (e.status == SalesEventStatus.voided) return false;

      // Include paid and refunded (refunds reduce totals)
      return e.status == SalesEventStatus.paid ||
          e.status == SalesEventStatus.refunded;
    }).toList();
  }

  /// Build hourly series (0-23 hours)
  static List<ChartPoint> _buildHourlySeries(
    List<SalesEvent> events,
    DateTime startDate,
    DateTime endDate,
    DateTime? reportingDayStart,
  ) {
    // Initialize 24 hours with zero values
    final hourlyData = List.generate(
      24,
      (hour) => {'grossSales': 0.0, 'paymentsCount': 0},
    );

    // Aggregate events by hour
    for (final event in events) {
      final localTime = event.timestampUTC.toLocal();
      final hour = localTime.hour;

      // Adjust for gross vs net based on status
      final amount = event.status == SalesEventStatus.refunded
          ? -event
                .amountGross // Refunds reduce totals
          : event.amountGross;

      hourlyData[hour]['grossSales'] =
          (hourlyData[hour]['grossSales'] as double) + amount;
      hourlyData[hour]['paymentsCount'] =
          (hourlyData[hour]['paymentsCount'] as int) + 1;
    }

    // Convert to ChartPoint list
    return List.generate(24, (hour) {
      final date = DateTime(2026, 1, 1, hour, 0); // Date placeholder for x-axis
      return ChartPoint(
        x: date,
        grossSales: hourlyData[hour]['grossSales'] as double,
        paymentsCount: hourlyData[hour]['paymentsCount'] as int,
        label: DateFormat('h a').format(date), // "10 AM"
      );
    });
  }

  /// Build daily series for period trend chart
  static List<ChartPoint> _buildDailySeries(
    List<SalesEvent> events,
    DateTime startDate,
    DateTime endDate,
  ) {
    final daysDiff = endDate.difference(startDate).inDays + 1;
    final dailyData = <DateTime, Map<String, dynamic>>{};

    // Initialize all days in range
    for (int i = 0; i < daysDiff; i++) {
      final day = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      ).add(Duration(days: i));
      dailyData[day] = {'grossSales': 0.0, 'paymentsCount': 0};
    }

    // Aggregate events by day
    for (final event in events) {
      final localTime = event.timestampUTC.toLocal();
      final day = DateTime(localTime.year, localTime.month, localTime.day);

      if (dailyData.containsKey(day)) {
        final amount = event.status == SalesEventStatus.refunded
            ? -event.amountGross
            : event.amountGross;

        dailyData[day]!['grossSales'] =
            (dailyData[day]!['grossSales'] as double) + amount;
        dailyData[day]!['paymentsCount'] =
            (dailyData[day]!['paymentsCount'] as int) + 1;
      }
    }

    // Convert to ChartPoint list
    return dailyData.entries.map((entry) {
      return ChartPoint(
        x: entry.key,
        grossSales: entry.value['grossSales'] as double,
        paymentsCount: entry.value['paymentsCount'] as int,
        label: DateFormat('d MMM').format(entry.key), // "29 Jan"
      );
    }).toList()..sort((a, b) => a.x.compareTo(b.x));
  }

  /// Build day-of-week totals (1=Monday, 7=Sunday)
  static ({Map<int, double> totals, Map<int, int> payments})
  _buildDayOfWeekTotals(
    List<SalesEvent> events,
    DateTime startDate,
    DateTime endDate,
  ) {
    final totals = <int, double>{};
    final payments = <int, int>{};

    // Initialize all weekdays
    for (int weekday = 1; weekday <= 7; weekday++) {
      totals[weekday] = 0.0;
      payments[weekday] = 0;
    }

    // Aggregate by weekday
    for (final event in events) {
      final localTime = event.timestampUTC.toLocal();
      final weekday = localTime.weekday; // 1=Mon, 7=Sun

      final amount = event.status == SalesEventStatus.refunded
          ? -event.amountGross
          : event.amountGross;

      totals[weekday] = totals[weekday]! + amount;
      payments[weekday] = payments[weekday]! + 1;
    }

    return (totals: totals, payments: payments);
  }

  /// Calculate time range selection summary
  static TimeRangeSelection calculateTimeRangeStats({
    required List<ChartPoint> hourlyData,
    required int startHour,
    required int endHour,
  }) {
    double totalSales = 0;
    int paymentsCount = 0;

    final start = startHour.clamp(0, 23);
    final end = endHour.clamp(0, 23);

    for (int hour = start; hour <= end; hour++) {
      if (hour < hourlyData.length) {
        totalSales += hourlyData[hour].grossSales;
        paymentsCount += hourlyData[hour].paymentsCount;
      }
    }

    return TimeRangeSelection(
      startHour: start,
      endHour: end,
      totalSales: totalSales,
      paymentsCount: paymentsCount,
    );
  }

  /// Get comparison period dates (previous year, same weekday)
  static Map<String, DateTime> getComparisonPeriod({
    required DateTime selectedStart,
    required DateTime selectedEnd,
    bool useClosestWeekday = true,
  }) {
    if (useClosestWeekday) {
      // Find same weekday in previous year
      final oneYearAgo = DateTime(
        selectedStart.year - 1,
        selectedStart.month,
        selectedStart.day,
      );

      final weekdayDiff = selectedStart.weekday - oneYearAgo.weekday;
      final adjustedStart = oneYearAgo.add(Duration(days: weekdayDiff));

      final duration = selectedEnd.difference(selectedStart);
      final adjustedEnd = adjustedStart.add(duration);

      return {'start': adjustedStart, 'end': adjustedEnd};
    } else {
      // Simple previous year
      return {
        'start': DateTime(
          selectedStart.year - 1,
          selectedStart.month,
          selectedStart.day,
        ),
        'end': DateTime(
          selectedEnd.year - 1,
          selectedEnd.month,
          selectedEnd.day,
        ),
      };
    }
  }

  /// Generate mock sales events for testing
  static List<SalesEvent> generateMockEvents({
    required DateTime startDate,
    required DateTime endDate,
    int eventsPerDay = 20,
  }) {
    final events = <SalesEvent>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    final daysDiff = endDate.difference(startDate).inDays + 1;

    for (int day = 0; day < daysDiff; day++) {
      final currentDay = startDate.add(Duration(days: day));

      for (int i = 0; i < eventsPerDay; i++) {
        // Distribute events across business hours (8 AM - 8 PM)
        final hour = 8 + ((random + i + day) % 12);
        final minute = (random + i * 7) % 60;

        final timestamp = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          hour,
          minute,
        );

        // Vary amounts realistically
        final baseAmount = 15.0 + ((random + i) % 50);
        final grossAmount = (baseAmount * 1.1).roundToDouble(); // With tax

        events.add(
          SalesEvent(
            id: 'mock-$day-$i',
            timestampUTC: timestamp.toUtc(),
            amountGross: grossAmount,
            amountNet: baseAmount,
            tax: grossAmount - baseAmount,
            paymentMethod: i % 3 == 0
                ? 'card'
                : (i % 3 == 1 ? 'qr' : 'counter'),
            status: SalesEventStatus.paid,
            deviceId: 'device-1',
            venueId: 'venue-1',
          ),
        );
      }
    }

    return events;
  }
}
