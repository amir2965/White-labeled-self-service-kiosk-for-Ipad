import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../features/payouts/domain/models/settlement.dart';
import '../../../features/payouts/presentation/providers/payouts_providers.dart';
import '../../../features/payouts/presentation/services/pdf_export_service.dart';
import '../../../features/payouts/presentation/widgets/date_range_pill.dart';
import '../../../features/payouts/presentation/widgets/empty_state_card.dart';
import '../../../features/payouts/presentation/widgets/pill_buttons.dart';
import '../../../features/payouts/presentation/widgets/settlement_table.dart';
import '../theme_provider.dart';

/// Body content of Activity screen for embedding in other pages
class ActivityContent extends ConsumerWidget {
  const ActivityContent({Key? key}) : super(key: key);

  /// Exports transfer history as a professional PDF
  Future<void> _exportToPdf(
    BuildContext context,
    List<Settlement> settlements,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      await PdfExportService.generateTransferHistoryPdf(
        settlements: settlements,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDateRangeSelector(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeModeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: isDarkMode
            ? BorderSide(color: Colors.white.withOpacity(0.15))
            : BorderSide.none,
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: QuickDateRangeSelector(
          onRangeSelected: (start, end) {
            ref.read(dateRangeProvider.notifier).setDateRange(start, end);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementsAsync = ref.watch(settlementsProvider);
    final dateRange = ref.watch(dateRangeProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    final canGoForward = dateRange.endDate
        .add(dateRange.endDate.difference(dateRange.startDate))
        .isBefore(DateTime.now());

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Filter row
                Row(
                  children: [
                    DateRangePill(
                      startDate: dateRange.startDate,
                      endDate: dateRange.endDate,
                      canGoForward: canGoForward,
                      onBackward: () {
                        ref.read(dateRangeProvider.notifier).stepBackward();
                      },
                      onForward: () {
                        ref.read(dateRangeProvider.notifier).stepForward();
                      },
                      onTap: () => _showDateRangeSelector(context, ref),
                    ),
                    const Spacer(),
                    settlementsAsync.when(
                      data: (settlements) => SecondaryPillButton(
                        label: 'Export PDF',
                        icon: Icons.picture_as_pdf,
                        onPressed: settlements.isEmpty
                            ? null
                            : () => _exportToPdf(
                                context,
                                settlements,
                                dateRange.startDate,
                                dateRange.endDate,
                              ),
                      ),
                      loading: () => const SecondaryPillButton(
                        label: 'Export PDF',
                        icon: Icons.picture_as_pdf,
                        onPressed: null,
                      ),
                      error: (_, __) => const SecondaryPillButton(
                        label: 'Export PDF',
                        icon: Icons.picture_as_pdf,
                        onPressed: null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Content
                settlementsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load transfers',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => ref.refresh(settlementsProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (settlements) {
                    if (settlements.isEmpty) {
                      return EmptyStateCard(
                        icon: Icons.description_outlined,
                        title: 'No transfers in this time frame',
                        subtitle:
                            'No funds were transferred in the time frame you have selected. Please select a different range.',
                      );
                    }

                    return SettlementTable(
                      settlements: settlements,
                      onRowTap: (settlement) {
                        // Show details in a dialog instead of navigating
                        _showSettlementDetailsDialog(
                          context,
                          settlement.id,
                          ref,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettlementDetailsDialog(
    BuildContext context,
    String settlementId,
    WidgetRef ref,
  ) {
    final isDarkMode = ref.read(themeModeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isDarkMode
              ? BorderSide(color: Colors.white.withOpacity(0.15))
              : BorderSide.none,
        ),
        title: Text(
          'Settlement Details',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        content: Text(
          'Settlement details dialog (implement as needed)',
          style: TextStyle(
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF007AFF),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
