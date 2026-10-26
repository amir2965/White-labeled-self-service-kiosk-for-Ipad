import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';

/// Template: Course Sections Rail
/// Modern retail-style browsing with rails/sliders for each category, allowing multiple rows
class CourseSectionsRetail1Template extends ConsumerStatefulWidget {
  const CourseSectionsRetail1Template({super.key});

  @override
  ConsumerState<CourseSectionsRetail1Template> createState() =>
      _CourseSectionsRetail1TemplateState();
}

class _CourseSectionsRetail1TemplateState
    extends ConsumerState<CourseSectionsRetail1Template> {
  String? _selectedCategoryId;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
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

    final products = menuState.getProductsByCategory(selectedCategory.id);

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
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.black : AppColors.gray300,
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
                        color: isSelected ? AppColors.white : AppColors.gray700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Scrollable content with welcome message and rail layouts
        Expanded(
          child: Container(
            color: AppColors.background,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                // Welcome message
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

                // Category title
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Text(
                    selectedCategory.name,
                    style: AppTypography.h2.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                // Product rails with multi-row layout
                _buildProductRails(products),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductRails(List products) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'No items in this category',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray600),
          ),
        ),
      );
    }

    // Calculate optimal rows based on item count
    // Show up to 6 items per row, with multiple rows if needed
    const itemsPerRow = 6;
    final rowCount = (products.length / itemsPerRow).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rowCount, (rowIndex) {
        final startIndex = rowIndex * itemsPerRow;
        final endIndex = (startIndex + itemsPerRow).clamp(0, products.length);
        final rowProducts = products.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
          child: SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: rowProducts.length,
              separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final product = rowProducts[index];
                return _ProductCard(product: product);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ProductDetailsScreen(product: product),
            );
          },
          child: Container(
            width: 400,
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
                    width: 160,
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
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (product.description.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
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
      },
    );
  }
}
