import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Day of Week bar chart showing totals for S M T W T F S
/// Minimal design with touch interactions
class DayOfWeekBarChart extends StatefulWidget {
  final Map<int, double> dayTotals; // weekday (1=Mon, 7=Sun) -> amount
  final Map<int, int> dayPayments;
  final Function(int weekday, double amount, int payments)? onBarTapped;

  const DayOfWeekBarChart({
    Key? key,
    required this.dayTotals,
    required this.dayPayments,
    this.onBarTapped,
  }) : super(key: key);

  @override
  State<DayOfWeekBarChart> createState() => _DayOfWeekBarChartState();
}

class _DayOfWeekBarChartState extends State<DayOfWeekBarChart> {
  int? _selectedWeekday;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _weekdayFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final maxY = _calculateMaxY();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'DAY OF WEEK',
                style: AppTypography.label.copyWith(
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Chart
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: maxY,
                    minY: 0,
                    groupsSpace: 12,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchCallback: (event, response) {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.spot == null) {
                          return;
                        }

                        if (event is FlTapUpEvent) {
                          final weekday =
                              response.spot!.touchedBarGroupIndex + 1;
                          _handleBarTap(weekday);
                        }
                      },
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return null; // We handle tooltip separately
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= 7) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _weekdayLabels[index],
                                style: AppTypography.caption.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: maxY / 4,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox();
                            return Text(
                              '\$${value.toInt()}',
                              style: AppTypography.caption.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade200,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        left: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    barGroups: _buildBarGroups(),
                  ),
                ),
              ),

              // Selected day summary
              if (_selectedWeekday != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildSelectedDaySummary(),
              ],
            ],
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      final weekday = index + 1; // 1=Mon, 7=Sun
      final amount = widget.dayTotals[weekday] ?? 0;
      final isSelected = _selectedWeekday == weekday;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: isSelected ? Colors.black : Colors.grey.shade800,
            width: 24,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _calculateMaxY(),
              color: Colors.grey.shade100,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSelectedDaySummary() {
    if (_selectedWeekday == null) return const SizedBox();

    final amount = widget.dayTotals[_selectedWeekday!] ?? 0;
    final payments = widget.dayPayments[_selectedWeekday!] ?? 0;
    final dayName = _weekdayFull[_selectedWeekday! - 1];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            dayName,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '\$${amount.toStringAsFixed(2)} • $payments payments',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekday = null;
              });
            },
            child: Text(
              'Clear',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBarTap(int weekday) {
    setState(() {
      _selectedWeekday = _selectedWeekday == weekday ? null : weekday;
    });

    if (_selectedWeekday != null) {
      final amount = widget.dayTotals[weekday] ?? 0;
      final payments = widget.dayPayments[weekday] ?? 0;
      widget.onBarTapped?.call(weekday, amount, payments);
    }
  }

  double _calculateMaxY() {
    double max = 0;
    for (final amount in widget.dayTotals.values) {
      if (amount > max) max = amount;
    }
    // Add 20% padding and round up to nearest 50
    return ((max * 1.2) / 50).ceil() * 50;
  }
}
