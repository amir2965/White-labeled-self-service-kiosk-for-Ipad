import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class ProductEditDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onDelete;

  const ProductEditDialog({
    super.key,
    required this.product,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late List<Map<String, dynamic>> _modifierGroups;
  late List<String> _tags;

  // Store initial screen dimensions to prevent dialog resize when keyboard appears
  double? _initialScreenHeight;
  double? _initialScreenWidth;

  // Scroll controller and focus nodes for auto-scroll behavior
  final ScrollController _scrollController = ScrollController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  // GlobalKeys for field positioning
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _priceKey = GlobalKey();
  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _descriptionKey = GlobalKey();

  // Maps to store GlobalKeys and FocusNodes for modifier group fields (keyed by group index)
  final Map<int, GlobalKey> _groupNameKeys = {};
  final Map<int, GlobalKey> _minSelectionKeys = {};
  final Map<int, GlobalKey> _maxSelectionKeys = {};
  final Map<int, FocusNode> _groupNameFocusNodes = {};
  final Map<int, FocusNode> _minSelectionFocusNodes = {};
  final Map<int, FocusNode> _maxSelectionFocusNodes = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name'] ?? '');
    _priceController = TextEditingController(
      text: widget.product['price']?.toString() ?? '0',
    );
    _categoryController = TextEditingController(
      text: widget.product['category'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product['description'] ?? '',
    );

    // Parse existing modifier groups or create empty list
    if (widget.product['modifierGroups'] != null) {
      _modifierGroups = List<Map<String, dynamic>>.from(
        (widget.product['modifierGroups'] as List).map(
          (g) => Map<String, dynamic>.from(g),
        ),
      );
    } else {
      _modifierGroups = [];
    }

    // Parse existing tags or create empty list
    if (widget.product['tags'] != null) {
      _tags = List<String>.from(widget.product['tags'] as List);
    } else {
      _tags = [];
    }

    // Initialize GlobalKeys and FocusNodes for existing modifier groups
    for (int i = 0; i < _modifierGroups.length; i++) {
      _initModifierFieldKeys(i);
    }

    // Add focus listeners for auto-scroll
    _nameFocus.addListener(() => _onFocusChange(_nameKey));
    _priceFocus.addListener(() => _onFocusChange(_priceKey));
    _categoryFocus.addListener(() => _onFocusChange(_categoryKey));
    _descriptionFocus.addListener(() => _onFocusChange(_descriptionKey));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameFocus.dispose();
    _priceFocus.dispose();
    _categoryFocus.dispose();
    _descriptionFocus.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();

    // Dispose modifier field focus nodes
    _groupNameFocusNodes.values.forEach((node) => node.dispose());
    _minSelectionFocusNodes.values.forEach((node) => node.dispose());
    _maxSelectionFocusNodes.values.forEach((node) => node.dispose());

    super.dispose();
  }

  // Initialize GlobalKeys and FocusNodes for a modifier group
  void _initModifierFieldKeys(int index) {
    _groupNameKeys[index] = GlobalKey();
    _minSelectionKeys[index] = GlobalKey();
    _maxSelectionKeys[index] = GlobalKey();

    _groupNameFocusNodes[index] = FocusNode();
    _minSelectionFocusNodes[index] = FocusNode();
    _maxSelectionFocusNodes[index] = FocusNode();

    // Add listeners to trigger auto-scroll
    _groupNameFocusNodes[index]!.addListener(
      () => _onFocusChange(_groupNameKeys[index]!),
    );
    _minSelectionFocusNodes[index]!.addListener(
      () => _onFocusChange(_minSelectionKeys[index]!),
    );
    _maxSelectionFocusNodes[index]!.addListener(
      () => _onFocusChange(_maxSelectionKeys[index]!),
    );
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
      final headerHeight = 72.0;

      // Label height: icon (18px) + spacing (4px) + text (16px) + spacing (4px) + extra padding (10px)
      final labelHeight = 52.0;

      // Calculate target position accounting for header, label, and keyboard
      // Position field below the header but above keyboard, with label visible
      final double targetY;
      if (keyboardHeight > 0) {
        // When keyboard is visible: position in upper half of visible area
        final visibleArea = screenHeight - keyboardHeight - headerHeight;
        targetY = headerHeight + (visibleArea * 0.35);
      } else {
        // When no keyboard: position in comfortable viewing area below header
        targetY = headerHeight + (screenHeight * 0.20);
      }

      // Calculate how much to scroll, accounting for the label above the field
      // We want both the label AND field to be visible
      final scrollAmount = (position.dy - labelHeight) - targetY;

      // Always scroll if needed, even without keyboard (removed the check)
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

  void _addModifierGroup() {
    setState(() {
      final newIndex = _modifierGroups.length;
      _modifierGroups.add({
        'groupName': 'New Group',
        'required': false,
        'minSelection': 0,
        'maxSelection': 1,
        'options': [],
      });
      _initModifierFieldKeys(newIndex);
    });
  }

  void _removeModifierGroup(int index) {
    setState(() {
      // Dispose focus nodes before removing
      _groupNameFocusNodes[index]?.dispose();
      _minSelectionFocusNodes[index]?.dispose();
      _maxSelectionFocusNodes[index]?.dispose();

      // Remove from maps
      _groupNameKeys.remove(index);
      _minSelectionKeys.remove(index);
      _maxSelectionKeys.remove(index);
      _groupNameFocusNodes.remove(index);
      _minSelectionFocusNodes.remove(index);
      _maxSelectionFocusNodes.remove(index);

      _modifierGroups.removeAt(index);
    });
  }

  void _addOption(int groupIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (dialogContext) {
        final nameController = TextEditingController();
        final priceController = TextEditingController(text: '0');
        final nameFocus = FocusNode();
        final priceFocus = FocusNode();
        final scrollController = ScrollController();

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text('Add Option', style: AppTypography.h3),
                contentPadding: EdgeInsets.zero,
                content: Container(
                  width: 400,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          focusNode: nameFocus,
                          autofocus: true,
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (scrollController.hasClients) {
                                scrollController.animateTo(
                                  0,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Option Name',
                            hintText: 'e.g., Extra Shot, Large Size',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: priceController,
                          focusNode: priceFocus,
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (scrollController.hasClients) {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Extra Price (\$)',
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        setState(() {
                          final options =
                              _modifierGroups[groupIndex]['options'] as List;
                          options.add({
                            'name': nameController.text,
                            'price': double.tryParse(priceController.text) ?? 0,
                          });
                        });
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showAddTagDialog() {
    final tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Tag'),
        content: TextField(
          controller: tagController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Tag (e.g., hot, iced, vegan)',
            hintText: 'Enter a tag',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty &&
                !_tags.contains(value.trim().toLowerCase())) {
              setState(() {
                _tags.add(value.trim().toLowerCase());
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final tag = tagController.text.trim().toLowerCase();
              if (tag.isNotEmpty && !_tags.contains(tag)) {
                setState(() {
                  _tags.add(tag);
                });
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _save() {
    final updatedProduct = {
      'name': _nameController.text.trim(),
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'category': _categoryController.text.trim(),
      'description': _descriptionController.text.trim(),
      'tags': _tags,
      'modifierGroups': _modifierGroups,
      'imageUrl': widget.product['imageUrl'], // Preserve existing image
    };
    widget.onSave(updatedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final currentScreenHeight = MediaQuery.of(context).size.height;
    final currentScreenWidth = MediaQuery.of(context).size.width;

    // Capture initial dimensions on first build (before keyboard)
    _initialScreenHeight ??= currentScreenHeight;
    _initialScreenWidth ??= currentScreenWidth;

    // Use initial dimensions ONLY - completely ignore viewport changes
    final isLandscape = _initialScreenWidth! > _initialScreenHeight!;

    // Fixed dimensions based on initial screen size
    final dialogWidth = 600.0;
    final dialogHeight = isLandscape
        ? _initialScreenHeight! * 0.75
        : _initialScreenHeight! * 0.85;

    // Calculate absolute positioning to center the dialog
    final left = (_initialScreenWidth! - dialogWidth) / 2;
    final top = (_initialScreenHeight! - dialogHeight) / 2;

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
                child: Container(color: Colors.black54),
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
                  borderRadius: BorderRadius.circular(16),
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
                        color: AppColors.black,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 24),
                          SizedBox(width: AppSpacing.sm),
                          Text(
                            'Edit Product',
                            style: AppTypography.h3.copyWith(
                              color: Colors.white,
                            ),
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
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          top: AppSpacing.lg,
                          // Always add keyboard height + extra space for comfortable typing
                          bottom:
                              AppSpacing.lg +
                              keyboardHeight +
                              (keyboardHeight > 0 ? 200 : 100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            _buildTextField(
                              key: _nameKey,
                              label: 'Product Name',
                              controller: _nameController,
                              focusNode: _nameFocus,
                              icon: Icons.restaurant_menu,
                            ),
                            SizedBox(height: AppSpacing.md),

                            // Price
                            _buildTextField(
                              key: _priceKey,
                              label: 'Price',
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
                            SizedBox(height: AppSpacing.md),

                            // Category
                            _buildTextField(
                              key: _categoryKey,
                              label: 'Category',
                              controller: _categoryController,
                              focusNode: _categoryFocus,
                              icon: Icons.category,
                            ),
                            SizedBox(height: AppSpacing.md),

                            // Description
                            _buildTextField(
                              key: _descriptionKey,
                              label: 'Description (Optional)',
                              controller: _descriptionController,
                              focusNode: _descriptionFocus,
                              icon: Icons.description,
                              maxLines: 2,
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Tags Section
                            Row(
                              children: [
                                Icon(Icons.local_offer, size: 20),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Tags',
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  '(hot, iced, vegan, etc.)',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ..._tags.map(
                                  (tag) => Chip(
                                    label: Text(tag),
                                    onDeleted: () {
                                      setState(() {
                                        _tags.remove(tag);
                                      });
                                    },
                                    deleteIcon: Icon(Icons.close, size: 18),
                                  ),
                                ),
                                ActionChip(
                                  avatar: Icon(Icons.add, size: 18),
                                  label: Text('Add Tag'),
                                  onPressed: () {
                                    _showAddTagDialog();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.lg),

                            // Modifiers Section
                            Row(
                              children: [
                                Icon(Icons.tune, size: 20),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Customization Groups',
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                TextButton.icon(
                                  onPressed: _addModifierGroup,
                                  icon: Icon(Icons.add),
                                  label: Text('Add Group'),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.sm),

                            // Modifier Groups List
                            ..._modifierGroups.asMap().entries.map((
                              groupEntry,
                            ) {
                              final group = groupEntry.value;
                              final options = group['options'] as List? ?? [];

                              return Container(
                                margin: EdgeInsets.only(bottom: AppSpacing.md),
                                padding: EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gray300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            key: _groupNameKeys[groupEntry.key],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text:
                                                            group['groupName'],
                                                      )
                                                      ..selection =
                                                          TextSelection.collapsed(
                                                            offset:
                                                                group['groupName']
                                                                    .toString()
                                                                    .length,
                                                          ),
                                                focusNode:
                                                    _groupNameFocusNodes[groupEntry
                                                        .key],
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Group Name (e.g., Size, Meat)',
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                onTap: () {
                                                  // Request focus to trigger listener
                                                  if (!_groupNameFocusNodes[groupEntry
                                                          .key]!
                                                      .hasFocus) {
                                                    _groupNameFocusNodes[groupEntry
                                                            .key]!
                                                        .requestFocus();
                                                  }
                                                  // Additional trigger via _onFocusChange
                                                  Future.delayed(
                                                    Duration(milliseconds: 150),
                                                    () {
                                                      _onFocusChange(
                                                        _groupNameKeys[groupEntry
                                                            .key]!,
                                                      );
                                                    },
                                                  );
                                                },
                                                onChanged: (val) {
                                                  _modifierGroups[groupEntry
                                                          .key]['groupName'] =
                                                      val;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Checkbox(
                                          value: group['required'] == true,
                                          onChanged: (val) {
                                            setState(() {
                                              _modifierGroups[groupEntry
                                                      .key]['required'] =
                                                  val;
                                              if (val == true &&
                                                  _modifierGroups[groupEntry
                                                          .key]['minSelection'] ==
                                                      0) {
                                                _modifierGroups[groupEntry
                                                        .key]['minSelection'] =
                                                    1;
                                              }
                                            });
                                          },
                                        ),
                                        Text('Required'),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _removeModifierGroup(
                                            groupEntry.key,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            key:
                                                _minSelectionKeys[groupEntry
                                                    .key],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: TextEditingController(
                                                  text:
                                                      (group['minSelection'] ??
                                                              0)
                                                          .toString(),
                                                ),
                                                focusNode:
                                                    _minSelectionFocusNodes[groupEntry
                                                        .key],
                                                decoration: InputDecoration(
                                                  labelText: 'Min Selection',
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                onTap: () {
                                                  // Request focus to trigger listener
                                                  if (!_minSelectionFocusNodes[groupEntry
                                                          .key]!
                                                      .hasFocus) {
                                                    _minSelectionFocusNodes[groupEntry
                                                            .key]!
                                                        .requestFocus();
                                                  }
                                                  // Additional trigger via _onFocusChange
                                                  Future.delayed(
                                                    Duration(milliseconds: 150),
                                                    () {
                                                      _onFocusChange(
                                                        _minSelectionKeys[groupEntry
                                                            .key]!,
                                                      );
                                                    },
                                                  );
                                                },
                                                onChanged: (val) {
                                                  _modifierGroups[groupEntry
                                                          .key]['minSelection'] =
                                                      int.tryParse(val) ?? 0;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            key:
                                                _maxSelectionKeys[groupEntry
                                                    .key],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: TextEditingController(
                                                  text:
                                                      (group['maxSelection'] ??
                                                              1)
                                                          .toString(),
                                                ),
                                                focusNode:
                                                    _maxSelectionFocusNodes[groupEntry
                                                        .key],
                                                decoration: InputDecoration(
                                                  labelText: 'Max Selection',
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                onTap: () {
                                                  // Request focus to trigger listener
                                                  if (!_maxSelectionFocusNodes[groupEntry
                                                          .key]!
                                                      .hasFocus) {
                                                    _maxSelectionFocusNodes[groupEntry
                                                            .key]!
                                                        .requestFocus();
                                                  }
                                                  // Additional trigger via _onFocusChange
                                                  Future.delayed(
                                                    Duration(milliseconds: 150),
                                                    () {
                                                      _onFocusChange(
                                                        _maxSelectionKeys[groupEntry
                                                            .key]!,
                                                      );
                                                    },
                                                  );
                                                },
                                                onChanged: (val) {
                                                  _modifierGroups[groupEntry
                                                          .key]['maxSelection'] =
                                                      int.tryParse(val) ?? 1;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    ...options.asMap().entries.map((optEntry) {
                                      final opt = optEntry.value;
                                      return ListTile(
                                        dense: true,
                                        title: Text(opt['name']),
                                        subtitle: Text(
                                          '+\$${opt['price']?.toStringAsFixed(2) ?? '0.00'}',
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.close, size: 18),
                                          onPressed: () {
                                            setState(() {
                                              options.removeAt(optEntry.key);
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _addOption(groupEntry.key),
                                      icon: Icon(Icons.add),
                                      label: Text('Add Option'),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),

                    // Footer Actions
                    SafeArea(
                      top: false,
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.gray200),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            // Delete Button
                            Expanded(
                              child: AppButton(
                                label: 'Delete',
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onDelete();
                                },
                                variant: AppButtonVariant.outline,
                                icon: Icons.delete_outline,
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            // Save Button
                            Expanded(
                              flex: 2,
                              child: AppButton(
                                label: 'Save Changes',
                                onPressed: _save,
                                variant: AppButtonVariant.filled,
                                icon: Icons.check,
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

  Widget _buildTextField({
    Key? key,
    required String label,
    required TextEditingController controller,
    FocusNode? focusNode,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gray600),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: () {
            // Ensure focus and trigger scroll even on tap
            if (focusNode != null && !focusNode.hasFocus) {
              focusNode.requestFocus();
            }
          },
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            onTap: () {
              // Additional scroll trigger on direct field tap
              if (key != null && key is GlobalKey) {
                Future.delayed(Duration(milliseconds: 150), () {
                  _onFocusChange(key);
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.gray300, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.gray300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.blue, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
