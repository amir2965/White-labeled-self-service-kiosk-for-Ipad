import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import 'image_editor_dialog.dart';

/// Inline editor for menu item properties
class MenuItemEditor extends StatefulWidget {
  final Product product;
  final Function(Product) onProductUpdated;
  final VoidCallback onDelete;

  const MenuItemEditor({
    super.key,
    required this.product,
    required this.onProductUpdated,
    required this.onDelete,
  });

  @override
  State<MenuItemEditor> createState() => _MenuItemEditorState();
}

class _MenuItemEditorState extends State<MenuItemEditor> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
  }

  @override
  void didUpdateWidget(MenuItemEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _nameController.text = widget.product.name;
      _descriptionController.text = widget.product.description;
      _priceController.text = widget.product.price.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF8F9FA),
      child: Column(
        children: [
          // Header
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
                Icon(Icons.edit, size: 20, color: AppColors.blue),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Edit Item',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                // Delete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  _buildImageSection(),
                  SizedBox(height: AppSpacing.lg),

                  // Name field
                  _buildTextField(
                    label: 'Name',
                    controller: _nameController,
                    icon: Icons.label_outline,
                    onChanged: (value) {
                      _updateProduct(name: value);
                    },
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Description field
                  _buildTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    onChanged: (value) {
                      _updateProduct(description: value);
                    },
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Price field
                  _buildTextField(
                    label: 'Price',
                    controller: _priceController,
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      _updateProduct(price: price);
                    },
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Availability toggle
                  _buildAvailabilityToggle(),
                  SizedBox(height: AppSpacing.lg),

                  // Modifiers section
                  _buildModifiersSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.image_outlined, size: 18, color: AppColors.blue),
                SizedBox(width: 8),
                Text(
                  'Item Image',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Image preview
          GestureDetector(
            onTap: _showImageOptions,
            child: Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.15),
                ),
              ),
              child: widget.product.imageUrl != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            widget.product.imageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          ),
                        ),
                        // Edit overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Change Image',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildImagePlaceholder(),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Image action buttons
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _buildImageButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildImageButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                if (widget.product.imageUrl != null) ...[
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildImageButton(
                      icon: Icons.crop,
                      label: 'Adjust',
                      onTap: _adjustImage,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Tap to add image',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: AppColors.blue),
              SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.blue),
                SizedBox(width: 6),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              border: InputBorder.none,
              hintText: 'Enter $label...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(Icons.visibility_outlined, size: 20, color: AppColors.blue),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  widget.product.isAvailable
                      ? 'Visible to customers'
                      : 'Hidden from menu',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.product.isAvailable,
            onChanged: (value) {
              _updateProduct(isAvailable: value);
            },
            activeColor: AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildModifiersSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.tune, size: 18, color: AppColors.blue),
                SizedBox(width: 8),
                Text(
                  'Modifiers',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _addModifierGroup,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.blue.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14, color: AppColors.blue),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.blue,
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

          if (widget.product.modifierGroups.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Text(
                'No modifiers yet. Add options like size, milk type, or extras.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...widget.product.modifierGroups.map((group) {
              return Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                margin: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${group.modifiers.length} options',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 16),
                      onPressed: () {
                        // Edit modifier group
                      },
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  void _updateProduct({
    String? name,
    String? description,
    double? price,
    bool? isAvailable,
    String? imageUrl,
  }) {
    final updated = Product(
      id: widget.product.id,
      categoryId: widget.product.categoryId,
      name: name ?? widget.product.name,
      description: description ?? widget.product.description,
      price: price ?? widget.product.price,
      isAvailable: isAvailable ?? widget.product.isAvailable,
      imageUrl: imageUrl ?? widget.product.imageUrl,
      modifierGroups: widget.product.modifierGroups,
      sortOrder: widget.product.sortOrder,
    );
    widget.onProductUpdated(updated);
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: AppColors.blue,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined, color: AppColors.blue),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (widget.product.imageUrl != null)
              ListTile(
                leading: Icon(Icons.crop, color: AppColors.blue),
                title: Text('Adjust Position'),
                onTap: () {
                  Navigator.pop(context);
                  _adjustImage();
                },
              ),
            if (widget.product.imageUrl != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Remove Image'),
                onTap: () {
                  Navigator.pop(context);
                  _updateProduct(imageUrl: '');
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // In production, upload to storage and get URL
        // For now, use local path as placeholder
        _updateProduct(imageUrl: image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _adjustImage() {
    if (widget.product.imageUrl == null) return;

    showDialog(
      context: context,
      builder: (context) => ImageEditorDialog(
        imageUrl: widget.product.imageUrl!,
        onSave: (adjustedImageUrl) {
          _updateProduct(imageUrl: adjustedImageUrl);
        },
      ),
    );
  }

  void _addModifierGroup() {
    // Show dialog to add modifier group
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier group editor coming soon')),
    );
  }
}
