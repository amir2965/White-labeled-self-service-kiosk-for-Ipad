import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/chart_models.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Time of Day line chart with hourly data points (0-23)
/// Minimal design with touch interactions
class TimeOfDayLineChart extends StatefulWidget {
  final List<ChartPoint> selectedSeries;
  final List<ChartPoint> compareSeries;
  final bool showComparison;
  final String dateLabel;
  final String? compareDateLabel;
  final void Function(ChartPointSelection?, Offset?)? onPointSelected;
  final TimeRangeSelection? rangeSelection;
  final Function(int startHour, int endHour)? onRangeSelected;

  const TimeOfDayLineChart({
    Key? key,
    required this.selectedSeries,
    required this.compareSeries,
    this.showComparison = true,
    required this.dateLabel,
    this.compareDateLabel,
    this.onPointSelected,
    this.rangeSelection,
    this.onRangeSelected,
  }) : super(key: key);

  @override
  State<TimeOfDayLineChart> createState() => _TimeOfDayLineChartState();
}

class _TimeOfDayLineChartState extends State<TimeOfDayLineChart> {
  int? _selectedHourIndex;
  int? _rangeStartHour;
  int? _rangeEndHour;

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
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),

              // Chart
              SizedBox(
                height: 280,
                child: LineChart(
                  LineChartData(
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
                          interval: 3, // Show every 3 hours
                          getTitlesWidget: (value, meta) {
                            final hour = value.toInt();
                            if (hour < 0 || hour > 23) return const SizedBox();

                            final date = DateTime(2026, 1, 1, hour, 0);
                            final label = DateFormat('h a').format(date);

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                label,
                                style: AppTypography.caption.copyWith(
                                  color: Colors.grey.shade600,
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
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        left: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    minX: 0,
                    maxX: 23,
                    minY: 0,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (event, response) {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.lineBarSpots == null) {
                          return;
                        }

                        if (event is FlTapUpEvent) {
                          final spot = response.lineBarSpots!.first;
                          final hour = spot.x.toInt();
                          final renderBox =
                              context.findRenderObject() as RenderBox?;
                          final globalPosition = renderBox?.localToGlobal(
                            event.localPosition,
                          );
                          if (globalPosition != null) {
                            _handlePointTap(hour, globalPosition);
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        getTooltipItems: (touchedSpots) => [],
                      ),
                      getTouchedSpotIndicator: (barData, spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: Colors.grey.shade400,
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: Colors.black,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                    ),
                    lineBarsData: [
                      // Selected series (primary black line)
                      _buildLineBarData(
                        widget.selectedSeries,
                        Colors.black,
                        isSelected: true,
                      ),
                      // Compare series (light gray line)
                      if (widget.showComparison &&
                          widget.compareSeries.isNotEmpty)
                        _buildLineBarData(
                          widget.compareSeries,
                          Colors.grey.shade400,
                          isSelected: false,
                        ),
                    ],
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        // Range selection overlay
                        if (_rangeStartHour != null && _rangeEndHour != null)
                          HorizontalLine(
                            y: 0,
                            color: Colors.grey.shade200.withOpacity(0.5),
                            strokeWidth: maxY,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Range selection summary
              if (widget.rangeSelection != null) ...[
                const SizedBox(height: AppSpacing.md),
                _buildRangeSelectionSummary(widget.rangeSelection!),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TIME OF DAY',
          style: AppTypography.label.copyWith(
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        if (widget.showComparison) _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem(Colors.black, widget.dateLabel),
        const SizedBox(width: AppSpacing.md),
        if (widget.compareDateLabel != null)
          _buildLegendItem(Colors.grey.shade400, widget.compareDateLabel!),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  LineChartBarData _buildLineBarData(
    List<ChartPoint> series,
    Color color, {
    required bool isSelected,
  }) {
    return LineChartBarData(
      spots: series
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.grossSales))
          .toList(),
      isCurved: true,
      curveSmoothness: 0.25,
      color: color,
      barWidth: isSelected ? 2.5 : 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          // Show dot only if there's data (>0) or if selected
          final hasData = spot.y > 0;
          final isSelectedPoint = _selectedHourIndex == index;

          if (!hasData && !isSelectedPoint) {
            // Empty hour - show baseline dot
            return FlDotCirclePainter(
              radius: 2,
              color: Colors.grey.shade300,
              strokeWidth: 0,
            );
          }

          return FlDotCirclePainter(
            radius: isSelectedPoint ? 5 : 3,
            color: Colors.white,
            strokeWidth: isSelectedPoint ? 2.5 : 2,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildRangeSelectionSummary(TimeRangeSelection selection) {
    final startLabel = DateFormat(
      'h:mm a',
    ).format(DateTime(2026, 1, 1, selection.startHour, 0));
    final endLabel = DateFormat(
      'h:mm a',
    ).format(DateTime(2026, 1, 1, selection.endHour, 0));

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
            '$startLabel – $endLabel',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '\$${selection.totalSales.toStringAsFixed(2)} • ${selection.paymentsCount} payments',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _clearSelection,
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

  void _handlePointTap(int hour, Offset tapPosition) {
    setState(() {
      if (_rangeStartHour == null) {
        // First tap - set start
        _rangeStartHour = hour;
        _selectedHourIndex = hour;
      } else if (_rangeEndHour == null) {
        // Second tap - set end
        _rangeEndHour = hour;

        // Ensure start < end
        if (_rangeStartHour! > _rangeEndHour!) {
          final temp = _rangeStartHour;
          _rangeStartHour = _rangeEndHour;
          _rangeEndHour = temp;
        }

        // Notify parent
        widget.onRangeSelected?.call(_rangeStartHour!, _rangeEndHour!);
      } else {
        // Third tap - reset
        _rangeStartHour = hour;
        _rangeEndHour = null;
        _selectedHourIndex = hour;
      }
    });

    // Also trigger point selection callback for tooltip
    if (_selectedHourIndex != null &&
        _selectedHourIndex! < widget.selectedSeries.length) {
      final point = widget.selectedSeries[_selectedHourIndex!];
      final comparePoint =
          widget.showComparison &&
              _selectedHourIndex! < widget.compareSeries.length
          ? widget.compareSeries[_selectedHourIndex!]
          : null;

      widget.onPointSelected?.call(
        ChartPointSelection(
          point: point,
          comparePoint: comparePoint,
          dateLabel: widget.dateLabel,
          compareDateLabel: widget.compareDateLabel,
        ),
        tapPosition,
      );
    }
  }

  void _clearSelection() {
    setState(() {
      _rangeStartHour = null;
      _rangeEndHour = null;
      _selectedHourIndex = null;
    });
    widget.onPointSelected?.call(null, null);
  }

  double _calculateMaxY() {
    double max = 0;
    for (final point in widget.selectedSeries) {
      if (point.grossSales > max) max = point.grossSales;
    }
    if (widget.showComparison) {
      for (final point in widget.compareSeries) {
        if (point.grossSales > max) max = point.grossSales;
      }
    }
    // Add 20% padding and round up to nearest 50
    return ((max * 1.2) / 50).ceil() * 50;
  }
}
