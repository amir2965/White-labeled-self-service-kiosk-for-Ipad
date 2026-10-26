import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template 1: Category Sidebar with Grid
/// Persistent left sidebar for categories, main grid for products
class CategorySidebarTemplate extends ConsumerStatefulWidget {
  const CategorySidebarTemplate({super.key});

  @override
  ConsumerState<CategorySidebarTemplate> createState() =>
      _CategorySidebarTemplateState();
}

class _CategorySidebarTemplateState
    extends ConsumerState<CategorySidebarTemplate> {
  int _selectedCategoryIndex = 0;

  int _getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 220; // Minus sidebar
    if (width > 1400) return 4;
    if (width > 1100) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    final selectedCategory = categories[_selectedCategoryIndex];
    final products = menuState.getProductsByCategory(selectedCategory.id);
    final isLastCategory = _selectedCategoryIndex == categories.length - 1;

    return Row(
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
              final isSelected = index == _selectedCategoryIndex;

              return _CategoryButton(
                label: category.name,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              );
            },
          ),
        ),

        // Main Content - Product Grid
        Expanded(
          child: Container(
            color: AppColors.background,
            child: Column(
              children: [
                // Header with category name and exit button
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
                            fontSize: 24,
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: products.isEmpty
                        ? Center(
                            child: Text(
                              'No products in this category',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.gray600,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _getGridColumns(context),
                                  childAspectRatio: 1.05,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return _ProductGridCard(product: products[index]);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

/// Product grid card for sidebar template
class _ProductGridCard extends ConsumerWidget {
  final Product product;

  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Always open customization window when clicking anywhere in the box
        showDialog(
          context: context,
          builder: (context) => ProductDetailsScreen(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return Container(
                            color: AppColors.gray300,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: AppColors.gray600,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.gray300,
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: AppColors.gray600,
                        ),
                      ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      height: 1.25,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
