import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';
import 'cart_sidebar_panel.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Restaurant Course Navigator + Cart
/// Left course navigator, center menu list with fast add, right cart sidebar.
class RestaurantCourseNavigatorWithCartTemplate extends ConsumerStatefulWidget {
  const RestaurantCourseNavigatorWithCartTemplate({super.key});

  @override
  ConsumerState<RestaurantCourseNavigatorWithCartTemplate> createState() =>
      _RestaurantCourseNavigatorWithCartTemplateState();
}

class _RestaurantCourseNavigatorWithCartTemplateState
    extends ConsumerState<RestaurantCourseNavigatorWithCartTemplate> {
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
      templateName: 'Course Navigator + Cart',
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

          // Center menu list
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  // Fixed category title header
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.gray300.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedCategory.name,
                            style: AppTypography.h3.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        KioskExitButton(
                          isVisible: isLastCategory,
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: products.isEmpty
                        ? Center(
                            child: Text(
                              'No items in this section',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.gray600,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.lg,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            itemCount: products.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              return _MenuRow(product: products[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Right cart sidebar
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

class _MenuRow extends ConsumerWidget {
  final Product product;

  const _MenuRow({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsScreen(product: product),
        );
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 44,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ProductDetailsScreen(product: product),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Icon(Icons.add, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
