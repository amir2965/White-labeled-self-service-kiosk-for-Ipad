import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/date_range_selection.dart';
import '../theme_provider.dart';
import 'date_range_pill.dart';
import 'reporting_timeframe_pill.dart';

/// Top filters bar with pill-style controls
class SalesSummaryTopFiltersBar extends ConsumerWidget {
  final DateRangeSelection dateSelection;
  final Function(DateRangeSelection) onDateSelectionChanged;
  final VoidCallback onPrint;
  final VoidCallback onExport;

  const SalesSummaryTopFiltersBar({
    super.key,
    required this.dateSelection,
    required this.onDateSelectionChanged,
    required this.onPrint,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      children: [
        // Row 1: Main controls
        Row(
          children: [
            // Date selector with arrows - now using DateRangePill
            DateRangePill(
              selection: dateSelection,
              onSelectionChanged: onDateSelectionChanged,
            ),
            SizedBox(width: AppSpacing.sm),
            // Reporting timeframe picker
            ReportingTimeframePill(),
            SizedBox(width: AppSpacing.sm),
            _buildDropdownPill('Summary', isDarkMode),
            SizedBox(width: AppSpacing.sm),
            _buildDropdownPill('Display by', isDarkMode),

            const Spacer(),

            // Actions
            IconButton(
              icon: Icon(
                Icons.print,
                size: 20,
                color: isDarkMode ? Colors.white.withOpacity(0.7) : null,
              ),
              onPressed: onPrint,
              tooltip: 'Print',
            ),
            IconButton(
              icon: Icon(
                Icons.download,
                size: 20,
                color: isDarkMode ? Colors.white.withOpacity(0.7) : null,
              ),
              onPressed: onExport,
              tooltip: 'Export',
            ),
          ],
        ),

        SizedBox(height: AppSpacing.sm),

        // Row 2: Secondary filters
        Row(
          children: [
            _buildDropdownPill('Filter By', isDarkMode),
            SizedBox(width: AppSpacing.sm),
            _buildDropdownPill('Closed Bills', isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownPill(String label, bool isDarkMode) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray300.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : AppColors.black,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.expand_more,
            size: 18,
            color: isDarkMode
                ? Colors.white.withOpacity(0.7)
                : AppColors.gray700,
          ),
        ],
      ),
    );
  }
}
