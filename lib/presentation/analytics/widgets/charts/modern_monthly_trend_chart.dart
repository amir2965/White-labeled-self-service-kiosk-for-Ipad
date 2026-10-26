import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'chart_crosshair_tooltip.dart';

/// Modern minimal monthly trend chart
/// Shows monthly revenue over a full year with bar + line visualization
class ModernMonthlyTrendChart extends StatefulWidget {
  final Map<int, double> monthlyData; // month (1-12) -> sales
  final int year;
  final double maxHeight;
  final bool isDarkMode;
  final Map<int, double>? comparisonData; // For previous year
  final Function(int month, double sales)? onMonthTap;

  const ModernMonthlyTrendChart({
    super.key,
    required this.monthlyData,
    required this.year,
    this.maxHeight = 320,
    this.isDarkMode = false,
    this.comparisonData,
    this.onMonthTap,
  });

  @override
  State<ModernMonthlyTrendChart> createState() =>
      _ModernMonthlyTrendChartState();
}

class _ModernMonthlyTrendChartState extends State<ModernMonthlyTrendChart> {
  int? _hoveredMonth;
  int? _pinnedMonth;
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.monthlyData.isEmpty) {
      return _buildEmptyState();
    }

    // Filter out zero values for calculations
    final nonZeroValues = widget.monthlyData.values
        .where((v) => v > 0)
        .toList();

    if (nonZeroValues.isEmpty) {
      return _buildEmptyState();
    }

    final totalSales = nonZeroValues.reduce((a, b) => a + b);
    final avgSales = totalSales / nonZeroValues.length;
    final maxSales = nonZeroValues.reduce((a, b) => a > b ? a : b);
    final minSales = nonZeroValues.reduce((a, b) => a < b ? a : b);

    // Find peak month (from all data including zeros)
    final peakMonth = widget.monthlyData.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stats row
        _buildStatsRow(totalSales, avgSales, peakMonth),

        const SizedBox(height: AppSpacing.lg),

        // Chart with crosshair overlay
        SizedBox(
          height: widget.maxHeight,
          child: Stack(
            children: [
              // Chart bars
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-axis labels
                  _buildYAxisLabels(maxSales, minSales),

                  const SizedBox(width: AppSpacing.sm),

                  // Bars
                  Expanded(
                    key: _chartKey,
                    child: CustomPaint(
                      painter: _MonthlyTrendPainter(
                        monthlyData: widget.monthlyData,
                        comparisonData: widget.comparisonData,
                        maxSales: maxSales,
                        minSales: minSales,
                        hoveredMonth: _hoveredMonth,
                        pinnedMonth: _pinnedMonth,
                        year: widget.year,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(12, (index) {
                          final month = index + 1;
                          return Expanded(
                            child: _buildMonthBar(
                              month,
                              maxSales,
                              minSales,
                              totalSales,
                              avgSales,
                              peakMonth.key,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              // Crosshair tooltip overlay
              if (_hoveredMonth != null || _pinnedMonth != null)
                _buildCrosshairOverlay(
                  month: _pinnedMonth ?? _hoveredMonth!,
                  maxSales: maxSales,
                  minSales: minSales,
                  totalSales: totalSales,
                  avgSales: avgSales,
                  peakMonth: peakMonth.key,
                ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // X-axis labels (month names)
        _buildXAxisLabels(),

        // Legend if comparison
        if (widget.comparisonData != null) ...[
          const SizedBox(height: AppSpacing.md),
          _buildLegend(),
        ],
      ],
    );
  }

  Widget _buildStatsRow(
    double total,
    double avg,
    MapEntry<int, double> peakMonth,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _buildStatPill(
          'Total Revenue',
          '\$${_formatLargeNumber(total)}',
          Icons.attach_money,
        ),
        _buildStatPill(
          'Monthly Average',
          '\$${_formatLargeNumber(avg)}',
          Icons.show_chart,
        ),
        _buildStatPill(
          'Peak Month',
          '${_getMonthName(peakMonth.key)} (\$${_formatLargeNumber(peakMonth.value)})',
          Icons.star_outline,
        ),
        _buildStatPill('Year', widget.year.toString(), Icons.calendar_today),
      ],
    );
  }

  Widget _buildStatPill(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.gray600),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabels(double maxSales, double minSales) {
    final range = maxSales - minSales;
    final effectiveRange = range > 0 ? range : maxSales;

    return SizedBox(
      width: 60,
      height: widget.maxHeight,
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Top label (maxSales)
            _buildYLabel('\$${_formatLargeNumber(maxSales)}'),
            // 75% of range
            _buildYLabel(
              '\$${_formatLargeNumber(minSales + effectiveRange * 0.75)}',
            ),
            // 50% of range
            _buildYLabel(
              '\$${_formatLargeNumber(minSales + effectiveRange * 0.5)}',
            ),
            // 25% of range
            _buildYLabel(
              '\$${_formatLargeNumber(minSales + effectiveRange * 0.25)}',
            ),
            // Bottom label (minSales)
            _buildYLabel('\$${_formatLargeNumber(minSales)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildYLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.gray500,
      ),
    );
  }

  Widget _buildMonthBar(
    int month,
    double maxSales,
    double minSales,
    double totalSales,
    double avgSales,
    int peakMonth,
  ) {
    final sales = widget.monthlyData[month] ?? 0;
    final range = maxSales - minSales;
    final effectiveRange = range > 0 ? range : maxSales;

    // Calculate height fraction based on data range
    // This represents how much of the available height the bar should occupy
    double heightFraction;
    if (sales <= 0) {
      heightFraction = 0.0;
    } else if (effectiveRange > 0) {
      heightFraction = (sales - minSales) / effectiveRange;
    } else {
      heightFraction = 1.0; // Full height if all values are the same
    }

    final isPeakMonth = month == peakMonth;
    final isCurrentMonth =
        widget.year == DateTime.now().year && month == DateTime.now().month;
    final isHovered = _hoveredMonth == month;

    Color barColor;
    if (isCurrentMonth) {
      barColor = AppColors.blue; // Current month - vibrant blue
    } else if (isPeakMonth) {
      barColor = AppColors.black; // Peak month - black
    } else if (sales > 0) {
      barColor = AppColors.gray400; // Regular data - gray
    } else {
      barColor = AppColors.gray200; // No data - light gray
    }

    if (isHovered) {
      barColor = AppColors.blue.withOpacity(0.8);
    }

    // Calculate actual bar height in pixels - round to prevent sub-pixel issues
    final barHeight = (widget.maxHeight * heightFraction).roundToDouble();

    // Remove border radius for near-full-height bars to prevent visual overflow
    // Border radius curves can make bars appear taller than they should be
    final shouldHaveBorderRadius = heightFraction < 0.95;

    return MouseRegion(
      onEnter: (_) {
        if (_pinnedMonth == null) {
          setState(() => _hoveredMonth = month);
        }
      },
      onExit: (_) {
        if (_pinnedMonth == null) {
          setState(() => _hoveredMonth = null);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_pinnedMonth == month) {
              _pinnedMonth = null; // Unpin if clicking same month
            } else {
              _pinnedMonth = month; // Pin this month
            }
          });
          widget.onMonthTap?.call(month, sales);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            height: widget.maxHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bar container with exact calculated height
                  // Remove border radius for peak bars to prevent visual height mismatch
                  ClipRRect(
                    borderRadius: shouldHaveBorderRadius
                        ? const BorderRadius.vertical(top: Radius.circular(4))
                        : BorderRadius.zero,
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: barColor,
                        boxShadow: isHovered
                            ? [
                                BoxShadow(
                                  color: barColor.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius:
                                      0, // No spread to prevent overlap
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  // Current month indicator dot
                  if (isCurrentMonth) ...[
                    const SizedBox(height: 4),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXAxisLabels() {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(12, (index) {
          final month = index + 1;
          final isCurrentMonth =
              widget.year == DateTime.now().year &&
              month == DateTime.now().month;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: isCurrentMonth
                ? BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  )
                : null,
            child: Text(
              _getMonthAbbr(month),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isCurrentMonth ? FontWeight.w700 : FontWeight.w600,
                color: isCurrentMonth ? AppColors.blue : AppColors.gray600,
                letterSpacing: 0.2,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCrosshairOverlay({
    required int month,
    required double maxSales,
    required double minSales,
    required double totalSales,
    required double avgSales,
    required int peakMonth,
  }) {
    final sales = widget.monthlyData[month] ?? 0;
    final previousYearSales = widget.comparisonData?[month];

    // Calculate crosshair position
    final chartBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (chartBox == null) return const SizedBox.shrink();

    final chartWidth = chartBox.size.width;
    final barWidth = chartWidth / 12;
    final xPosition = ((month - 1) + 0.5) * barWidth; // Center of the bar

    // Calculate Y position at the top of the bar using SAME coordinate system as bars
    // Use the passed minSales/maxSales to ensure perfect alignment
    final range = maxSales - minSales;
    final effectiveRange = range > 0 ? range : maxSales;

    // Height fraction: how high the bar is (0.0 to 1.0)
    final heightFraction = effectiveRange > 0 && sales > 0
        ? (sales - minSales) / effectiveRange
        : 0.0;

    // Y position from top: 0 at maxSales, maxHeight at minSales
    // For a bar at heightFraction, the top is at (1 - heightFraction) from top
    final yPosition = widget.maxHeight * (1 - heightFraction);

    return ChartCrosshairTooltip(
      position: Offset(xPosition, yPosition),
      chartHeight: widget.maxHeight,
      chartWidth: chartWidth,
      isPinned: _pinnedMonth == month,
      onDismiss: () => setState(() => _pinnedMonth = null),
      child: MonthlyTooltipContent(
        month: month,
        year: widget.year,
        sales: sales,
        totalSales: totalSales,
        avgSales: avgSales,
        previousYearSales: previousYearSales,
        isCurrentMonth:
            widget.year == DateTime.now().year && month == DateTime.now().month,
        isPeakMonth: month == peakMonth,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(AppColors.blue, '${widget.year}'),
        const SizedBox(width: AppSpacing.md),
        _buildLegendItem(AppColors.gray400, '${widget.year - 1}'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: widget.maxHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart, size: 48, color: AppColors.gray300),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'No monthly data available',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getMonthAbbr(int month) {
    const abbr = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return abbr[month - 1];
  }
}

/// Custom painter for monthly trend overlay (optional line chart)
class _MonthlyTrendPainter extends CustomPainter {
  final Map<int, double> monthlyData;
  final Map<int, double>? comparisonData;
  final double maxSales;
  final double minSales;
  final int? hoveredMonth;
  final int? pinnedMonth;
  final int year;

  _MonthlyTrendPainter({
    required this.monthlyData,
    required this.comparisonData,
    required this.maxSales,
    required this.minSales,
    required this.hoveredMonth,
    required this.pinnedMonth,
    required this.year,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Optional: Could draw trend line overlay here
    // For now, just bars are sufficient for monthly view
  }

  @override
  bool shouldRepaint(_MonthlyTrendPainter oldDelegate) {
    return oldDelegate.hoveredMonth != hoveredMonth ||
        oldDelegate.pinnedMonth != pinnedMonth ||
        oldDelegate.monthlyData != monthlyData;
  }
}
