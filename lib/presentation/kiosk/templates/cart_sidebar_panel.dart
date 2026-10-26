import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../payments/checkout_screen.dart';
import '../../providers/cart_provider.dart';

/// Reusable right-side cart/checkout sidebar.
class CartSidebarPanel extends ConsumerWidget {
  final double width;

  const CartSidebarPanel({super.key, this.width = 360});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(color: AppColors.gray300, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  'Your Order',
                  style: AppTypography.h3.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.gray300),
                  ),
                  child: Text(
                    '${cartState.itemCount}',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cartState.itemCount == 0
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 40,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'Cart is empty',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.gray600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: cartState.items.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      return Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.gray300.withOpacity(0.8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.notes != null &&
                                      item.notes!.isNotEmpty) ...[
                                    SizedBox(height: 4),
                                    Text(
                                      item.notes!,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (item.modifiers.isNotEmpty) ...[
                                    SizedBox(height: 4),
                                    ...item.modifiers.map((modifier) {
                                      final priceText =
                                          modifier.modifier.priceAdjustment > 0
                                          ? ' (+\$${modifier.modifier.priceAdjustment.toStringAsFixed(2)})'
                                          : '';
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          '• ${modifier.modifier.name}$priceText',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }),
                                  ],
                                  SizedBox(height: 2),
                                  Text(
                                    'x${item.quantity}  •  \$${item.totalPrice.toStringAsFixed(2)}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.gray600,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                _QtyButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(
                                          index,
                                          item.quantity - 1,
                                        );
                                  },
                                ),
                                SizedBox(width: 8),
                                _QtyButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(
                                          index,
                                          item.quantity + 1,
                                        );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray300, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${cartState.total.toStringAsFixed(2)}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: cartState.itemCount == 0
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  items: cartState.items.map((item) {
                                    final modifierCost = item.modifiers.fold(
                                      0.0,
                                      (sum, m) =>
                                          sum + m.modifier.priceAdjustment,
                                    );
                                    return {
                                      'name': item.product.name,
                                      'basePrice': item.product.price,
                                      'price':
                                          item.product.price + modifierCost,
                                      'quantity': item.quantity,
                                      'notes': item.notes,
                                      'modifiers': item.modifiers
                                          .map(
                                            (m) => {
                                              'name': m.modifier.name,
                                              'modifier': {
                                                'name': m.modifier.name,
                                                'priceAdjustment':
                                                    m.modifier.priceAdjustment,
                                              },
                                            },
                                          )
                                          .toList(),
                                    };
                                  }).toList(),
                                  subtotal: cartState.subtotal,
                                  serviceFee: cartState.serviceFee,
                                  total: cartState.total,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.gray300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray300, width: 1),
        ),
        child: Icon(icon, size: 18, color: AppColors.gray900),
      ),
    );
  }
}
