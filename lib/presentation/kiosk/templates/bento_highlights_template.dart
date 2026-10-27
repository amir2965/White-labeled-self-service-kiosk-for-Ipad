import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../../providers/featured_display_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';
import '../widgets/kiosk_layout.dart';

/// Template: Bento Highlights
/// Bento-style top highlight tiles (1 large + 2 small) then a modern grid.
class BentoHighlightsTemplate extends ConsumerStatefulWidget {
  const BentoHighlightsTemplate({super.key});

  @override
  ConsumerState<BentoHighlightsTemplate> createState() =>
      _BentoHighlightsTemplateState();
}

class _BentoHighlightsTemplateState
    extends ConsumerState<BentoHighlightsTemplate> {
  String? _selectedCategoryId;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _highlightScrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _highlightScrollController.dispose();
    super.dispose();
  }

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

    // Check if this is the last category for exit button
    final isLastCategory = categories.last.id == selectedCategory.id;

    // Get featured product IDs from the new provider
    final featuredIds = ref.watch(
      featuredProductIdsProvider(selectedCategory.id),
    );
    final allProducts = menuState.getProductsByCategory(selectedCategory.id);

    // Filter to get actual featured products based on IDs
    final featured = allProducts
        .where((p) => featuredIds.contains(p.id))
        .toList();

    final hideFeatured = ref.watch(hideFeaturedFromMenuProvider);
    final products = hideFeatured
        ? allProducts.where((p) => !featuredIds.contains(p.id)).toList()
        : allProducts;

    // Calculate highlight animation progress
    const highlightCollapseDistance = 280.0;
    final progress = (_scrollOffset / highlightCollapseDistance).clamp(
      0.0,
      1.0,
    );
    final easedProgress = progress * progress * (3 - 2 * progress);

    // Calculate transforms
    // Highlights move in lockstep with the grid so no empty band opens up
    final highlightTranslateY = -_scrollOffset.clamp(0.0, 280.0);
    final leftSlideOffset = -0.6 * easedProgress;
    final rightSlideOffset = 0.6 * easedProgress;
    final highlightOpacity = (1.0 - progress * progress).clamp(0.0, 1.0);

    return Column(
      children: [
        // Category chips at top
        Container(
          color: AppColors.white,
          padding: EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray300.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            height: 64,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                KioskExitButton(isVisible: isLastCategory),
                SizedBox(width: AppSpacing.sm),
                ...categories.map((category) {
                  final isSelected = category.id == selectedCategory.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = category.id;
                        });
                        // Reset scroll to initial position instantly
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(0);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.black
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.black
                                : AppColors.gray300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: AppTypography.bodyLarge.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.gray900,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Stack: Highlights overlay + Scrollable grid
        Expanded(
          child: Stack(
            children: [
              // Scrollable grid (always visible, scrolls normally)
              Container(
                color: AppColors.background,
                child: GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    featured.isEmpty ? AppSpacing.lg : 280,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isCompactKiosk(context) ? 2.05 : 2.6,
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
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.gray300.withOpacity(0.7),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.md,
                                  AppSpacing.xs,
                                  AppSpacing.sm,
                                  AppSpacing.xs,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      style: AppTypography.h3.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        height: 1.1,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.gray600,
                                        fontSize: 13,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: AppTypography.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                              child: SizedBox(
                                width: isCompactKiosk(context) ? 110 : 150,
                                child: ColoredBox(
                                  color: AppColors.gray300.withOpacity(0.5),
                                  child: product.imageUrl == null
                                      ? Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 40,
                                            color: AppColors.gray600,
                                          ),
                                        )
                                      : Image.network(
                                          product.imageUrl!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                              color: AppColors.gray600,
                                            ),
                                          ),
                                        ),
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

              // Highlights positioned absolutely, transform based on scroll
              if (featured.isNotEmpty && highlightOpacity > 0.01)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, highlightTranslateY),
                    child: Opacity(
                      opacity: highlightOpacity,
                      child: Container(
                        height: 256,
                        padding: EdgeInsets.only(top: AppSpacing.md),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = constraints.maxWidth;
                            final screenCenter = screenWidth / 2;
                            final highlightScrollOffset =
                                _highlightScrollController.hasClients
                                ? _highlightScrollController.offset
                                : 0.0;

                            return ListView.builder(
                              controller: _highlightScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              itemCount: featured.length.clamp(0, 6),
                              itemBuilder: (context, index) {
                                final product = featured.length > index
                                    ? featured[index]
                                    : (products.length > index
                                          ? products[index]
                                          : null);

                                if (product == null) {
                                  return const SizedBox.shrink();
                                }

                                // Calculate box position and width
                                final boxWidth = index == 0 ? 400.0 : 280.0;
                                final boxLeft =
                                    AppSpacing.lg +
                                    (index > 0
                                        ? 400 + 16 + (index - 1) * (280 + 16)
                                        : 0) -
                                    highlightScrollOffset;
                                final boxCenter = boxLeft + (boxWidth / 2);

                                // Determine split direction based on position relative to screen center
                                final slideOffset = boxCenter < screenCenter
                                    ? leftSlideOffset
                                    : rightSlideOffset;

                                return Transform.translate(
                                  offset: Offset(screenWidth * slideOffset, 0),
                                  child: Container(
                                    width: index == 0 ? 400 : 280,
                                    margin: EdgeInsets.only(right: 16),
                                    child: _HighlightTile(
                                      product: product,
                                      title: product.name,
                                      subtitle: product.description,
                                      price: product.price,
                                      imageUrl: product.imageUrl,
                                      big: index == 0,
                                      isTall: false,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                                product: product,
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final dynamic product;
  final String title;
  final String subtitle;
  final double? price;
  final String? imageUrl;
  final bool big;
  final bool isTall;
  final VoidCallback? onTap;

  const _HighlightTile({
    required this.product,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.big,
    this.isTall = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = big ? 220.0 : 220.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              if (imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.gray300.withOpacity(0.3),
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: AppColors.gray500,
                      ),
                    ),
                  ),
                )
              else
                Positioned.fill(
                  child: Container(
                    color: AppColors.gray300.withOpacity(0.3),
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: AppColors.gray500,
                    ),
                  ),
                ),

              // Gradient Overlay for text readability
              if (imageUrl != null)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withOpacity(0.1),
                          AppColors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),

              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: AppTypography.h2.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: big ? 24 : 20,
                          color: imageUrl != null
                              ? AppColors.white
                              : AppColors.black,
                          height: 1.2,
                          shadows: imageUrl != null
                              ? [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: AppColors.black.withOpacity(0.7),
                                  ),
                                ]
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      if (big)
                        Text(
                          subtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: imageUrl != null
                                ? AppColors.white.withOpacity(0.95)
                                : AppColors.gray600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            shadows: imageUrl != null
                                ? [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 6,
                                      color: AppColors.black.withOpacity(0.6),
                                    ),
                                  ]
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          if (price != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: imageUrl != null
                                    ? AppColors.white
                                    : AppColors.black,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '\$${price!.toStringAsFixed(2)}',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: imageUrl != null
                                      ? AppColors.black
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          ],
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
