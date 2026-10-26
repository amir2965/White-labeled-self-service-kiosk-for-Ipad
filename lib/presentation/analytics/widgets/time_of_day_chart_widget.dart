import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/sales_summary_model.dart';

/// Time of day sales trend chart with comparison
class TimeOfDayChartWidget extends StatelessWidget {
  final List<HourlySalesPoint> selectedDayPoints;
  final List<HourlySalesPoint> compareDayPoints;
  final double grossSales;
  final double? comparisonDelta;

  const TimeOfDayChartWidget({
    super.key,
    required this.selectedDayPoints,
    required this.compareDayPoints,
    required this.grossSales,
    this.comparisonDelta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'TIME OF DAY',
            style: AppTypography.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Summary sentence
          _buildSummary(),

          SizedBox(height: AppSpacing.sm),

          // See more link
          InkWell(
            onTap: () {},
            child: Text(
              'See more sales trends →',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // Chart
          SizedBox(height: 200, child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final deltaText = comparisonDelta != null && comparisonDelta! > 0
        ? 'up \$${comparisonDelta!.toStringAsFixed(2)}'
        : comparisonDelta != null && comparisonDelta! < 0
        ? 'down \$${(-comparisonDelta!).toStringAsFixed(2)}'
        : 'unchanged';

    final deltaColor = comparisonDelta != null && comparisonDelta! > 0
        ? AppColors.success
        : comparisonDelta != null && comparisonDelta! < 0
        ? AppColors.error
        : AppColors.gray700;

    return RichText(
      text: TextSpan(
        style: AppTypography.bodyMedium.copyWith(
          fontSize: 15,
          color: AppColors.gray800,
          height: 1.5,
        ),
        children: [
          TextSpan(text: 'Gross sales today are '),
          TextSpan(
            text: '\$${grossSales.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (comparisonDelta != null) ...[
            TextSpan(text: '. So far this is '),
            TextSpan(
              text: deltaText,
              style: TextStyle(fontWeight: FontWeight.w600, color: deltaColor),
            ),
            TextSpan(text: ' from the previous period.'),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (selectedDayPoints.isEmpty) {
      return Center(
        child: Text(
          'No sales data available',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.gray300.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.gray600,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 2,
              getTitlesWidget: (value, meta) {
                final hour = value.toInt();
                if (hour % 4 != 0) return const SizedBox.shrink();
                return Text(
                  _formatHour(hour),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.gray600,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: _calculateMaxY(),
        lineBarsData: [
          // Selected day line (black)
          LineChartBarData(
            spots: selectedDayPoints
                .map((p) => FlSpot(p.hour.toDouble(), p.sales))
                .toList(),
            isCurved: true,
            color: AppColors.black,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.black,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),

          // Compare day line (gray) - if available
          if (compareDayPoints.isNotEmpty)
            LineChartBarData(
              spots: compareDayPoints
                  .map((p) => FlSpot(p.hour.toDouble(), p.sales))
                  .toList(),
              isCurved: true,
              color: AppColors.gray400,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2.5,
                    color: AppColors.gray400,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(show: false),
            ),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    final maxSelected = selectedDayPoints.isNotEmpty
        ? selectedDayPoints.map((p) => p.sales).reduce((a, b) => a > b ? a : b)
        : 0.0;
    final maxCompare = compareDayPoints.isNotEmpty
        ? compareDayPoints.map((p) => p.sales).reduce((a, b) => a > b ? a : b)
        : 0.0;

    final max = [maxSelected, maxCompare].reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceil().toDouble();
  }

  double _calculateInterval() {
    final maxY = _calculateMaxY();
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 500) return 100;
    return 200;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12AM';
    if (hour < 12) return '${hour}AM';
    if (hour == 12) return '12PM';
    return '${hour - 12}PM';
  }
}
