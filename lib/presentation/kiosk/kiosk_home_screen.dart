import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/category_widgets.dart';
import '../../core/widgets/product_card.dart' as widgets;
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/kiosk_config_provider.dart';
import 'product_details_screen.dart';
import '../payments/checkout_screen.dart';
import 'widgets/kiosk_pin_screen.dart';

class KioskHomeScreen extends ConsumerStatefulWidget {
  const KioskHomeScreen({super.key});

  @override
  ConsumerState<KioskHomeScreen> createState() => _KioskHomeScreenState();
}

class _KioskHomeScreenState extends ConsumerState<KioskHomeScreen> {
  int _selectedCategoryIndex = 0;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    // Load demo cafe menu
    Future.microtask(() {
      ref.read(menuProvider.notifier).seedDemoMenu('cafe');
    });
  }

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
      builder: (context) => KioskPinScreen(
        onCorrectPin: () {
          Navigator.pop(context); // Close PIN screen
          Navigator.pop(context); // Exit kiosk mode to dashboard
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final cartState = ref.watch(cartProvider);
    final config = ref.watch(kioskConfigProvider);

    if (menuState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (menuState.error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: ${menuState.error}')),
      );
    }

    final categories = menuState.categories;
    final products = _selectedCategoryIndex < categories.length
        ? menuState.getProductsByCategory(categories[_selectedCategoryIndex].id)
        : [];
    final isLastCategory =
        categories.isNotEmpty &&
        _selectedCategoryIndex == categories.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isLastCategory),
            if (categories.isNotEmpty) _buildCategoryTabs(categories),
            Expanded(child: _buildProductGrid(products)),
            if (cartState.itemCount > 0) _buildCartBar(cartState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLastCategory) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: AppTypography.display2),
              SizedBox(height: AppSpacing.xs),
              Text(
                'What would you like today?',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.storefront, size: 48, color: AppColors.blue),
          // Hidden exit button - only visible on last category
          if (isLastCategory) ...[
            SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: _handleExitTap,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.more_vert,
                  size: 24,
                  color: AppColors.gray400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(List<dynamic> categories) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: EdgeInsets.only(right: AppSpacing.sm),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.black : AppColors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: isSelected ? AppColors.black : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  category.name,
                  style: AppTypography.h4.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.gray400,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'No products available',
              style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return widgets.ProductCard(
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
          style: widgets.ProductCardStyle.imageHeavy,
          onTap: () => _showProductDetails(product),
        );
      },
    );
  }

  void _showProductDetails(dynamic product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsScreen(product: product),
    );
  }

  Widget _buildCartBar(CartState cartState) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '${cartState.itemCount}',
              style: AppTypography.h4.copyWith(color: AppColors.white),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Cart Total', style: AppTypography.bodySmall),
                Text(
                  '\$${cartState.total.toStringAsFixed(2)}',
                  style: AppTypography.h3,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    items: cartState.items.map((item) {
                      final modifierCost = item.modifiers.fold(
                        0.0,
                        (sum, m) => sum + m.modifier.priceAdjustment,
                      );
                      return {
                        'name': item.product.name,
                        'basePrice': item.product.price,
                        'price': item.product.price + modifierCost,
                        'quantity': item.quantity,
                        'modifiers': item.modifiers
                            .map(
                              (m) => {
                                'name': m.modifier.name,
                                'modifier': {
                                  'name': m.modifier.name,
                                  'priceAdjustment': m.modifier.priceAdjustment,
                                },
                              },
                            )
                            .toList(),
                      };
                    }).toList(),
                    subtotal: cartState.subtotal,
                    serviceFee: cartState.serviceFee,
                    total: cartState.total,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Text('Checkout', style: AppTypography.h4),
                SizedBox(width: AppSpacing.sm),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
