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
import '../widgets/kiosk_exit_button.dart';
import 'cart_sidebar_panel.dart';

/// Template: Restaurant Course Navigator + Cart (Image Version)
/// Left course navigator, center menu list with images, right cart sidebar.
/// Features larger item boxes with professional product imagery.
class RestaurantCourseNavigatorWithCartImageTemplate
    extends ConsumerStatefulWidget {
  const RestaurantCourseNavigatorWithCartImageTemplate({super.key});

  @override
  ConsumerState<RestaurantCourseNavigatorWithCartImageTemplate> createState() =>
      _RestaurantCourseNavigatorWithCartImageTemplateState();
}

class _RestaurantCourseNavigatorWithCartImageTemplateState
    extends ConsumerState<RestaurantCourseNavigatorWithCartImageTemplate> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final isLastCategory = categories.last.id == _selectedCategoryId;

    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    final products = menuState.getProductsByCategory(selectedCategory.id);

    return LandscapeOnlyGuard(
      templateName: 'Course Navigator + Cart (Images)',
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
                        Text(
                          selectedCategory.name,
                          style: AppTypography.h3.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        KioskExitButton(isVisible: isLastCategory),
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
                              return _MenuItemCard(product: products[index]);
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

class _MenuItemCard extends ConsumerWidget {
  final Product product;

  const _MenuItemCard({required this.product});

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
        height: 175, // Increased from 160 for more bottom space
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 200,
              height: 175,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _PlaceholderImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.blue,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : _PlaceholderImage(),
              ),
            ),

            // Content Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Product Description (fixed 2-line height)
                    SizedBox(
                      height: 42,
                      child: Text(
                        product.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gray600,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 8),

                    // Bottom Row: Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.gray300.withOpacity(0.6),
                            ),
                          ),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),

                        // Add to Cart Button
                        SizedBox(
                          width: 120,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Add',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 48, color: AppColors.gray400),
            SizedBox(height: 8),
            Text(
              'No Image',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
