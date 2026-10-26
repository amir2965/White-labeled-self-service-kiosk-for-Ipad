import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/date_range_selection.dart';
import '../theme_provider.dart';
import 'date_range_popover.dart';

/// Date range pill button that opens the picker popover
class DateRangePill extends ConsumerWidget {
  final DateRangeSelection selection;
  final Function(DateRangeSelection) onSelectionChanged;

  const DateRangePill({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray300.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous button
          _buildArrowButton(
            icon: Icons.chevron_left,
            onTap: () => _onPreviousPressed(),
            isDarkMode: isDarkMode,
          ),

          // Date text button (opens popover)
          InkWell(
            onTap: () => _showDatePicker(context),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.gray700,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    _formatSelection(),
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Next button
          _buildArrowButton(
            icon: Icons.chevron_right,
            onTap: () => _onNextPressed(),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        child: Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.white.withOpacity(0.7) : AppColors.gray700,
        ),
      ),
    );
  }

  String _formatSelection() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (selection.isSingleDay) {
      return dateFormat.format(selection.start);
    } else {
      return '${dateFormat.format(selection.start)} – ${dateFormat.format(selection.end)}';
    }
  }

  void _onPreviousPressed() {
    if (selection.isSingleDay) {
      // Previous day
      final newDate = selection.start.subtract(Duration(days: 1));
      onSelectionChanged(DateRangeSelection.singleDay(newDate));
    } else {
      // Shift range backward by same number of days
      final rangeDays = selection.end.difference(selection.start).inDays;
      final newStart = selection.start.subtract(Duration(days: rangeDays + 1));
      final newEnd = selection.end.subtract(Duration(days: rangeDays + 1));
      onSelectionChanged(DateRangeSelection.range(newStart, newEnd));
    }
  }

  void _onNextPressed() {
    if (selection.isSingleDay) {
      // Next day
      final newDate = selection.start.add(Duration(days: 1));
      onSelectionChanged(DateRangeSelection.singleDay(newDate));
    } else {
      // Shift range forward by same number of days
      final rangeDays = selection.end.difference(selection.start).inDays;
      final newStart = selection.start.add(Duration(days: rangeDays + 1));
      final newEnd = selection.end.add(Duration(days: rangeDays + 1));
      onSelectionChanged(DateRangeSelection.range(newStart, newEnd));
    }
  }

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => DateRangePopover(
        initialSelection: selection,
        onSelectionChanged: (newSelection) {
          onSelectionChanged(newSelection);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
