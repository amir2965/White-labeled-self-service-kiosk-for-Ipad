import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/entities/product.dart';
import '../providers/menu_provider.dart';
import '../providers/merchant_provider.dart';
import 'widgets/menu_item_editor.dart';
import 'widgets/category_manager.dart';
import 'template_customization_screen.dart';

/// Menu Management Screen - Edit menu items with inline editor
class MenuManagementScreen extends ConsumerStatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  ConsumerState<MenuManagementScreen> createState() =>
      _MenuManagementScreenState();
}

class _MenuManagementScreenState extends ConsumerState<MenuManagementScreen> {
  String? _selectedProductId;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Select first category by default
    Future.microtask(() {
      final menuState = ref.read(menuProvider);
      if (menuState.categories.isNotEmpty) {
        setState(() {
          _selectedCategoryId = menuState.categories.first.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final merchantState = ref.watch(merchantProvider);
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(merchantState.businessName),
          Expanded(
            child: isLandscape
                ? _buildLandscapeLayout(menuState)
                : _buildPortraitLayout(menuState),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String businessName) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.arrow_back, size: 20),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),

            // Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu Management',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  businessName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            Spacer(),

            // Preview button
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TemplateCustomizationScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, size: 18, color: AppColors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Preview',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: AppSpacing.md),

            // Save button
            Material(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _saveChanges,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Save Changes',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Widget _buildLandscapeLayout(MenuState menuState) {
    return Row(
      children: [
        // Left: Menu items grid with categories
        Expanded(flex: 7, child: _buildMenuItemsPanel(menuState)),

        // Divider
        Container(width: 1, color: AppColors.textSecondary.withOpacity(0.1)),

        // Right: Editor panel
        Expanded(flex: 3, child: _buildEditorPanel(menuState)),
      ],
    );
  }

  Widget _buildPortraitLayout(MenuState menuState) {
    return Column(
      children: [
        Expanded(child: _buildMenuItemsPanel(menuState)),
        if (_selectedProductId != null)
          Container(height: 300, child: _buildEditorPanel(menuState)),
      ],
    );
  }

  Widget _buildMenuItemsPanel(MenuState menuState) {
    final categories = menuState.sortedCategories;
    final selectedCategory = _selectedCategoryId != null
        ? categories.firstWhere(
            (c) => c.id == _selectedCategoryId,
            orElse: () => categories.first,
          )
        : (categories.isNotEmpty ? categories.first : null);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Category tabs
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...categories.map((category) {
                          final isSelected = category.id == _selectedCategoryId;
                          final itemCount = menuState
                              .getProductsByCategory(category.id)
                              .length;

                          return Padding(
                            padding: EdgeInsets.only(right: AppSpacing.sm),
                            child: Material(
                              color: isSelected
                                  ? AppColors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                    _selectedProductId = null;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.blue
                                          : AppColors.textSecondary.withOpacity(
                                              0.2,
                                            ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        category.name,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white.withOpacity(0.2)
                                              : AppColors.textSecondary
                                                    .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '$itemCount',
                                          style: AppTypography.caption.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showCategoryManager,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.textSecondary.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.settings, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products grid
          Expanded(
            child: selectedCategory != null
                ? _buildProductsGrid(menuState, selectedCategory)
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(MenuState menuState, Category category) {
    final products = menuState.getProductsByCategory(category.id);

    if (products.isEmpty) {
      return _buildEmptyCategoryState(category);
    }

    return ReorderableGridView.builder(
      padding: EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // A bit wider than tall to further trim empty space under content
        childAspectRatio: 1.3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length + 1, // +1 for add button
      onReorder: (oldIndex, newIndex) {
        _reorderProduct(products, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        // Add new item button
        if (index == products.length) {
          return _buildAddItemCard();
        }

        final product = products[index];
        final isSelected = product.id == _selectedProductId;

        return _buildProductCard(product, isSelected);
      },
    );
  }

  Widget _buildProductCard(Product product, bool isSelected) {
    return Material(
      key: ValueKey(product.id),
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedProductId = product.id;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.blue
                  : AppColors.textSecondary.withOpacity(0.15),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.blue.withOpacity(0.15),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with drag handle
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Container(
                      height: 92,
                      width: double.infinity,
                      color: AppColors.textSecondary.withOpacity(0.05),
                      child: product.imageUrl != null
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),
                  // Drag handle
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.drag_indicator,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Selected indicator
                  if (isSelected)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.description.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          product.description,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                          if (!product.isAvailable)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Hidden',
                                style: AppTypography.caption.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
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

  Widget _buildAddItemCard() {
    return Material(
      key: ValueKey('add_new'),
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _addNewProduct,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.blue.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, size: 32, color: AppColors.blue),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Add Item',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.textSecondary.withOpacity(0.05),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: AppColors.textSecondary.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildEditorPanel(MenuState menuState) {
    if (_selectedProductId == null) {
      return Container(
        color: Color(0xFFF8F9FA),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.3),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Select an item to edit',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final product = menuState.products.firstWhere(
      (p) => p.id == _selectedProductId,
      orElse: () => menuState.products.first,
    );

    return MenuItemEditor(
      product: product,
      onProductUpdated: (updatedProduct) {
        ref.read(menuProvider.notifier).updateProduct(updatedProduct);
      },
      onDelete: () {
        _deleteProduct(product);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No categories yet',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _showCategoryManager,
            icon: Icon(Icons.add),
            label: Text('Add Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategoryState(Category category) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No items in ${category.name}',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _addNewProduct,
            icon: Icon(Icons.add),
            label: Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _reorderProduct(List<Product> products, int oldIndex, int newIndex) {
    // Prevent dropping onto the add button slot
    if (newIndex >= products.length) {
      newIndex = products.length - 1;
    }

    // Skip if no actual movement
    if (oldIndex == newIndex) return;

    ref
        .read(menuProvider.notifier)
        .reorderProducts(products[oldIndex].categoryId, oldIndex, newIndex);
  }

  void _addNewProduct() {
    if (_selectedCategoryId == null) return;

    ref
        .read(menuProvider.notifier)
        .addProduct(
          categoryId: _selectedCategoryId!,
          name: 'New Item',
          price: 0.0,
        );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(menuProvider.notifier).deleteProduct(product.id);
              setState(() {
                _selectedProductId = null;
              });
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCategoryManager() {
    showDialog(context: context, builder: (context) => CategoryManager());
  }

  void _saveChanges() {
    // In production, this would sync to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu changes saved successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
