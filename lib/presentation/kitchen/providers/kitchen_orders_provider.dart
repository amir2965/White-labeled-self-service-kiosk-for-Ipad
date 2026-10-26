import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/modifier.dart';

/// Provider for kitchen orders with auto-refresh
final kitchenOrdersProvider =
    StateNotifierProvider<KitchenOrdersNotifier, List<Order>>((ref) {
      return KitchenOrdersNotifier();
    });

/// Filter provider for order status
final orderStatusFilterProvider = StateProvider<OrderStatusFilter>((ref) {
  return OrderStatusFilter.active; // Default to active orders
});

enum OrderStatusFilter {
  all,
  active, // pending + confirmed
  pending,
  confirmed,
  completed,
}

class KitchenOrdersNotifier extends StateNotifier<List<Order>> {
  KitchenOrdersNotifier() : super([]) {
    _loadMockOrders();
  }

  void _loadMockOrders() {
    // Generate mock orders for demo
    state = [
      _createMockOrder(
        id: 'ORD001',
        orderNumber: 1,
        status: OrderStatus.pending,
        minutesAgo: 2,
        items: [
          ('Cappuccino', 2, 'Extra hot, no foam'),
          ('Croissant', 1, null),
        ],
      ),
      _createMockOrder(
        id: 'ORD002',
        orderNumber: 2,
        status: OrderStatus.confirmed,
        minutesAgo: 5,
        items: [
          ('Flat White', 1, null),
          ('Avocado Toast', 1, 'No chili flakes'),
          ('Orange Juice', 1, null),
        ],
      ),
      _createMockOrder(
        id: 'ORD003',
        orderNumber: 3,
        status: OrderStatus.pending,
        minutesAgo: 1,
        items: [('Latte', 3, 'Oat milk'), ('Blueberry Muffin', 2, null)],
      ),
      _createMockOrder(
        id: 'ORD004',
        orderNumber: 4,
        status: OrderStatus.confirmed,
        minutesAgo: 8,
        items: [('Espresso', 2, null), ('Banana Bread', 1, 'Toasted')],
      ),
      _createMockOrder(
        id: 'ORD005',
        orderNumber: 5,
        status: OrderStatus.completed,
        minutesAgo: 12,
        items: [
          ('Iced Coffee', 1, 'Large'),
          ('Caesar Salad', 1, 'Dressing on side'),
        ],
      ),
    ];
  }

  Order _createMockOrder({
    required String id,
    required int orderNumber,
    required OrderStatus status,
    required int minutesAgo,
    required List<(String, int, String?)> items,
  }) {
    final createdAt = DateTime.now().subtract(Duration(minutes: minutesAgo));

    final orderItems = items.map((item) {
      final (name, quantity, notes) = item;
      return OrderItem(
        id: 'ITEM_${id}_$name',
        product: Product(
          id: 'PROD_$name',
          name: name,
          description: name,
          price: 5.0,
          categoryId: 'CAT_BEVERAGES',
          imageUrl: null,
          modifierGroups: [],
          tags: [],
          isAvailable: true,
          isFeatured: false,
        ),
        quantity: quantity,
        unitPrice: 5.0,
        totalPrice: 5.0 * quantity,
        selectedModifiers: [],
        notes: notes,
      );
    }).toList();

    return Order(
      id: id,
      merchantId: 'MERCHANT_1',
      items: orderItems,
      subtotal: 0.0,
      serviceFee: 0.0,
      total: 0.0,
      status: status,
      paymentMethod: PaymentMethod.qrCode,
      createdAt: createdAt,
      completedAt: status == OrderStatus.completed
          ? createdAt.add(Duration(minutes: 10))
          : null,
    );
  }

  /// Update order status (kitchen workflow)
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            status: newStatus,
            completedAt: newStatus == OrderStatus.completed
                ? DateTime.now()
                : null,
          )
        else
          order,
    ];
  }

  /// Mark order as in progress
  void startOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.confirmed);
  }

  /// Mark order as ready
  void completeOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.completed);
  }

  /// Remove completed orders (cleanup)
  void removeCompletedOrders() {
    state = state
        .where((order) => order.status != OrderStatus.completed)
        .toList();
  }

  /// Simulate new order arrival (for demo)
  void addNewOrder() {
    final newOrderNumber = state.length + 1;
    final newOrder = _createMockOrder(
      id: 'ORD${newOrderNumber.toString().padLeft(3, '0')}',
      orderNumber: newOrderNumber,
      status: OrderStatus.pending,
      minutesAgo: 0,
      items: [('Coffee', 1, null), ('Sandwich', 1, 'No onions')],
    );
    state = [newOrder, ...state];
  }
}

/// Computed provider for filtered orders
final filteredOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(kitchenOrdersProvider);
  final filter = ref.watch(orderStatusFilterProvider);

  switch (filter) {
    case OrderStatusFilter.all:
      return orders;
    case OrderStatusFilter.active:
      return orders
          .where(
            (o) =>
                o.status == OrderStatus.pending ||
                o.status == OrderStatus.confirmed,
          )
          .toList();
    case OrderStatusFilter.pending:
      return orders.where((o) => o.status == OrderStatus.pending).toList();
    case OrderStatusFilter.confirmed:
      return orders.where((o) => o.status == OrderStatus.confirmed).toList();
    case OrderStatusFilter.completed:
      return orders.where((o) => o.status == OrderStatus.completed).toList();
  }
});
