import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Restaurant Menu Board
/// Typography-first, minimal menu board with category navigation (no cards).
class RestaurantMenuBoardTemplate extends ConsumerStatefulWidget {
  const RestaurantMenuBoardTemplate({super.key});

  @override
  ConsumerState<RestaurantMenuBoardTemplate> createState() =>
      _RestaurantMenuBoardTemplateState();
}

class _RestaurantMenuBoardTemplateState
    extends ConsumerState<RestaurantMenuBoardTemplate> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryIndex =
        (_selectedCategoryIndex.clamp(0, categories.length - 1) as num).toInt();
    final selectedCategory = categories[_selectedCategoryIndex];
    final products = menuState.getProductsByCategory(selectedCategory.id);
    final isLastCategory = _selectedCategoryIndex == categories.length - 1;

    return Row(
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
              final isSelected = index == _selectedCategoryIndex;

              return _CategoryButton(
                label: category.name,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
              );
            },
          ),
        ),

        // Right menu board list
        Expanded(
          child: Container(
            color: AppColors.background,
            child: Column(
              children: [
                // Fixed category title header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
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
                      Expanded(
                        child: Text(
                          selectedCategory.name,
                          style: AppTypography.h2.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      KioskExitButton(
                        isVisible: isLastCategory,
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: products.isEmpty
                      ? Center(
                          child: Text(
                            'No items in this category yet.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          children: [
                            ...products.map((product) {
                              return _MenuRow(
                                title: product.name,
                                subtitle: product.description,
                                price: product.price,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ProductDetailsScreen(product: product),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final double price;
  final VoidCallback onTap;

  const _MenuRow({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.lg),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray600,
                        fontSize: 18,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppSpacing.xl),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTypography.h3.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.add, color: AppColors.white, size: 28),
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
