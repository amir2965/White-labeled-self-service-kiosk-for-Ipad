import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/date_range_selection.dart';
import '../theme_provider.dart';
import 'calendar_grid.dart';
import 'quick_preset_list.dart';

/// Date range picker popover with calendar and presets
class DateRangePopover extends ConsumerStatefulWidget {
  final DateRangeSelection initialSelection;
  final Function(DateRangeSelection) onSelectionChanged;

  const DateRangePopover({
    super.key,
    required this.initialSelection,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<DateRangePopover> createState() => _DateRangePopoverState();
}

class _DateRangePopoverState extends ConsumerState<DateRangePopover> {
  late DateTime _displayMonth;
  late DateTime? _selectedStart;
  late DateTime? _selectedEnd;
  bool _isSelectingRange = false;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(
      widget.initialSelection.start.year,
      widget.initialSelection.start.month,
      1,
    );
    _selectedStart = widget.initialSelection.start;
    _selectedEnd = widget.initialSelection.end;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 720,
          height: 520,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : AppColors.gray300.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.6 : 0.12),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left panel: Calendar + Start/End inputs
              Expanded(flex: 3, child: _buildCalendarPanel()),

              // Vertical divider
              Container(
                width: 1,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.15)
                    : AppColors.gray300.withOpacity(0.3),
              ),

              // Right panel: Quick presets
              Expanded(
                flex: 2,
                child: QuickPresetList(
                  onPresetSelected: (preset) {
                    final range = preset.range;
                    _selectedStart = range.start;
                    _selectedEnd = range.end;
                    _displayMonth = DateTime(
                      range.start.year,
                      range.start.month,
                      1,
                    );
                    setState(() {});
                    _applySelection(preset: preset);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarPanel() {
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      children: [
        // Header with month navigation
        _buildMonthHeader(),

        Divider(
          height: 1,
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray300.withOpacity(0.3),
        ),

        // Calendar grid
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: CalendarGrid(
              displayMonth: _displayMonth,
              selectedStart: _selectedStart,
              selectedEnd: _selectedEnd,
              onDateSelected: _onDateTapped,
              isDarkMode: isDarkMode,
            ),
          ),
        ),

        Divider(
          height: 1,
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray300.withOpacity(0.3),
        ),

        // Start/End inputs
        _buildStartEndInputs(),
      ],
    );
  }

  Widget _buildMonthHeader() {
    final monthYear = DateFormat('MMMM yyyy').format(_displayMonth);
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // Back chevron (optional)
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.gray700,
            ),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),

          Spacer(),

          // Previous month
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.gray700,
            ),
            onPressed: _onPreviousMonth,
            tooltip: 'Previous month',
          ),

          // Month label
          Container(
            width: 180,
            child: Text(
              monthYear,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.black,
              ),
            ),
          ),

          // Next month
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.gray700,
            ),
            onPressed: _onNextMonth,
            tooltip: 'Next month',
          ),

          Spacer(),
        ],
      ),
    );
  }

  Widget _buildStartEndInputs() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _buildDateInput(
              label: 'START',
              value: _selectedStart != null
                  ? dateFormat.format(_selectedStart!)
                  : '',
              onChanged: (text) => _onStartInputChanged(text),
              isDarkMode: isDarkMode,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildDateInput(
              label: 'END',
              value: _selectedEnd != null
                  ? dateFormat.format(_selectedEnd!)
                  : '',
              onChanged: (text) => _onEndInputChanged(text),
              isDarkMode: isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput({
    required String label,
    required String value,
    required Function(String) onChanged,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: isDarkMode
                ? Colors.white.withOpacity(0.6)
                : AppColors.gray600,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : AppColors.gray300.withOpacity(0.5),
            ),
          ),
          child: Center(
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                color: isDarkMode ? Colors.white : AppColors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.gray500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPreviousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1, 1);
    });
  }

  void _onNextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 1);
    });
  }

  void _onDateTapped(DateTime date) {
    if (!_isSelectingRange) {
      // First tap: set start date
      _selectedStart = date;
      _selectedEnd = date;
      _isSelectingRange = true;
    } else {
      // Second tap: set end date
      if (date.isBefore(_selectedStart!)) {
        // User tapped earlier date, swap
        _selectedEnd = _selectedStart;
        _selectedStart = date;
      } else {
        _selectedEnd = date;
      }
      _isSelectingRange = false;
      _applySelection();
      return;
    }
    setState(() {});
  }

  void _onStartInputChanged(String text) {
    final date = _parseDate(text);
    if (date != null) {
      setState(() {
        _selectedStart = date;
        if (_selectedEnd != null && date.isAfter(_selectedEnd!)) {
          _selectedEnd = date;
        }
      });
    }
  }

  void _onEndInputChanged(String text) {
    final date = _parseDate(text);
    if (date != null) {
      setState(() {
        _selectedEnd = date;
        if (_selectedStart != null && date.isBefore(_selectedStart!)) {
          _selectedStart = date;
        }
      });
    }
  }

  DateTime? _parseDate(String text) {
    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Invalid format
    }
    return null;
  }

  void _applySelection({RangePreset? preset}) {
    if (_selectedStart == null || _selectedEnd == null) return;

    final selection = DateRangeSelection.range(
      _selectedStart!,
      _selectedEnd!,
      preset: preset,
    );

    widget.onSelectionChanged(selection);
  }
}
