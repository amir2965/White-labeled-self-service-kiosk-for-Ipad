import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payouts_providers.dart';
import '../widgets/payout_app_bar.dart';

/// Balances screen showing available, pending, and in-transit amounts
class BalancesScreen extends ConsumerWidget {
  const BalancesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PayoutAppBar(
        title: 'Balances',
        onBack: () => context.go('/overview'),
        trailing: IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push('/payouts/settings'),
          color: const Color(0xFF007AFF),
        ),
      ),
      body: balanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Failed to load balance',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.refresh(balanceProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (balance) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Available balance - large centered amount
                    Text(
                      balance.available.formatted,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Pending and In Transit chips
                    if (balance.pending.minorUnits > 0 ||
                        balance.inTransit.minorUnits > 0)
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          if (balance.pending.minorUnits > 0)
                            _BalanceChip(
                              label: 'Pending',
                              amount: balance.pending.formatted,
                              icon: Icons.schedule,
                            ),
                          if (balance.inTransit.minorUnits > 0)
                            _BalanceChip(
                              label: 'In transit',
                              amount: balance.inTransit.formatted,
                              icon: Icons.sync,
                            ),
                        ],
                      ),

                    const SizedBox(height: 48),

                    // Upcoming transfer card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 800),
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
                          Row(
                            children: [
                              const Text(
                                'Upcoming transfer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF007AFF,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.access_time,
                                  color: Color(0xFF007AFF),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Your next scheduled transfer will appear once you begin taking payments. View your Transfers to check funds that have already been sent to your bank account.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  context.push('/payouts/activity'),
                              child: const Text(
                                'View all transfers',
                                style: TextStyle(
                                  color: Color(0xFF007AFF),
                                  fontSize: 15,
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
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;

  const _BalanceChip({
    Key? key,
    required this.label,
    required this.amount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
