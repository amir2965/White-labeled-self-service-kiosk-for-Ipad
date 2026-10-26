import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../models/sales_summary_model.dart';
import 'chart_crosshair_tooltip.dart';

/// Modern minimal hourly revenue chart
/// Shows 24-hour breakdown with elegant bar visualization
class ModernHourlyChart extends StatefulWidget {
  final List<HourlySalesPoint> data;
  final int? currentHour; // Highlight current hour if viewing today
  final double maxHeight;
  final bool showLabels;
  final bool isDarkMode;
  final Function(int hour, double sales)? onBarTap;

  const ModernHourlyChart({
    super.key,
    required this.data,
    this.currentHour,
    this.maxHeight = 240,
    this.showLabels = true,
    this.isDarkMode = false,
    this.onBarTap,
  });

  @override
  State<ModernHourlyChart> createState() => _ModernHourlyChartState();
}

class _ModernHourlyChartState extends State<ModernHourlyChart> {
  int? _hoveredHour;
  int? _pinnedHour;
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    // Calculate range with non-zero values for better scaling
    final nonZeroValues = widget.data
        .map((e) => e.sales)
        .where((s) => s > 0)
        .toList();

    final double maxSales;
    final double minSales;

    if (nonZeroValues.isEmpty) {
      maxSales = 100; // Default range
      minSales = 0;
    } else {
      maxSales = nonZeroValues.reduce((a, b) => a > b ? a : b);
      minSales = nonZeroValues.reduce((a, b) => a < b ? a : b);
    }

    final totalSales = widget.data.fold<double>(0.0, (sum, e) => sum + e.sales);
    final avgSales = totalSales / widget.data.length;

    // Find peak hour
    final peakPoint = widget.data.reduce((a, b) => a.sales > b.sales ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stats row
        _buildStatsRow(totalSales, avgSales, peakPoint),

        const SizedBox(height: AppSpacing.lg),

        // Chart area
        SizedBox(
          height: widget.maxHeight,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-axis labels
                  if (widget.showLabels) _buildYAxisLabels(maxSales, minSales),

                  const SizedBox(width: AppSpacing.sm),

                  // Chart bars
                  Expanded(
                    key: _chartKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(24, (index) {
                        final point = widget.data.firstWhere(
                          (p) => p.hour == index,
                          orElse: () => HourlySalesPoint(hour: index, sales: 0),
                        );

                        return Expanded(
                          child: _buildBar(
                            hour: index,
                            sales: point.sales,
                            maxSales: maxSales,
                            minSales: minSales,
                            isCurrentHour: widget.currentHour == index,
                            isPeakHour: point.hour == peakPoint.hour,
                            totalSales: totalSales,
                            avgSales: avgSales,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              // Tooltip overlay
              if (_hoveredHour != null || _pinnedHour != null)
                _buildCrosshairOverlay(
                  hour: _pinnedHour ?? _hoveredHour!,
                  maxSales: maxSales,
                  minSales: minSales,
                  totalSales: totalSales,
                  avgSales: avgSales,
                  peakHour: peakPoint.hour,
                ),
            ],
          ),
        ),

        // X-axis labels
        if (widget.showLabels) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildXAxisLabels(),
        ],
      ],
    );
  }

  Widget _buildStatsRow(double total, double avg, HourlySalesPoint peak) {
    return Row(
      children: [
        _buildStatPill(
          'Total',
          '\$${total.toStringAsFixed(0)}',
          Icons.attach_money,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildStatPill(
          'Average',
          '\$${avg.toStringAsFixed(0)}',
          Icons.show_chart,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildStatPill(
          'Peak Hour',
          '${_formatHour(peak.hour)} (\$${peak.sales.toStringAsFixed(0)})',
          Icons.trending_up,
        ),
      ],
    );
  }

  Widget _buildStatPill(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : AppColors.gray50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.6)
                : AppColors.gray600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.gray600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: widget.isDarkMode ? Colors.white : AppColors.black,
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
      width: 50,
      height: widget.maxHeight,
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildYLabel('\$${_formatNumber(maxSales)}'),
            _buildYLabel(
              '\$${_formatNumber(minSales + effectiveRange * 0.75)}',
            ),
            _buildYLabel('\$${_formatNumber(minSales + effectiveRange * 0.5)}'),
            _buildYLabel(
              '\$${_formatNumber(minSales + effectiveRange * 0.25)}',
            ),
            _buildYLabel('\$${_formatNumber(minSales)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildYLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.5)
            : AppColors.gray500,
      ),
    );
  }

  Widget _buildBar({
    required int hour,
    required double sales,
    required double maxSales,
    required double minSales,
    required bool isCurrentHour,
    required bool isPeakHour,
    required double totalSales,
    required double avgSales,
  }) {
    // Calculate height fraction based on data range (same as monthly chart)
    final range = maxSales - minSales;
    final effectiveRange = range > 0 ? range : maxSales;

    double heightFraction;
    if (sales <= 0) {
      heightFraction = 0.0;
    } else if (effectiveRange > 0) {
      heightFraction = (sales - minSales) / effectiveRange;
    } else {
      heightFraction = 1.0;
    }

    final isHovered = _hoveredHour == hour;
    final hasData = sales > 0;

    Color barColor;
    if (widget.isDarkMode) {
      // Dark mode colors
      if (isCurrentHour) {
        barColor = AppColors.blue; // Current hour - keep blue
      } else if (isPeakHour) {
        barColor = Colors.white.withOpacity(0.9); // Peak hour - white
      } else if (hasData) {
        barColor = Colors.white.withOpacity(0.3); // Regular data
      } else {
        barColor = Colors.white.withOpacity(0.06); // No data
      }
      if (isHovered) {
        barColor = AppColors.blue.withOpacity(0.8);
      }
    } else {
      // Light mode colors
      if (isCurrentHour) {
        barColor = AppColors.blue; // Current hour - vibrant blue
      } else if (isPeakHour) {
        barColor = AppColors.black; // Peak hour - black
      } else if (hasData) {
        barColor = AppColors.gray300; // Regular data - light gray
      } else {
        barColor = AppColors.gray100; // No data - very light gray
      }
      if (isHovered) {
        barColor = AppColors.blue.withOpacity(0.8);
      }
    }

    // Calculate actual bar height in pixels - round to prevent sub-pixel issues
    final barHeight = (widget.maxHeight * heightFraction).roundToDouble();

    // Remove border radius for near-full-height bars to prevent visual overflow
    final shouldHaveBorderRadius = heightFraction < 0.95;

    return MouseRegion(
      onEnter: (_) {
        if (_pinnedHour == null) {
          setState(() => _hoveredHour = hour);
        }
      },
      onExit: (_) {
        if (_pinnedHour == null) {
          setState(() => _hoveredHour = null);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_pinnedHour == hour) {
              _pinnedHour = null; // Unpin if clicking same hour
            } else {
              _pinnedHour = hour; // Pin this hour
            }
          });
          widget.onBarTap?.call(hour, sales);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: SizedBox(
            height: widget.maxHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bar with conditional border radius
                  // Remove radius for peak bars to prevent visual height mismatch
                  ClipRRect(
                    borderRadius: shouldHaveBorderRadius
                        ? const BorderRadius.vertical(top: Radius.circular(3))
                        : BorderRadius.zero,
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(color: barColor),
                    ),
                  ),

                  // Current hour indicator
                  if (isCurrentHour) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
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
    return Row(
      children: [
        const SizedBox(width: 50), // Match Y-axis width
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(24, (hour) {
              // Show label for every 3rd hour (0, 3, 6, 9, 12, 15, 18, 21)
              final shouldShowLabel = hour % 3 == 0;

              String label = '';
              if (shouldShowLabel) {
                if (hour == 0) {
                  label = '12a';
                } else if (hour < 12) {
                  label = '${hour}a';
                } else if (hour == 12) {
                  label = '12p';
                } else {
                  label = '${hour - 12}p';
                }
              }

              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: widget.isDarkMode
                          ? Colors.white.withOpacity(0.5)
                          : AppColors.gray500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildXLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.5)
            : AppColors.gray500,
      ),
    );
  }

  Widget _buildCrosshairOverlay({
    required int hour,
    required double maxSales,
    required double minSales,
    required double totalSales,
    required double avgSales,
    required int peakHour,
  }) {
    final point = widget.data.firstWhere(
      (p) => p.hour == hour,
      orElse: () => HourlySalesPoint(hour: hour, sales: 0),
    );

    // Calculate crosshair position
    final chartBox = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (chartBox == null) return const SizedBox.shrink();

    final chartWidth = chartBox.size.width;
    final barWidth = chartWidth / 24;
    final xPosition = (hour + 0.5) * barWidth; // Center of the bar

    // Calculate Y position at the top of the bar using SAME coordinate system as bars
    // Use the passed minSales/maxSales to ensure perfect alignment
    final range = maxSales - minSales;
    final effectiveRange = range > 0 ? range : maxSales;

    final heightFraction = effectiveRange > 0 && point.sales > 0
        ? (point.sales - minSales) / effectiveRange
        : 0.0;

    final yPosition = widget.maxHeight * (1 - heightFraction);

    return ChartCrosshairTooltip(
      position: Offset(xPosition, yPosition),
      chartHeight: widget.maxHeight,
      chartWidth: chartWidth,
      isPinned: _pinnedHour == hour,
      onDismiss: () => setState(() => _pinnedHour = null),
      child: HourlyTooltipContent(
        hour: hour,
        sales: point.sales,
        totalSales: totalSales,
        avgSales: avgSales,
        isCurrentHour: widget.currentHour == hour,
        isPeakHour: hour == peakHour,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: widget.maxHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 48,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.3)
                : AppColors.gray300,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No sales data available',
            style: TextStyle(
              fontSize: 14,
              color: widget.isDarkMode
                  ? Colors.white.withOpacity(0.5)
                  : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour == 12) return '12 PM';
    if (hour < 12) return '$hour AM';
    return '${hour - 12} PM';
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
