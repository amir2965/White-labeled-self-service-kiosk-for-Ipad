import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template 4: Dense Information Grid
/// Maximum information density with category filters at top
class DenseGridTemplate extends ConsumerStatefulWidget {
  const DenseGridTemplate({super.key});

  @override
  ConsumerState<DenseGridTemplate> createState() => _DenseGridTemplateState();
}

class _DenseGridTemplateState extends ConsumerState<DenseGridTemplate> {
  String? _selectedCategoryId; // null = "All"

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;
    final allProducts = menuState.products;

    // Filter products by category
    final products = _selectedCategoryId == null
        ? allProducts
        : menuState.getProductsByCategory(_selectedCategoryId!);

    // Check if this is the last category for exit button
    final isLastCategory =
        _selectedCategoryId != null &&
        categories.isNotEmpty &&
        categories.last.id == _selectedCategoryId;

    return Column(
      children: [
        // Category Filter Chips
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.gray300, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              KioskExitButton(isVisible: isLastCategory),
              SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: 'All',
                isSelected: _selectedCategoryId == null,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = null;
                  });
                },
              ),
              ...categories.map((category) {
                return _FilterChip(
                  label: category.name,
                  isSelected: _selectedCategoryId == category.id,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                );
              }),
            ],
          ),
        ),

        // Dense Product Grid
        Expanded(
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.all(20),
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'No products available',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getGridColumns(context),
                      childAspectRatio: 1.125, // 180×160 cards
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _DenseProductCard(product: products[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  int _getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1500) return 5;
    if (width > 1200) return 4;
    return 3;
  }
}

/// Filter chip for category selection
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue : AppColors.white,
            border: Border.all(
              color: isSelected ? AppColors.blue : AppColors.gray300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.white : AppColors.gray600,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: isSelected ? AppColors.white : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dense product card (text-only, compact)
class _DenseProductCard extends ConsumerWidget {
  final Product product;

  const _DenseProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get modifier summary
    final modifierSummary = _getModifierSummary(product);

    return GestureDetector(
      onTap: () {
        if (product.modifierGroups.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ProductDetailsScreen(product: product),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.black,
                      ),
                    ),
                    if (modifierSummary.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        modifierSummary,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.gray600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Add Button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    if (product.modifierGroups.isEmpty) {
                      ref
                          .read(cartProvider.notifier)
                          .addItem(
                            product: product,
                            modifiers: [],
                            quantity: 1,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.black,
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModifierSummary(Product product) {
    if (product.modifierGroups.isEmpty) return '';

    final summaryParts = <String>[];
    for (final group in product.modifierGroups) {
      if (group.modifiers.length <= 3) {
        summaryParts.add(group.modifiers.map((m) => m.name).join('/'));
      } else {
        summaryParts.add('${group.name}');
      }
    }

    return summaryParts.join(' • ');
  }
}
