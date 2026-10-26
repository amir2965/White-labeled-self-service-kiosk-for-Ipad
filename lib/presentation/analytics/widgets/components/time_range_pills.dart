import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'date_range_selector_dialog.dart';

/// Time range selector with pill buttons
class TimeRangePills extends StatelessWidget {
  final String selectedRange;
  final Function(String) onRangeSelected;
  final Function(DateTime start, DateTime end)? onCustomRangeSelected;
  final List<String> ranges;
  final bool showMoreButton;
  final bool isDarkMode;

  const TimeRangePills({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
    this.onCustomRangeSelected,
    this.ranges = const [
      'Today',
      'Yesterday',
      'Last 7 Days',
      'Last 30 Days',
      'This Year',
      'Previous Year',
    ],
    this.showMoreButton = true,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Increased from 40 to prevent text cutoff
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: isDarkMode
            ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
            : null,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Range pills
          ...ranges.map((range) {
            final isSelected = range == selectedRange;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _RangePill(
                label: range,
                isSelected: isSelected,
                onTap: () => onRangeSelected(range),
                isDarkMode: isDarkMode,
              ),
            );
          }),

          // More button
          if (showMoreButton) ...[
            const SizedBox(width: 4),
            _MoreButton(
              currentSelection: selectedRange,
              onRangeSelected: onRangeSelected,
              onCustomRangeSelected: onCustomRangeSelected,
              isDarkMode: isDarkMode,
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual range pill button
class _RangePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _RangePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10, // Increased padding for better text display
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDarkMode
                      ? Colors.white.withOpacity(0.15)
                      : AppColors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: isSelected && !isDarkMode
                ? [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected
                    ? (isDarkMode ? Colors.white : AppColors.black)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray600),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                height: 1.2, // Better line height
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// More button that opens date range selector dialog
class _MoreButton extends StatelessWidget {
  final String currentSelection;
  final Function(String) onRangeSelected;
  final Function(DateTime start, DateTime end)? onCustomRangeSelected;
  final bool isDarkMode;

  const _MoreButton({
    required this.currentSelection,
    required this.onRangeSelected,
    this.onCustomRangeSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDateRangeSelector(
            context,
            currentSelection: currentSelection,
            onSelectionChanged: onRangeSelected,
            onCustomRangeSelected: onCustomRangeSelected,
          );
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.more_horiz,
                size: 20,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.gray700,
              ),
              const SizedBox(width: 4),
              Text(
                'More',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.gray700,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
