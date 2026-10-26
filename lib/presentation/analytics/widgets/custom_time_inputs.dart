import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reporting_timeframe.dart';

/// Custom time input fields with AM/PM dropdown
class CustomTimeInputs extends StatefulWidget {
  final String startTime;
  final String endTime;
  final Function(String) onStartChanged;
  final Function(String) onEndChanged;
  final VoidCallback onApply;

  const CustomTimeInputs({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onApply,
  });

  @override
  State<CustomTimeInputs> createState() => _CustomTimeInputsState();
}

class _CustomTimeInputsState extends State<CustomTimeInputs> {
  late TimeInput _startTime;
  late TimeInput _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = TimeInput.parse(widget.startTime);
    _endTime = TimeInput.parse(widget.endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // START label
        Text(
          'START',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Start time input
        _buildTimeInput(
          time: _startTime,
          onTimeChanged: (time) {
            setState(() => _startTime = time);
            widget.onStartChanged(time.format());
          },
        ),

        const SizedBox(height: 16),

        // END label
        Text(
          'END',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),

        // End time input
        _buildTimeInput(
          time: _endTime,
          onTimeChanged: (time) {
            setState(() => _endTime = time);
            widget.onEndChanged(time.format());
          },
        ),

        const SizedBox(height: 16),

        // Apply button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Apply',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInput({
    required TimeInput time,
    required Function(TimeInput) onTimeChanged,
  }) {
    return Row(
      children: [
        // Time input field
        Expanded(
          child: _buildTimeTextField(
            time: time,
            onChanged: (hour, minute) {
              onTimeChanged(time.copyWith(hour: hour, minute: minute));
            },
          ),
        ),
        const SizedBox(width: 8),

        // AM/PM dropdown
        Container(
          width: 76,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool>(
              value: time.isPM,
              onChanged: (isPM) {
                if (isPM != null) {
                  onTimeChanged(time.copyWith(isPM: isPM));
                }
              },
              items: const [
                DropdownMenuItem(value: false, child: Text('AM')),
                DropdownMenuItem(value: true, child: Text('PM')),
              ],
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildTimeTextField({
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
}
