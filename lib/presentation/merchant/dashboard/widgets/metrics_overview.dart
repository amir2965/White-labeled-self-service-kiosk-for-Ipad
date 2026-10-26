import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../providers/sales_provider.dart';

/// Metrics overview showing today's business snapshot
class MetricsOverview extends ConsumerWidget {
  const MetricsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesData = ref.watch(salesProvider);

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Overview',
                style: AppTypography.h3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  salesData.when(
                    data: (_) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: AppColors.success),
                          SizedBox(width: 4),
                          Text(
                            'Live',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.gray400,
                      ),
                    ),
                    error: (_, __) => Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: Icon(Icons.refresh, size: 20),
                    onPressed: () => ref.read(salesProvider.notifier).refresh(),
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                    tooltip: 'Refresh data',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xl),

          // Metrics Grid
          salesData.when(
            data: (metrics) => LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildMetric(
                          'Orders',
                          metrics.todayOrders.toString(),
                          Icons.receipt_long,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: _buildMetric(
                          'Revenue',
                          '\$${metrics.todayRevenue.toStringAsFixed(2)}',
                          Icons.attach_money,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: _buildMetric(
                          'Avg. Order',
                          '\$${metrics.todayAvgOrder.toStringAsFixed(2)}',
                          Icons.trending_up,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildMetric(
                        'Orders',
                        metrics.todayOrders.toString(),
                        Icons.receipt_long,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _buildMetric(
                        'Revenue',
                        '\$${metrics.todayRevenue.toStringAsFixed(2)}',
                        Icons.attach_money,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _buildMetric(
                        'Avg. Order',
                        '\$${metrics.todayAvgOrder.toStringAsFixed(2)}',
                        Icons.trending_up,
                      ),
                    ],
                  );
                }
              },
            ),
            loading: () => _buildLoadingState(),
            error: (error, _) => _buildErrorState(error.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Row(
      children: [
        Expanded(child: _buildMetric('Orders', '---', Icons.receipt_long)),
        SizedBox(width: AppSpacing.lg),
        Expanded(child: _buildMetric('Revenue', '---', Icons.attach_money)),
        SizedBox(width: AppSpacing.lg),
        Expanded(child: _buildMetric('Avg. Order', '---', Icons.trending_up)),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Unable to load sales data. Check server connection.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.gray600),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}
