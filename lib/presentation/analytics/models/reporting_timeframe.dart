import 'package:freezed_annotation/freezed_annotation.dart';

part 'reporting_timeframe.freezed.dart';
part 'reporting_timeframe.g.dart';

/// Reporting timeframe model for sales attribution
@freezed
class ReportingTimeframe with _$ReportingTimeframe {
  const factory ReportingTimeframe({
    required String id,
    required String name,
    required String timezone, // IANA timezone (e.g., 'Australia/Sydney')
    required String startLocalTime, // 12-hour format: "12:00 AM"
    required String endLocalTime, // 12-hour format: "11:59 PM"
  }) = _ReportingTimeframe;

  factory ReportingTimeframe.fromJson(Map<String, dynamic> json) =>
      _$ReportingTimeframeFromJson(json);

  /// Default reporting day (12:00 AM - 11:59 PM)
  factory ReportingTimeframe.defaultDay({
    String timezone = 'Australia/Sydney',
  }) {
    return ReportingTimeframe(
      id: 'default',
      name: 'Reporting day (Default)',
      timezone: timezone,
      startLocalTime: '12:00 AM',
      endLocalTime: '11:59 PM',
    );
  }
}

/// Reporting timeframe selection state
@freezed
class ReportingTimeframeSelection with _$ReportingTimeframeSelection {
  const factory ReportingTimeframeSelection({
    required ReportingTimeframeType type,
    required String startTime, // 12-hour format
    required String endTime, // 12-hour format
    required String timezone,
    String? presetId, // For saved preset type
    String? presetName, // Display name for saved preset
  }) = _ReportingTimeframeSelection;

  factory ReportingTimeframeSelection.fromJson(Map<String, dynamic> json) =>
      _$ReportingTimeframeSelectionFromJson(json);

  /// Default reporting day
  factory ReportingTimeframeSelection.defaultDay({
    String timezone = 'Australia/Sydney',
  }) {
    return ReportingTimeframeSelection(
      type: ReportingTimeframeType.defaultDay,
      startTime: '12:00 AM',
      endTime: '11:59 PM',
      timezone: timezone,
    );
  }

  /// Custom timeframe
  factory ReportingTimeframeSelection.custom({
    required String startTime,
    required String endTime,
    String timezone = 'Australia/Sydney',
  }) {
    return ReportingTimeframeSelection(
      type: ReportingTimeframeType.custom,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
    );
  }

  /// Saved preset
  factory ReportingTimeframeSelection.savedPreset({
    required String presetId,
    required String presetName,
    required String startTime,
    required String endTime,
    required String timezone,
  }) {
    return ReportingTimeframeSelection(
      type: ReportingTimeframeType.savedPreset,
      startTime: startTime,
      endTime: endTime,
      timezone: timezone,
      presetId: presetId,
      presetName: presetName,
    );
  }
}

/// Reporting timeframe type
enum ReportingTimeframeType { defaultDay, custom, savedPreset }

extension ReportingTimeframeSelectionExtension on ReportingTimeframeSelection {
  /// Get display label for pill
  String get displayLabel {
    switch (type) {
      case ReportingTimeframeType.defaultDay:
        return 'Reporting day';
      case ReportingTimeframeType.custom:
        return '$startTime – $endTime';
      case ReportingTimeframeType.savedPreset:
        return presetName ?? '$startTime – $endTime';
    }
  }

  /// Get subtext for popover
  String get subtext {
    return '$startTime – $endTime ($timezone)';
  }
}

/// Time input model for AM/PM formatting
class TimeInput {
  final int hour; // 1-12
  final int minute; // 0-59
  final bool isPM;

  TimeInput({required this.hour, required this.minute, required this.isPM});

  /// Parse from 12-hour format string: "12:00 AM"
  factory TimeInput.parse(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    return TimeInput(hour: hour, minute: minute, isPM: isPM);
  }

  /// Format to 12-hour string: "12:00 AM"
  String format() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    final period = isPM ? 'PM' : 'AM';
    return '$hourStr:$minuteStr $period';
  }

  /// Convert to 24-hour for comparison
  int toMinutesSinceMidnight() {
    int hours24 = hour == 12 ? 0 : hour;
    if (isPM && hour != 12) hours24 += 12;
    return hours24 * 60 + minute;
  }

  TimeInput copyWith({int? hour, int? minute, bool? isPM}) {
    return TimeInput(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isPM: isPM ?? this.isPM,
    );
  }
}
