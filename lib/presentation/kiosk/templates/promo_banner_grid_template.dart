import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/featured_display_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';
import '../widgets/kiosk_layout.dart';

/// Template: Promo Banner Grid
/// Modern, minimal layout with a top promo banner + category chips + spacious grid.
class PromoBannerGridTemplate extends ConsumerStatefulWidget {
  const PromoBannerGridTemplate({super.key});

  @override
  ConsumerState<PromoBannerGridTemplate> createState() =>
      _PromoBannerGridTemplateState();
}

class _PromoBannerGridTemplateState
    extends ConsumerState<PromoBannerGridTemplate> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    final products = menuState.getProductsByCategory(selectedCategory.id);

    // Check if this is the last category for exit button
    final isLastCategory = categories.last.id == selectedCategory.id;

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
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                KioskExitButton(isVisible: isLastCategory),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category.id == selectedCategory.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
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
              ],
            ),
          ),
        ),

        // Main content area
        Expanded(
          child: isLandscape
              ? _LandscapeLayout(products: products, featured: featured)
              : _PortraitLayout(products: products, featured: featured),
        ),
      ],
    );
  }
}

// Landscape layout: 2 columns + scrollable featured column on right
class _LandscapeLayout extends StatelessWidget {
  final List<dynamic> products;
  final List<dynamic> featured;

  const _LandscapeLayout({required this.products, required this.featured});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main 2-column grid
        Expanded(
          child: Container(
            color: AppColors.background,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: isCompactKiosk(context) ? 1.2 : 1.50,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _GridCard(
                  product: product,
                  isPortrait: false,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Featured items scrollable column on right
        if (featured.isNotEmpty)
          Container(
            width: isCompactKiosk(context) ? 250 : 320,
            color: AppColors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.gray300.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.star,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Featured',
                          style: AppTypography.h3.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: featured.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final product = featured[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.gray300.withOpacity(0.7),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.imageUrl != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 2.0,
                                    child: Image.network(
                                      product.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.gray300.withOpacity(
                                          0.3,
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          size: 32,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.all(AppSpacing.sm),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.gray600,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: AppColors.white,
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
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Portrait layout: 3 columns with featured banner at top
class _PortraitLayout extends StatelessWidget {
  final List<dynamic> products;
  final List<dynamic> featured;

  const _PortraitLayout({required this.products, required this.featured});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Featured scrollable banner
        if (featured.isNotEmpty)
          Container(
            color: AppColors.white,
            padding: EdgeInsets.fromLTRB(0, AppSpacing.md, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.star,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Featured Items',
                        style: AppTypography.h3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: featured.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = featured[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          );
                        },
                        child: Container(
                          width: 260,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.gray300.withOpacity(0.7),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (product.imageUrl != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  ),
                                  child: SizedBox(
                                    width: 100,
                                    child: Image.network(
                                      product.imageUrl!,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.gray300.withOpacity(
                                          0.3,
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          size: 32,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSpacing.sm),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.gray600,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
        // Grid
        Expanded(
          child: Container(
            color: AppColors.background,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 0,
              ),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _GridCard(
                  product: product,
                  isPortrait: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
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

class _GridCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;
  final bool isPortrait;

  const _GridCard({
    required this.product,
    required this.onTap,
    this.isPortrait = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Expanded(
                flex: isCompactKiosk(context) ? 1 : 3,
                child: product.imageUrl != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.gray300.withOpacity(0.3),
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: AppColors.gray500,
                              ),
                            ),
                          ),
                          // Subtle gradient at bottom for better text readability if needed
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.black.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: AppColors.gray300.withOpacity(0.3),
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: AppColors.gray500,
                        ),
                      ),
              ),

              // Product Info
              Expanded(
                flex: isCompactKiosk(context) ? 1 : 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gray600,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isPortrait ? 10 : 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: AppColors.white,
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
      ),
    );
  }
}
