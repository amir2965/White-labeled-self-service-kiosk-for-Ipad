import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';

/// Template: Category Landing
/// Starts with a category landing page (large tiles) then drills into products.
class CategoryLandingTemplate extends ConsumerStatefulWidget {
  const CategoryLandingTemplate({super.key});

  @override
  ConsumerState<CategoryLandingTemplate> createState() =>
      _CategoryLandingTemplateState();
}

class _CategoryLandingTemplateState
    extends ConsumerState<CategoryLandingTemplate> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    // Landing view
    if (_selectedCategoryId == null) {
      return Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.storefront, color: AppColors.white),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: AppTypography.h2.copyWith(fontSize: 26),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pick a category to get started',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      '${categories.length} categories',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.2,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final products = menuState.getProductsByCategory(category.id);
                final count = products.length;
                final categoryImage =
                    products.isNotEmpty && products.first.imageUrl != null
                    ? products.first.imageUrl
                    : null;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.gray300.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          child: SizedBox(
                            width: 110,
                            child: ColoredBox(
                              color: AppColors.gray300.withOpacity(0.4),
                              child: categoryImage == null
                                  ? Icon(
                                      Icons.category,
                                      size: 40,
                                      color: AppColors.gray600,
                                    )
                                  : Image.network(
                                      categoryImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.category,
                                        size: 40,
                                        color: AppColors.gray600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category.name,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '$count items',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.gray600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: AppSpacing.sm),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.gray600,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    // Drill-down view
    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );
    final products = menuState.getProductsByCategory(selectedCategory.id);

    return Column(
      children: [
        Container(
          color: AppColors.white,
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gray300),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCategory.name,
                      style: AppTypography.h2.copyWith(fontSize: 22),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap an item to customize.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.blue.withOpacity(0.25)),
                ),
                child: Text(
                  '${products.length} items',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.background,
            padding: EdgeInsets.all(AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                // Adjusted for better proportions
                final aspectRatio = isLandscape ? 0.78 : 0.72;

                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCard(
                      product: product,
                      isLandscape: isLandscape,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final bool isLandscape;

  const _ProductCard({required this.product, required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsScreen(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gray300.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section with fixed aspect ratio
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 1.35,
                child: Container(
                  color: AppColors.gray300.withOpacity(0.25),
                  child: product.imageUrl == null
                      ? Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 42,
                            color: AppColors.gray500,
                          ),
                        )
                      : Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 42,
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            // Content section with fixed layout
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      height: 1.2,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray600,
                      fontSize: 13,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AppColors.white,
                        letterSpacing: -0.3,
                      ),
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
