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

/// Template: Top Tab Navigation with Two Column List View
/// Horizontal category tabs at top, product rows in two columns
class TopTabListTwoColumnTemplate extends ConsumerStatefulWidget {
  const TopTabListTwoColumnTemplate({super.key});

  @override
  ConsumerState<TopTabListTwoColumnTemplate> createState() =>
      _TopTabListTwoColumnTemplateState();
}

class _TopTabListTwoColumnTemplateState
    extends ConsumerState<TopTabListTwoColumnTemplate> {
  int _selectedCategoryIndex = 0;

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

    return Column(
      children: [
        // Fixed top navigation bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray300.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.gray300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            category.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              fontSize: 17,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.gray700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Hidden exit button - only visible on last category
              KioskExitButton(
                isVisible: isLastCategory,
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),

        // Product List - Two Columns
        Expanded(
          child: Container(
            color: AppColors.background,
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'No products in this category',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: List.generate((products.length / 2).ceil(), (
                        rowIndex,
                      ) {
                        final leftIndex = rowIndex * 2;
                        final rightIndex = leftIndex + 1;
                        final hasRight = rightIndex < products.length;

                        return Padding(
                          padding: EdgeInsets.only(top: rowIndex > 0 ? 24 : 0),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _ProductListRow(
                                    product: products[leftIndex],
                                    isCompact: true,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: hasRight
                                      ? _ProductListRow(
                                          product: products[rightIndex],
                                          isCompact: true,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _ProductListRow extends ConsumerWidget {
  final Product product;
  final bool isCompact;

  const _ProductListRow({required this.product, required this.isCompact});

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
        height: isCompact ? 150 : 170,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: isCompact ? 110 : 130,
                height: isCompact ? 110 : 130,
                color: AppColors.gray100,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 48,
                            color: AppColors.gray400,
                          );
                        },
                      )
                    : Icon(Icons.fastfood, size: 48, color: AppColors.gray400),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 18 : 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isCompact && product.description != null) ...[
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          product.description!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTypography.h3.copyWith(
                          fontSize: isCompact ? 20 : 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: isCompact ? 42 : 46,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: isCompact ? 18 : 22,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
