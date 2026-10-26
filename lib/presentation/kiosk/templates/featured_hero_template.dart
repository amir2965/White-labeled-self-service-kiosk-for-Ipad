import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/featured_display_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Featured Hero
/// A bold "hero" rail for featured items + category chips + compact grid.
class FeaturedHeroTemplate extends ConsumerStatefulWidget {
  const FeaturedHeroTemplate({super.key});

  @override
  ConsumerState<FeaturedHeroTemplate> createState() =>
      _FeaturedHeroTemplateState();
}

class _FeaturedHeroTemplateState extends ConsumerState<FeaturedHeroTemplate> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    // Get featured items from all categories using the new provider
    final List<Product> featured = [];
    for (final category in categories) {
      final featuredIds = ref.watch(featuredProductIdsProvider(category.id));
      final categoryProducts = menuState.getProductsByCategory(category.id);
      final categoryFeatured = categoryProducts
          .where((p) => featuredIds.contains(p.id))
          .toList();
      featured.addAll(categoryFeatured);
    }

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;

    // Check if this is the last category for exit button
    final isLastCategory = categories.last.id == _selectedCategoryId;

    final products = menuState.getProductsByCategory(_selectedCategoryId!);

    return Column(
      children: [
        // Hero rail
        Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KioskExitButton(isVisible: isLastCategory),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Featured',
                    style: AppTypography.h2.copyWith(fontSize: 22),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Tap to customize',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final product = featured[index];
                    return _HeroCard(product: product);
                  },
                ),
              ),
            ],
          ),
        ),

        // Category chips
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.gray300, width: 1),
            ),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...categories.map((category) {
                final isSelected = _selectedCategoryId == category.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category.id;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.black : AppColors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.black
                              : AppColors.gray300,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Compact grid
        Expanded(
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.all(20),
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
                      return _CompactCard(product: products[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  int _columnsForWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1500) return 5;
    if (width > 1200) return 4;
    return 3;
  }
}

class _HeroCard extends ConsumerWidget {
  final Product product;

  const _HeroCard({required this.product});

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
        width: 360,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.h2.copyWith(
                            fontSize: 22,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          product.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white.withOpacity(0.75),
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Customize',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                width: 130,
                color: AppColors.gray300,
                child: product.imageUrl == null
                    ? Icon(Icons.image, size: 42, color: AppColors.gray600)
                    : Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 42,
                            color: AppColors.gray600,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactCard extends ConsumerWidget {
  final Product product;

  const _CompactCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (product.modifierGroups.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ProductDetailsScreen(product: product),
          );
        } else {
          ref.read(cartProvider.notifier).addItem(product: product);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray300, width: 1),
        ),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gray300.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      product.modifierGroups.isNotEmpty ? 'Customize' : 'Add',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
