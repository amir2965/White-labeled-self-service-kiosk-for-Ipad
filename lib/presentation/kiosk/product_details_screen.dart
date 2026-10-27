import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/modifier.dart';
import '../../domain/entities/order.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  final Map<String, List<String>> _selectedModifiers = {};
  final TextEditingController _notesController = TextEditingController();
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _animateToNextStep() {
    _animationController.reset();
    _animationController.forward();
  }

  int get _totalSteps {
    // Modifier groups + special instructions + quantity + review
    return widget.product.modifierGroups.length + 3;
  }

  bool get _canProceed {
    if (_currentStep < widget.product.modifierGroups.length) {
      final group = widget.product.modifierGroups[_currentStep];
      final selectedCount = _selectedModifiers[group.id]?.length ?? 0;
      return selectedCount >= group.minSelection;
    }
    return true;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1 && _canProceed) {
      setState(() {
        _currentStep++;
      });
      _animateToNextStep();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _animateToNextStep();
    }
  }

  List<SelectedModifier> _buildSelectedModifiers() {
    final List<SelectedModifier> selected = [];

    for (final group in widget.product.modifierGroups) {
      final selectedIds = _selectedModifiers[group.id] ?? [];
      for (final modifierId in selectedIds) {
        final modifier = group.modifiers.firstWhere((m) => m.id == modifierId);
        selected.add(
          SelectedModifier(
            modifierGroupId: group.id,
            modifierGroupName: group.name,
            modifier: modifier,
          ),
        );
      }
    }

    return selected;
  }

  double _calculateTotalPrice() {
    double base = widget.product.price;
    double modifierTotal = 0.0;

    for (final group in widget.product.modifierGroups) {
      final selectedIds = _selectedModifiers[group.id] ?? [];
      for (final modifierId in selectedIds) {
        final modifier = group.modifiers.firstWhere((m) => m.id == modifierId);
        modifierTotal += modifier.priceAdjustment;
      }
    }

    return (base + modifierTotal) * _quantity;
  }

  void _addToCart() {
    ref
        .read(cartProvider.notifier)
        .addItem(
          product: widget.product,
          modifiers: _buildSelectedModifiers(),
          quantity: _quantity,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _calculateTotalPrice();
    final compact = MediaQuery.sizeOf(context).width < 600;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : AppSpacing.screenPadding * 2,
          vertical: compact ? 8 : AppSpacing.screenPadding,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 750),
          child: Column(
            children: [
              // Header with progress indicator
              _buildHeader(),

              // Progress Bar
              _buildProgressBar(),

              // Content - Fade-in only (no slide animation)
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildCurrentStep(),
                ),
              ),

              // Footer with navigation
              _buildFooter(totalPrice),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: AppTypography.h2.copyWith(fontSize: 26),
                ),
                SizedBox(height: 4),
                Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            iconSize: 28,
            color: AppColors.gray700,
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentStep + 1) / _totalSteps;

    return Container(
      height: 6,
      width: double.infinity,
      color: AppColors.gray200,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.blue, AppColors.blue.withValues(alpha: 0.8)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_currentStep < widget.product.modifierGroups.length) {
      return _buildModifierStep(widget.product.modifierGroups[_currentStep]);
    } else if (_currentStep == widget.product.modifierGroups.length) {
      return _buildNotesStep();
    } else if (_currentStep == widget.product.modifierGroups.length + 1) {
      return _buildQuantityStep();
    } else {
      return _buildReviewStep();
    }
  }

  Widget _buildModifierGroup(ModifierGroup group) {
    final selectedIds = _selectedModifiers[group.id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(group.name, style: AppTypography.h4),
            if (group.isRequired) ...[
              SizedBox(width: AppSpacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'REQUIRED',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),

        if (group.minSelection > 0 || group.maxSelection != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              _getSelectionHint(group),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

        SizedBox(height: AppSpacing.sm),

        ...group.modifiers.map(
          (modifier) => _buildModifierOption(
            group,
            modifier,
            selectedIds.contains(modifier.id),
          ),
        ),

        SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildModifierStep(ModifierGroup group) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Step title
          Text(
            group.name,
            style: AppTypography.h2.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          // Selection hint with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (group.isRequired)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.blue, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.stars, size: 16, color: AppColors.blue),
                      SizedBox(width: 6),
                      Text(
                        'REQUIRED',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 12),
              Text(
                _getSelectionHint(group),
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xl),

          // Modifier options in grid
          _buildModifierOptions(group),
        ],
      ),
    );
  }

  Widget _buildModifierOptions(ModifierGroup group) {
    final selectedIds = _selectedModifiers[group.id] ?? [];

    return Column(
      children: group.modifiers.map((modifier) {
        final isSelected = selectedIds.contains(modifier.id);
        final canSelect =
            group.maxSelection == null ||
            selectedIds.length < group.maxSelection!;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedModifiers[group.id]?.remove(modifier.id);
              } else if (canSelect || group.maxSelection == 1) {
                if (group.maxSelection == 1) {
                  _selectedModifiers[group.id] = [modifier.id];
                } else {
                  _selectedModifiers[group.id] = [
                    ...(_selectedModifiers[group.id] ?? []),
                    modifier.id,
                  ];
                }
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.blue.withValues(alpha: 0.08)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.blue : AppColors.gray300,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Check icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blue : AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.blue : AppColors.gray400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: AppColors.white, size: 18)
                      : null,
                ),
                SizedBox(width: 16),

                // Modifier name
                Expanded(
                  child: Text(
                    modifier.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected ? AppColors.black : AppColors.gray800,
                    ),
                  ),
                ),

                // Price adjustment
                if (modifier.priceAdjustment != 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: modifier.priceAdjustment > 0
                          ? AppColors.blue.withValues(alpha: 0.1)
                          : AppColors.gray200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${modifier.priceAdjustment > 0 ? '+' : ''}\$${modifier.priceAdjustment.toStringAsFixed(2)}',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: modifier.priceAdjustment > 0
                            ? AppColors.blue
                            : AppColors.gray700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 64, color: AppColors.blue),
          SizedBox(height: 20),
          Text(
            'Special Instructions',
            style: AppTypography.h2.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Any special requests or modifications?',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray600),
          ),
          SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _notesController,
            maxLines: 5,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'e.g., "No ice", "Extra hot", "Light foam"...',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.gray400,
              ),
              filled: true,
              fillColor: AppColors.gray100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityStep() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.blue),
            SizedBox(height: 20),
            Text(
              'How many?',
              style: AppTypography.h2.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onTap: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _quantity.toString(),
                      style: AppTypography.h1.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    icon: Icons.add,
                    onTap: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: onTap != null ? AppColors.blue : AppColors.gray300,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    final selectedMods = _buildSelectedModifiers();
    final basePrice = widget.product.price;
    final modifierTotal = selectedMods.fold<double>(
      0,
      (sum, mod) => sum + mod.modifier.priceAdjustment,
    );
    final itemTotal = basePrice + modifierTotal;
    final total = itemTotal * _quantity;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle, size: 64, color: AppColors.success),
                SizedBox(height: 16),
                Text(
                  'Review Your Order',
                  style: AppTypography.h2.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Product summary
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: AppTypography.h3.copyWith(fontSize: 22),
                      ),
                    ),
                    Text(
                      'x$_quantity',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.blue,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                if (selectedMods.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Divider(color: AppColors.gray300),
                  SizedBox(height: 12),
                  ...selectedMods.map(
                    (mod) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 16,
                            color: AppColors.gray600,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mod.modifier.name,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.gray700,
                              ),
                            ),
                          ),
                          if (mod.modifier.priceAdjustment != 0)
                            Text(
                              '+\$${mod.modifier.priceAdjustment.toStringAsFixed(2)}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (_notesController.text.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Divider(color: AppColors.gray300),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 16, color: AppColors.gray600),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _notesController.text,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.gray700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 24),

          // Price breakdown
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _buildPriceRow('Base Price', basePrice),
                if (modifierTotal > 0) ...[
                  SizedBox(height: 8),
                  _buildPriceRow('Customizations', modifierTotal),
                ],
                if (_quantity > 1) ...[
                  SizedBox(height: 8),
                  _buildPriceRow('Item Total', itemTotal),
                  SizedBox(height: 8),
                  _buildPriceRow('Quantity', _quantity.toDouble(), isQty: true),
                ],
                SizedBox(height: 12),
                Divider(color: AppColors.blue.withValues(alpha: 0.3)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.h3.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTypography.h3.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isQty = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.gray700),
        ),
        Text(
          isQty ? value.toInt().toString() : '\$${value.toStringAsFixed(2)}',
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.gray800,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(double totalPrice) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final compact = MediaQuery.sizeOf(context).width < 600;

    return Container(
      padding: EdgeInsets.all(compact ? 12 : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  side: BorderSide(color: AppColors.gray300, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!compact) Icon(Icons.arrow_back, color: AppColors.gray700),
                    if (!compact) SizedBox(width: 8),
                    Text(
                      'Back',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_currentStep > 0) SizedBox(width: 12),

          // Next/Add to Cart button
          Expanded(
            flex: 2,
            child: AppButton(
              label: isLastStep
                  ? '${compact ? 'Add' : 'Add to Cart'} • \$${totalPrice.toStringAsFixed(2)}'
                  : 'Continue',
              onPressed: _canProceed
                  ? (isLastStep ? _addToCart : _nextStep)
                  : null,
              size: AppButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectionHint(ModifierGroup group) {
    if (group.minSelection == group.maxSelection &&
        group.maxSelection != null) {
      return 'Choose ${group.minSelection}';
    } else if (group.maxSelection != null) {
      return 'Choose ${group.minSelection} to ${group.maxSelection}';
    } else if (group.minSelection > 0) {
      return 'Choose at least ${group.minSelection}';
    }
    return 'Optional';
  }

  Widget _buildModifierOption(
    ModifierGroup group,
    Modifier modifier,
    bool isSelected,
  ) {
    final canSelect =
        group.maxSelection == null ||
        (_selectedModifiers[group.id]?.length ?? 0) < group.maxSelection!;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedModifiers[group.id]?.remove(modifier.id);
          } else if (canSelect) {
            if (group.maxSelection == 1) {
              _selectedModifiers[group.id] = [modifier.id];
            } else {
              _selectedModifiers[group.id] = [
                ...(_selectedModifiers[group.id] ?? []),
                modifier.id,
              ];
            }
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.sm),
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blue.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.blue : AppColors.gray400,
              size: 24,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                modifier.name,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (modifier.priceAdjustment > 0)
              Text(
                '+\$${modifier.priceAdjustment.toStringAsFixed(2)}',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
