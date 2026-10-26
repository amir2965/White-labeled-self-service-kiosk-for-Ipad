import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Calendar grid widget for date selection
class CalendarGrid extends StatelessWidget {
  final DateTime displayMonth;
  final DateTime? selectedStart;
  final DateTime? selectedEnd;
  final Function(DateTime) onDateSelected;
  final bool isDarkMode;

  const CalendarGrid({
    super.key,
    required this.displayMonth,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onDateSelected,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weekday header row
        _buildWeekdayHeader(),

        SizedBox(height: AppSpacing.sm),

        // Calendar grid
        Expanded(child: _buildCalendarGrid()),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.gray600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _getDaysInMonth();
    final weeks = <List<DateTime?>>[];

    // Group days into weeks
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return Column(
      children: weeks
          .map(
            (week) => Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: week
                    .map(
                      (date) => Expanded(
                        child: date != null
                            ? _buildDayCell(date)
                            : SizedBox.shrink(),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isInCurrentMonth = date.month == displayMonth.month;
    final isSelected = _isDateSelected(date);
    final isInRange = _isDateInRange(date);
    final isStartBoundary =
        selectedStart != null &&
        date.year == selectedStart!.year &&
        date.month == selectedStart!.month &&
        date.day == selectedStart!.day;
    final isEndBoundary =
        selectedEnd != null &&
        date.year == selectedEnd!.year &&
        date.month == selectedEnd!.month &&
        date.day == selectedEnd!.day;

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isInRange
              ? (isDarkMode ? Colors.white.withOpacity(0.1) : AppColors.gray200)
              : (isSelected
                    ? (isDarkMode ? const Color(0xFF007AFF) : AppColors.black)
                    : Colors.transparent),
          shape: BoxShape.circle,
          border: (isStartBoundary || isEndBoundary)
              ? Border.all(
                  color: isDarkMode ? const Color(0xFF007AFF) : AppColors.black,
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: (isStartBoundary || isEndBoundary)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: isSelected
                  ? AppColors.white
                  : (isInCurrentMonth
                        ? (isDarkMode ? Colors.white : AppColors.black)
                        : (isDarkMode
                              ? Colors.white.withOpacity(0.3)
                              : AppColors.gray400)),
            ),
          ),
        ),
      ),
    );
  }

  bool _isDateSelected(DateTime date) {
    if (selectedStart == null) return false;

    final isStart =
        date.year == selectedStart!.year &&
        date.month == selectedStart!.month &&
        date.day == selectedStart!.day;

    if (selectedEnd == null) return isStart;

    final isEnd =
        date.year == selectedEnd!.year &&
        date.month == selectedEnd!.month &&
        date.day == selectedEnd!.day;

    return isStart || isEnd;
  }

  bool _isDateInRange(DateTime date) {
    if (selectedStart == null || selectedEnd == null) return false;

    final isAfterStart =
        date.isAfter(selectedStart!) || date.isAtSameMomentAs(selectedStart!);
    final isBeforeEnd =
        date.isBefore(selectedEnd!) || date.isAtSameMomentAs(selectedEnd!);

    return isAfterStart && isBeforeEnd && !_isDateSelected(date);
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDay = DateTime(displayMonth.year, displayMonth.month + 1, 0);

    // Get the weekday of the first day (0 = Sunday, 6 = Saturday)
    final firstWeekday = firstDay.weekday % 7;

    // Create list with null placeholders for days before the first day
    final days = <DateTime?>[];
    for (var i = 0; i < firstWeekday; i++) {
      days.add(null);
    }

    // Add all days of the month
    for (var day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(displayMonth.year, displayMonth.month, day));
    }

    // Pad to complete the last week
    while (days.length % 7 != 0) {
      days.add(null);
    }

    return days;
  }
}
