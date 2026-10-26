import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reporting_timeframe.dart';

/// Provider for reporting timeframe selection
final reportingTimeframeProvider =
    StateNotifierProvider<
      ReportingTimeframeNotifier,
      ReportingTimeframeSelection
    >((ref) => ReportingTimeframeNotifier());

/// Provider for saved timeframes
final savedTimeframesProvider =
    StateNotifierProvider<SavedTimeframesNotifier, List<ReportingTimeframe>>(
      (ref) => SavedTimeframesNotifier(),
    );

/// Notifier for reporting timeframe selection
class ReportingTimeframeNotifier
    extends StateNotifier<ReportingTimeframeSelection> {
  ReportingTimeframeNotifier()
    : super(ReportingTimeframeSelection.defaultDay()) {
    _loadSelection();
  }

  Future<void> _loadSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('reporting_timeframe_selection');
      if (json != null) {
        state = ReportingTimeframeSelection.fromJson(jsonDecode(json));
      }
    } catch (e) {
      print('⚠️ Error loading timeframe selection: $e');
    }
  }

  Future<void> setSelection(ReportingTimeframeSelection selection) async {
    state = selection;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'reporting_timeframe_selection',
        jsonEncode(selection.toJson()),
      );
    } catch (e) {
      print('⚠️ Error saving timeframe selection: $e');
    }
  }

  Future<void> setDefaultDay() async {
    await setSelection(ReportingTimeframeSelection.defaultDay());
  }

  Future<void> setCustom(String startTime, String endTime) async {
    await setSelection(
      ReportingTimeframeSelection.custom(
        startTime: startTime,
        endTime: endTime,
      ),
    );
  }

  Future<void> setSavedPreset(ReportingTimeframe preset) async {
    await setSelection(
      ReportingTimeframeSelection.savedPreset(
        presetId: preset.id,
        presetName: preset.name,
        startTime: preset.startLocalTime,
        endTime: preset.endLocalTime,
        timezone: preset.timezone,
      ),
    );
  }
}

/// Notifier for saved timeframes
class SavedTimeframesNotifier extends StateNotifier<List<ReportingTimeframe>> {
  SavedTimeframesNotifier() : super([]) {
    _loadTimeframes();
  }

  Future<void> _loadTimeframes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('saved_timeframes');
      if (json != null) {
        final List<dynamic> list = jsonDecode(json);
        state = list.map((item) => ReportingTimeframe.fromJson(item)).toList();
      }
    } catch (e) {
      print('⚠️ Error loading saved timeframes: $e');
    }
  }

  Future<void> addTimeframe(ReportingTimeframe timeframe) async {
    state = [...state, timeframe];
    await _saveTimeframes();
  }

  Future<void> updateTimeframe(ReportingTimeframe timeframe) async {
    state = [
      for (final t in state)
        if (t.id == timeframe.id) timeframe else t,
    ];
    await _saveTimeframes();
  }

  Future<void> deleteTimeframe(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _saveTimeframes();
  }

  Future<void> _saveTimeframes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(state.map((t) => t.toJson()).toList());
      await prefs.setString('saved_timeframes', json);
    } catch (e) {
      print('⚠️ Error saving timeframes: $e');
    }
  }
}

/// Provider for available timezones
final timezonesProvider = Provider<List<String>>((ref) {
  return [
    'Australia/Sydney',
    'Australia/Melbourne',
    'Australia/Brisbane',
    'Australia/Adelaide',
    'Australia/Perth',
    'Australia/Darwin',
    'Pacific/Auckland',
    'America/New_York',
    'America/Chicago',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Asia/Tokyo',
    'Asia/Singapore',
    'Asia/Dubai',
  ];
});
