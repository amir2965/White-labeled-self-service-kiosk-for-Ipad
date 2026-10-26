import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class MenuOrderManager extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(List<Map<String, dynamic>>) onSave;

  const MenuOrderManager({
    super.key,
    required this.products,
    required this.onSave,
  });

  @override
  State<MenuOrderManager> createState() => _MenuOrderManagerState();
}

class _MenuOrderManagerState extends State<MenuOrderManager> {
  late List<String> _categoryOrder;
  late Map<String, List<Map<String, dynamic>>> _productsByCategory;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  String? _activeCategory;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(String category) {
    setState(() {
      _activeCategory = category;
    });

    final key = _categoryKeys[category];
    if (key != null) {
      // First, try to scroll using ensureVisible if context exists
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // If context doesn't exist yet (item not built), scroll by index
        final categoryIndex = _categoryOrder.indexOf(category);
        if (categoryIndex != -1 && _scrollController.hasClients) {
          // Calculate more accurate estimated position
          final estimatedPosition = categoryIndex * 250.0;
          final maxScroll = _scrollController.position.maxScrollExtent;
          final targetPosition = estimatedPosition > maxScroll
              ? maxScroll
              : estimatedPosition;

          _scrollController
              .animateTo(
                targetPosition,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
              .then((_) {
                // After scrolling, wait for build, then try ensureVisible
                Future.delayed(Duration(milliseconds: 100), () {
                  if (key.currentContext != null) {
                    Scrollable.ensureVisible(
                      key.currentContext!,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      alignment: 0.0, // Top of viewport
                    );
                  }
                });
              });
        }
      }
    }
  }

  void _initializeData() {
    // Group products by category
    _productsByCategory = {};
    for (var product in widget.products) {
      final category = product['category'] ?? 'Other';
      _productsByCategory.putIfAbsent(category, () => []);
      _productsByCategory[category]!.add(product);
    }

    // Get category order
    _categoryOrder = _productsByCategory.keys.toList();

    // Initialize GlobalKeys for all categories upfront
    _categoryKeys.clear();
    for (var category in _categoryOrder) {
      _categoryKeys[category] = GlobalKey();
    }
  }

  void _save() {
    // Rebuild products list in the new order
    final orderedProducts = <Map<String, dynamic>>[];
    for (var category in _categoryOrder) {
      orderedProducts.addAll(_productsByCategory[category]!);
    }
    widget.onSave(orderedProducts);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 900,
        constraints: BoxConstraints(maxHeight: 800),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.reorder, color: Colors.white, size: 28),
                  SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organize Menu',
                        style: AppTypography.h3.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Drag to reorder categories and items',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Row(
                children: [
                  // Categories sidebar
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.gray200),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 20,
                                color: AppColors.gray600,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Categories',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1),
                        Expanded(
                          child: ReorderableListView(
                            padding: EdgeInsets.all(AppSpacing.sm),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex--;
                                final item = _categoryOrder.removeAt(oldIndex);
                                _categoryOrder.insert(newIndex, item);
                              });
                            },
                            children: _categoryOrder.map((category) {
                              final products = _productsByCategory[category]!;
                              final isActive = _activeCategory == category;
                              return Container(
                                key: ValueKey(category),
                                margin: EdgeInsets.only(bottom: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Color(0xFF10B981).withOpacity(0.08)
                                      : AppColors.gray50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isActive
                                        ? Color(0xFF10B981)
                                        : AppColors.gray200,
                                    width: isActive ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Active indicator bar
                                    if (isActive)
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 4,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF10B981),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () =>
                                            _scrollToCategory(category),
                                        child: ListTile(
                                          dense: true,
                                          leading: Icon(
                                            Icons.drag_indicator,
                                            color: isActive
                                                ? Color(0xFF10B981)
                                                : AppColors.gray600,
                                          ),
                                          title: Text(
                                            category,
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: isActive
                                                      ? Color(0xFF10B981)
                                                      : null,
                                                ),
                                          ),
                                          subtitle: Text(
                                            '${products.length} items',
                                            style: AppTypography.bodySmall
                                                .copyWith(
                                                  color: isActive
                                                      ? Color(
                                                          0xFF10B981,
                                                        ).withOpacity(0.8)
                                                      : null,
                                                ),
                                          ),
                                          trailing: Icon(
                                            Icons.chevron_right,
                                            color: isActive
                                                ? Color(0xFF10B981)
                                                : AppColors.gray600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Products list
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 20,
                                color: AppColors.gray600,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'All Items',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(AppSpacing.md),
                            itemCount: _categoryOrder.length,
                            itemBuilder: (context, categoryIndex) {
                              final category = _categoryOrder[categoryIndex];
                              final products = _productsByCategory[category]!;

                              return Container(
                                key: _categoryKeys[category],
                                margin: EdgeInsets.only(bottom: AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category header
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _activeCategory == category
                                            ? Color(
                                                0xFF10B981,
                                              ).withOpacity(0.08)
                                            : AppColors.blue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                        border: _activeCategory == category
                                            ? Border.all(
                                                color: Color(0xFF10B981),
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.category,
                                            size: 18,
                                            color: _activeCategory == category
                                                ? Color(0xFF10B981)
                                                : AppColors.blue,
                                          ),
                                          SizedBox(width: AppSpacing.xs),
                                          Text(
                                            category,
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      _activeCategory ==
                                                          category
                                                      ? Color(0xFF10B981)
                                                      : AppColors.blue,
                                                ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${products.length} items',
                                            style: AppTypography.bodySmall
                                                .copyWith(
                                                  color:
                                                      _activeCategory ==
                                                          category
                                                      ? Color(0xFF10B981)
                                                      : AppColors.blue,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.sm),

                                    // Products in category
                                    ReorderableListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: products.length,
                                      onReorder: (oldIndex, newIndex) {
                                        setState(() {
                                          if (newIndex > oldIndex) newIndex--;
                                          final item = products.removeAt(
                                            oldIndex,
                                          );
                                          products.insert(newIndex, item);
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        final product = products[index];
                                        return Container(
                                          key: ValueKey(
                                            '${category}_${product['name']}_$index',
                                          ),
                                          margin: EdgeInsets.only(
                                            bottom: AppSpacing.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: AppColors.gray200,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.02,
                                                ),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: () {},
                                              child: ListTile(
                                                dense: true,
                                                leading: Container(
                                                  width: 40,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.drag_indicator,
                                                        color:
                                                            AppColors.gray400,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Container(
                                                        width: 4,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.blue,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                2,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                title: Text(
                                                  product['name'] ?? '',
                                                  style:
                                                      AppTypography.bodyMedium,
                                                ),
                                                subtitle: Text(
                                                  '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                                                  style: AppTypography.bodySmall
                                                      .copyWith(
                                                        color:
                                                            AppColors.gray600,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.gray200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      variant: AppButtonVariant.outline,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: 'Save Order',
                      onPressed: _save,
                      variant: AppButtonVariant.filled,
                      icon: Icons.check,
                    ),
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
