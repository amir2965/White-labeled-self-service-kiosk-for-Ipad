import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';

/// Dialog for managing categories (add, edit, delete, reorder)
class CategoryManager extends ConsumerStatefulWidget {
  const CategoryManager({super.key});

  @override
  ConsumerState<CategoryManager> createState() => _CategoryManagerState();
}

class _CategoryManagerState extends ConsumerState<CategoryManager> {
  final TextEditingController _nameController = TextEditingController();
  String? _editingCategoryId;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(AppSpacing.xl),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.category_outlined, color: AppColors.blue),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Manage Categories',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Add category form
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'New category name...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: _addCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 6),
                        Text('Add'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Categories list
            Expanded(
              child: categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'No categories yet',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ReorderableListView.builder(
                      padding: EdgeInsets.all(AppSpacing.md),
                      itemCount: categories.length,
                      onReorder: (oldIndex, newIndex) {
                        ref
                            .read(menuProvider.notifier)
                            .reorderCategories(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final itemCount = menuState
                            .getProductsByCategory(category.id)
                            .length;

                        return Container(
                          key: ValueKey(category.id),
                          margin: EdgeInsets.only(bottom: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.drag_indicator,
                              color: AppColors.textSecondary,
                            ),
                            title: Text(
                              category.name,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit_outlined, size: 18),
                                  onPressed: () => _editCategory(category),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCategory(category),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCategory() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    ref.read(menuProvider.notifier).addCategory(name);
    _nameController.clear();
  }

  void _editCategory(category) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: category.name);
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  ref
                      .read(menuProvider.notifier)
                      .updateCategory(category.id, newName);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(category) {
    final menuState = ref.read(menuProvider);
    final itemCount = menuState.getProductsByCategory(category.id).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text(
          itemCount > 0
              ? 'This category has $itemCount item(s). Deleting it will also remove all items in this category. Continue?'
              : 'Are you sure you want to delete "${category.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(menuProvider.notifier).deleteCategory(category.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
