import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// System status card showing health indicators
class StatusCard extends StatelessWidget {
  final VoidCallback onViewDetails;

  const StatusCard({super.key, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.3),
            width: 1,
          ),
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
            // Status Indicator
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'System Healthy',
                  style: AppTypography.h3.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // Status Items
            _buildStatusItem(
              'Kiosk',
              'Ready',
              Icons.check_circle_outline,
              const Color(0xFF10B981),
            ),
            SizedBox(height: AppSpacing.md),
            _buildStatusItem(
              'Connectivity',
              'Active',
              Icons.wifi,
              const Color(0xFF10B981),
            ),
            SizedBox(height: AppSpacing.md),
            _buildStatusItem(
              'Payment',
              'Connected',
              Icons.credit_card,
              const Color(0xFF10B981),
            ),

            SizedBox(height: AppSpacing.lg),

            // View Details Link
            Row(
              children: [
                Text(
                  'View Details',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward, size: 16, color: AppColors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray700),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }
}
