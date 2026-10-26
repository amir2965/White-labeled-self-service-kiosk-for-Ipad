import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import '../../../domain/entities/modifier.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';
import 'cart_sidebar_panel.dart';

/// Template: Coffee Order Pad + Cart
/// Adaptive layout with smart order pad visibility:
/// - Order pad shows for beverage categories (Coffee, Tea, Drinks, etc.)
/// - Order pad hides for food categories (no customization needed)
/// - Grid layout adjusts columns based on available space
/// Center: responsive browse grid. Right: cart sidebar.
class CoffeeOrderPadWithCartTemplate extends ConsumerStatefulWidget {
  const CoffeeOrderPadWithCartTemplate({super.key});

  @override
  ConsumerState<CoffeeOrderPadWithCartTemplate> createState() =>
      _CoffeeOrderPadWithCartTemplateState();
}

class _CoffeeOrderPadWithCartTemplateState
    extends ConsumerState<CoffeeOrderPadWithCartTemplate> {
  String? _selectedCategoryId;

  int _tempIndex = 0;
  int _sizeIndex = 1;
  int _milkIndex = 0;

  // Size price adjustments
  static const Map<String, double> _sizePrices = {
    'S': 0.0,
    'M': 0.50,
    'L': 1.0,
  };

  // Categories that should show the order pad
  bool _shouldShowOrderPad(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    return lowerName.contains('coffee') ||
        lowerName.contains('beverage') ||
        lowerName.contains('drink') ||
        lowerName.contains('tea') ||
        lowerName.contains('smoothie') ||
        lowerName.contains('juice');
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

    final selectedProducts = menuState.getProductsByCategory(
      _selectedCategoryId!,
    );

    final showOrderPad = _shouldShowOrderPad(selectedCategory.name);
    final isLastCategory = categories.last.id == _selectedCategoryId;

    return LandscapeOnlyGuard(
      templateName: 'Coffee Order Pad + Cart',
      child: Column(
        children: [
          // Full-width category navigation bar at top
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.gray300, width: 1),
              ),
            ),
            child: Stack(
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category.id == _selectedCategoryId;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: AppSpacing.md,
                        top: 12,
                        bottom: 12,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.black
                                : AppColors.white,
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
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

          // Content row (order pad + main area + cart)
          Expanded(
            child: Row(
              children: [
                // Order Pad (conditionally shown)
                if (showOrderPad)
                  Container(
                    width: 380,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        right: BorderSide(color: AppColors.gray300, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Customize',
                                style: AppTypography.h2.copyWith(fontSize: 22),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Set preferences before adding items to cart.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            0,
                            AppSpacing.lg,
                            AppSpacing.md,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ToggleGroup(
                                label: 'Temp',
                                options: const ['Hot', 'Iced'],
                                selectedIndex: _tempIndex,
                                onSelected: (i) =>
                                    setState(() => _tempIndex = i),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              _ToggleGroup(
                                label: 'Size',
                                options: const ['S', 'M', 'L'],
                                prices: const [0.0, 0.50, 1.0],
                                selectedIndex: _sizeIndex,
                                onSelected: (i) =>
                                    setState(() => _sizeIndex = i),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              _ToggleGroup(
                                label: 'Milk',
                                options: const ['Whole', 'Oat', 'Almond'],
                                selectedIndex: _milkIndex,
                                onSelected: (i) =>
                                    setState(() => _milkIndex = i),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),

                // Main content area with fixed header
                Expanded(
                  child: Column(
                    children: [
                      // Fixed category title header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
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
                            Text(
                              selectedCategory.name,
                              style: AppTypography.h3.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grid with products
                      Expanded(
                        child: Container(
                          color: AppColors.background,
                          child: GridView.builder(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _columnsForWidth(
                                    context,
                                    showOrderPad,
                                  ),
                                  childAspectRatio: 0.95,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: selectedProducts.length,
                            itemBuilder: (context, index) {
                              return _CoffeeBrowseCard(
                                product: selectedProducts[index],
                                tempOption: showOrderPad
                                    ? const ['Hot', 'Iced'][_tempIndex]
                                    : '',
                                sizeOption: showOrderPad
                                    ? const ['S', 'M', 'L'][_sizeIndex]
                                    : '',
                                milkOption: showOrderPad
                                    ? const [
                                        'Whole',
                                        'Oat',
                                        'Almond',
                                      ][_milkIndex]
                                    : '',
                                sizePriceAdjustment: showOrderPad
                                    ? const [0.0, 0.50, 1.0][_sizeIndex]
                                    : 0.0,
                                applyCustomization: showOrderPad,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const CartSidebarPanel(width: 360),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _columnsForWidth(BuildContext context, bool showOrderPad) {
    final width = MediaQuery.of(context).size.width;
    // Adjust column count based on available space
    if (showOrderPad) {
      // Less space available with order pad
      if (width > 1800) return 4;
      if (width > 1400) return 3;
      return 2;
    } else {
      // More space without order pad
      if (width > 1600) return 5;
      if (width > 1200) return 4;
      if (width > 900) return 3;
      return 2;
    }
  }
}

class _ToggleGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<double>? prices;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ToggleGroup({
    required this.label,
    required this.options,
    this.prices,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray300.withOpacity(0.8)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray600,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(options.length, (index) {
                final isSelected = index == selectedIndex;
                final price = prices != null && index < prices!.length
                    ? prices![index]
                    : null;
                final showPrice = price != null && price > 0;

                return GestureDetector(
                  onTap: () => onSelected(index),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
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
                        child: Text(
                          options[index],
                          style: AppTypography.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.gray900,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (showPrice)
                        Positioned(
                          top: -8,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+\$${price.toStringAsFixed(2)}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoffeeBrowseCard extends ConsumerWidget {
  final Product product;
  final String tempOption;
  final String sizeOption;
  final String milkOption;
  final double sizePriceAdjustment;
  final bool applyCustomization;

  const _CoffeeBrowseCard({
    required this.product,
    required this.tempOption,
    required this.sizeOption,
    required this.milkOption,
    required this.sizePriceAdjustment,
    required this.applyCustomization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adjustedPrice = product.price + sizePriceAdjustment;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsScreen(product: product),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxHeight < 140 || constraints.maxWidth < 160;

          // Enhanced sizing for better elderly readability
          final padding = isCompact
              ? EdgeInsets.all(AppSpacing.md)
              : applyCustomization
              ? EdgeInsets.all(AppSpacing.lg)
              : EdgeInsets.all(
                  AppSpacing.xl,
                ); // More padding for non-customization

          final titleMaxLines = isCompact ? 2 : 3;
          final showDescription =
              !isCompact && product.description.trim().isNotEmpty;

          // Larger button for better tap target
          final buttonSize = isCompact
              ? 44.0
              : applyCustomization
              ? 48.0
              : 56.0;

          // Enhanced typography for elderly readability
          final titleStyle = isCompact
              ? AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  height: 1.3,
                )
              : applyCustomization
              ? AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  height: 1.3,
                )
              : AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  height: 1.3,
                );

          final priceStyle = isCompact
              ? AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                )
              : applyCustomization
              ? AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                )
              : AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                );

          final descriptionStyle = isCompact
              ? AppTypography.bodySmall.copyWith(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 1.4,
                )
              : applyCustomization
              ? AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.4,
                )
              : AppTypography.bodyLarge.copyWith(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.4,
                );

          return Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray300.withOpacity(0.7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: titleStyle,
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showDescription) ...[
                  SizedBox(
                    height: applyCustomization ? AppSpacing.xs : AppSpacing.sm,
                  ),
                  Text(
                    product.description,
                    style: descriptionStyle,
                    maxLines: applyCustomization ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: priceStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () {
                          if (applyCustomization) {
                            // Create modifiers list for size pricing
                            final modifiers = <SelectedModifier>[];
                            if (sizePriceAdjustment > 0) {
                              modifiers.add(
                                SelectedModifier(
                                  modifierGroupId: 'size',
                                  modifierGroupName: 'Size',
                                  modifier: Modifier(
                                    id: 'size_$sizeOption',
                                    name: 'Size: $sizeOption',
                                    priceAdjustment: sizePriceAdjustment,
                                  ),
                                ),
                              );
                            }
                            // Add customization note to product
                            final customNote =
                                '$tempOption, $sizeOption, $milkOption';
                            ref
                                .read(cartProvider.notifier)
                                .addItem(
                                  product: product,
                                  modifiers: modifiers,
                                  notes: customNote,
                                );
                          } else {
                            // Open customization window for non-beverage items
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Icon(
                          Icons.add,
                          size: isCompact
                              ? 22
                              : applyCustomization
                              ? 26
                              : 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
