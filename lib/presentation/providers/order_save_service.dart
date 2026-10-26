import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../../data/datasources/mock_sales_data_generator.dart';
import '../../data/repositories/sales_repository.dart';

/// Order Save Service Provider
final orderSaveServiceProvider = Provider<OrderSaveService>((ref) {
  final repository = ref.read(salesRepositoryProvider);
  return OrderSaveService(repository);
});

/// Service to save completed orders to the database
/// Converts Order entities to SalesTransaction format for MongoDB
class OrderSaveService {
  final SalesRepository _repository;

  OrderSaveService(this._repository);

  /// Save a completed order to the database
  /// Call this when an order status changes to 'completed'
  Future<void> saveCompletedOrder({
    required Order order,
    required String merchantId,
  }) async {
    // Only save completed orders
    if (order.status != OrderStatus.completed) {
      print('⚠️ Order ${order.id} not completed yet, skipping save');
      return;
    }

    try {
      // Convert Order to SalesTransaction
      final transaction = SalesTransaction.fromOrder(order, merchantId);

      // Save to repository (MongoDB or Mock)
      await _repository.saveTransaction(transaction);

      print(
        '✅ Saved order ${order.id} to database: \$${transaction.total.toStringAsFixed(2)}',
      );
    } catch (e) {
      print('❌ Failed to save order ${order.id}: $e');
      rethrow;
    }
  }

  /// Batch save multiple orders (useful for migration or bulk operations)
  Future<void> saveCompletedOrdersBatch({
    required List<Order> orders,
    required String merchantId,
  }) async {
    final completedOrders = orders
        .where((o) => o.status == OrderStatus.completed)
        .toList();

    if (completedOrders.isEmpty) {
      print('⚠️ No completed orders to save');
      return;
    }

    try {
      final transactions = completedOrders
          .map((order) => SalesTransaction.fromOrder(order, merchantId))
          .toList();

      await _repository.saveTransactionsBatch(transactions);

      print('✅ Batch saved ${transactions.length} orders to database');
    } catch (e) {
      print('❌ Failed to batch save orders: $e');
      rethrow;
    }
  }
}

/// Sales Repository Provider (defined here to avoid circular dependency)
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  // For development: use mock data
  return MockSalesRepository();

  // For production: use MongoDB
  // final mongoDatabase = ref.read(mongoDatabaseProvider);
  // return MongoSalesRepository(mongoDatabase);
});
