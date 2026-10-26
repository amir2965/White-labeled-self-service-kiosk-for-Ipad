import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reporting_timeframe.dart';
import '../providers/reporting_timeframe_provider.dart';

/// Modal dialog for creating/editing reporting timeframes
class AddReportingTimeframesModal extends ConsumerStatefulWidget {
  final ReportingTimeframe? editTimeframe;

  const AddReportingTimeframesModal({super.key, this.editTimeframe});

  @override
  ConsumerState<AddReportingTimeframesModal> createState() =>
      _AddReportingTimeframesModalState();
}

class _AddReportingTimeframesModalState
    extends ConsumerState<AddReportingTimeframesModal> {
  final _nameController = TextEditingController();
  String? _selectedTimezone;
  TimeInput _startTime = TimeInput(hour: 12, minute: 0, isPM: false);
  TimeInput _endTime = TimeInput(hour: 11, minute: 59, isPM: true);

  @override
  void initState() {
    super.initState();
    if (widget.editTimeframe != null) {
      _nameController.text = widget.editTimeframe!.name;
      _selectedTimezone = widget.editTimeframe!.timezone;
      _startTime = TimeInput.parse(widget.editTimeframe!.startLocalTime);
      _endTime = TimeInput.parse(widget.editTimeframe!.endLocalTime);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timezones = ref.watch(timezonesProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  const Text(
                    'Add reporting timeframes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade200),

            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hour set name
                    _buildFormRow(
                      label: 'Hour set name',
                      child: _buildTextField(
                        controller: _nameController,
                        placeholder: 'Name',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Timezone
                    _buildFormRow(
                      label: 'Timezone',
                      child: _buildTimezoneDropdown(timezones),
                    ),

                    const SizedBox(height: 24),

                    // Start time
                    _buildFormRow(
                      label: 'Start time',
                      child: _buildTimeInputRow(
                        time: _startTime,
                        onChanged: (time) => setState(() => _startTime = time),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // End time
                    _buildFormRow(
                      label: 'End time',
                      child: _buildTimeInputRow(
                        time: _endTime,
                        onChanged: (time) => setState(() => _endTime = time),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Helper text
                    Text(
                      'The start time determines the calendar day your sales will be attributed to.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade200),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Save & add another
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _saveTimeframe(keepOpen: true),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Save & add another',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Save
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveTimeframe(keepOpen: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildFormRow({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade900),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildTimezoneDropdown(List<String> timezones) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTimezone,
          hint: Text(
            'Select timezone',
            style: TextStyle(color: Colors.grey.shade400),
          ),
          onChanged: (value) => setState(() => _selectedTimezone = value),
          items: timezones.map((tz) {
            return DropdownMenuItem(
              value: tz,
              child: Text(
                tz,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade900),
              ),
            );
          }).toList(),
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildTimeInputRow({
    required TimeInput time,
    required Function(TimeInput) onChanged,
  }) {
    return Row(
      children: [
        // Time field
        Expanded(
          child: _buildTimeField(
            time: time,
            onChanged: (hour, minute) {
              onChanged(time.copyWith(hour: hour, minute: minute));
            },
          ),
        ),
        const SizedBox(width: 8),

        // AM/PM dropdown
        Container(
          width: 76,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool>(
              value: time.isPM,
              onChanged: (isPM) {
                if (isPM != null) onChanged(time.copyWith(isPM: isPM));
              },
              items: const [
                DropdownMenuItem(value: false, child: Text('AM')),
                DropdownMenuItem(value: true, child: Text('PM')),
              ],
              isExpanded: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade900,
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required TimeInput time,
    required Function(int hour, int minute) onChanged,
  }) {
    final controller = TextEditingController(
      text:
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
    );

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade900,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          hintText: '00:00',
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
          LengthLimitingTextInputFormatter(5),
        ],
        onChanged: (value) {
          final parts = value.split(':');
          if (parts.length == 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);
            if (hour != null &&
                minute != null &&
                hour >= 1 &&
                hour <= 12 &&
                minute >= 0 &&
                minute <= 59) {
              onChanged(hour, minute);
            }
          }
        },
      ),
    );
  }

  Future<void> _saveTimeframe({required bool keepOpen}) async {
    // Validate
    if (_nameController.text.isEmpty) {
      _showError('Please enter a name');
      return;
    }
    if (_selectedTimezone == null) {
      _showError('Please select a timezone');
      return;
    }

    // Create timeframe
    final timeframe = ReportingTimeframe(
      id:
          widget.editTimeframe?.id ??
          'tf_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      timezone: _selectedTimezone!,
      startLocalTime: _startTime.format(),
      endLocalTime: _endTime.format(),
    );

    // Save
    if (widget.editTimeframe != null) {
      await ref
          .read(savedTimeframesProvider.notifier)
          .updateTimeframe(timeframe);
    } else {
      await ref.read(savedTimeframesProvider.notifier).addTimeframe(timeframe);
    }

    if (keepOpen) {
      // Clear form
      setState(() {
        _nameController.clear();
        _selectedTimezone = null;
        _startTime = TimeInput(hour: 12, minute: 0, isPM: false);
        _endTime = TimeInput(hour: 11, minute: 59, isPM: true);
      });
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }
}
