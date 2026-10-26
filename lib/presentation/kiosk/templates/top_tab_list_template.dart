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

/// Template 2: Top Tab Navigation with List View
/// Horizontal category tabs at top, product rows with horizontal cards
class TopTabListTemplate extends ConsumerStatefulWidget {
  const TopTabListTemplate({super.key});

  @override
  ConsumerState<TopTabListTemplate> createState() => _TopTabListTemplateState();
}

class _TopTabListTemplateState extends ConsumerState<TopTabListTemplate> {
  int _selectedCategoryIndex = 0;
  bool _isTwoColumnMode = false; // Toggle between 1 and 2 columns
  static const double _rowSpacing = 16.0; // Row spacing for two-column mode

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    final selectedCategory = categories[_selectedCategoryIndex];
    final products = menuState.getProductsByCategory(selectedCategory.id);
    final isLastCategory = _selectedCategoryIndex == categories.length - 1;

    return Column(
      children: [
        // Category Tabs
        Container(
          height: 72,
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
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = index == _selectedCategoryIndex;

                    return _TabButton(
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
              // Hidden exit button - only visible on last category
              KioskExitButton(
                isVisible: isLastCategory,
                padding: const EdgeInsets.all(12),
              ),
              // Column mode toggle
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(
                    _isTwoColumnMode ? Icons.view_agenda : Icons.view_stream,
                    color: AppColors.gray600,
                  ),
                  onPressed: () {
                    setState(() {
                      _isTwoColumnMode = !_isTwoColumnMode;
                    });
                  },
                  tooltip: _isTwoColumnMode ? 'One Column' : 'Two Columns',
                ),
              ),
            ],
          ),
        ),

        // Product List
        Expanded(
          child: Container(
            color: AppColors.background,
            child: products.isEmpty
                ? Center(
                    child: Text(
                      'No products in this category',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  )
                : _isTwoColumnMode
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: List.generate((products.length / 2).ceil(), (
                        rowIndex,
                      ) {
                        final leftIndex = rowIndex * 2;
                        final rightIndex = leftIndex + 1;
                        final hasRight = rightIndex < products.length;

                        return Padding(
                          padding: EdgeInsets.only(top: rowIndex > 0 ? 24 : 0),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _ProductListRow(
                                    product: products[leftIndex],
                                    isCompact: true,
                                  ),
                                ),
                                SizedBox(width: 24),
                                Expanded(
                                  child: hasRight
                                      ? _ProductListRow(
                                          product: products[rightIndex],
                                          isCompact: true,
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: products
                          .map(
                            (product) => _ProductListRow(
                              product: product,
                              isCompact: false,
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Animated wrapper for product items with minimal fade-in effect
class _AnimatedProductItem extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedProductItem({required this.child, required this.index});

  @override
  State<_AnimatedProductItem> createState() => _AnimatedProductItemState();
}

class _AnimatedProductItemState extends State<_AnimatedProductItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 40), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

/// Tab button for top navigation
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.blue : AppColors.gray600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

/// Product row for list template
class _ProductListRow extends ConsumerWidget {
  final Product product;
  final bool isCompact;

  const _ProductListRow({required this.product, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = isCompact
        ? double.infinity
        : (screenWidth * 0.7).clamp(600.0, 900.0);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => ProductDetailsScreen(product: product),
            );
          },
          child: Container(
            height: isCompact ? 180 : 140,
            margin: EdgeInsets.only(bottom: isCompact ? 0 : 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product Image
                if (product.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(7),
                    ),
                    child: SizedBox(
                      height: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) {
                            return Container(
                              color: AppColors.gray200,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.gray500,
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                // Product Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 20 : 20,
                      vertical: isCompact ? 20 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: isCompact ? 24 : 22,
                            height: 1.25,
                          ),
                          maxLines: isCompact ? 2 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        if (product.description.isNotEmpty && !isCompact)
                          Text(
                            product.description,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 16,
                              color: AppColors.gray600,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),

                // Price
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 20 : 20,
                    vertical: isCompact ? 20 : 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isCompact ? 26 : 24,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
