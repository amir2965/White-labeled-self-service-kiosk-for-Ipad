import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Premium metric card component
/// Displays a single KPI with optional subtitle and delta
class AnalyticsMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final String? delta;
  final bool isDeltaPositive;
  final bool isLarge;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const AnalyticsMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.delta,
    this.isDeltaPositive = true,
    this.isLarge = false,
    this.icon,
    this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? AppSpacing.xl : AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label with optional icon
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.gray600,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.gray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isLarge ? AppSpacing.md : AppSpacing.sm),

            // Big value
            Text(
              value,
              style: (isLarge ? AppTypography.display1 : AppTypography.h1)
                  .copyWith(color: isDarkMode ? Colors.white : Colors.black87),
            ),

            // Subtitle or delta
            if (subtitle != null || delta != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    if (subtitle != null)
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.6)
                                : AppColors.gray600,
                          ),
                        ),
                      ),
                    if (delta != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDeltaPositive
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          delta!,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDeltaPositive
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
