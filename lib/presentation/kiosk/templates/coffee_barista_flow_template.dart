import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/featured_display_provider.dart';
import '../product_details_screen.dart';
import '../widgets/category_hold_detector.dart';
import '../widgets/kiosk_pin_screen.dart';

/// Template: Coffee Barista Flow
/// 3-column layout: presets (left) + big product buttons (center) + upsell/help (right).
class CoffeeBaristaFlowTemplate extends ConsumerStatefulWidget {
  const CoffeeBaristaFlowTemplate({super.key});

  @override
  ConsumerState<CoffeeBaristaFlowTemplate> createState() =>
      _CoffeeBaristaFlowTemplateState();
}

class _CoffeeBaristaFlowTemplateState
    extends ConsumerState<CoffeeBaristaFlowTemplate> {
  String? _selectedCategoryId;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleExitTap() {
    final now = DateTime.now();

    // Reset if more than 2 seconds since last tap
    if (_lastTapTime == null || now.difference(_lastTapTime!).inSeconds > 2) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    // Show PIN after 5 taps
    if (_tapCount >= 5) {
      _tapCount = 0;
      _showPinScreen();
    }
  }

  void _showPinScreen() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => KioskPinScreen(
        onCorrectPin: () {
          Navigator.of(dialogContext).pop(); // Close PIN dialog
          context.go('/dashboard'); // Navigate to dashboard
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    _selectedCategoryId ??= categories.first.id;
    final selectedCategory = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    // Get featured product IDs from the new provider
    final featuredIds = ref.watch(
      featuredProductIdsProvider(selectedCategory.id),
    );
    final allProducts = menuState.getProductsByCategory(selectedCategory.id);

    // Filter to get actual featured products based on IDs
    final featured = allProducts
        .where((p) => featuredIds.contains(p.id))
        .toList();

    final hideFeatured = ref.watch(hideFeaturedFromMenuProvider);
    final products = hideFeatured
        ? allProducts.where((p) => !featuredIds.contains(p.id)).toList()
        : allProducts;

    // Check if current category is the last one
    final isLastCategory = categories.last.id == selectedCategory.id;

    return LandscapeOnlyGuard(
      templateName: 'Coffee Barista Flow',
      child: Row(
        children: [
          // Left Sidebar - Categories
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                right: BorderSide(color: AppColors.gray300, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category.id == _selectedCategoryId;
                final isLastCategory = index == categories.length - 1;

                return _CategoryButtonWithHold(
                  label: category.name,
                  isSelected: isSelected,
                  isLastCategory: isLastCategory,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                  onHoldComplete: isLastCategory ? _showPinScreen : null,
                );
              },
            ),
          ),

          // Center: big product buttons
          Expanded(
            child: Container(
              color: AppColors.background,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedCategory.name,
                          style: AppTypography.h2.copyWith(fontSize: 26),
                        ),
                      ),
                      // Hidden exit button - only on last category
                      if (isLastCategory)
                        GestureDetector(
                          onTap: _handleExitTap,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(right: AppSpacing.md),
                            child: Icon(
                              Icons.more_vert,
                              size: 28,
                              color: AppColors.gray400,
                            ),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.blue.withOpacity(0.25),
                          ),
                        ),
                        child: Text(
                          '${products.length} items',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: featured.isEmpty ? 3 : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: featured.isEmpty ? 2.0 : 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final hasDescription = product.description.isNotEmpty;

                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.gray300.withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                featured.isEmpty ? 14 : 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: AppTypography.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                          height: 1.15,
                                          letterSpacing: -0.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (hasDescription) ...[
                                        SizedBox(
                                          height: featured.isEmpty ? 4 : 6,
                                        ),
                                        Text(
                                          product.description,
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.gray600,
                                                fontSize: featured.isEmpty
                                                    ? 12.5
                                                    : 13,
                                                height: 1.25,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: featured.isEmpty ? 6 : 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AppTypography.h3.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Container(
                                        width: featured.isEmpty ? 38 : 44,
                                        height: featured.isEmpty ? 38 : 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius: BorderRadius.circular(
                                            featured.isEmpty ? 10 : 12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.white,
                                          size: featured.isEmpty ? 20 : 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right: upsell/help (only show if there are featured items)
          if (featured.isNotEmpty)
            Container(
              width: 340,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  left: BorderSide(color: AppColors.gray300, width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make it yours',
                            style: AppTypography.h3.copyWith(
                              fontSize: 20,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Every drink can be customized on the next screen.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.white.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      'Featured Items',
                      style: AppTypography.h3.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        itemCount: featured.length.clamp(0, 6),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = featured[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.gray300.withOpacity(0.8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.gray600,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.black,
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
            ),
        ],
      ),
    );
  }
}

/// Category button in sidebar
class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final void Function(LongPressStartDetails)? onLongPressStart;
  final void Function(LongPressEndDetails)? onLongPressEnd;
  final VoidCallback? onLongPressCancel;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      onLongPressCancel: onLongPressCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.gray900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

/// Category button with hold detection for exit
class _CategoryButtonWithHold extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isLastCategory;
  final VoidCallback onTap;
  final VoidCallback? onHoldComplete;

  const _CategoryButtonWithHold({
    required this.label,
    required this.isSelected,
    required this.isLastCategory,
    required this.onTap,
    this.onHoldComplete,
  });

  @override
  State<_CategoryButtonWithHold> createState() =>
      _CategoryButtonWithHoldState();
}

class _CategoryButtonWithHoldState extends State<_CategoryButtonWithHold> {
  Timer? _holdTimer;
  bool _isHolding = false;
  double _holdProgress = 0.0;

  void _startHoldTimer() {
    if (!widget.isLastCategory || widget.onHoldComplete == null) return;

    HapticFeedback.lightImpact();
    setState(() => _isHolding = true);

    const totalDuration = Duration(seconds: 10);
    const updateInterval = Duration(milliseconds: 100);
    int elapsed = 0;

    _holdTimer = Timer.periodic(updateInterval, (timer) {
      elapsed += updateInterval.inMilliseconds;
      final progress = elapsed / totalDuration.inMilliseconds;

      if (progress >= 1.0) {
        timer.cancel();
        _onHoldComplete();
      } else {
        if (mounted) {
          setState(() => _holdProgress = progress);
        }
      }
    });
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
    if (mounted) {
      setState(() {
        _isHolding = false;
        _holdProgress = 0.0;
      });
    }
  }

  void _onHoldComplete() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
    widget.onHoldComplete?.call();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: (_) => _startHoldTimer(),
      onLongPressEnd: (_) => _cancelHoldTimer(),
      onLongPressCancel: () => _cancelHoldTimer(),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isSelected ? AppColors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label.toUpperCase(),
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: widget.isSelected
                    ? FontWeight.w700
                    : FontWeight.w600,
                color: widget.isSelected ? AppColors.white : AppColors.gray900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Progress indicator overlay
          if (_isHolding)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Progress bar at bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _holdProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: _holdProgress >= 0.98
                                    ? Radius.circular(8)
                                    : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
