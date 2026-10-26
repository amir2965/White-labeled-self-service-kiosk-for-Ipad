import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../theme_provider.dart';
import 'custom_date_range_picker.dart';

/// Modern minimal date range selector dialog
class DateRangeSelectorDialog extends ConsumerStatefulWidget {
  final String currentSelection;
  final Function(String) onSelectionChanged;
  final Function(DateTime start, DateTime end)? onCustomRangeSelected;

  const DateRangeSelectorDialog({
    super.key,
    required this.currentSelection,
    required this.onSelectionChanged,
    this.onCustomRangeSelected,
  });

  @override
  ConsumerState<DateRangeSelectorDialog> createState() =>
      _DateRangeSelectorDialogState();
}

class _DateRangeSelectorDialogState
    extends ConsumerState<DateRangeSelectorDialog> {
  late String _selectedRange;

  final List<Map<String, dynamic>> _allRanges = [
    {'label': 'Today', 'icon': Icons.today},
    {'label': 'Yesterday', 'icon': Icons.event},
    {'label': 'Last 7 Days', 'icon': Icons.date_range},
    {'label': 'Last 30 Days', 'icon': Icons.calendar_month},
    {'label': 'This Year', 'icon': Icons.calendar_today},
    {'label': 'Previous Year', 'icon': Icons.history},
    {'label': 'Last 90 Days', 'icon': Icons.calendar_view_month},
    {'label': 'Month to Date', 'icon': Icons.event_note},
    {'label': 'Quarter to Date', 'icon': Icons.view_agenda},
    {'label': 'Custom Range', 'icon': Icons.date_range_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 480,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: isDarkMode
              ? Border.all(color: Colors.white.withOpacity(0.15))
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(isDarkMode ? 0.6 : 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.15)
                        : AppColors.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 24,
                    color: isDarkMode
                        ? const Color(0xFF007AFF)
                        : AppColors.blue,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Select Date Range',
                    style: AppTypography.h3.copyWith(
                      color: isDarkMode ? Colors.white : AppColors.black,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray600,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Date range options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: _allRanges.length,
                itemBuilder: (context, index) {
                  final range = _allRanges[index];
                  final isSelected = range['label'] == _selectedRange;
                  final isCustomRange = range['label'] == 'Custom Range';

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        if (isCustomRange) {
                          // Open custom date range picker
                          Navigator.pop(context);
                          await showCustomDateRangePicker(
                            context,
                            initialStartDate: DateTime.now().subtract(
                              Duration(days: 7),
                            ),
                            initialEndDate: DateTime.now(),
                            onApply: (start, end) {
                              if (widget.onCustomRangeSelected != null) {
                                widget.onCustomRangeSelected!(start, end);
                              }
                            },
                          );
                        } else {
                          setState(() => _selectedRange = range['label']);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDarkMode
                                    ? const Color(0xFF007AFF).withOpacity(0.15)
                                    : AppColors.blue.withOpacity(0.05))
                              : Colors.transparent,
                          border: Border(
                            left: BorderSide(
                              color: isSelected
                                  ? (isDarkMode
                                        ? const Color(0xFF007AFF)
                                        : AppColors.blue)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDarkMode
                                          ? const Color(0xFF007AFF)
                                          : AppColors.blue)
                                    : (isDarkMode
                                          ? Colors.white.withOpacity(0.05)
                                          : AppColors.gray100),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                range['icon'],
                                size: 20,
                                color: isSelected
                                    ? AppColors.white
                                    : (isDarkMode
                                          ? Colors.white.withOpacity(0.6)
                                          : AppColors.gray600),
                              ),
                            ),

                            const SizedBox(width: AppSpacing.md),

                            // Label
                            Expanded(
                              child: Text(
                                range['label'],
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? (isDarkMode
                                            ? Colors.white
                                            : AppColors.black)
                                      : (isDarkMode
                                            ? Colors.white.withOpacity(0.8)
                                            : AppColors.gray800),
                                ),
                              ),
                            ),

                            // Checkmark
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: isDarkMode
                                    ? const Color(0xFF007AFF)
                                    : AppColors.blue,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Footer with actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.15)
                        : AppColors.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : AppColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      widget.onSelectionChanged(_selectedRange);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF007AFF)
                          : AppColors.blue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white,
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

/// Helper function to show the date range selector dialog
Future<void> showDateRangeSelector(
  BuildContext context, {
  required String currentSelection,
  required Function(String) onSelectionChanged,
  Function(DateTime start, DateTime end)? onCustomRangeSelected,
}) {
  return showDialog(
    context: context,
    barrierColor: AppColors.black.withOpacity(0.4),
    builder: (context) => DateRangeSelectorDialog(
      currentSelection: currentSelection,
      onSelectionChanged: onSelectionChanged,
      onCustomRangeSelected: onCustomRangeSelected,
    ),
  );
}
