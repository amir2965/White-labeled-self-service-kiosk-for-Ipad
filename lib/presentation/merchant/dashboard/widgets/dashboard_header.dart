import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Dashboard header with business name and timestamp
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr =
        '${_formatHour(now.hour)}:${_padZero(now.minute)} ${_getAmPm(now.hour)}';
    final dateStr =
        '${_getWeekday(now.weekday)}, ${_getMonth(now.month)} ${now.day}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Message
        Text(
          'Command Center',
          style: AppTypography.h1.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSpacing.xs),

        // Business Info
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.gray300.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 16,
                    color: AppColors.gray700,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Demo Café',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              '$dateStr • $timeStr',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12';
    if (hour > 12) return '${hour - 12}';
    return '$hour';
  }

  String _padZero(int value) => value.toString().padLeft(2, '0');

  String _getAmPm(int hour) => hour >= 12 ? 'PM' : 'AM';

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonth(int month) {
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
    return months[month - 1];
  }
}
