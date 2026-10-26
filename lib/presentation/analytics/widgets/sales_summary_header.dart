import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Sales summary header with date and comparison legend
class SalesSummaryHeader extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime? compareDate;
  final DateTime lastUpdated;

  const SalesSummaryHeader({
    super.key,
    required this.selectedDate,
    this.compareDate,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final dateTitle = DateFormat('d MMM y').format(selectedDate);
    final timeAgo = _getTimeAgo(lastUpdated);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Large date title
        Text(
          dateTitle,
          style: AppTypography.display1.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        // Right side: data freshness and legend
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Data as of $timeAgo',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray600,
                fontSize: 13,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLegendItem('Current day', AppColors.black),
                SizedBox(width: AppSpacing.md),
                _buildLegendItem('Comparison day', AppColors.gray400),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 12,
            color: AppColors.gray700,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);

    if (difference.inSeconds < 60) {
      return 'a few seconds ago';
    } else if (difference.inMinutes < 2) {
      return 'a minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 2) {
      return 'an hour ago';
    } else {
      return '${difference.inHours} hours ago';
    }
  }
}
