import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../providers/sales_summary_provider.dart';
import '../models/sales_summary_model.dart';

/// **Professional Modern Sales Summary**
///
/// A clean, minimal, and highly informative sales analytics dashboard
/// Built from scratch following these design principles:
/// - Minimal black/white/blue color palette
/// - Clear metric hierarchy
/// - Professional charts
/// - Generous white space
/// - Mobile-optimized touch targets
class SalesSummaryContent extends ConsumerStatefulWidget {
  const SalesSummaryContent({super.key});

  @override
  ConsumerState<SalesSummaryContent> createState() =>
      _SalesSummaryContentState();
}

class _SalesSummaryContentState extends ConsumerState<SalesSummaryContent> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedHourIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesSummaryProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesSummaryProvider);

    return salesState.when(
      data: _buildContent,
      loading: _buildLoading,
      error: (error, stack) => _buildError(error),
    );
  }

  Widget _buildContent(SalesSummaryModel data) {
    return Container(
      color: AppColors.gray100,
      child: CustomScrollView(
        slivers: [
          // Date Selector Header
          SliverToBoxAdapter(child: _buildDateHeader()),

          // Key Metrics Cards (4 cards now)
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildKeyMetrics(data)),
          ),

          // Payment Method Split (QR vs Counter) - Prominent
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildPaymentMethodSplit(data)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Sales Trend Chart
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildSalesTrendChart(data)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Peak Hours Insight
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildPeakHoursInsight(data)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Kiosk Performance (if multiple kiosks)
          if (data.kioskPerformances.length > 1)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              sliver: SliverToBoxAdapter(child: _buildKioskPerformance(data)),
            ),

          if (data.kioskPerformances.length > 1)
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Payment Method Trend Over Time
          if (data.paymentMethodTrends.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              sliver: SliverToBoxAdapter(child: _buildPaymentMethodTrend(data)),
            ),

          if (data.paymentMethodTrends.isNotEmpty)
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Payment Breakdown (Original detailed)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildPaymentBreakdown(data)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Financial Details
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(child: _buildFinancialDetails(data)),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Bottom padding
          ),
        ],
      ),
    );
  }

  /// Date selector header with navigation
  Widget _buildDateHeader() {
    final dateFormat = DateFormat('EEEE, MMM d, y');

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Previous day button
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
              ref.read(salesSummaryProvider.notifier).refresh();
            },
            tooltip: 'Previous day',
          ),

          const SizedBox(width: AppSpacing.md),

          // Date display
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.blue,
                          onPrimary: AppColors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                  ref.read(salesSummaryProvider.notifier).refresh();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateFormat.format(_selectedDate),
                      style: AppTypography.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Next day button
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 28),
            onPressed:
                _selectedDate.isBefore(
                  DateTime.now().subtract(const Duration(days: 1)),
                )
                ? () {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        const Duration(days: 1),
                      );
                    });
                    ref.read(salesSummaryProvider.notifier).refresh();
                  }
                : null,
            tooltip: 'Next day',
          ),
        ],
      ),
    );
  }

  /// Key metrics cards (Total Sales, Orders, AOV, Transactions)
  Widget _buildKeyMetrics(SalesSummaryModel data) {
    final aov = data.totalOrders > 0 ? data.grossSales / data.totalOrders : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'TOTAL SALES',
                value: _formatCurrency(data.grossSales),
                subtitle: DateFormat('MMM d, y').format(data.selectedDate),
                icon: Icons.paid_outlined,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _buildMetricCard(
                title: 'ORDERS',
                value: data.totalOrders.toString(),
                subtitle: 'Transactions',
                icon: Icons.receipt_long_outlined,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'AVG ORDER VALUE',
                value: _formatCurrency(aov),
                subtitle: 'Per transaction',
                icon: Icons.shopping_cart_outlined,
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _buildMetricCard(
                title: 'NET SALES',
                value: _formatCurrency(data.netSales),
                subtitle: 'After fees & taxes',
                icon: Icons.trending_up,
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            value,
            style: AppTypography.h1.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
            ),
          ],
        ],
      ),
    );
  }

  /// Professional line chart showing hourly sales trend
  Widget _buildSalesTrendChart(SalesSummaryModel data) {
    if (data.hourlySalesPointsSelectedDay.isEmpty) {
      return _buildEmptyChart();
    }

    final maxY = data.hourlySalesPointsSelectedDay
        .map((p) => p.sales)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sales Trend',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Hourly',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sales by hour throughout the day',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.gray300,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCurrency(value),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 3 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${value.toInt()}:00',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 23,
                minY: 0,
                maxY: maxY * 1.2,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.black.withOpacity(0.9),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(12),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final hour = spot.x.toInt();
                        final sales = spot.y;
                        return LineTooltipItem(
                          '${hour}:00\n${_formatCurrency(sales)}',
                          AppTypography.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback: (event, response) {
                    if (response != null && response.lineBarSpots != null) {
                      setState(() {
                        _selectedHourIndex = response.lineBarSpots!.first.x
                            .toInt();
                      });
                    } else {
                      setState(() {
                        _selectedHourIndex = null;
                      });
                    }
                  },
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(color: AppColors.blue, strokeWidth: 2),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: AppColors.white,
                              strokeWidth: 3,
                              strokeColor: AppColors.blue,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.hourlySalesPointsSelectedDay
                        .map(
                          (point) => FlSpot(point.hour.toDouble(), point.sales),
                        )
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.blue,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final isSelected = _selectedHourIndex == spot.x.toInt();
                        return FlDotCirclePainter(
                          radius: isSelected ? 5 : 3,
                          color: isSelected ? AppColors.white : AppColors.blue,
                          strokeWidth: isSelected ? 2 : 0,
                          strokeColor: isSelected
                              ? AppColors.blue
                              : Colors.transparent,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue.withOpacity(0.3),
                          AppColors.blue.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.show_chart, size: 64, color: AppColors.gray400),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No sales data available',
              style: AppTypography.h4.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }

  /// Payment methods breakdown
  Widget _buildPaymentBreakdown(SalesSummaryModel data) {
    final payments = data.paymentsBreakdown;
    final total =
        payments.card + payments.cash + payments.giftCard + payments.other;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Breakdown by payment type',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (payments.card > 0)
            _buildPaymentRow(
              'Card',
              payments.card,
              total,
              Icons.credit_card,
              AppColors.blue,
            ),
          if (payments.cash > 0)
            _buildPaymentRow(
              'Cash',
              payments.cash,
              total,
              Icons.payments_outlined,
              AppColors.gray800,
            ),
          if (payments.giftCard > 0)
            _buildPaymentRow(
              'Gift Card',
              payments.giftCard,
              total,
              Icons.card_giftcard,
              AppColors.gray700,
            ),
          if (payments.other > 0)
            _buildPaymentRow(
              'Other',
              payments.other,
              total,
              Icons.more_horiz,
              AppColors.gray600,
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(
    String label,
    double amount,
    double total,
    IconData icon,
    Color color,
  ) {
    final percentage = (amount / total * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatCurrency(amount),
                style: AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: amount / total,
              minHeight: 6,
              backgroundColor: AppColors.gray300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  /// Financial details breakdown
  Widget _buildFinancialDetails(SalesSummaryModel data) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Summary',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Detailed breakdown of all transactions',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildDetailRow('Gross Sales', data.grossSales, isTotal: false),
          _buildDetailRow('Product Sales', data.productSales, isTotal: false),
          if (data.tips > 0) _buildDetailRow('Tips', data.tips, isTotal: false),
          if (data.discounts > 0)
            _buildDetailRow(
              'Discounts',
              -data.discounts,
              isTotal: false,
              isNegative: true,
            ),
          if (data.returns > 0)
            _buildDetailRow(
              'Returns',
              -data.returns,
              isTotal: false,
              isNegative: true,
            ),
          const Divider(height: AppSpacing.xxl, thickness: 1),
          _buildDetailRow('Net Sales', data.netSales, isTotal: false),
          _buildDetailRow('Taxes', data.taxes, isTotal: false),
          const Divider(height: AppSpacing.xxl, thickness: 2),
          _buildDetailRow(
            'Total Collected',
            data.totalCollected,
            isTotal: true,
          ),
          if (data.paymentsBreakdown.fees > 0) ...[
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
              'Processing Fees',
              -data.paymentsBreakdown.fees,
              isTotal: false,
              isNegative: true,
              isSubtle: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    double amount, {
    required bool isTotal,
    bool isNegative = false,
    bool isSubtle = false,
  }) {
    final textStyle = isTotal
        ? AppTypography.h3.copyWith(fontWeight: FontWeight.w700)
        : AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: isSubtle ? AppColors.gray600 : AppColors.gray800,
          );

    final amountStyle = isTotal
        ? AppTypography.h3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          )
        : AppTypography.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: isNegative ? AppColors.error : AppColors.gray800,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(_formatCurrency(amount), style: amountStyle),
        ],
      ),
    );
  }

  /// Payment Method Split - QR Code vs Pay at Counter (Prominent Card)
  Widget _buildPaymentMethodSplit(SalesSummaryModel data) {
    final qrAmount = data.paymentsBreakdown.qrCode;
    final counterAmount = data.paymentsBreakdown.payAtCounter;
    final total = qrAmount + counterAmount;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    final qrPercentage = (qrAmount / total * 100).toInt();
    final counterPercentage = (counterAmount / total * 100).toInt();
    final qrCount = data.paymentsBreakdown.qrCodeCount;
    final counterCount = data.paymentsBreakdown.payAtCounterCount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method Performance',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'QR Code vs Pay at Counter',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              // QR Code Column
              Expanded(
                flex: qrPercentage,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    border: Border.all(color: AppColors.blue, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.qr_code, color: AppColors.blue, size: 28),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'QR Code',
                            style: AppTypography.h4.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _formatCurrency(qrAmount),
                        style: AppTypography.h1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$qrCount transactions • $qrPercentage%',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Pay at Counter Column
              Expanded(
                flex: counterPercentage,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.gray800.withOpacity(0.05),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(12),
                    ),
                    border: Border.all(color: AppColors.gray800, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: AppColors.gray800,
                            size: 28,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Pay at Counter',
                            style: AppTypography.h4.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _formatCurrency(counterAmount),
                        style: AppTypography.h1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$counterCount transactions • $counterPercentage%',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.gray800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Peak Hours Insight Card
  Widget _buildPeakHoursInsight(SalesSummaryModel data) {
    if (data.hourlySalesPointsSelectedDay.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find peak hour
    var peakHour = 0;
    var peakSales = 0.0;
    var slowHour = 0;
    var slowSales = double.infinity;

    for (final point in data.hourlySalesPointsSelectedDay) {
      if (point.sales > peakSales) {
        peakSales = point.sales;
        peakHour = point.hour;
      }
      if (point.sales > 0 && point.sales < slowSales) {
        slowSales = point.sales;
        slowHour = point.hour;
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Row(
        children: [
          // Peak Hour
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Peak Hour',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${peakHour.toString().padLeft(2, '0')}:00',
                    style: AppTypography.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatCurrency(peakSales),
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Slow Hour
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.gray300.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_down,
                        color: AppColors.gray600,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Slow Hour',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${slowHour.toString().padLeft(2, '0')}:00',
                    style: AppTypography.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatCurrency(
                      slowSales == double.infinity ? 0 : slowSales,
                    ),
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kiosk Performance Comparison
  Widget _buildKioskPerformance(SalesSummaryModel data) {
    if (data.kioskPerformances.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort by total sales
    final sortedKiosks = List<KioskPerformance>.from(data.kioskPerformances)
      ..sort((a, b) => b.totalSales.compareTo(a.totalSales));

    final maxSales = sortedKiosks.first.totalSales;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kiosk Performance',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${sortedKiosks.length} kiosks',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sales ranking and contribution',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xxl),
          ...sortedKiosks.map((kiosk) {
            final percentage = (kiosk.totalSales / maxSales);
            final rank = sortedKiosks.indexOf(kiosk) + 1;
            final isTopPerformer = rank == 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isTopPerformer
                              ? AppColors.blue
                              : AppColors.gray300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '#$rank',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isTopPerformer
                                  ? AppColors.white
                                  : AppColors.gray700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kiosk.kioskName,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${kiosk.transactionCount} orders • AOV: ${_formatCurrency(kiosk.averageOrderValue)}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatCurrency(kiosk.totalSales),
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isTopPerformer
                              ? AppColors.blue
                              : AppColors.gray800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: AppColors.gray300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isTopPerformer ? AppColors.blue : AppColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Payment Method Trend Over Time
  Widget _buildPaymentMethodTrend(SalesSummaryModel data) {
    if (data.paymentMethodTrends.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxY = data.paymentMethodTrends
        .map((t) => t.qrCodeAmount + t.payAtCounterAmount)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method Trend',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'QR vs Counter adoption over time',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.gray300,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCurrency(value),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= data.paymentMethodTrends.length) {
                          return const SizedBox();
                        }
                        final trend = data.paymentMethodTrends[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MMM d').format(trend.timestamp),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.paymentMethodTrends.length - 1).toDouble(),
                minY: 0,
                maxY: maxY * 1.2,
                lineBarsData: [
                  // QR Code Line
                  LineChartBarData(
                    spots: data.paymentMethodTrends.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.qrCodeAmount);
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.blue.withOpacity(0.2),
                    ),
                  ),
                  // Pay at Counter Line
                  LineChartBarData(
                    spots: data.paymentMethodTrends.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value.payAtCounterAmount,
                      );
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.gray700,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.gray700.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.black.withOpacity(0.9),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(12),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= data.paymentMethodTrends.length) {
                          return null;
                        }
                        final trend = data.paymentMethodTrends[index];
                        final isQR = spot.barIndex == 0;
                        final amount = isQR
                            ? trend.qrCodeAmount
                            : trend.payAtCounterAmount;
                        final label = isQR ? 'QR Code' : 'Counter';
                        return LineTooltipItem(
                          '$label\n${_formatCurrency(amount)}',
                          AppTypography.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('QR Code', AppColors.blue),
              const SizedBox(width: AppSpacing.xl),
              _buildLegendItem('Pay at Counter', AppColors.gray700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      color: AppColors.gray100,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Container(
      color: AppColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Unable to load sales data',
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error.toString(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () {
                ref.read(salesSummaryProvider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }
}
