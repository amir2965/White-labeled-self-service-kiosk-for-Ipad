import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/order.dart';
import '../analytics/theme_provider.dart';
import '../analytics/widgets/components/luxury_back_button.dart';
import 'providers/kitchen_orders_provider.dart';
import 'widgets/kitchen_order_card.dart';

/// Kitchen Display Screen - Shows incoming orders for kitchen staff
class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KitchenDisplayScreen> createState() =>
      _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(filteredOrdersProvider);
    final filter = ref.watch(orderStatusFilterProvider);
    final now = DateTime.now();
    final timeFormat = DateFormat('h:mm a');

    // Count orders by status
    final allOrders = ref.watch(kitchenOrdersProvider);
    final pendingCount = allOrders
        .where((o) => o.status == OrderStatus.pending)
        .length;
    final confirmedCount = allOrders
        .where((o) => o.status == OrderStatus.confirmed)
        .length;
    final completedCount = allOrders
        .where((o) => o.status == OrderStatus.completed)
        .length;
    final activeCount = pendingCount + confirmedCount;
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.gray200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Title
                      const Icon(
                        Icons.restaurant_menu,
                        size: 32,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Kitchen Display',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const Spacer(),
                      // Current Time
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          timeFormat.format(now),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Tabs
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.gray200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Active',
                        count: activeCount,
                        isSelected: filter == OrderStatusFilter.active,
                        color: AppColors.blue,
                        onTap: () {
                          ref.read(orderStatusFilterProvider.notifier).state =
                              OrderStatusFilter.active;
                        },
                      ),
                      const SizedBox(width: 12),
                      _FilterChip(
                        label: 'New',
                        count: pendingCount,
                        isSelected: filter == OrderStatusFilter.pending,
                        color: AppColors.warning,
                        onTap: () {
                          ref.read(orderStatusFilterProvider.notifier).state =
                              OrderStatusFilter.pending;
                        },
                      ),
                      const SizedBox(width: 12),
                      _FilterChip(
                        label: 'In Progress',
                        count: confirmedCount,
                        isSelected: filter == OrderStatusFilter.confirmed,
                        color: AppColors.info,
                        onTap: () {
                          ref.read(orderStatusFilterProvider.notifier).state =
                              OrderStatusFilter.confirmed;
                        },
                      ),
                      const SizedBox(width: 12),
                      _FilterChip(
                        label: 'Ready',
                        count: completedCount,
                        isSelected: filter == OrderStatusFilter.completed,
                        color: AppColors.success,
                        onTap: () {
                          ref.read(orderStatusFilterProvider.notifier).state =
                              OrderStatusFilter.completed;
                        },
                      ),
                      const Spacer(),
                      // Clear Completed Button
                      if (completedCount > 0)
                        TextButton.icon(
                          onPressed: () {
                            ref
                                .read(kitchenOrdersProvider.notifier)
                                .removeCompletedOrders();
                          },
                          icon: const Icon(Icons.clear_all, size: 20),
                          label: const Text('Clear Completed'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.gray700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Orders Grid
                Expanded(
                  child: orders.isEmpty
                      ? _buildEmptyState(filter)
                      : Padding(
                          padding: const EdgeInsets.all(24),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // 3 columns for iPad landscape
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                ),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final orderNumber = _getOrderNumber(
                                order,
                                allOrders,
                              );
                              return KitchenOrderCard(
                                order: order,
                                orderNumber: orderNumber,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
          // Dashboard quick access button (bottom right)
          Positioned(
            bottom: 12,
            right: 24,
            child: DashboardSlideAccess(
              onUnlocked: () {
                context.go('/dashboard');
              },
              isDarkMode: isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(OrderStatusFilter filter) {
    String message;
    IconData icon;

    switch (filter) {
      case OrderStatusFilter.pending:
        message = 'No new orders';
        icon = Icons.notifications_off_outlined;
        break;
      case OrderStatusFilter.confirmed:
        message = 'No orders in progress';
        icon = Icons.restaurant_outlined;
        break;
      case OrderStatusFilter.completed:
        message = 'No completed orders';
        icon = Icons.check_circle_outline;
        break;
      default:
        message = 'No orders to display';
        icon = Icons.receipt_long_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.gray300),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getOrderNumber(Order order, List<Order> allOrders) {
    // Extract order number from ID (e.g., "ORD001" -> 1)
    final idNumber = order.id.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(idNumber) ?? allOrders.indexOf(order) + 1;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color : AppColors.gray100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.gray700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white.withOpacity(0.3)
                      : AppColors.gray300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.white : AppColors.gray700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
