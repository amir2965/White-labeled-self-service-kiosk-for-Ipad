import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/chart_models.dart';
import '../../models/sales_summary_model.dart';
import '../../utils/sales_chart_aggregator.dart';
import 'modern_chart_card.dart';
import 'modern_hourly_chart.dart';
import 'modern_daily_trend_chart.dart';
import 'modern_monthly_trend_chart.dart';
import 'modern_comparison_card.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_colors.dart';

/// **Modern Minimal Charts Section**
///
/// Intelligent chart selection:
/// - Single Day: Hourly revenue breakdown with peak hour analysis
/// - Multi Day: Daily trend + insights + comparisons
///
/// Design: Luxury minimal (black/blue/white)
/// Features: Contextual, informative, elegant
class SalesSummaryChartsSection extends ConsumerStatefulWidget {
  final DateTime selectedStartDate;
  final DateTime selectedEndDate;
  final List<HourlySalesPoint> hourlySalesData;
  final Map<String, double>? dailyData; // For multi-day periods
  final Map<int, double>?
  monthlyData; // For yearly periods (month 1-12 -> sales)
  final double totalRevenue;
  final int totalOrders;
  final double? previousPeriodRevenue; // For comparison
  final int? previousPeriodOrders;
  final bool isDarkMode;

  const SalesSummaryChartsSection({
    Key? key,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.hourlySalesData,
    required this.totalRevenue,
    required this.totalOrders,
    this.dailyData,
    this.monthlyData,
    this.previousPeriodRevenue,
    this.previousPeriodOrders,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  ConsumerState<SalesSummaryChartsSection> createState() =>
      _SalesSummaryChartsSectionState();
}

class _SalesSummaryChartsSectionState
    extends ConsumerState<SalesSummaryChartsSection> {
  bool get _isSingleDay {
    return widget.selectedStartDate.day == widget.selectedEndDate.day &&
        widget.selectedStartDate.month == widget.selectedEndDate.month &&
        widget.selectedStartDate.year == widget.selectedEndDate.year;
  }

  bool get _isYearlyPeriod {
    // Check if this is a yearly period (This Year or Previous Year)
    // Start date must be January 1st of any year
    final isYearlyStart =
        widget.selectedStartDate.month == 1 &&
        widget.selectedStartDate.day == 1;

    // For "This Year": end date could be today (mid-year) or Dec 31
    // For "Previous Year": end date should be Dec 31 of same year as start
    final isYearlyEnd =
        (widget.selectedEndDate.month == 12 &&
            widget.selectedEndDate.day == 31) ||
        (widget.selectedStartDate.year == DateTime.now().year &&
            widget.selectedEndDate.year == DateTime.now().year);

    final sameYear =
        widget.selectedStartDate.year == widget.selectedEndDate.year;

    return isYearlyStart && isYearlyEnd && sameYear;
  }

  bool get _isToday {
    final now = DateTime.now();
    return widget.selectedStartDate.day == now.day &&
        widget.selectedStartDate.month == now.month &&
        widget.selectedStartDate.year == now.year;
  }

  int? get _currentHour {
    if (_isSingleDay && _isToday) {
      return DateTime.now().hour;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode indicator
        _buildModeIndicator(),

        const SizedBox(height: AppSpacing.lg),

        if (_isSingleDay) _buildSingleDayView() else _buildMultiDayView(),
      ],
    );
  }

  Widget _buildModeIndicator() {
    final days =
        widget.selectedEndDate.difference(widget.selectedStartDate).inDays + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : AppColors.gray50,
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : AppColors.gray200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isSingleDay ? Icons.schedule : Icons.calendar_today,
            size: 14,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.7)
                : AppColors.gray600,
          ),
          const SizedBox(width: 6),
          Text(
            _isSingleDay
                ? (_isToday ? 'Today\'s Performance' : 'Single Day Analysis')
                : 'Multi-Day Analysis ($days days)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode
                  ? Colors.white.withOpacity(0.9)
                  : AppColors.gray700,
            ),
          ),
          if (_isToday) ...[
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleDayView() {
    final insights = _generateSingleDayInsights();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main hourly chart
        ModernChartCard(
          title: 'Hourly Revenue Breakdown',
          subtitle: _isToday
              ? 'Real-time sales performance by hour'
              : 'Sales performance by hour on ${_formatDate(widget.selectedStartDate)}',
          metric: '\$${widget.totalRevenue.toStringAsFixed(0)}',
          timeframe: _isToday
              ? 'Live Updates'
              : _formatDate(widget.selectedStartDate),
          insightText: insights.isNotEmpty ? insights.first : null,
          insightIcon: Icons.access_time,
          isDarkMode: widget.isDarkMode,
          chart: ModernHourlyChart(
            data: widget.hourlySalesData,
            currentHour: _currentHour,
            maxHeight: 280,
            isDarkMode: widget.isDarkMode,
          ),
        ),

        // Comparison if available
        if (widget.previousPeriodRevenue != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ModernComparisonCard(
                  title: 'Revenue',
                  currentValue: widget.totalRevenue,
                  previousValue: widget.previousPeriodRevenue,
                  customLabel: 'vs previous day',
                  isDarkMode: widget.isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ModernComparisonCard(
                  title: 'Orders',
                  currentValue: widget.totalOrders.toDouble(),
                  previousValue: widget.previousPeriodOrders?.toDouble(),
                  customLabel: 'vs previous day',
                  isRevenueMetric: false,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            ],
          ),
        ],

        // Insights panel
        if (insights.length > 1) ...[
          const SizedBox(height: AppSpacing.lg),
          ModernInsightsPanel(
            insights: insights.skip(1).toList(),
            isDarkMode: widget.isDarkMode,
          ),
        ],
      ],
    );
  }

  Widget _buildMultiDayView() {
    final insights = _generateMultiDayInsights();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Monthly trend chart for yearly periods
        if (_isYearlyPeriod && widget.monthlyData != null) ...[
          ModernChartCard(
            title: 'Monthly Revenue Trend',
            subtitle:
                'Sales performance across ${widget.selectedStartDate.year}',
            metric: '\$${_formatLargeNumber(widget.totalRevenue)}',
            timeframe: 'Year ${widget.selectedStartDate.year}',
            insightText: insights.isNotEmpty ? insights.first : null,
            insightIcon: Icons.calendar_month,
            isDarkMode: widget.isDarkMode,
            chart: ModernMonthlyTrendChart(
              monthlyData: widget.monthlyData!,
              year: widget.selectedStartDate.year,
              maxHeight: 320,
              isDarkMode: widget.isDarkMode,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],

        // Daily trend chart for non-yearly periods
        if (!_isYearlyPeriod && widget.dailyData != null) ...[
          ModernChartCard(
            title: 'Daily Revenue Trend',
            subtitle: 'Sales performance across ${_getDayCount()} days',
            metric: '\$${widget.totalRevenue.toStringAsFixed(0)}',
            timeframe:
                '${_formatDate(widget.selectedStartDate)} - ${_formatDate(widget.selectedEndDate)}',
            insightText: insights.isNotEmpty ? insights.first : null,
            insightIcon: Icons.trending_up,
            isDarkMode: widget.isDarkMode,
            chart: ModernDailyTrendChart(
              dailyData: widget.dailyData!,
              startDate: widget.selectedStartDate,
              endDate: widget.selectedEndDate,
              maxHeight: 280,
              isDarkMode: widget.isDarkMode,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],

        // Average hourly pattern
        ModernChartCard(
          title: 'Average Hourly Pattern',
          subtitle:
              'Typical sales distribution across hours (averaged over ${_getDayCount()} days)',
          timeframe: 'Aggregate View',
          insightText: 'Identify your busiest hours to optimize staffing',
          insightIcon: Icons.schedule,
          isDarkMode: widget.isDarkMode,
          chart: ModernHourlyChart(
            data: _calculateAverageHourlyData(),
            maxHeight: 240,
            showLabels: true,
            isDarkMode: widget.isDarkMode,
          ),
        ),

        // Comparisons
        if (widget.previousPeriodRevenue != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ModernComparisonCard(
                  title: 'Total Revenue',
                  currentValue: widget.totalRevenue,
                  previousValue: widget.previousPeriodRevenue,
                  customLabel: 'vs previous period',
                  isDarkMode: widget.isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ModernComparisonCard(
                  title: 'Total Orders',
                  currentValue: widget.totalOrders.toDouble(),
                  previousValue: widget.previousPeriodOrders?.toDouble(),
                  customLabel: 'vs previous period',
                  isRevenueMetric: false,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            ],
          ),
        ],

        // Daily average card
        const SizedBox(height: AppSpacing.lg),
        _buildDailyAverageCard(),

        // Insights
        if (insights.length > 1) ...[
          const SizedBox(height: AppSpacing.lg),
          ModernInsightsPanel(
            title: 'Period Insights',
            insights: insights.skip(1).toList(),
            isDarkMode: widget.isDarkMode,
          ),
        ],
      ],
    );
  }

  Widget _buildDailyAverageCard() {
    final days = _getDayCount();
    final avgDaily = widget.totalRevenue / days;
    final avgOrders = widget.totalOrders / days;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildAverageMetric(
              'Daily Avg Revenue',
              '\$${avgDaily.toStringAsFixed(0)}',
              Icons.attach_money,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
          ),
          Expanded(
            child: _buildAverageMetric(
              'Daily Avg Orders',
              avgOrders.toStringAsFixed(0),
              Icons.receipt_long,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
          ),
          Expanded(
            child: _buildAverageMetric(
              'Avg Order Value',
              '\$${(widget.totalRevenue / widget.totalOrders).toStringAsFixed(2)}',
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.6)
              : AppColors.gray500,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.7)
                : AppColors.gray600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: widget.isDarkMode ? Colors.white : AppColors.black,
          ),
        ),
      ],
    );
  }

  List<HourlySalesPoint> _calculateAverageHourlyData() {
    // Group hourly data and average it
    final days = _getDayCount();
    final hourlyTotals = <int, double>{};

    for (final point in widget.hourlySalesData) {
      hourlyTotals[point.hour] = (hourlyTotals[point.hour] ?? 0) + point.sales;
    }

    return List.generate(24, (hour) {
      final total = hourlyTotals[hour] ?? 0;
      final avg = days > 0 ? total / days : 0;
      return HourlySalesPoint(hour: hour, sales: avg.toDouble());
    });
  }

  List<String> _generateSingleDayInsights() {
    final insights = <String>[];

    if (widget.hourlySalesData.isEmpty) return insights;

    // Find peak hour
    final peakPoint = widget.hourlySalesData.reduce(
      (a, b) => a.sales > b.sales ? a : b,
    );
    insights.add(
      'Peak hour: ${_formatHourRange(peakPoint.hour)} with \$${peakPoint.sales.toStringAsFixed(0)} in sales',
    );

    // Compare to previous period
    if (widget.previousPeriodRevenue != null &&
        widget.previousPeriodRevenue! > 0) {
      final change = widget.totalRevenue - widget.previousPeriodRevenue!;
      final changePercent = (change / widget.previousPeriodRevenue!) * 100;

      if (changePercent > 10) {
        insights.add(
          'Revenue is up ${changePercent.toStringAsFixed(1)}% compared to previous day - excellent performance!',
        );
      } else if (changePercent < -10) {
        insights.add(
          'Revenue is down ${changePercent.abs().toStringAsFixed(1)}% compared to previous day',
        );
      }
    }

    // Business hours analysis
    final businessHours = widget.hourlySalesData.where(
      (p) => p.hour >= 9 && p.hour <= 17,
    );
    if (businessHours.isNotEmpty) {
      final businessTotal = businessHours.fold<double>(
        0,
        (sum, p) => sum + p.sales,
      );
      final businessPercent = (businessTotal / widget.totalRevenue) * 100;
      insights.add(
        '${businessPercent.toStringAsFixed(0)}% of sales occurred during business hours (9 AM - 5 PM)',
      );
    }

    return insights;
  }

  List<String> _generateMultiDayInsights() {
    final insights = <String>[];

    final days = _getDayCount();
    final avgDaily = widget.totalRevenue / days;

    insights.add(
      'Average daily revenue: \$${avgDaily.toStringAsFixed(0)} over $days days',
    );

    // Find best day
    if (widget.dailyData != null && widget.dailyData!.isNotEmpty) {
      final bestDay = widget.dailyData!.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final bestDate = DateTime.parse(bestDay.key);
      insights.add(
        'Best performing day: ${_formatDate(bestDate)} with \$${bestDay.value.toStringAsFixed(0)}',
      );
    }

    // Trend analysis
    if (widget.previousPeriodRevenue != null &&
        widget.previousPeriodRevenue! > 0) {
      final change = widget.totalRevenue - widget.previousPeriodRevenue!;
      final changePercent = (change / widget.previousPeriodRevenue!) * 100;

      if (changePercent.abs() > 5) {
        insights.add(
          'Period-over-period ${changePercent > 0 ? 'growth' : 'decline'}: ${changePercent.abs().toStringAsFixed(1)}%',
        );
      }
    }

    // Order volume analysis
    final avgOrders = widget.totalOrders / days;
    insights.add('Average of ${avgOrders.toStringAsFixed(0)} orders per day');

    return insights;
  }

  int _getDayCount() {
    return widget.selectedEndDate.difference(widget.selectedStartDate).inDays +
        1;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _formatHourRange(int hour) {
    final start = hour;
    final end = (hour + 1) % 24;
    return '${_formatHourLabel(start)}-${_formatHourLabel(end)}';
  }

  String _formatHourLabel(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  String _formatLargeNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
