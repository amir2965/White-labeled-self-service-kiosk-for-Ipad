import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/models/payout_status.dart';
import '../providers/payouts_providers.dart';
import '../widgets/payout_app_bar.dart';
import '../widgets/status_pill.dart';

/// Settlement details screen showing breakdown and timeline
class SettlementDetailsScreen extends ConsumerWidget {
  final String settlementId;

  const SettlementDetailsScreen({Key? key, required this.settlementId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementAsync = ref.watch(settlementByIdProvider(settlementId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PayoutAppBar(
        title: 'Transfer Details',
        backLabel: 'Activity',
        onBack: () => context.go('/payouts/activity'),
      ),
      body: settlementAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Failed to load transfer details',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    ref.refresh(settlementByIdProvider(settlementId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (settlement) {
          final dateFormatter = DateFormat('dd MMM yyyy, h:mm a');
          final dayFormatter = DateFormat('dd MMM yyyy');

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),

                      // Header card with date and status
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateFormatter.format(settlement.createdAt),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ref: ${settlement.reference}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            StatusPill(status: settlement.status),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settlement period
                      _SectionCard(
                        title: 'Settlement Period',
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Period Start',
                              value: dayFormatter.format(
                                settlement.periodStart,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              label: 'Period End',
                              value: dayFormatter.format(settlement.periodEnd),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Breakdown
                      _SectionCard(
                        title: 'Breakdown',
                        child: Column(
                          children: [
                            _MoneyRow(
                              label: 'Gross',
                              amount: settlement.gross.formatted,
                              isSubdued: false,
                            ),
                            const SizedBox(height: 12),
                            _MoneyRow(
                              label: 'Fees',
                              amount: settlement.fees.formatted,
                              isSubdued: true,
                              isNegative: true,
                            ),
                            const SizedBox(height: 12),
                            _MoneyRow(
                              label: 'GST',
                              amount: settlement.gst.formatted,
                              isSubdued: true,
                              isNegative: true,
                            ),
                            const SizedBox(height: 16),
                            Divider(color: Colors.grey.shade300, height: 1),
                            const SizedBox(height: 16),
                            _MoneyRow(
                              label: 'Net Paid',
                              amount: settlement.netPaid.formatted,
                              isSubdued: false,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Destination
                      _SectionCard(
                        title: 'Destination',
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Bank Account',
                              value: '•••• ${settlement.destinationBankLast4}',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              label: 'Reference',
                              value: settlement.reference,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Timeline
                      _SectionCard(
                        title: 'Timeline',
                        child: _Timeline(status: settlement.status),
                      ),

                      // Failure reason if applicable
                      if (settlement.failureReason != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFB74D)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFF57C00),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Transfer Issue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      settlement.failureReason!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({Key? key, required this.title, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _MoneyRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isSubdued;
  final bool isNegative;
  final bool isBold;

  const _MoneyRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isSubdued = false,
    this.isNegative = false,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 15,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: isSubdued ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
        Text(
          isNegative ? '-$amount' : amount,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isSubdued
                ? Colors.grey.shade600
                : (isBold ? Colors.black : Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  final PayoutStatus status;

  const _Timeline({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      _TimelineStep(
        label: 'Pending',
        isCompleted: true,
        isActive: status == PayoutStatus.pending,
      ),
      _TimelineStep(
        label: 'Processing',
        isCompleted:
            status == PayoutStatus.paid || status == PayoutStatus.processing,
        isActive: status == PayoutStatus.processing,
      ),
      _TimelineStep(
        label: status == PayoutStatus.failed ? 'Failed' : 'Paid',
        isCompleted: status == PayoutStatus.paid,
        isActive: status == PayoutStatus.paid || status == PayoutStatus.failed,
        isFailed: status == PayoutStatus.failed,
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          steps[i],
          if (i < steps.length - 1)
            Container(
              margin: const EdgeInsets.only(left: 11),
              width: 2,
              height: 24,
              color: steps[i].isCompleted
                  ? const Color(0xFF007AFF)
                  : Colors.grey.shade300,
            ),
        ],
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isActive;
  final bool isFailed;

  const _TimelineStep({
    Key? key,
    required this.label,
    required this.isCompleted,
    required this.isActive,
    this.isFailed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF007AFF)
                : (isActive ? Colors.grey.shade300 : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted || isActive
                  ? const Color(0xFF007AFF)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isCompleted || isActive
                ? Colors.black87
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
