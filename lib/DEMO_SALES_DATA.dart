// Demo: How to use the Sales Data System
// This file shows example usage - not meant to be run directly

import 'data/repositories/sales_repository.dart';
import 'data/datasources/mock_sales_data_generator.dart';
import 'domain/entities/order.dart';
import 'presentation/providers/order_save_service.dart';

/// Example 1: Query sales data for a specific date range
Future<void> example1_QuerySalesData() async {
  final repository = MockSalesRepository();

  // Query last 7 days
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 7));

  final summary = await repository.getSalesSummary(
    merchantId: 'merchant_001',
    startDate: startDate,
    endDate: endDate,
  );

  print('📊 Last 7 Days Summary:');
  print('Total Revenue: \$${summary['totalRevenue'].toStringAsFixed(2)}');
  print('Total Orders: ${summary['transactionCount']}');
  print('Average Order: \$${summary['averageOrderValue'].toStringAsFixed(2)}');
  print(
    'QR Payments: \$${summary['qrCodeRevenue'].toStringAsFixed(2)} (${summary['qrCodeCount']} orders)',
  );
  print(
    'Counter Payments: \$${summary['counterRevenue'].toStringAsFixed(2)} (${summary['counterCount']} orders)',
  );
}

/// Example 2: Get transactions for a specific day
Future<void> example2_GetDailyTransactions() async {
  final repository = MockSalesRepository();

  final today = DateTime.now();
  final transactions = await repository.getTransactionsForDay(
    merchantId: 'merchant_001',
    date: today,
  );

  print('\n📋 Today\'s Transactions: ${transactions.length}');

  // Show first 3 transactions
  for (int i = 0; i < 3 && i < transactions.length; i++) {
    final tx = transactions[i];
    print('\n  Transaction #${i + 1}:');
    print(
      '  Time: ${tx.timestamp.hour}:${tx.timestamp.minute.toString().padLeft(2, '0')}',
    );
    print('  Items: ${tx.items.length}');
    print('  Total: \$${tx.total.toStringAsFixed(2)}');
    print('  Payment: ${tx.paymentMethod}');
  }
}

/// Example 3: Analyze hourly patterns
Future<void> example3_HourlyAnalysis() async {
  final repository = MockSalesRepository();

  final today = DateTime.now();
  final transactions = await repository.getTransactionsForDay(
    merchantId: 'merchant_001',
    date: today,
  );

  final hourlyData = MockSalesDataGenerator.aggregateByHour(transactions);

  print('\n⏰ Hourly Breakdown:');
  hourlyData.forEach((hour, sales) {
    if (sales > 0) {
      final orderCount = transactions
          .where((t) => t.timestamp.hour == hour)
          .length;
      print(
        '  ${hour.toString().padLeft(2, '0')}:00 - \$${sales.toStringAsFixed(2)} (${orderCount} orders)',
      );
    }
  });
}

/// Example 4: Save a completed order from kiosk
Future<void> example4_SaveKioskOrder(Order completedOrder) async {
  // This would be called from order_confirmation_screen.dart
  // when payment is completed

  final repository = MockSalesRepository();
  final merchantId = 'merchant_001';

  // Convert order to sales transaction
  final transaction = SalesTransaction.fromOrder(completedOrder, merchantId);

  // Save to database
  await repository.saveTransaction(transaction);

  print('✅ Saved order ${completedOrder.id}');
  print('   Total: \$${transaction.total.toStringAsFixed(2)}');
  print('   Payment: ${transaction.paymentMethod}');
  print('   Items: ${transaction.items.length}');
}

/// Example 5: Compare periods (This Week vs Last Week)
Future<void> example5_ComparePeriods() async {
  final repository = MockSalesRepository();
  final now = DateTime.now();

  // This week
  final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
  final thisWeekSummary = await repository.getSalesSummary(
    merchantId: 'merchant_001',
    startDate: thisWeekStart,
    endDate: now,
  );

  // Last week
  final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
  final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));
  final lastWeekSummary = await repository.getSalesSummary(
    merchantId: 'merchant_001',
    startDate: lastWeekStart,
    endDate: lastWeekEnd,
  );

  final thisWeekRevenue = thisWeekSummary['totalRevenue'] as double;
  final lastWeekRevenue = lastWeekSummary['totalRevenue'] as double;
  final growth = ((thisWeekRevenue - lastWeekRevenue) / lastWeekRevenue * 100);

  print('\n📈 Week Comparison:');
  print('This Week: \$${thisWeekRevenue.toStringAsFixed(2)}');
  print('Last Week: \$${lastWeekRevenue.toStringAsFixed(2)}');
  print('Growth: ${growth > 0 ? '+' : ''}${growth.toStringAsFixed(1)}%');
}

/// Example 6: Get top selling products for a period
Future<void> example6_TopProducts() async {
  final repository = MockSalesRepository();

  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));

  final transactions = await repository.getTransactions(
    merchantId: 'merchant_001',
    startDate: startDate,
    endDate: endDate,
  );

  // Aggregate by product
  final Map<String, Map<String, dynamic>> productStats = {};

  for (final transaction in transactions) {
    for (final item in transaction.items) {
      if (!productStats.containsKey(item.productId)) {
        productStats[item.productId] = {
          'name': item.productName,
          'quantity': 0,
          'revenue': 0.0,
        };
      }

      productStats[item.productId]!['quantity'] += item.quantity;
      productStats[item.productId]!['revenue'] += item.totalPrice;
    }
  }

  // Sort by revenue
  final sortedProducts = productStats.entries.toList()
    ..sort(
      (a, b) => (b.value['revenue'] as double).compareTo(
        a.value['revenue'] as double,
      ),
    );

  print('\n🏆 Top 5 Products (Last 30 Days):');
  for (int i = 0; i < 5 && i < sortedProducts.length; i++) {
    final product = sortedProducts[i];
    print('  ${i + 1}. ${product.value['name']}');
    print(
      '     Revenue: \$${(product.value['revenue'] as double).toStringAsFixed(2)}',
    );
    print('     Sold: ${product.value['quantity']} units');
  }
}

/// Example 7: Payment method analysis
Future<void> example7_PaymentAnalysis() async {
  final repository = MockSalesRepository();

  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 90));

  final summary = await repository.getSalesSummary(
    merchantId: 'merchant_001',
    startDate: startDate,
    endDate: endDate,
  );

  final qrRevenue = summary['qrCodeRevenue'] as double;
  final counterRevenue = summary['counterRevenue'] as double;
  final totalRevenue = summary['totalRevenue'] as double;

  final qrPercent = (qrRevenue / totalRevenue * 100);
  final counterPercent = (counterRevenue / totalRevenue * 100);

  print('\n💳 Payment Methods (Last 90 Days):');
  print(
    'QR Code: \$${qrRevenue.toStringAsFixed(2)} (${qrPercent.toStringAsFixed(1)}%)',
  );
  print('  ${summary['qrCodeCount']} transactions');
  print(
    'Pay at Counter: \$${counterRevenue.toStringAsFixed(2)} (${counterPercent.toStringAsFixed(1)}%)',
  );
  print('  ${summary['counterCount']} transactions');
}

/// Example 8: MongoDB aggregation equivalent
/// This shows what the MongoDB query would look like
void example8_MongoDBQuery() {
  print('''
// MongoDB Aggregation Query Example:
// Get daily sales summary

db.sales_transactions.aggregate([
  {
    \$match: {
      merchantId: "merchant_001",
      date: "2026-02-05",
      status: "completed"
    }
  },
  {
    \$group: {
      _id: null,
      totalRevenue: { \$sum: "\$total" },
      totalOrders: { \$sum: 1 },
      avgOrderValue: { \$avg: "\$total" },
      qrRevenue: {
        \$sum: {
          \$cond: [{ \$eq: ["\$paymentMethod", "qrCode"] }, "\$total", 0]
        }
      },
      counterRevenue: {
        \$sum: {
          \$cond: [{ \$eq: ["\$paymentMethod", "payAtCounter"] }, "\$total", 0]
        }
      }
    }
  }
])
  ''');
}

// Main demo runner
void main() async {
  print('═══════════════════════════════════════════════════════');
  print('  Self-Service Kiosk - Sales Data System Demo');
  print('  2 Years of Mock Data Ready!');
  print('═══════════════════════════════════════════════════════\n');

  // Initialize mock data (happens automatically in app)
  MockSalesRepository.initialize();

  // Run examples
  await example1_QuerySalesData();
  await example2_GetDailyTransactions();
  await example3_HourlyAnalysis();
  await example5_ComparePeriods();
  await example6_TopProducts();
  await example7_PaymentAnalysis();
  example8_MongoDBQuery();

  print('\n═══════════════════════════════════════════════════════');
  print('  ✅ Demo Complete!');
  print('  See MONGODB_INTEGRATION.md for production setup');
  print('═══════════════════════════════════════════════════════\n');
}
