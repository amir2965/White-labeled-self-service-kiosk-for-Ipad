import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../theme_provider.dart';

/// Luxury minimal single date picker, optimized for transaction views
class CustomSingleDatePicker extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const CustomSingleDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  ConsumerState<CustomSingleDatePicker> createState() =>
      _CustomSingleDatePickerState();
}

class _CustomSingleDatePickerState
    extends ConsumerState<CustomSingleDatePicker> {
  late DateTime _selectedDate;
  late DateTime _viewingMonth;
  final PageController _pageController = PageController(initialPage: 1000);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _viewingMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _viewingMonth = DateTime(_viewingMonth.year, _viewingMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewingMonth = DateTime(_viewingMonth.year, _viewingMonth.month + 1);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _viewingMonth = DateTime(now.year, now.month);
    });
  }

  void _onDateTapped(DateTime date) {
    // Only allow dates within range
    if (date.isBefore(widget.firstDate) || date.isAfter(widget.lastDate)) {
      return;
    }

    setState(() {
      _selectedDate = date;
    });
  }

  void _applySelection() {
    widget.onDateSelected(_selectedDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: isDarkMode
              ? Border.all(color: Colors.white.withOpacity(0.15))
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(isDarkMode ? 0.6 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with month/year navigation
            _buildHeader(isDarkMode),

            // Quick selection row (Today, Yesterday, etc.)
            _buildQuickSelectionRow(isDarkMode),

            // Calendar grid
            _buildCalendarGrid(isDarkMode),

            // Footer with action buttons
            _buildFooter(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    final monthYearText = DateFormat('MMMM yyyy').format(_viewingMonth);
    final now = DateTime.now();
    final isCurrentMonth =
        _viewingMonth.year == now.year && _viewingMonth.month == now.month;

    // Check if we can go forward (not future months)
    final canGoForward = DateTime(
      _viewingMonth.year,
      _viewingMonth.month + 1,
    ).isBefore(DateTime(now.year, now.month + 1));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : AppColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Month/Year display
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: isDarkMode ? const Color(0xFF007AFF) : AppColors.blue,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  monthYearText,
                  style: AppTypography.h4.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.3,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Navigation controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous month
              _NavigationButton(
                icon: Icons.chevron_left,
                onPressed: _previousMonth,
                isDarkMode: isDarkMode,
              ),

              const SizedBox(width: 4),

              // Today button (if not current month)
              if (!isCurrentMonth)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: isDarkMode
                        ? const Color(0xFF007AFF).withOpacity(0.15)
                        : AppColors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: InkWell(
                      onTap: _goToToday,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          'Today',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDarkMode
                                ? const Color(0xFF007AFF)
                                : AppColors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 4),

              // Next month (disabled if future)
              _NavigationButton(
                icon: Icons.chevron_right,
                onPressed: canGoForward ? _nextMonth : null,
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.sm),

          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.5)
                  : AppColors.gray500,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSelectionRow(bool isDarkMode) {
    final now = DateTime.now();
    final currentYear = now.year;

    // Generate year chips from 2022 to current year
    final years = List<int>.generate(
      currentYear - 2022 + 1,
      (index) => 2022 + index,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...years.map((year) {
              final isSelected = _viewingMonth.year == year;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _QuickSelectChip(
                  label: year.toString(),
                  isSelected: isSelected,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    setState(() {
                      // If it's the current year, go to current month
                      // Otherwise, go to January of that year
                      if (year == currentYear) {
                        _viewingMonth = DateTime(year, now.month);
                        // Update selected date to current date if in current year
                        _selectedDate = DateTime(now.year, now.month, now.day);
                      } else {
                        _viewingMonth = DateTime(year, 1);
                        // Set selected date to first day of January for that year
                        _selectedDate = DateTime(year, 1, 1);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          // Weekday headers
          _buildWeekdayHeaders(isDarkMode),
          const SizedBox(height: 8),

          // Calendar days grid
          _buildDaysGrid(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(bool isDarkMode) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTypography.label.copyWith(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.6)
                    : AppColors.gray500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(bool isDarkMode) {
    final firstDayOfMonth = DateTime(
      _viewingMonth.year,
      _viewingMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _viewingMonth.year,
      _viewingMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final weeks = <Widget>[];
    var dayCounter = 1;

    // Build calendar grid (up to 6 weeks)
    for (var week = 0; week < 6; week++) {
      final days = <Widget>[];

      for (var weekday = 0; weekday < 7; weekday++) {
        if ((week == 0 && weekday < startWeekday) || dayCounter > daysInMonth) {
          // Empty cell for padding
          days.add(const Expanded(child: SizedBox()));
        } else {
          final date = DateTime(
            _viewingMonth.year,
            _viewingMonth.month,
            dayCounter,
          );
          days.add(
            Expanded(
              child: _DayCell(
                date: date,
                isSelected: _isSameDay(date, _selectedDate),
                isToday: _isSameDay(date, DateTime.now()),
                isOutOfRange:
                    date.isBefore(widget.firstDate) ||
                    date.isAfter(widget.lastDate),
                isDarkMode: isDarkMode,
                onTap: () => _onDateTapped(date),
              ),
            ),
          );
          dayCounter++;
        }
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: days),
        ),
      );

      // Stop if we've shown all days
      if (dayCounter > daysInMonth) break;
    }

    return Column(children: weeks);
  }

  Widget _buildFooter(bool isDarkMode) {
    final selectedDateText = DateFormat(
      'EEEE, MMMM d, yyyy',
    ).format(_selectedDate);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A1A1A)
            : AppColors.gray50.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : AppColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Selected date display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date',
                  style: AppTypography.caption.copyWith(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.gray600,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedDateText,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Action buttons
          Row(
            children: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.gray600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.gray600,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Apply button
              ElevatedButton(
                onPressed: _applySelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF007AFF)
                      : AppColors.blue,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Navigation button for month switching
class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDarkMode;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: isDarkMode
          ? (isEnabled
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.02))
          : (isEnabled ? AppColors.gray50 : AppColors.gray100),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: isDarkMode
                ? (isEnabled
                      ? Colors.white.withOpacity(0.7)
                      : Colors.white.withOpacity(0.3))
                : (isEnabled ? AppColors.gray700 : AppColors.gray400),
          ),
        ),
      ),
    );
  }
}

/// Quick selection chip (Today, Yesterday, etc.)
class _QuickSelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _QuickSelectChip({
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? (isDarkMode ? const Color(0xFF007AFF) : AppColors.blue)
          : (isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.gray50),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isSelected
                  ? AppColors.white
                  : (isDarkMode ? Colors.white : AppColors.gray700),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual day cell in the calendar grid
class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isOutOfRange;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isOutOfRange,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    FontWeight fontWeight;
    BoxBorder? border;

    if (isOutOfRange) {
      bgColor = Colors.transparent;
      textColor = isDarkMode
          ? Colors.white.withOpacity(0.2)
          : AppColors.gray300;
      fontWeight = FontWeight.w500;
    } else if (isSelected) {
      bgColor = isDarkMode ? const Color(0xFF007AFF) : AppColors.blue;
      textColor = AppColors.white;
      fontWeight = FontWeight.w700;
    } else if (isToday) {
      bgColor = isDarkMode
          ? const Color(0xFF007AFF).withOpacity(0.15)
          : AppColors.blue.withOpacity(0.1);
      textColor = isDarkMode ? const Color(0xFF007AFF) : AppColors.blue;
      fontWeight = FontWeight.w700;
      border = Border.all(
        color: isDarkMode ? const Color(0xFF007AFF) : AppColors.blue,
        width: 1.5,
      );
    } else {
      bgColor = Colors.transparent;
      textColor = isDarkMode ? Colors.white : AppColors.gray800;
      fontWeight = FontWeight.w500;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: isOutOfRange ? null : onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              style: AppTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: 14,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the custom single date picker
Future<DateTime?> showCustomSingleDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (context) => CustomSingleDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      onDateSelected: (date) {
        selectedDate = date;
      },
    ),
  );

  return selectedDate;
}
