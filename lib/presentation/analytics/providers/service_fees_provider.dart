import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fee_models.dart';

/// Provider for service fees data
/// TODO: Replace with actual API call to backend
final serviceFeesProvider = FutureProvider<ServiceFeesData>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 300));

  return _getMockServiceFeesData();
});

/// Mock data generator for service fees
/// TODO: Remove this function when integrating with real backend
ServiceFeesData _getMockServiceFeesData() {
  // Generate realistic mock transactions
  final transactions = <FeeTransaction>[];
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  // Generate 2000 transactions for YESTERDAY to test high-volume pagination
  for (var i = 0; i < 2000; i++) {
    // Spread transactions throughout the day (24 hours)
    final hour = i % 24;
    final minute = (i * 17) % 60; // Pseudo-random minutes
    final second = (i * 37) % 60; // Pseudo-random seconds

    final transactionTime = yesterday.add(
      Duration(hours: hour, minutes: minute, seconds: second),
    );

    // Vary amounts realistically between $5 and $500
    final grossAmount = 5.0 + ((i * 73) % 495) + ((i * 11) % 100) / 100;
    final feePercent = 1.5;
    final serviceFee = grossAmount * (feePercent / 100);

    transactions.add(
      FeeTransaction(
        date: transactionTime,
        orderId: 'ORD${10000 + i}',
        grossAmount: grossAmount,
        serviceFee: serviceFee,
        feePercent: feePercent,
      ),
    );
  }

  // Add a few transactions for today (for comparison)
  final todayTransactions = [45.50, 32.00, 78.25, 120.00, 23.50];

  for (var i = 0; i < todayTransactions.length; i++) {
    final grossAmount = todayTransactions[i];
    final feePercent = 1.5;
    final serviceFee = grossAmount * (feePercent / 100);

    transactions.add(
      FeeTransaction(
        date: now.subtract(Duration(hours: i * 2)),
        orderId: 'ORD${20000 + i}',
        grossAmount: grossAmount,
        serviceFee: serviceFee,
        feePercent: feePercent,
      ),
    );
  }

  // Calculate summary values
  final grossSales = transactions.fold<double>(
    0.0,
    (sum, t) => sum + t.grossAmount,
  );

  final totalServiceFees = transactions.fold<double>(
    0.0,
    (sum, t) => sum + t.serviceFee,
  );

  final averageFeePercent = 1.5;
  final effectiveFeeRate = (totalServiceFees / grossSales) * 100;
  final netBeforeGst = grossSales - totalServiceFees;

  return ServiceFeesData(
    summary: FeeSummary(
      totalServiceFees: totalServiceFees,
      averageFeePercent: averageFeePercent,
      effectiveFeeRate: effectiveFeeRate,
      grossSales: grossSales,
      netBeforeGst: netBeforeGst,
    ),
    breakdown: FeeBreakdown(
      grossSales: grossSales,
      platformFee: totalServiceFees,
      feePercent: averageFeePercent,
      netBeforeGst: netBeforeGst,
    ),
    transactions: transactions..sort((a, b) => b.date.compareTo(a.date)),
  );
}
