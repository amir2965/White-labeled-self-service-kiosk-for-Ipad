import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../../providers/merchant_provider.dart';

/// Live preview panel showing selected template with menu items
class TemplatePreviewPanel extends ConsumerWidget {
  final String? selectedProductId;
  final Function(String) onProductTap;

  const TemplatePreviewPanel({
    super.key,
    this.selectedProductId,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProvider);
    final merchantState = ref.watch(merchantProvider);
    final templateType = merchantState.menuDisplayTemplate;

    return Container(
      color: Color(0xFFF8F9FA),
      child: Column(
        children: [
          // Preview header
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.preview, size: 18, color: AppColors.blue),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Live Preview',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getTemplateName(templateType),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scaled preview
          Expanded(
            child: Container(
              margin: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Transform.scale(
                  scale: 0.7,
                  child: _buildTemplatePreview(
                    context,
                    menuState,
                    merchantState,
                  ),
                ),
              ),
            ),
          ),

          // Info footer
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Click items in preview to select and edit',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatePreview(
    BuildContext context,
    MenuState menuState,
    MerchantState merchantState,
  ) {
    final categories = menuState.sortedCategories;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Mock nav bar
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  merchantState.businessName,
                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700),
                ),
                Spacer(),
                Icon(Icons.shopping_cart_outlined, size: 24),
              ],
            ),
          ),

          // Category tabs
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.1),
                ),
              ),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isFirst = index == 0;

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isFirst ? AppColors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category.name,
                    style: AppTypography.bodySmall.copyWith(
                      color: isFirst ? Colors.white : AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),

          // Products preview
          Expanded(
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      'No items to preview',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : _buildProductsPreview(menuState, categories.first),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsPreview(MenuState menuState, category) {
    final products = menuState
        .getProductsByCategory(category.id)
        .take(6)
        .toList();

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isSelected = product.id == selectedProductId;

        return GestureDetector(
          onTap: () => onProductTap(product.id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.blue
                    : AppColors.textSecondary.withOpacity(0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.05),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(11),
                      ),
                    ),
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              color: AppColors.textSecondary.withOpacity(0.3),
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),
                  ),
                ),
                // Info
                Padding(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
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
    );
  }

  String _getTemplateName(templateType) {
    // Map enum to display name
    return templateType?.toString().split('.').last ?? 'Default';
  }
}
