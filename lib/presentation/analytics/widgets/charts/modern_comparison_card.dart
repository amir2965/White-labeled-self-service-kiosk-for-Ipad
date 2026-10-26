import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Modern comparison card showing period-over-period changes
/// Minimal design
class ModernComparisonCard extends StatelessWidget {
  final String title;
  final double currentValue;
  final double? previousValue;
  final String? customLabel;
  final bool showPercentage;
  final bool isRevenueMetric;
  final bool isDarkMode;

  const ModernComparisonCard({
    super.key,
    required this.title,
    required this.currentValue,
    this.previousValue,
    this.customLabel,
    this.showPercentage = true,
    this.isRevenueMetric = true,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasComparison = previousValue != null && previousValue! > 0;
    final change = hasComparison ? currentValue - previousValue! : 0;
    final changePercent = hasComparison ? (change / previousValue!) * 100 : 0;
    final isPositive = change > 0;
    final isNeutral = change == 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.gray600,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Current value
          Text(
            _formatValue(currentValue),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : AppColors.black,
              letterSpacing: -0.5,
            ),
          ),

          if (hasComparison) ...[
            const SizedBox(height: AppSpacing.sm),

            // Change indicator
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isNeutral
                        ? AppColors.gray100
                        : (isPositive ? AppColors.blue : AppColors.error)
                              .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    isNeutral
                        ? Icons.remove
                        : (isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                    size: 14,
                    color: isNeutral
                        ? AppColors.gray500
                        : (isPositive ? AppColors.blue : AppColors.error),
                  ),
                ),

                const SizedBox(width: 6),

                // Change text
                Text(
                  _formatChange(change.toDouble(), changePercent.toDouble()),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isNeutral
                        ? AppColors.gray600
                        : (isPositive ? AppColors.blue : AppColors.error),
                  ),
                ),

                const SizedBox(width: 4),

                // Label
                Text(
                  customLabel ?? 'vs previous period',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),

            // Visual comparison bar
            const SizedBox(height: AppSpacing.md),
            _buildComparisonBar(currentValue, previousValue!),
          ],
        ],
      ),
    );
  }

  Widget _buildComparisonBar(double current, double previous) {
    final maxValue = math.max(current, previous);
    final currentPercent = (current / maxValue * 100).clamp(0, 100);
    final previousPercent = (previous / maxValue * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current period bar
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                'Current',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray600,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: currentPercent / 100,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: Text(
                _formatValue(current),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // Previous period bar
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                'Previous',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray600,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: previousPercent / 100,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.gray400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: Text(
                _formatValue(previous),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatValue(double value) {
    if (isRevenueMetric) {
      if (value >= 1000000) {
        return '\$${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '\$${(value / 1000).toStringAsFixed(1)}K';
      }
      return '\$${value.toStringAsFixed(0)}';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  String _formatChange(double change, double percent) {
    final absChange = change.abs();
    final absPercent = percent.abs();

    if (showPercentage) {
      return '${absPercent.toStringAsFixed(1)}%';
    } else {
      return _formatValue(absChange);
    }
  }
}

/// Insights panel showing AI-generated or rule-based insights
class ModernInsightsPanel extends StatelessWidget {
  final List<String> insights;
  final String? title;
  final bool isDarkMode;

  const ModernInsightsPanel({
    super.key,
    required this.insights,
    this.title,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.blue.withOpacity(0.08)
            : AppColors.blue.withOpacity(0.04),
        border: Border.all(
          color: isDarkMode
              ? AppColors.blue.withOpacity(0.3)
              : AppColors.blue.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.blue.withOpacity(0.15)
                      : AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.lightbulb,
                  size: 16,
                  color: isDarkMode
                      ? AppColors.blue.withOpacity(0.9)
                      : AppColors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title ?? 'Insights',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Insights list
          ...insights.asMap().entries.map((entry) {
            final index = entry.key;
            final insight = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < insights.length - 1 ? AppSpacing.sm : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.blue.withOpacity(0.8)
                          : AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.gray800,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
