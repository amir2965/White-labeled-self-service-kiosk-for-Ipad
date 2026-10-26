import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// **Enhanced Crosshair with Tooltip**
///
/// Luxury minimal interactive overlay for chart data points:
/// - Vertical crosshair line spanning chart height
/// - Elegant floating tooltip with detailed metrics
/// - Click-to-pin functionality
/// - Smooth animations and shadows
///
/// Design: Black/Blue/White only, generous spacing, refined
class ChartCrosshairTooltip extends StatefulWidget {
  final Offset position; // Position of crosshair/tooltip anchor
  final Widget child; // The tooltip content
  final double chartHeight;
  final double chartWidth;
  final bool isPinned; // Whether tooltip is pinned (clicked)
  final VoidCallback? onDismiss; // Called when user clicks outside

  const ChartCrosshairTooltip({
    super.key,
    required this.position,
    required this.child,
    required this.chartHeight,
    required this.chartWidth,
    this.isPinned = false,
    this.onDismiss,
  });

  @override
  State<ChartCrosshairTooltip> createState() => _ChartCrosshairTooltipState();
}

class _ChartCrosshairTooltipState extends State<ChartCrosshairTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Crosshair vertical line
            _buildCrosshairLine(),

            // Tooltip
            _buildTooltip(),

            // Invisible dismiss area (when pinned)
            if (widget.isPinned && widget.onDismiss != null)
              _buildDismissOverlay(),
          ],
        );
      },
    );
  }

  Widget _buildCrosshairLine() {
    return Positioned(
      left: 0,
      top: widget.position.dy - 0.5, // Center the 1px line
      child: Opacity(
        opacity: _fadeAnimation.value * 0.35,
        child: Container(
          width: widget.chartWidth,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.blue.withOpacity(0.0),
                AppColors.blue,
                AppColors.blue,
                AppColors.blue.withOpacity(0.0),
              ],
              stops: const [0.0, 0.1, 0.9, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    // Position tooltip at chart edges to avoid covering nearby bars
    const tooltipWidth = 240.0;
    const tooltipEstimatedHeight = 140.0;
    const edgePadding = 16.0; // Padding from chart edges
    const yAxisReservedSpace = 60.0; // Space reserved for Y-axis labels

    // Determine which side of chart has more space
    final leftSpace = widget.position.dx;
    final rightSpace = widget.chartWidth - widget.position.dx;

    // Position tooltip at the edge with more space
    double leftPosition;
    bool tooltipOnLeft;

    if (leftSpace > rightSpace &&
        leftSpace > tooltipWidth + edgePadding + yAxisReservedSpace) {
      // Position at left edge of chart, after Y-axis
      tooltipOnLeft = true;
      leftPosition = yAxisReservedSpace + edgePadding;
    } else if (rightSpace > tooltipWidth + edgePadding) {
      // Position at right edge of chart
      tooltipOnLeft = false;
      leftPosition = widget.chartWidth - tooltipWidth - edgePadding;
    } else if (leftSpace > rightSpace) {
      // Fallback: position on left side, after Y-axis
      tooltipOnLeft = true;
      leftPosition = yAxisReservedSpace + edgePadding;
    } else {
      // Fallback: position on right side
      tooltipOnLeft = false;
      leftPosition = widget.chartWidth - tooltipWidth - edgePadding;
    }

    // Vertically center on data point, but keep within bounds
    double topPosition = widget.position.dy - (tooltipEstimatedHeight / 2);
    topPosition = topPosition.clamp(
      16.0, // Min padding from top
      widget.chartHeight -
          tooltipEstimatedHeight -
          16.0, // Min padding from bottom
    );

    return Positioned(
      left: leftPosition.clamp(8.0, widget.chartWidth - tooltipWidth - 8.0),
      top: topPosition,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: tooltipOnLeft
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: _buildTooltipCard(),
        ),
      ),
    );
  }

  Widget _buildTooltipCard() {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 280),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray800, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.blue.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Padding(padding: const EdgeInsets.all(16), child: widget.child),

          // Pin indicator (if pinned)
          if (widget.isPinned) ...[
            Container(height: 1, color: AppColors.gray800),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.push_pin,
                    size: 12,
                    color: AppColors.blue.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pinned • Tap anywhere to dismiss',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDismissOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.translucent,
        child: Container(color: Colors.transparent),
      ),
    );
  }

  double _calculateTooltipLeft() {
    // Try to center tooltip on crosshair, but keep it within bounds
    const tooltipEstimatedWidth = 240.0;
    final centeredLeft = widget.position.dx - (tooltipEstimatedWidth / 2);

    // Keep within chart bounds with padding
    const padding = 16.0;
    final maxLeft = widget.chartWidth - tooltipEstimatedWidth - padding;

    return centeredLeft.clamp(padding, math.max(padding, maxLeft));
  }
}

/// **Tooltip Content Builder - Hourly Chart**
class HourlyTooltipContent extends StatelessWidget {
  final int hour;
  final double sales;
  final double totalSales;
  final double avgSales;
  final bool isCurrentHour;
  final bool isPeakHour;

  const HourlyTooltipContent({
    super.key,
    required this.hour,
    required this.sales,
    required this.totalSales,
    required this.avgSales,
    this.isCurrentHour = false,
    this.isPeakHour = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentOfTotal = (sales / totalSales * 100);
    final comparisonToAvg = ((sales - avgSales) / avgSales * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hour with badge
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatHour(hour),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            if (isCurrentHour)
              _buildBadge('NOW', AppColors.blue)
            else if (isPeakHour)
              _buildBadge('PEAK', AppColors.black),
          ],
        ),

        const SizedBox(height: 12),

        // Revenue
        _buildMetricRow(
          label: 'Revenue',
          value: '\$${sales.toStringAsFixed(2)}',
          isMain: true,
        ),

        const SizedBox(height: 8),

        // % of total
        _buildMetricRow(
          label: 'Of Total',
          value: '${percentOfTotal.toStringAsFixed(1)}%',
        ),

        const SizedBox(height: 8),

        // Comparison to average
        _buildMetricRow(
          label: 'vs Average',
          value:
              '${comparisonToAvg >= 0 ? '+' : ''}${comparisonToAvg.toStringAsFixed(1)}%',
          valueColor: comparisonToAvg >= 0 ? AppColors.blue : AppColors.gray500,
          icon: comparisonToAvg >= 0 ? Icons.trending_up : Icons.trending_down,
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required String label,
    required String value,
    bool isMain = false,
    Color? valueColor,
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: valueColor ?? AppColors.gray400),
          const SizedBox(width: 4),
        ],
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isMain ? 13 : 12,
            color: AppColors.gray400,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 17 : 13,
            fontWeight: isMain ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.white,
            letterSpacing: isMain ? -0.5 : 0,
          ),
        ),
      ],
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}

/// **Tooltip Content Builder - Monthly Chart**
class MonthlyTooltipContent extends StatelessWidget {
  final int month;
  final int year;
  final double sales;
  final double totalSales;
  final double avgSales;
  final double? previousYearSales;
  final bool isCurrentMonth;
  final bool isPeakMonth;

  const MonthlyTooltipContent({
    super.key,
    required this.month,
    required this.year,
    required this.sales,
    required this.totalSales,
    required this.avgSales,
    this.previousYearSales,
    this.isCurrentMonth = false,
    this.isPeakMonth = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentOfTotal = (sales / totalSales * 100);
    final comparisonToAvg = ((sales - avgSales) / avgSales * 100);
    final yoyChange = previousYearSales != null
        ? ((sales - previousYearSales!) / previousYearSales! * 100)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month with badge
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_getMonthName(month)} $year',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            if (isCurrentMonth)
              _buildBadge('CURRENT', AppColors.blue)
            else if (isPeakMonth)
              _buildBadge('PEAK', AppColors.black),
          ],
        ),

        const SizedBox(height: 12),

        // Revenue
        _buildMetricRow(
          label: 'Revenue',
          value: '\$${_formatNumber(sales)}',
          isMain: true,
        ),

        const SizedBox(height: 8),

        // % of total
        _buildMetricRow(
          label: 'Of Total',
          value: '${percentOfTotal.toStringAsFixed(1)}%',
        ),

        const SizedBox(height: 8),

        // Comparison to average
        _buildMetricRow(
          label: 'vs Average',
          value:
              '${comparisonToAvg >= 0 ? '+' : ''}${comparisonToAvg.toStringAsFixed(1)}%',
          valueColor: comparisonToAvg >= 0 ? AppColors.blue : AppColors.gray500,
          icon: comparisonToAvg >= 0 ? Icons.trending_up : Icons.trending_down,
        ),

        // Year-over-year change
        if (yoyChange != null) ...[
          const SizedBox(height: 8),
          _buildMetricRow(
            label: 'YoY Change',
            value:
                '${yoyChange >= 0 ? '+' : ''}${yoyChange.toStringAsFixed(1)}%',
            valueColor: yoyChange >= 0 ? AppColors.blue : AppColors.gray500,
            icon: yoyChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required String label,
    required String value,
    bool isMain = false,
    Color? valueColor,
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: valueColor ?? AppColors.gray400),
          const SizedBox(width: 4),
        ],
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isMain ? 13 : 12,
            color: AppColors.gray400,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 17 : 13,
            fontWeight: isMain ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.white,
            letterSpacing: isMain ? -0.5 : 0,
          ),
        ),
      ],
    );
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

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }
}

/// **Tooltip Content Builder - Daily Chart**
class DailyTooltipContent extends StatelessWidget {
  final DateTime date;
  final double sales;
  final double totalSales;
  final double avgSales;
  final bool isToday;

  const DailyTooltipContent({
    super.key,
    required this.date,
    required this.sales,
    required this.totalSales,
    required this.avgSales,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentOfTotal = (sales / totalSales * 100);
    final comparisonToAvg = ((sales - avgSales) / avgSales * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date with badge
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDateFull(date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  _getDayOfWeek(date),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            if (isToday) _buildBadge('TODAY', AppColors.blue),
          ],
        ),

        const SizedBox(height: 12),

        // Revenue
        _buildMetricRow(
          label: 'Revenue',
          value: '\$${sales.toStringAsFixed(2)}',
          isMain: true,
        ),

        const SizedBox(height: 8),

        // % of total
        _buildMetricRow(
          label: 'Of Total',
          value: '${percentOfTotal.toStringAsFixed(1)}%',
        ),

        const SizedBox(height: 8),

        // Comparison to average
        _buildMetricRow(
          label: 'vs Average',
          value:
              '${comparisonToAvg >= 0 ? '+' : ''}${comparisonToAvg.toStringAsFixed(1)}%',
          valueColor: comparisonToAvg >= 0 ? AppColors.blue : AppColors.gray500,
          icon: comparisonToAvg >= 0 ? Icons.trending_up : Icons.trending_down,
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required String label,
    required String value,
    bool isMain = false,
    Color? valueColor,
    IconData? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: valueColor ?? AppColors.gray400),
          const SizedBox(width: 4),
        ],
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isMain ? 13 : 12,
            color: AppColors.gray400,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 17 : 13,
            fontWeight: isMain ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? AppColors.white,
            letterSpacing: isMain ? -0.5 : 0,
          ),
        ),
      ],
    );
  }

  String _formatDateFull(DateTime date) {
    const months = [
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getDayOfWeek(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }
}
