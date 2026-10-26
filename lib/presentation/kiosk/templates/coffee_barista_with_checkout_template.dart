import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';
import 'cart_sidebar_panel.dart';

/// Template: Coffee Barista Flow with Checkout Bar
/// 3-column layout: presets (left) + big product buttons (center) + checkout bar (right).
class CoffeeBaristaWithCheckoutTemplate extends ConsumerStatefulWidget {
  const CoffeeBaristaWithCheckoutTemplate({super.key});

  @override
  ConsumerState<CoffeeBaristaWithCheckoutTemplate> createState() =>
      _CoffeeBaristaWithCheckoutTemplateState();
}

class _CoffeeBaristaWithCheckoutTemplateState
    extends ConsumerState<CoffeeBaristaWithCheckoutTemplate> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    final products = menuState.getProductsByCategory(selectedCategory.id);
    final isLastCategory = categories.last.id == selectedCategory.id;

    return LandscapeOnlyGuard(
      templateName: 'Coffee Barista + Checkout',
      child: Row(
        children: [
          // Left Sidebar - Categories
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                right: BorderSide(color: AppColors.gray300, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category.id == _selectedCategoryId;

                return _CategoryButton(
                  label: category.name,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                );
              },
            ),
          ),

          // Center: big product buttons
          Expanded(
            child: Container(
              color: AppColors.background,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedCategory.name,
                          style: AppTypography.h2.copyWith(fontSize: 26),
                        ),
                      ),
                      KioskExitButton(isVisible: isLastCategory),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.95,
                          ),
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
                            padding: EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.gray300.withOpacity(0.7),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.coffee,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: AppTypography.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.gray600,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const CartSidebarPanel(width: 360),
        ],
      ),
    );
  }
}

/// Category button in sidebar
class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.gray900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
