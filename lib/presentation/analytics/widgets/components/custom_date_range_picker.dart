import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../theme_provider.dart';

/// Luxury minimal custom date range picker
class CustomDateRangePicker extends ConsumerStatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onApply;

  const CustomDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApply,
  });

  @override
  ConsumerState<CustomDateRangePicker> createState() =>
      _CustomDateRangePickerState();
}

/// Content-only version of date range picker (no Dialog wrapper or footer)
/// Used for embedding in other dialogs like ActivityDateRangePicker
class DateRangePickerContent extends ConsumerStatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onApply;
  final bool showFooter;
  final bool showHeader;

  const DateRangePickerContent({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApply,
    this.showFooter = false,
    this.showHeader = true,
  });

  @override
  ConsumerState<DateRangePickerContent> createState() =>
      _DateRangePickerContentState();
}

class _CustomDateRangePickerState extends ConsumerState<CustomDateRangePicker> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 560,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
        child: DateRangePickerContent(
          initialStartDate: widget.initialStartDate,
          initialEndDate: widget.initialEndDate,
          onApply: (start, end) {
            widget.onApply(start, end);
            // Don't call Navigator.pop here - DateRangePickerContent's footer handles it
          },
          showFooter: true,
          showHeader: true,
        ),
      ),
    );
  }
}

class _DateRangePickerContentState
    extends ConsumerState<DateRangePickerContent> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _selectedYear = DateTime.now().year;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _yearScrollController = ScrollController();
  static const int _startYear = 2020;
  static const int _endYear = 2050;
  OverlayEntry? _monthSelectorOverlay;
  final Map<int, GlobalKey> _monthKeys = {};

  @override
  void initState() {
    super.initState();
    // Start with no selection
    _startDate = null;
    _endDate = null;

    // Initialize month keys for all 12 months
    for (int i = 1; i <= 12; i++) {
      _monthKeys[i] = GlobalKey();
    }

    // Auto-scroll to current month after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    final currentMonth = now.month;

    // Only scroll if we're viewing the current year
    if (_selectedYear != now.year) return;

    // Calculate approximate offset (each month section ~320px)
    final offset = (currentMonth - 1) * 320.0;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _monthSelectorOverlay?.remove();
    _scrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header (only if showHeader is true)
        if (widget.showHeader) _buildHeader(isDarkMode),

        // Calendar (scrollable year view)
        Expanded(child: _buildCalendar(isDarkMode)),

        // Footer with selected dates (only if showFooter is true)
        if (widget.showFooter) _buildFooter(isDarkMode),
      ],
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
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
            Icons.date_range,
            size: 20,
            color: isDarkMode ? const Color(0xFF007AFF) : AppColors.blue,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Select Date Range',
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w600,
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
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(bool isDarkMode) {
    return Column(
      children: [
        // Year navigation bar
        _buildYearNavigation(isDarkMode),

        // Scrollable calendar content - only selected year
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Generate only 12 months for selected year
                  ...List.generate(12, (monthIndex) {
                    final month = monthIndex + 1;
                    return Column(
                      children: [
                        _buildMonthSection(_selectedYear, month, isDarkMode),
                        if (monthIndex < 11)
                          const SizedBox(height: AppSpacing.xl),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearNavigation(bool isDarkMode) {
    return Container(
      height: 56,
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
      child: ListView.builder(
        controller: _yearScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: _endYear - _startYear + 1,
        itemBuilder: (context, index) {
          final year = _startYear + index;
          final isSelected = year == _selectedYear;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _scrollToYear(year),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md + 2,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDarkMode
                              ? const Color(0xFF007AFF)
                              : AppColors.blue)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: isSelected
                          ? (isDarkMode
                                ? const Color(0xFF007AFF)
                                : AppColors.blue)
                          : (isDarkMode
                                ? Colors.white.withOpacity(0.3)
                                : AppColors.gray300),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$year',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : (isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : AppColors.gray700),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollToYear(int year) {
    setState(() {
      _selectedYear = year;
    });

    // If selected year is current year, scroll to current month after rebuild
    if (year == DateTime.now().year) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentMonth();
      });
    } else {
      // Otherwise scroll to top
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Widget _buildMonthSection(int year, int month, bool isDarkMode) {
    final monthDate = DateTime(year, month, 1);

    return Column(
      key: _monthKeys[month],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month name with year - clickable
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GestureDetector(
            onTap: () => _showMonthSelector(month),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('MMMM').format(monthDate),
                      style: AppTypography.h4.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.5)
                          : AppColors.gray500,
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs + 2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : AppColors.gray100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$year',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray600,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map(
                (day) => SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(
                      day,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : AppColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Calendar grid for this month
        _buildCalendarGridForMonth(year, month, isDarkMode),
      ],
    );
  }

  Widget _buildCalendarGridForMonth(int year, int month, bool isDarkMode) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    // Feb 2024 = 29 days (leap year), Feb 2026 = 28 days (not leap year)
    // Leap years: divisible by 4 (except century years not divisible by 400)
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    // Calculate how many weeks we need (minimum rows to display all dates)
    final totalCells = firstWeekday + daysInMonth;
    final numberOfWeeks = (totalCells / 7).ceil();

    return Column(
      children: List.generate(numberOfWeeks, (weekIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

              // Only show dates within the month range
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox(width: 48, height: 48);
              }

              // Double-check date is valid before creating
              try {
                final date = DateTime(year, month, dayNumber);
                final isInRange = _isDateInRange(date);
                final isStart =
                    _startDate != null && _isSameDay(date, _startDate!);
                final isEnd = _endDate != null && _isSameDay(date, _endDate!);
                final isToday = _isSameDay(date, DateTime.now());

                return _buildDayCell(
                  date,
                  isInRange,
                  isStart,
                  isEnd,
                  isToday,
                  isDarkMode,
                );
              } catch (e) {
                // If date is invalid, return empty cell
                return const SizedBox(width: 48, height: 48);
              }
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    bool isInRange,
    bool isStart,
    bool isEnd,
    bool isToday,
    bool isDarkMode,
  ) {
    Color? bgColor;
    Color? textColor = isDarkMode ? Colors.white : AppColors.black;
    BoxBorder? border;

    if (isStart && (_endDate == null || _isSameDay(_startDate!, _endDate!))) {
      // First day only (no range yet) - BLUE in dark mode, BLACK in light
      bgColor = isDarkMode ? const Color(0xFF007AFF) : AppColors.black;
      textColor = AppColors.white;
    } else if (isStart && !isEnd) {
      // First day with range selected - BLUE in dark mode, BLACK in light
      bgColor = isDarkMode ? const Color(0xFF007AFF) : AppColors.black;
      textColor = AppColors.white;
    } else if (isEnd && !isStart) {
      // Last day - BLUE
      bgColor = isDarkMode ? const Color(0xFF007AFF) : AppColors.blue;
      textColor = AppColors.white;
    } else if (isInRange) {
      // Days in between - LIGHT GRAY or dark mode equivalent
      bgColor = isDarkMode ? Colors.white.withOpacity(0.1) : AppColors.gray200;
    } else if (isToday) {
      border = Border.all(
        color: isDarkMode ? const Color(0xFF007AFF) : AppColors.blue,
        width: 2,
      );
    }

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: AppTypography.bodyMedium.copyWith(
            color: textColor,
            fontWeight: (isStart || isEnd) ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showMonthSelector(int currentMonth) {
    // Remove existing overlay if any
    _monthSelectorOverlay?.remove();

    // Get the render box of the dialog to position the overlay
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;

    _monthSelectorOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent barrier to close on tap outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _monthSelectorOverlay?.remove();
                _monthSelectorOverlay = null;
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          // Month selector positioned in center
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 280,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.gray200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.gray200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: AppColors.blue,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Select Month',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Month list
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final month = index + 1;
                          final monthName = DateFormat(
                            'MMMM',
                          ).format(DateTime(_selectedYear, month));
                          final isSelected = month == currentMonth;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _scrollToMonth(month);
                                _monthSelectorOverlay?.remove();
                                _monthSelectorOverlay = null;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm + 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.blue.withOpacity(0.08)
                                      : Colors.transparent,
                                  border: isSelected
                                      ? Border(
                                          left: BorderSide(
                                            color: AppColors.blue,
                                            width: 3,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  monthName,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.blue
                                        : AppColors.gray800,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_monthSelectorOverlay!);
  }

  void _scrollToMonth(int month) {
    // Use GlobalKey to get accurate position and scroll to it
    final key = _monthKeys[month];
    if (key?.currentContext != null) {
      // Use Scrollable.ensureVisible for accurate positioning
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0, // 0.0 = top of viewport
      );
    }
  }

  Widget _buildFooter(bool isDarkMode) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
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
      child: Column(
        children: [
          // Selected dates display
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.gray50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _startDate != null
                            ? dateFormat.format(_startDate!)
                            : 'Select start date',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _startDate != null
                              ? (isDarkMode ? Colors.white : AppColors.black)
                              : (isDarkMode
                                    ? Colors.white.withOpacity(0.3)
                                    : AppColors.gray400),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.4)
                      : AppColors.gray400,
                  size: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'End Date',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _endDate != null
                            ? dateFormat.format(_endDate!)
                            : 'Select end date',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _endDate != null
                              ? (isDarkMode ? Colors.white : AppColors.black)
                              : (isDarkMode
                                    ? Colors.white.withOpacity(0.3)
                                    : AppColors.gray400),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
              ElevatedButton(
                onPressed: (_startDate != null && _endDate != null)
                    ? () {
                        widget.onApply(_startDate!, _endDate!);
                        Navigator.pop(context);
                      }
                    : null, // Disable button if dates not fully selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF007AFF)
                      : AppColors.blue,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : AppColors.gray300,
                  disabledForegroundColor: isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.gray500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply Range',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      // Rule 1: If no start date, set as start date
      if (_startDate == null) {
        _startDate = date;
        _endDate = null;
        return;
      }

      // Rule 5: If clicking the start date again after selecting end date
      if (_endDate != null && _isSameDay(date, _startDate!)) {
        _endDate = null;
        return;
      }

      // Rule 6: If clicking the end date again, make it the new start date
      if (_endDate != null && _isSameDay(date, _endDate!)) {
        _startDate = date;
        _endDate = null;
        return;
      }

      // Rule 3: If clicking before start date, reset and make it new start
      if (date.isBefore(_startDate!)) {
        _startDate = date;
        _endDate = null;
        return;
      }

      // Rule 4: If clicking same as start date but no end date yet
      if (_isSameDay(date, _startDate!) && _endDate == null) {
        // Do nothing, keep as start date only
        return;
      }

      // Rule 4: If clicking after start date, set as end date
      if (date.isAfter(_startDate!)) {
        _endDate = date;
        return;
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;

    // Only show range if start and end are different
    if (_isSameDay(_startDate!, _endDate!)) return false;

    return date.isAfter(_startDate!) && date.isBefore(_endDate!);
  }
}

/// Helper function to show custom date range picker
Future<void> showCustomDateRangePicker(
  BuildContext context, {
  DateTime? initialStartDate,
  DateTime? initialEndDate,
  required Function(DateTime startDate, DateTime endDate) onApply,
}) {
  return showDialog(
    context: context,
    barrierColor: AppColors.black.withOpacity(0.4),
    builder: (context) => CustomDateRangePicker(
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      onApply: onApply,
    ),
  );
}
