import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_range_selection.freezed.dart';

/// Date range selection state
@freezed
class DateRangeSelection with _$DateRangeSelection {
  const factory DateRangeSelection({
    required DateTime start,
    required DateTime end,
    required bool isSingleDay,
    RangePreset? preset,
  }) = _DateRangeSelection;

  factory DateRangeSelection.singleDay(DateTime date) {
    return DateRangeSelection(
      start: date,
      end: date,
      isSingleDay: true,
      preset: null,
    );
  }

  factory DateRangeSelection.range(
    DateTime start,
    DateTime end, {
    RangePreset? preset,
  }) {
    return DateRangeSelection(
      start: start,
      end: end,
      isSingleDay: start.isAtSameMomentAs(end),
      preset: preset,
    );
  }

  factory DateRangeSelection.today() {
    final now = DateTime.now();
    return DateRangeSelection.singleDay(
      now,
    ).copyWith(preset: RangePreset.today);
  }
}

/// Quick range presets
enum RangePreset {
  today,
  yesterday,
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  thisYear,
  lastYear,
}

extension RangePresetExtension on RangePreset {
  String get label {
    switch (this) {
      case RangePreset.today:
        return 'Today';
      case RangePreset.yesterday:
        return 'Yesterday';
      case RangePreset.thisWeek:
        return 'This week';
      case RangePreset.lastWeek:
        return 'Last week';
      case RangePreset.thisMonth:
        return 'This month';
      case RangePreset.lastMonth:
        return 'Last month';
      case RangePreset.thisYear:
        return 'This year';
      case RangePreset.lastYear:
        return 'Last year';
    }
  }

  DateRangeSelection get range {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case RangePreset.today:
        return DateRangeSelection.range(today, today, preset: this);

      case RangePreset.yesterday:
        final yesterday = today.subtract(Duration(days: 1));
        return DateRangeSelection.range(yesterday, yesterday, preset: this);

      case RangePreset.thisWeek:
        final weekday = today.weekday;
        final startOfWeek = today.subtract(Duration(days: weekday % 7));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return DateRangeSelection.range(startOfWeek, endOfWeek, preset: this);

      case RangePreset.lastWeek:
        final weekday = today.weekday;
        final startOfLastWeek = today.subtract(Duration(days: weekday % 7 + 7));
        final endOfLastWeek = startOfLastWeek.add(Duration(days: 6));
        return DateRangeSelection.range(
          startOfLastWeek,
          endOfLastWeek,
          preset: this,
        );

      case RangePreset.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return DateRangeSelection.range(startOfMonth, endOfMonth, preset: this);

      case RangePreset.lastMonth:
        final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final endOfLastMonth = DateTime(now.year, now.month, 0);
        return DateRangeSelection.range(
          startOfLastMonth,
          endOfLastMonth,
          preset: this,
        );

      case RangePreset.thisYear:
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31);
        return DateRangeSelection.range(startOfYear, endOfYear, preset: this);

      case RangePreset.lastYear:
        final startOfLastYear = DateTime(now.year - 1, 1, 1);
        final endOfLastYear = DateTime(now.year - 1, 12, 31);
        return DateRangeSelection.range(
          startOfLastYear,
          endOfLastYear,
          preset: this,
        );
    }
  }
}
