import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reporting_timeframe.dart';
import '../providers/reporting_timeframe_provider.dart';
import '../theme_provider.dart';
import 'custom_time_inputs.dart';
import 'add_reporting_timeframes_modal.dart';

/// Popover for selecting reporting timeframe
class ReportingTimeframePopover extends ConsumerStatefulWidget {
  const ReportingTimeframePopover({super.key});

  @override
  ConsumerState<ReportingTimeframePopover> createState() =>
      _ReportingTimeframePopoverState();
}

class _ReportingTimeframePopoverState
    extends ConsumerState<ReportingTimeframePopover> {
  bool _isCustomExpanded = false;
  String _customStartTime = '12:00 AM';
  String _customEndTime = '11:59 PM';

  @override
  void initState() {
    super.initState();
    final selection = ref.read(reportingTimeframeProvider);
    if (selection.type == ReportingTimeframeType.custom) {
      _isCustomExpanded = true;
      _customStartTime = selection.startTime;
      _customEndTime = selection.endTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(reportingTimeframeProvider);
    final savedTimeframes = ref.watch(savedTimeframesProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Center(
        child: Container(
          width: 400,
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.6 : 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Options list
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // Default reporting day
                      _buildRadioOption(
                        title: 'Reporting day (Default)',
                        subtitle: '12:00 AM – 11:59 PM (AEST)',
                        isSelected:
                            selection.type == ReportingTimeframeType.defaultDay,
                        isDarkMode: isDarkMode,
                        onTap: () async {
                          await ref
                              .read(reportingTimeframeProvider.notifier)
                              .setDefaultDay();
                          if (mounted) Navigator.pop(context);
                        },
                      ),

                      // Custom option
                      _buildRadioOption(
                        title: 'Custom',
                        subtitle: _isCustomExpanded
                            ? null
                            : '$_customStartTime – $_customEndTime',
                        isSelected:
                            selection.type == ReportingTimeframeType.custom,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          setState(() {
                            _isCustomExpanded = true;
                          });
                        },
                      ),

                      // Custom time inputs (expanded)
                      if (_isCustomExpanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
                          child: CustomTimeInputs(
                            startTime: _customStartTime,
                            endTime: _customEndTime,
                            onStartChanged: (time) {
                              setState(() => _customStartTime = time);
                            },
                            onEndChanged: (time) {
                              setState(() => _customEndTime = time);
                            },
                            onApply: () async {
                              // Validate times
                              if (_validateCustomTimes()) {
                                await ref
                                    .read(reportingTimeframeProvider.notifier)
                                    .setCustom(
                                      _customStartTime,
                                      _customEndTime,
                                    );
                                if (mounted) Navigator.pop(context);
                              }
                            },
                          ),
                        ),

                      // Saved presets
                      ...savedTimeframes.map((preset) {
                        final isSelected =
                            selection.type ==
                                ReportingTimeframeType.savedPreset &&
                            selection.presetId == preset.id;
                        return _buildRadioOption(
                          title: preset.name,
                          subtitle:
                              '${preset.startLocalTime} – ${preset.endLocalTime} (${_abbreviateTimezone(preset.timezone)})',
                          isSelected: isSelected,
                          isDarkMode: isDarkMode,
                          onTap: () async {
                            await ref
                                .read(reportingTimeframeProvider.notifier)
                                .setSavedPreset(preset);
                            if (mounted) Navigator.pop(context);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Divider
              Divider(
                height: 1,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.15)
                    : Colors.grey.shade200,
              ),

              // Add timeframes button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _showAddTimeframesModal(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: isDarkMode
                            ? const Color(0xFF007AFF)
                            : Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add reporting timeframes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? const Color(0xFF007AFF)
                              : Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    String? subtitle,
    required bool isSelected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio indicator
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDarkMode ? const Color(0xFF007AFF) : Colors.black)
                      : (isDarkMode
                            ? Colors.white.withOpacity(0.4)
                            : Colors.grey.shade400),
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCustomTimes() {
    // Basic validation - ensure times are parseable
    try {
      TimeInput.parse(_customStartTime);
      TimeInput.parse(_customEndTime);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid time format')));
      return false;
    }
  }

  String _abbreviateTimezone(String timezone) {
    if (timezone.contains('Sydney') || timezone.contains('Melbourne')) {
      return 'AEST';
    }
    return timezone.split('/').last;
  }

  void _showAddTimeframesModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const AddReportingTimeframesModal(),
    );
  }
}
