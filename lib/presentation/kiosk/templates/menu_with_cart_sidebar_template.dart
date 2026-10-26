import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../payments/checkout_screen.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Menu With Cart Sidebar
/// 3-pane layout: categories (left) + product grid (center) + always-visible cart (right).
class MenuWithCartSidebarTemplate extends ConsumerStatefulWidget {
  const MenuWithCartSidebarTemplate({super.key});

  @override
  ConsumerState<MenuWithCartSidebarTemplate> createState() =>
      _MenuWithCartSidebarTemplateState();
}

class _MenuWithCartSidebarTemplateState
    extends ConsumerState<MenuWithCartSidebarTemplate> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final cartState = ref.watch(cartProvider);

    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    final selectedCategory = categories[_selectedCategoryIndex];
    final products = menuState.getProductsByCategory(selectedCategory.id);

    // Check if this is the last category for exit button
    final isLastCategory = _selectedCategoryIndex == categories.length - 1;

    return LandscapeOnlyGuard(
      templateName: 'Menu + Cart Sidebar',
      child: Row(
        children: [
          // Left categories
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                right: BorderSide(color: AppColors.gray300, width: 1),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: KioskExitButton(isVisible: isLastCategory),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = index == _selectedCategoryIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 68,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.gray300,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            category.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Center products
          Expanded(
            child: Container(
              color: AppColors.background,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        'No products in this category',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _columnsForWidth(context),
                        childAspectRatio: 1.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.gray300.withOpacity(0.7),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 3,
                                ),

                                if (product.description.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    product.description,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.gray600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                SizedBox(height: 8),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: AppTypography.h3.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .addItem(
                                              product: product,
                                              quantity: 1,
                                            );
                                      },
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Right cart sidebar
          Container(
            width: 360,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                left: BorderSide(color: AppColors.gray300, width: 1),
              ),
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
                        style: AppTypography.h2.copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      if (cartState.itemCount > 0)
                        TextButton(
                          onPressed: () =>
                              ref.read(cartProvider.notifier).clear(),
                          child: Text('Clear'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: cartState.items.isEmpty
                      ? Center(
                          child: Text(
                            'Cart is empty',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.gray600,
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
                              SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final item = cartState.items[index];
                            return Container(
                              padding: EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.gray300.withOpacity(0.6),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'x${item.quantity}  •  \$${item.totalPrice.toStringAsFixed(2)}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
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
                                          final modifierCost = item.modifiers
                                              .fold(
                                                0.0,
                                                (sum, m) =>
                                                    sum +
                                                    m.modifier.priceAdjustment,
                                              );
                                          return {
                                            'name': item.product.name,
                                            'basePrice': item.product.price,
                                            'price':
                                                item.product.price +
                                                modifierCost,
                                            'quantity': item.quantity,
                                            'modifiers': item.modifiers
                                                .map(
                                                  (m) => {
                                                    'name': m.modifier.name,
                                                    'modifier': {
                                                      'name': m.modifier.name,
                                                      'priceAdjustment': m
                                                          .modifier
                                                          .priceAdjustment,
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
          ),
        ],
      ),
    );
  }

  int _columnsForWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1500) return 4;
    if (width > 1200) return 3;
    return 2;
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
