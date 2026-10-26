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

/// Template: Coffee Tiles
/// Coffee-first layout: large drink tiles + preference chips + compact browse grid.
class CoffeeTilesTemplate extends ConsumerStatefulWidget {
  const CoffeeTilesTemplate({super.key});

  @override
  ConsumerState<CoffeeTilesTemplate> createState() =>
      _CoffeeTilesTemplateState();
}

class _CoffeeTilesTemplateState extends ConsumerState<CoffeeTilesTemplate> {
  String? _selectedCategoryId;
  String? _selectedPreference;

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
    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    // Check if this is the last category for exit button
    final isLastCategory = categories.last.id == selectedCategory.id;

    final products = menuState.getProductsByCategory(selectedCategory.id);
    final filteredProducts = _filterProducts(products, _selectedPreference);

    final tiles = featured.isNotEmpty
        ? featured.take(6).toList()
        : products.take(6).toList();

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Top header + preference chips
          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    KioskExitButton(isVisible: isLastCategory),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Coffee',
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
                        ),
                      ),
                      child: Text(
                        'Fast tiles',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Tap any tile to customize',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _PrefPill(
                      label: 'Hot',
                      isSelected: _selectedPreference == 'Hot',
                      onTap: () {
                        setState(() {
                          _selectedPreference = _selectedPreference == 'Hot'
                              ? null
                              : 'Hot';
                        });
                      },
                    ),
                    _PrefPill(
                      label: 'Iced',
                      isSelected: _selectedPreference == 'Iced',
                      onTap: () {
                        setState(() {
                          _selectedPreference = _selectedPreference == 'Iced'
                              ? null
                              : 'Iced';
                        });
                      },
                    ),
                    _PrefPill(
                      label: 'Oat Milk',
                      isSelected: _selectedPreference == 'Oat Milk',
                      onTap: () {
                        setState(() {
                          _selectedPreference =
                              _selectedPreference == 'Oat Milk'
                              ? null
                              : 'Oat Milk';
                        });
                      },
                    ),
                    _PrefPill(
                      label: 'Extra Shot',
                      isSelected: _selectedPreference == 'Extra Shot',
                      onTap: () {
                        setState(() {
                          _selectedPreference =
                              _selectedPreference == 'Extra Shot'
                              ? null
                              : 'Extra Shot';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tiles
          Container(
            color: AppColors.background,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final product = tiles[index];
                return _TileCard(
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

          // Category chips + compact grid
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(color: AppColors.gray300, width: 1),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...categories.map((category) {
                  final isSelected = category.id == selectedCategory.id;
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
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.black
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.black
                                : AppColors.gray300,
                          ),
                        ),
                        child: Text(
                          category.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _CompactCard(
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
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterProducts(List<dynamic> products, String? preference) {
    if (preference == null) return products;

    return products.where((product) {
      final name = product.name.toLowerCase();
      final description = product.description.toLowerCase();
      final combined = '$name $description';

      switch (preference) {
        case 'Hot':
          return !combined.contains('iced') &&
              !combined.contains('cold') &&
              !combined.contains('nitro');
        case 'Iced':
          return combined.contains('iced') ||
              combined.contains('cold') ||
              combined.contains('nitro');
        case 'Oat Milk':
          return combined.contains('oat');
        case 'Extra Shot':
          return combined.contains('shot') || combined.contains('espresso');
        default:
          return true;
      }
    }).toList();
  }
}

class _PrefPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrefPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.gray300,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.white : AppColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;

  const _TileCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: double.infinity,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.gray300.withOpacity(0.3),
                          child: Icon(
                            Icons.coffee,
                            size: 32,
                            color: AppColors.gray600,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.gray300.withOpacity(0.3),
                        child: Icon(
                          Icons.coffee,
                          size: 32,
                          color: AppColors.gray600,
                        ),
                      ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.2,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Price badge
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
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

class _CompactCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;

  const _CompactCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.gray300.withOpacity(0.3),
                          child: Icon(
                            Icons.coffee,
                            size: 36,
                            color: AppColors.gray500,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.gray300.withOpacity(0.3),
                        child: Icon(
                          Icons.coffee,
                          size: 36,
                          color: AppColors.gray500,
                        ),
                      ),
              ),
              // Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
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
      ),
    );
  }
}
