import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';
import '../providers/kitchen_orders_provider.dart';

/// Kitchen order card with status management
class KitchenOrderCard extends ConsumerWidget {
  final Order order;
  final int orderNumber;

  const KitchenOrderCard({
    Key? key,
    required this.order,
    required this.orderNumber,
  }) : super(key: key);

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return AppColors.info;
      case OrderStatus.completed:
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'NEW';
      case OrderStatus.confirmed:
        return 'IN PROGRESS';
      case OrderStatus.completed:
        return 'READY';
      default:
        return status.name.toUpperCase();
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.notifications_active;
      case OrderStatus.confirmed:
        return Icons.restaurant;
      case OrderStatus.completed:
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }

  String _getTimeSince(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
    }
  }

  Color _getTimerColor(DateTime createdAt) {
    final minutes = DateTime.now().difference(createdAt).inMinutes;
    if (minutes < 5) return AppColors.gray600;
    if (minutes < 10) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(order.status);
    final timeSince = _getTimeSince(order.createdAt);
    final timerColor = _getTimerColor(order.createdAt);
    final isCompleted = order.status == OrderStatus.completed;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with order number and status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Order Number
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$orderNumber',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: timerColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 16, color: timerColor),
                          const SizedBox(width: 4),
                          Text(
                            timeSince,
                            style: TextStyle(
                              color: timerColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Status Badge
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(order.status),
                      size: 18,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusLabel(order.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: order.items.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 24, color: AppColors.gray200),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity Badge
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.gray900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.quantity}x',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Item Name
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Special Instructions
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.notes!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.gray800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),

          // Action Buttons
          if (!isCompleted)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (order.status == OrderStatus.pending) ...[
                    Expanded(
                      child: _ActionButton(
                        label: 'START',
                        icon: Icons.play_arrow,
                        color: AppColors.info,
                        onPressed: () {
                          ref
                              .read(kitchenOrdersProvider.notifier)
                              .startOrder(order.id);
                        },
                      ),
                    ),
                  ] else if (order.status == OrderStatus.confirmed) ...[
                    Expanded(
                      child: _ActionButton(
                        label: 'MARK READY',
                        icon: Icons.check,
                        color: AppColors.success,
                        onPressed: () {
                          ref
                              .read(kitchenOrdersProvider.notifier)
                              .completeOrder(order.id);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
