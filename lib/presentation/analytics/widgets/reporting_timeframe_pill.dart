import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reporting_timeframe.dart';
import '../providers/reporting_timeframe_provider.dart';
import '../theme_provider.dart';
import 'reporting_timeframe_popover.dart';

/// Touch-friendly pill button that opens reporting timeframe popover
class ReportingTimeframePill extends ConsumerWidget {
  const ReportingTimeframePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(reportingTimeframeProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return GestureDetector(
      onTap: () => _showPopover(context),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.15)
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 18,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              selection.displayLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopover(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => const ReportingTimeframePopover(),
    );
  }
}
