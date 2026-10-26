import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Modern minimal chart container with metadata header
/// Luxury design
class ModernChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? metric;
  final String? timeframe;
  final Widget chart;
  final VoidCallback? onInfoTap;
  final String? insightText;
  final Color? insightColor;
  final IconData? insightIcon;
  final bool isDarkMode;

  const ModernChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.chart,
    this.metric,
    this.timeframe,
    this.onInfoTap,
    this.insightText,
    this.insightColor,
    this.insightIcon,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.7)
                                  : AppColors.gray600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onInfoTap != null)
                      InkWell(
                        onTap: onInfoTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.6)
                                : AppColors.gray500,
                          ),
                        ),
                      ),
                  ],
                ),

                // Metric and timeframe
                if (metric != null || timeframe != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      if (metric != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            metric!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                      if (metric != null && timeframe != null)
                        const SizedBox(width: AppSpacing.sm),
                      if (timeframe != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : AppColors.gray100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.7)
                                    : AppColors.gray600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeframe!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.8)
                                      : AppColors.gray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Insight banner
                if (insightText != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: (insightColor ?? AppColors.blue).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (insightColor ?? AppColors.blue).withOpacity(
                          0.2,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          insightIcon ?? Icons.lightbulb_outline,
                          size: 16,
                          color: insightColor ?? AppColors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            insightText!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: insightColor ?? AppColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
          ),

          // Chart
          Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: chart),
        ],
      ),
    );
  }
}

/// Chart legend item
class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String? value;
  final bool isActive;

  const ChartLegendItem({
    super.key,
    required this.color,
    required this.label,
    this.value,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray700,
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 4),
            Text(
              value!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Chart stat pill
class ChartStatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;

  const ChartStatPill({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color ?? AppColors.gray600),
            const SizedBox(width: 6),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color ?? AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
