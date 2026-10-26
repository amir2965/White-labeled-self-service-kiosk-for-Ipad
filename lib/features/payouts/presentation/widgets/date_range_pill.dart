import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../presentation/analytics/theme_provider.dart';
import '../../../../presentation/analytics/widgets/components/custom_date_range_picker.dart';

/// Date range pill with navigation chevrons
class DateRangePill extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onBackward;
  final VoidCallback onForward;
  final VoidCallback onTap;
  final bool canGoForward;

  const DateRangePill({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onBackward,
    required this.onForward,
    required this.onTap,
    this.canGoForward = true,
  }) : super(key: key);

  String _formatDateRange() {
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left chevron
          IconButton(
            onPressed: onBackward,
            icon: const Icon(Icons.chevron_left),
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black87,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
          ),

          // Date range text with caret
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDateRange(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey.shade700,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Right chevron
          IconButton(
            onPressed: canGoForward ? onForward : null,
            icon: const Icon(Icons.chevron_right),
            color: canGoForward
                ? (isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black87)
                : (isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.shade400),
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
          ),
        ],
      ),
    );
  }
}

/// Shows custom fullscreen date range picker for Activity page
Future<DateTimeRange?> showDateRangePicker2(
  BuildContext context, {
  required DateTime initialStartDate,
  required DateTime initialEndDate,
  bool isDarkMode = false,
}) async {
  DateTime? selectedStart;
  DateTime? selectedEnd;

  await showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    barrierDismissible: true,
    builder: (context) => ActivityDateRangePicker(
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      isDarkMode: isDarkMode,
      onApply: (start, end) {
        selectedStart = start;
        selectedEnd = end;
        // Don't call Navigator.pop here - DateRangePickerContent's footer handles it
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    ),
  );

  if (selectedStart != null && selectedEnd != null) {
    return DateTimeRange(start: selectedStart!, end: selectedEnd!);
  }
  return null;
}

/// Quick date range selector
class QuickDateRangeSelector extends ConsumerWidget {
  final Function(DateTime, DateTime) onRangeSelected;

  const QuickDateRangeSelector({Key? key, required this.onRangeSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            'Last 30 days',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          onTap: () {
            final end = DateTime.now();
            final start = end.subtract(const Duration(days: 30));
            Navigator.pop(context);
            onRangeSelected(start, end);
          },
        ),
        ListTile(
          title: Text(
            'Last 90 days',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          onTap: () {
            final end = DateTime.now();
            final start = end.subtract(const Duration(days: 90));
            Navigator.pop(context);
            onRangeSelected(start, end);
          },
        ),
        ListTile(
          title: Text(
            'This month',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          onTap: () {
            final now = DateTime.now();
            final start = DateTime(now.year, now.month, 1);
            Navigator.pop(context);
            onRangeSelected(start, now);
          },
        ),
        ListTile(
          title: Text(
            'Last month',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          onTap: () {
            final now = DateTime.now();
            final start = DateTime(now.year, now.month - 1, 1);
            final end = DateTime(
              now.year,
              now.month,
              1,
            ).subtract(const Duration(days: 1));
            Navigator.pop(context);
            onRangeSelected(start, end);
          },
        ),
        Divider(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade300,
        ),
        ListTile(
          title: Text(
            'Custom range...',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          ),
          onTap: () async {
            Navigator.pop(context);
            final range = await showDateRangePicker2(
              context,
              initialStartDate: DateTime.now().subtract(
                const Duration(days: 30),
              ),
              initialEndDate: DateTime.now(),
              isDarkMode: isDarkMode,
            );
            if (range != null) {
              onRangeSelected(range.start, range.end);
            }
          },
        ),
      ],
    );
  }
}

/// Custom date range picker for Activity page with blue header
class ActivityDateRangePicker extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final bool isDarkMode;
  final Function(DateTime, DateTime) onApply;
  final VoidCallback onCancel;

  const ActivityDateRangePicker({
    Key? key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.isDarkMode,
    required this.onApply,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ActivityDateRangePicker> createState() =>
      _ActivityDateRangePickerState();
}

class _ActivityDateRangePickerState extends State<ActivityDateRangePicker> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: screenHeight * 0.9,
        ),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with blue background - simplified to just title and close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Date Range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
            ),

            // Calendar with footer showing date indicators and Apply/Cancel buttons
            Expanded(
              child: DateRangePickerContent(
                initialStartDate: widget.initialStartDate,
                initialEndDate: widget.initialEndDate,
                onApply: (start, end) {
                  // Directly call parent's onApply when user clicks Apply Range in footer
                  widget.onApply(start, end);
                },
                showFooter:
                    true, // Show footer with date indicators and buttons
                showHeader: false, // Hide header - we have blue header above
              ),
            ),
          ],
        ),
      ),
    );
  }
}
