import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

/// **Enterprise-Grade Daily Revenue Trend Chart**
///
/// Professional minimal design
/// Completely rewritten for reliability and performance
///
/// Features:
/// - Smooth gradient area chart with professional styling
/// - Interactive hover states with elegant tooltips
/// - Responsive Y-axis with smart currency formatting
/// - Adaptive X-axis labels based on date range
/// - Modern grid system for better readability
/// - Guaranteed to work with mock data
class ModernDailyTrendChart extends StatefulWidget {
  final Map<String, double> dailyData;
  final DateTime startDate;
  final DateTime endDate;
  final double maxHeight;
  final bool isDarkMode;

  const ModernDailyTrendChart({
    super.key,
    required this.dailyData,
    required this.startDate,
    required this.endDate,
    this.maxHeight = 300,
    this.isDarkMode = false,
  });

  @override
  State<ModernDailyTrendChart> createState() => _ModernDailyTrendChartState();
}

class _ModernDailyTrendChartState extends State<ModernDailyTrendChart> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // Validate data exists
    if (widget.dailyData.isEmpty) {
      return _buildEmptyState();
    }

    // Build data points array
    final values = _buildDataPoints();

    if (values.isEmpty || values.every((v) => v == 0)) {
      return _buildEmptyState();
    }

    // Calculate key metrics
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final totalRevenue = values.reduce((a, b) => a + b);
    final avgRevenue = totalRevenue / values.length;
    final days = widget.endDate.difference(widget.startDate).inDays + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Professional stats header
        _buildStatsHeader(totalRevenue, avgRevenue, maxValue, days),

        const SizedBox(height: 24),

        // Main chart area
        SizedBox(
          height: widget.maxHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Y-Axis labels
              _buildYAxis(maxValue, minValue),

              const SizedBox(width: 12),

              // Chart canvas
              Expanded(
                child: Column(
                  children: [
                    // Chart with hover interaction
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return MouseRegion(
                            onHover: (event) => _handleHover(
                              event.localPosition,
                              constraints.maxWidth,
                              values.length,
                            ),
                            onExit: (_) => setState(() => _hoveredIndex = null),
                            child: CustomPaint(
                              painter: _DailyRevenuePainter(
                                values: values,
                                maxValue: maxValue,
                                minValue: minValue,
                                hoveredIndex: _hoveredIndex,
                                isDarkMode: widget.isDarkMode,
                              ),
                              child: Container(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // X-Axis labels
                    _buildXAxis(days),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Interactive tooltip
        if (_hoveredIndex != null && _hoveredIndex! < values.length)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildTooltip(values, _hoveredIndex!),
          ),
      ],
    );
  }

  List<double> _buildDataPoints() {
    final values = <double>[];
    final days = widget.endDate.difference(widget.startDate).inDays + 1;

    for (int i = 0; i < days; i++) {
      final date = widget.startDate.add(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final value = widget.dailyData[dateKey] ?? 0.0;
      values.add(value);
    }

    return values;
  }

  void _handleHover(Offset position, double width, int dataLength) {
    if (dataLength == 0) return;
    final index = ((position.dx / width) * dataLength).floor().clamp(
      0,
      dataLength - 1,
    );
    setState(() => _hoveredIndex = index);
  }

  /// Professional stats header showing key metrics
  Widget _buildStatsHeader(double total, double avg, double peak, int days) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem('Total Revenue', _formatCurrency(total)),
          const SizedBox(width: 32),
          _buildStatItem('Daily Average', _formatCurrency(avg)),
          const SizedBox(width: 32),
          _buildStatItem('Peak Day', _formatCurrency(peak)),
          const SizedBox(width: 32),
          _buildStatItem('Period', '$days days'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white60 : Colors.black54,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: widget.isDarkMode ? Colors.white : Colors.black87,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  /// Y-Axis with currency formatting
  Widget _buildYAxis(double maxValue, double minValue) {
    final range = maxValue - minValue;
    final step = range / 4; // 5 labels (0, 25%, 50%, 75%, 100%)

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (i) {
          final value = maxValue - (step * i);
          return Text(
            _formatCurrency(value),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode ? Colors.white54 : Colors.black45,
            ),
          );
        }),
      ),
    );
  }

  /// Adaptive X-Axis based on date range
  Widget _buildXAxis(int days) {
    final labels = <String>[];
    final dateFormat = days <= 7 ? DateFormat('E d') : DateFormat('M/d');

    // Show 5-7 labels evenly distributed
    final labelCount = days <= 7 ? days : math.min(7, days);
    final step = (days - 1) / (labelCount - 1);

    for (int i = 0; i < labelCount; i++) {
      final dayOffset = (step * i).round();
      final date = widget.startDate.add(Duration(days: dayOffset));
      labels.add(dateFormat.format(date));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white54 : Colors.black45,
          ),
        );
      }).toList(),
    );
  }

  /// Interactive hover tooltip
  Widget _buildTooltip(List<double> values, int index) {
    final date = widget.startDate.add(Duration(days: index));
    final value = values[index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('EEE, MMM d').format(date),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _formatCurrency(value),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state when no data available
  Widget _buildEmptyState() {
    return Container(
      height: widget.maxHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.show_chart_outlined,
            size: 48,
            color: widget.isDarkMode ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  /// Format currency with K/M suffixes
  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }
}

/// **Professional CustomPainter Implementation**
///
/// Renders enterprise-grade revenue trend visualization:
/// - Smooth bezier curves for elegant line rendering
/// - Gradient area fill for visual depth
/// - Interactive hover states with animations
/// - Precision grid system for readability
class _DailyRevenuePainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final double minValue;
  final int? hoveredIndex;
  final bool isDarkMode;

  _DailyRevenuePainter({
    required this.values,
    required this.maxValue,
    required this.minValue,
    this.hoveredIndex,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final range = maxValue - minValue;
    if (range == 0) return;

    // Draw grid lines (horizontal every 25%)
    _drawGrid(canvas, size);

    // Draw gradient area fill
    _drawAreaGradient(canvas, size);

    // Draw main line
    _drawLine(canvas, size);

    // Draw data points
    _drawDataPoints(canvas, size);

    // Draw hover indicator
    if (hoveredIndex != null) {
      _drawHoverIndicator(canvas, size, hoveredIndex!);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDarkMode ? Colors.white : Colors.black).withOpacity(0.06)
      ..strokeWidth = 1;

    // Draw 5 horizontal grid lines (0%, 25%, 50%, 75%, 100%)
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawAreaGradient(Canvas canvas, Size size) {
    final path = Path();
    final points = _calculatePoints(size);

    // Start from bottom left
    path.moveTo(0, size.height);

    // Line to first point
    if (points.isNotEmpty) {
      path.lineTo(points[0].dx, size.height);
      path.lineTo(points[0].dx, points[0].dy);
    }

    // Smooth curve through all points
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlPoint = Offset(prev.dx + (curr.dx - prev.dx) / 2, prev.dy);
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        curr.dx,
        curr.dy,
      );
    }

    // Close path to bottom right
    if (points.isNotEmpty) {
      path.lineTo(points.last.dx, size.height);
      path.lineTo(0, size.height);
    }

    // Apply gradient fill (blue with opacity gradient)
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.blue.withOpacity(0.25),
        AppColors.blue.withOpacity(0.05),
        AppColors.blue.withOpacity(0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, gradientPaint);
  }

  void _drawLine(Canvas canvas, Size size) {
    final points = _calculatePoints(size);
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    // Smooth bezier curve through all points
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlPoint = Offset(prev.dx + (curr.dx - prev.dx) / 2, prev.dy);
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        curr.dx,
        curr.dy,
      );
    }

    final linePaint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  void _drawDataPoints(Canvas canvas, Size size) {
    final points = _calculatePoints(size);

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      // Outer white border
      final outerPaint = Paint()
        ..color = isDarkMode ? const Color(0xFF2A2A2A) : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 5, outerPaint);

      // Inner blue circle
      final innerPaint = Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 4, innerPaint);
    }
  }

  void _drawHoverIndicator(Canvas canvas, Size size, int index) {
    if (index < 0 || index >= values.length) return;

    final points = _calculatePoints(size);
    if (index >= points.length) return;

    final point = points[index];

    // Vertical indicator line
    final linePaint = Paint()
      ..color = AppColors.blue.withOpacity(0.3)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(point.dx, 0),
      Offset(point.dx, size.height),
      linePaint,
    );

    // Highlighted point (larger)
    final glowPaint = Paint()
      ..color = AppColors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, 10, glowPaint);

    final highlightPaint = Paint()
      ..color = isDarkMode ? const Color(0xFF2A2A2A) : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, 7, highlightPaint);

    final centerPaint = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, 6, centerPaint);
  }

  List<Offset> _calculatePoints(Size size) {
    final points = <Offset>[];
    final range = maxValue - minValue;

    if (range == 0) {
      // All values the same - draw flat line in middle
      for (int i = 0; i < values.length; i++) {
        final x = (i / (values.length - 1)) * size.width;
        points.add(Offset(x, size.height / 2));
      }
      return points;
    }

    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : (i / (values.length - 1)) * size.width;

      // Normalize value to 0-1 range, then invert Y (0 at top)
      final normalized = (values[i] - minValue) / range;
      final y = size.height - (normalized * size.height);

      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(_DailyRevenuePainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.values != values ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
