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
import '../widgets/kiosk_layout.dart';
import 'cart_sidebar_panel.dart';

/// Template: Restaurant Spotlight + Cart
/// Big hero spotlight, category chips, and a spacious gallery grid.
class RestaurantSpotlightWithCartTemplate extends ConsumerStatefulWidget {
  const RestaurantSpotlightWithCartTemplate({super.key});

  @override
  ConsumerState<RestaurantSpotlightWithCartTemplate> createState() =>
      _RestaurantSpotlightWithCartTemplateState();
}

class _RestaurantSpotlightWithCartTemplateState
    extends ConsumerState<RestaurantSpotlightWithCartTemplate> {
  String? _selectedCategoryId;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyNav = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky nav when scrolled past the hero section (around 250px)
    // Hide it when scrolled back near the top (less than 200px)
    final offset = _scrollController.offset;
    final shouldShow = offset > 250;

    if (shouldShow != _showStickyNav) {
      setState(() {
        _showStickyNav = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final hideFeatured = ref.watch(hideFeaturedFromMenuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final isLastCategory = categories.last.id == _selectedCategoryId;

    // Get featured product IDs from the new provider
    final featuredIds = ref.watch(
      featuredProductIdsProvider(_selectedCategoryId!),
    );
    final allProducts = menuState.getProductsByCategory(_selectedCategoryId!);

    // Get featured products
    final categoryFeatured = allProducts
        .where((p) => featuredIds.contains(p.id))
        .toList();
    final spotlight = categoryFeatured.isNotEmpty
        ? categoryFeatured.first
        : allProducts.isNotEmpty
        ? allProducts.first
        : null;

    final selectedProducts = hideFeatured
        ? allProducts.where((p) => !featuredIds.contains(p.id)).toList()
        : allProducts;

    if (spotlight == null) {
      return const Center(child: Text('No products available'));
    }

    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                color: AppColors.background,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _SpotlightHero(product: spotlight),
                    SizedBox(height: AppSpacing.lg),

                    // Category chips (original position)
                    _CategoryChips(
                      categories: categories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() {
                          _selectedCategoryId = categoryId;
                        });
                      },
                    ),

                    SizedBox(height: AppSpacing.lg),

                    _SpotlightGrid(products: selectedProducts),
                  ],
                ),
              ),

              // Sticky navigation bar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: _showStickyNav ? 0 : -120,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      _CategoryChips(
                        categories: categories,
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: (categoryId) {
                          setState(() {
                            _selectedCategoryId = categoryId;
                          });
                        },
                      ),
                      Positioned(
                        right: AppSpacing.lg,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: KioskExitButton(isVisible: isLastCategory),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const CartSidebarPanel(width: 360),
      ],
    );
  }
}

// Extract category nav bar into a separate widget for reusability
class _CategoryChips extends StatelessWidget {
  final List categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const _CategoryChips({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.gray300.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 64,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 14),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.id == selectedCategoryId;
            return GestureDetector(
              onTap: () => onCategorySelected(category.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.black : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.black : AppColors.gray300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    category.name,
                    style: AppTypography.bodyLarge.copyWith(
                      color: isSelected ? AppColors.white : AppColors.gray900,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SpotlightHero extends ConsumerWidget {
  final Product product;

  const _SpotlightHero({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
      ),
      child: isLandscape
          ? _buildLandscapeLayout(context)
          : _buildPortraitLayout(),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildContent()),
        SizedBox(width: AppSpacing.lg),
        _buildImage(
          width: MediaQuery.of(context).size.width < 1100 ? 200 : 240,
          height: 140,
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image at top in portrait - reduced height
        Center(child: _buildImage(width: 320, height: 160)),
        SizedBox(height: AppSpacing.md),
        _buildContent(),
      ],
    );
  }

  Widget _buildImage({required double width, required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        color: AppColors.gray300.withOpacity(0.4),
        child: product.imageUrl == null
            ? Icon(Icons.image, size: 44, color: AppColors.gray600)
            : Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported,
                  size: 44,
                  color: AppColors.gray600,
                ),
              ),
      ),
    );
  }

  Widget _buildContent() {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.blue.withOpacity(0.25)),
              ),
              child: Text(
                'SPOTLIGHT',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  fontSize: 11,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              product.name,
              style: AppTypography.h2.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              product.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray600,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTypography.h3.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Customize',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SpotlightGrid extends StatelessWidget {
  final List<Product> products;

  const _SpotlightGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
        ),
        child: Text(
          'No items found',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final crossAxisCount = width > 1100 ? 3 : 2;
        // Taller aspect ratio to accommodate description text
        final aspectRatio = isCompactKiosk(context)
            ? 1.22
            : (isLandscape ? 1.6 : 1.15);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _SpotlightCard(product: products[index]);
          },
        );
      },
    );
  }
}

class _SpotlightCard extends ConsumerWidget {
  final Product product;

  const _SpotlightCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  color: AppColors.gray100,
                  child:
                      product.imageUrl != null && product.imageUrl!.isNotEmpty
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
                              ),
                            );
                          },
                        )
                      : _PlaceholderImage(),
                ),
              ),
            ),

            // Content Area
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name - Bold and prominent
                    Text(
                      product.name,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: isCompactKiosk(context) ? 18 : 20,
                        height: 1.2,
                        letterSpacing: -0.4,
                        color: AppColors.black,
                      ),
                      maxLines: isCompactKiosk(context) ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 6),

                    // Product Description - with proper height
                    Text(
                      product.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray600,
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: isCompactKiosk(context) ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price at bottom - always visible
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: -0.3,
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
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray100,
      child: Center(
        child: Icon(Icons.restaurant, size: 48, color: AppColors.gray400),
      ),
    );
  }
}
