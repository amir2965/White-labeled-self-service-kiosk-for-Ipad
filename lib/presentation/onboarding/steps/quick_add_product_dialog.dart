import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';

/// Quick Add Product Dialog - Simplified, peaceful UI for fast manual entry
class QuickAddProductDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback? onCancel;
  final List<String> existingCategories;
  final Map<String, dynamic>? template;

  const QuickAddProductDialog({
    super.key,
    required this.onSave,
    this.onCancel,
    this.existingCategories = const [],
    this.template,
  });

  @override
  State<QuickAddProductDialog> createState() => _QuickAddProductDialogState();
}

class _QuickAddProductDialogState extends State<QuickAddProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _categoryFocus = FocusNode();

  // Store initial screen dimensions to prevent dialog resize when keyboard appears
  double? _initialScreenHeight;
  double? _initialScreenWidth;

  // Scroll controller for auto-scroll behavior
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for field positioning
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _priceKey = GlobalKey();
  final GlobalKey _categoryKey = GlobalKey();

  bool _addAnother = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.template?['name'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.template?['price']?.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.template?['category'] ?? '',
    );
    _selectedCategory = widget.template?['category'];

    // Add focus listeners for auto-scroll
    _nameFocus.addListener(() => _onFocusChange(_nameKey));
    _priceFocus.addListener(() => _onFocusChange(_priceKey));
    _categoryFocus.addListener(() => _onFocusChange(_categoryKey));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _nameFocus.dispose();
    _priceFocus.dispose();
    _categoryFocus.dispose();
    super.dispose();
  }

  // Auto-scroll to field when focused, positioning it above keyboard
  void _onFocusChange(GlobalKey fieldKey) {
    // Delay to allow keyboard animation
    Future.delayed(Duration(milliseconds: 100), () {
      if (!mounted || !_scrollController.hasClients) return;

      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      final RenderBox? renderBox =
          fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      // Get field position relative to the entire screen
      final position = renderBox.localToGlobal(Offset.zero);
      final fieldHeight = renderBox.size.height;

      // Calculate visible area (dialog height minus keyboard)
      final screenHeight =
          _initialScreenHeight ?? MediaQuery.of(context).size.height;

      // Header height is approximately 72px (padding + icon + text)
      final headerHeight = 88.0; // Increased to provide more clearance

      // Label height: text (16px) + spacing (4px) + extra padding
      final labelHeight = 50.0; // Increased to ensure full label visibility

      // Calculate target position accounting for header, label, and keyboard
      // Position field below the header but above keyboard, with label fully visible
      final double targetY;
      if (keyboardHeight > 0) {
        // When keyboard is visible: position in upper half of visible area
        final visibleArea = screenHeight - keyboardHeight - headerHeight;
        targetY =
            headerHeight +
            (visibleArea * 0.25); // Adjusted for better positioning
      } else {
        // When no keyboard: position in comfortable viewing area below header
        targetY = headerHeight + (screenHeight * 0.15);
      }

      // Calculate how much to scroll, accounting for the label above the field
      // We want both the label AND field to be visible, with extra clearance from header
      final scrollAmount =
          (position.dy - labelHeight - 20) -
          targetY; // Added 20px extra clearance

      // Always scroll if needed
      final currentScroll = _scrollController.offset;
      final targetScroll = (currentScroll + scrollAmount).clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      // Scroll if displacement is more than 15px
      if (scrollAmount.abs() > 15) {
        _scrollController.animateTo(
          targetScroll,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter product name'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    final product = {
      'name': _nameController.text.trim(),
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'category': _selectedCategory ?? _categoryController.text.trim(),
      'description': '',
      'available': true,
      'modifierGroups': [],
    };

    widget.onSave(product);

    if (_addAnother) {
      // Clear fields but keep category for next item
      setState(() {
        _nameController.clear();
        _priceController.clear();
        _nameFocus.requestFocus();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${product['name']} added'),
          backgroundColor: AppColors.blue,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenHeight = MediaQuery.of(context).size.height;
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Capture initial dimensions on first build (before keyboard)
    _initialScreenHeight ??= currentScreenHeight;
    _initialScreenWidth ??= currentScreenWidth;

    // Use initial dimensions ONLY - completely ignore viewport changes
    final isLandscape = _initialScreenWidth! > _initialScreenHeight!;

    // Fixed dimensions based on initial screen size
    final dialogWidth = 500.0;
    final dialogHeight = isLandscape
        ? _initialScreenHeight! * 0.70
        : _initialScreenHeight! * 0.80;

    // Calculate absolute positioning to center the dialog
    final left = (_initialScreenWidth! - dialogWidth) / 2;
    // Move dialog up slightly when keyboard appears to improve field visibility
    final top = keyboardHeight > 0
        ? ((_initialScreenHeight! - dialogHeight) / 2) - (keyboardHeight * 0.1)
        : (_initialScreenHeight! - dialogHeight) / 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: _initialScreenWidth,
        height: _initialScreenHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black54),
                ),
              ),
            ),
            // Dialog content with ABSOLUTE positioning
            Positioned(
              left: left,
              top: top,
              width: dialogWidth,
              height: dialogHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Add Product',
                                  style: AppTypography.h3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Add items quickly, one at a time',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onCancel?.call();
                            },
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: AppSpacing.xl,
                          right: AppSpacing.xl,
                          top: AppSpacing.xl,
                          // Always add keyboard height + extra space for comfortable typing
                          bottom:
                              AppSpacing.xl +
                              keyboardHeight +
                              (keyboardHeight > 0 ? 200 : 100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            _buildField(
                              key: _nameKey,
                              label: 'Product Name',
                              hint: 'e.g., Cappuccino, Caesar Salad',
                              controller: _nameController,
                              focusNode: _nameFocus,
                              autofocus: true,
                              icon: Icons.restaurant_menu,
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Price
                            _buildField(
                              key: _priceKey,
                              label: 'Price (\$)',
                              hint: '0.00',
                              controller: _priceController,
                              focusNode: _priceFocus,
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Category - Dropdown or Text
                            Text(
                              'Category',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),

                            if (widget.existingCategories.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gray300),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    prefixIcon: Icon(Icons.category, size: 20),
                                  ),
                                  hint: Text('Select or type new...'),
                                  items: [
                                    ...widget.existingCategories.map((cat) {
                                      return DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      );
                                    }),
                                    DropdownMenuItem(
                                      value: '__new__',
                                      child: Text(
                                        '+ New Category',
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == '__new__') {
                                        _selectedCategory = null;
                                      } else {
                                        _selectedCategory = value;
                                        _categoryController.text = value ?? '';
                                      }
                                    });
                                  },
                                ),
                              ),

                            if (_selectedCategory == null ||
                                widget.existingCategories.isEmpty)
                              _buildField(
                                key: _categoryKey,
                                label: widget.existingCategories.isEmpty
                                    ? null
                                    : 'Or create new',
                                hint: 'e.g., Drinks, Meals, Desserts',
                                controller: _categoryController,
                                focusNode: _categoryFocus,
                                icon: Icons.category,
                              ),

                            SizedBox(height: AppSpacing.lg),

                            // Add Another Checkbox
                            Container(
                              padding: EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.blue.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _addAnother,
                                    onChanged: (val) {
                                      setState(() {
                                        _addAnother = val ?? false;
                                      });
                                    },
                                    activeColor: AppColors.blue,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Keep adding more',
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          'Stay in this dialog to quickly add multiple items',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.gray600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer Actions
                    SafeArea(
                      top: false,
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.gray200),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'Cancel',
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onCancel?.call();
                                },
                                variant: AppButtonVariant.outline,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              flex: 2,
                              child: AppButton(
                                label: _addAnother
                                    ? 'Add & Continue'
                                    : 'Add Product',
                                onPressed: _save,
                                variant: AppButtonVariant.filled,
                                icon: _addAnother ? Icons.add : Icons.check,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    Key? key,
    String? label,
    required String hint,
    required TextEditingController controller,
    FocusNode? focusNode,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool autofocus = false,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.gray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onSubmitted: (_) => _save(),
        ),
      ],
    );
  }
}
