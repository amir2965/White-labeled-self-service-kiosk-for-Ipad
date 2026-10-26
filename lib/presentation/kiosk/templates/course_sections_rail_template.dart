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

/// Template: Course Sections Rail
/// Restaurant-first browsing: vertical list of sections; each section is a horizontal rail.
class CourseSectionsRailTemplate extends ConsumerStatefulWidget {
  const CourseSectionsRailTemplate({super.key});

  @override
  ConsumerState<CourseSectionsRailTemplate> createState() =>
      _CourseSectionsRailTemplateState();
}

class _CourseSectionsRailTemplateState
    extends ConsumerState<CourseSectionsRailTemplate> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  String? _selectedCategoryId;
  bool _showExitButton = false;

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
    // Show exit button when user has scrolled past a certain point
    // or when last category is in view
    final hasScrolled =
        _scrollController.hasClients && _scrollController.offset > 100;
    if (hasScrolled != _showExitButton) {
      setState(() {
        _showExitButton = hasScrolled;
      });
    }
  }

  void _scrollToCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _categoryKeys[categoryId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    // Initialize to first category if not set
    _selectedCategoryId ??= categories.first.id;

    // Since this is a continuous rail template, show exit button when
    // user scrolls or when last category is selected
    final isLastCategory = categories.last.id == _selectedCategoryId;
    final shouldShowExitButton = _showExitButton || isLastCategory;

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

    // Ensure all categories have keys
    for (final category in categories) {
      _categoryKeys.putIfAbsent(category.id, () => GlobalKey());
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
                      final isSelected = _selectedCategoryId == category.id;
                      return GestureDetector(
                        onTap: () => _scrollToCategory(category.id),
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
              if (shouldShowExitButton) ...[
                SizedBox(width: AppSpacing.md),
                Center(
                  child: KioskExitButton(
                    isVisible: true,
                    size: 28,
                    color: AppColors.black,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: Container(
            color: AppColors.background,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                // Top editorial header
                Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gray300.withOpacity(0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.black, AppColors.gray900],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to Our Menu',
                                style: AppTypography.h2.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Discover our curated selections and explore the full menu. Tap any item to customize your order.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.gray600,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Featured rail (optional)
                if (featured.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.lg,
                    ),
                    child: Text(
                      'Highlights',
                      style: AppTypography.h3.copyWith(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: featured.length.clamp(0, 8),
                      separatorBuilder: (_, __) =>
                          SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final product = featured[index];
                        return _RailCard(
                          product: product,
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
                  SizedBox(height: AppSpacing.xl),
                ],

                // Each category section
                ...categories.map((category) {
                  final products = menuState.getProductsByCategory(category.id);
                  if (products.isEmpty) return const SizedBox.shrink();

                  return Column(
                    key: _categoryKeys[category.id],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                category.name,
                                style: AppTypography.h3.copyWith(fontSize: 20),
                              ),
                            ),
                            Text(
                              '${products.length} items',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.gray600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          itemCount: products.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _RailCard(
                              product: product,
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
                      SizedBox(height: AppSpacing.xl),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RailCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _RailCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 144,
                height: double.infinity,
                child: ColoredBox(
                  color: AppColors.gray300.withOpacity(0.35),
                  child: product.imageUrl == null
                      ? Center(
                          child: Icon(
                            Icons.image,
                            size: 30,
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
                              size: 30,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.h3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                        if (product.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            product.description,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.gray600,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                        fontSize: 20,
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
