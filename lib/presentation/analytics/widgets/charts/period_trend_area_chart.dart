import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/chart_models.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Period trend area chart showing daily sales across date range
/// Minimal design with area fill
class PeriodTrendAreaChart extends StatelessWidget {
  final List<ChartPoint> series;
  final List<ChartPoint>? compareSeries;
  final bool showComparison;
  final void Function(ChartPointSelection?, Offset?)? onPointSelected;

  const PeriodTrendAreaChart({
    Key? key,
    required this.series,
    this.compareSeries,
    this.showComparison = false,
    this.onPointSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) {
      return _buildEmptyState();
    }

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
              // Header with date range
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),

              // Chart
              SizedBox(
                height: 200,
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
                          interval: _calculateXInterval(),
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= series.length) {
                              return const SizedBox();
                            }

                            final point = series[index];

                            // Show first and last label always
                            if (index == 0 || index == series.length - 1) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat('d MMM').format(point.x),
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
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
                              '\$${(value / 1000).toStringAsFixed(0)}k',
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
                    maxX: (series.length - 1).toDouble(),
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
                          final index = spot.x.toInt();
                          final renderBox =
                              context.findRenderObject() as RenderBox?;
                          final globalPosition = renderBox?.localToGlobal(
                            event.localPosition,
                          );
                          if (globalPosition != null) {
                            _handlePointTap(index, globalPosition);
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.transparent,
                        getTooltipItems: (touchedSpots) => [],
                      ),
                    ),
                    lineBarsData: [
                      _buildLineBarData(series, Colors.black),
                      if (showComparison && compareSeries != null)
                        _buildLineBarData(compareSeries!, Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    if (series.isEmpty) return const SizedBox();

    final startDate = series.first.x;
    final endDate = series.last.x;
    final dateRangeLabel = series.length == 1
        ? DateFormat('d MMM yyyy').format(startDate)
        : '${DateFormat('d MMM').format(startDate)} – ${DateFormat('d MMM yyyy').format(endDate)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateRangeLabel,
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
        ),
        _buildDataStatus(),
      ],
    );
  }

  Widget _buildDataStatus() {
    return Row(
      children: [
        Text(
          'Data as of 2 hours ago',
          style: AppTypography.caption.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(width: 4),
        Container(
          width: 20,
          height: 1,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLineBarData(List<ChartPoint> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.grossSales))
          .toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: color == Colors.black, // Only fill for primary series
        color: Colors.grey.shade100.withOpacity(0.5),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'No data available',
          style: AppTypography.bodyMedium.copyWith(color: Colors.grey.shade500),
        ),
      ),
    );
  }

  void _handlePointTap(int index, Offset tapPosition) {
    if (index < 0 || index >= series.length) return;

    final point = series[index];
    final comparePoint =
        showComparison && compareSeries != null && index < compareSeries!.length
        ? compareSeries![index]
        : null;

    onPointSelected?.call(
      ChartPointSelection(
        point: point,
        comparePoint: comparePoint,
        dateLabel: DateFormat('d MMM yyyy').format(point.x),
        compareDateLabel: comparePoint != null
            ? DateFormat('d MMM yyyy').format(comparePoint.x)
            : null,
      ),
      tapPosition,
    );
  }

  double _calculateMaxY() {
    double max = 0;
    for (final point in series) {
      if (point.grossSales > max) max = point.grossSales;
    }
    if (showComparison && compareSeries != null) {
      for (final point in compareSeries!) {
        if (point.grossSales > max) max = point.grossSales;
      }
    }
    return ((max * 1.2) / 100).ceil() * 100;
  }

  double _calculateXInterval() {
    // Show labels at start and end only for now
    return series.length > 1 ? series.length.toDouble() : 1;
  }
}
