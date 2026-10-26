import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Coffee Quick Order
/// Split screen: left "Quick order" rail + right "Explore" grid.
class CoffeeQuickOrderTemplate extends ConsumerStatefulWidget {
  const CoffeeQuickOrderTemplate({super.key});

  @override
  ConsumerState<CoffeeQuickOrderTemplate> createState() =>
      _CoffeeQuickOrderTemplateState();
}

class _CoffeeQuickOrderTemplateState
    extends ConsumerState<CoffeeQuickOrderTemplate> {
  String? _selectedCategoryId;
  String? _selectedQuickFilter;

  static const List<String> _quickFilters = <String>['Hot', 'Iced', 'Oat Milk'];

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final selectedProducts = menuState.getProductsByCategory(
      _selectedCategoryId!,
    );
    final isLastCategory = categories.last.id == _selectedCategoryId;

    final quickOrderItems = menuState.products
        .where((p) => p.isAvailable)
        .where((p) => _matchesQuickFilter(p, _selectedQuickFilter))
        .toList(growable: false);

    return Row(
      children: [
        // Left quick order rail
        Container(
          width: 420,
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
                      'Quick Order',
                      style: AppTypography.h2.copyWith(fontSize: 22),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Fast add for common items. Tap others to customize.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              // "Preference" chips (visual)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _quickFilters
                      .map(
                        (label) => _Pill(
                          label: label,
                          isSelected: _selectedQuickFilter == label,
                          onTap: () {
                            setState(() {
                              _selectedQuickFilter =
                                  _selectedQuickFilter == label ? null : label;
                            });
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  itemCount: quickOrderItems.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return _QuickRow(product: quickOrderItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),

        // Right explore
        Expanded(
          child: Column(
            children: [
              // Categories as minimal top tabs
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
                        final isSelected = _selectedCategoryId == category.id;
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
                                horizontal: 22,
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
                                  fontWeight: FontWeight.w600,
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

              Expanded(
                child: Container(
                  color: AppColors.background,
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _columnsForWidth(context),
                      childAspectRatio: 1.15,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: selectedProducts.length,
                    itemBuilder: (context, index) {
                      return _CoffeeCard(product: selectedProducts[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _columnsForWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1500) return 4;
    if (width > 1200) return 3;
    return 2;
  }

  bool _matchesQuickFilter(Product product, String? filter) {
    if (filter == null) return true;

    final name = product.name.toLowerCase();
    final description = product.description.toLowerCase();
    final combined = '$name $description';

    bool hasModifierNamed(String query) {
      final q = query.toLowerCase();
      for (final group in product.modifierGroups) {
        if (group.name.toLowerCase().contains(q)) return true;
        for (final modifier in group.modifiers) {
          if (modifier.name.toLowerCase().contains(q)) return true;
        }
      }
      return false;
    }

    switch (filter) {
      case 'Hot':
        return !combined.contains('iced') &&
            !combined.contains('cold') &&
            !combined.contains('nitro');
      case 'Iced':
        return combined.contains('iced') ||
            combined.contains('cold') ||
            combined.contains('nitro');
      case 'Oat Milk':
        return combined.contains('oat') || hasModifierNamed('oat');
      default:
        return true;
    }
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.black
              : AppColors.gray300.withOpacity(0.25),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.gray300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.white : AppColors.gray900,
          ),
        ),
      ),
    );
  }
}

class _QuickRow extends ConsumerWidget {
  final Product product;

  const _QuickRow({required this.product});

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
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray300, width: 1),
              ),
              child: Icon(Icons.local_cafe, color: AppColors.gray600),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (product.modifierGroups.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    );
                  } else {
                    ref.read(cartProvider.notifier).addItem(product: product);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: AppColors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoffeeCard extends ConsumerWidget {
  final Product product;

  const _CoffeeCard({required this.product});

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
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.7),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: product.imageUrl == null
                    ? Container(
                        color: AppColors.gray300.withOpacity(0.4),
                        child: Icon(Icons.image, color: AppColors.gray600),
                      )
                    : Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.gray300.withOpacity(0.4),
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.gray600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.gray300.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.add, color: AppColors.gray900),
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
