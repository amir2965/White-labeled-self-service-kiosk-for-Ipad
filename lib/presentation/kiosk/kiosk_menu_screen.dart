import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import 'menu_template_config.dart';
import 'templates/category_sidebar_template.dart';
import 'templates/category_landing_template.dart';
import 'templates/bento_highlights_template.dart';
import 'templates/coffee_barista_flow_template.dart';
import 'templates/coffee_barista_with_checkout_template.dart';
import 'templates/chef_specials_board_template.dart';
import 'templates/coffee_quick_order_template.dart';
import 'templates/coffee_tiles_template.dart';
import 'templates/course_sections_rail_template.dart';
import 'templates/course_sections_retail_1_template.dart';
import 'templates/top_tab_list_one_column_template.dart';
import 'templates/top_tab_list_two_column_template.dart';
import 'templates/dense_grid_template.dart';
import 'templates/featured_hero_template.dart';
import 'templates/menu_with_cart_sidebar_template.dart';
import 'templates/promo_banner_grid_template.dart';
import 'templates/restaurant_menu_board_template.dart';
import 'templates/restaurant_menu_board_with_cart_template.dart';
import 'templates/bento_with_cart_sidebar_template.dart';
import 'templates/restaurant_course_navigator_with_cart_template.dart';
import 'templates/restaurant_course_navigator_with_cart_image_template.dart';
import 'templates/restaurant_spotlight_with_cart_template.dart';
import 'templates/coffee_order_pad_with_cart_template.dart';
import '../payments/checkout_screen.dart';

/// Main kiosk screen with template support
class KioskMenuScreen extends ConsumerStatefulWidget {
  final MenuDisplayTemplate template;

  const KioskMenuScreen({
    super.key,
    this.template = MenuDisplayTemplate.categorySidebar,
  });

  @override
  ConsumerState<KioskMenuScreen> createState() => _KioskMenuScreenState();
}

class _KioskMenuScreenState extends ConsumerState<KioskMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Load demo menu if not already loaded
    Future.microtask(() {
      final menuState = ref.read(menuProvider);
      if (menuState.categories.isEmpty) {
        ref.read(menuProvider.notifier).seedDemoMenu('cafe');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final cartState = ref.watch(cartProvider);

    final hasRightCartSidebar =
        widget.template == MenuDisplayTemplate.menuWithCartSidebar ||
        widget.template == MenuDisplayTemplate.restaurantMenuBoardWithCart ||
        widget.template == MenuDisplayTemplate.bentoWithCartSidebar ||
        widget.template ==
            MenuDisplayTemplate.restaurantCourseNavigatorWithCart ||
        widget.template ==
            MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage ||
        widget.template == MenuDisplayTemplate.restaurantSpotlightWithCart ||
        widget.template == MenuDisplayTemplate.coffeeOrderPadWithCart ||
        widget.template == MenuDisplayTemplate.coffeeBaristaWithCheckout;

    if (menuState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (menuState.error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.gray600),
              SizedBox(height: AppSpacing.md),
              Text(
                'Error: ${menuState.error}',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(cartState),
            Expanded(child: _buildTemplateContent()),
            if (!hasRightCartSidebar && cartState.itemCount > 0)
              _buildCartBar(cartState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CartState cartState) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray300, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo/Brand
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_cafe, color: AppColors.white, size: 28),
          ),
          SizedBox(width: AppSpacing.md),
          Text(
            'Menu',
            style: AppTypography.h2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Cart Summary
          if (cartState.itemCount > 0 && MediaQuery.sizeOf(context).width >= 600)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray300.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, size: 20, color: AppColors.gray900),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    '${cartState.itemCount} items • \$${cartState.total.toStringAsFixed(2)}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(width: AppSpacing.md),
          // Cart Button
          ElevatedButton.icon(
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
            icon: const Icon(Icons.shopping_cart, size: 20),
            label: const Text('Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateContent() {
    switch (widget.template) {
      case MenuDisplayTemplate.categorySidebar:
        return const CategorySidebarTemplate();
      case MenuDisplayTemplate.topTabList:
        // Kept for backward compatibility, defaults to one column
        return const TopTabListOneColumnTemplate();
      case MenuDisplayTemplate.topTabListOneColumn:
        return const TopTabListOneColumnTemplate();
      case MenuDisplayTemplate.topTabListTwoColumn:
        return const TopTabListTwoColumnTemplate();
      case MenuDisplayTemplate.denseGrid:
        return const DenseGridTemplate();
      case MenuDisplayTemplate.featuredHero:
        return const FeaturedHeroTemplate();

      case MenuDisplayTemplate.coffeeQuickOrder:
        return const CoffeeQuickOrderTemplate();
      case MenuDisplayTemplate.chefSpecialsBoard:
        return const ChefSpecialsBoardTemplate();
      case MenuDisplayTemplate.menuWithCartSidebar:
        return const MenuWithCartSidebarTemplate();

      case MenuDisplayTemplate.promoBannerGrid:
        return const PromoBannerGridTemplate();
      case MenuDisplayTemplate.courseSectionsRail:
        return const CourseSectionsRailTemplate();
      case MenuDisplayTemplate.courseSectionsRetail1:
        return const CourseSectionsRetail1Template();
      case MenuDisplayTemplate.coffeeTiles:
        return const CoffeeTilesTemplate();

      case MenuDisplayTemplate.restaurantMenuBoard:
        return const RestaurantMenuBoardTemplate();
      case MenuDisplayTemplate.categoryLanding:
        return const CategoryLandingTemplate();
      case MenuDisplayTemplate.coffeeBaristaFlow:
        return const CoffeeBaristaFlowTemplate();
      case MenuDisplayTemplate.bentoHighlights:
        return const BentoHighlightsTemplate();

      case MenuDisplayTemplate.restaurantMenuBoardWithCart:
        return const RestaurantMenuBoardWithCartTemplate();
      case MenuDisplayTemplate.bentoWithCartSidebar:
        return const BentoWithCartSidebarTemplate();

      case MenuDisplayTemplate.restaurantCourseNavigatorWithCart:
        return const RestaurantCourseNavigatorWithCartTemplate();
      case MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage:
        return const RestaurantCourseNavigatorWithCartImageTemplate();
      case MenuDisplayTemplate.restaurantSpotlightWithCart:
        return const RestaurantSpotlightWithCartTemplate();
      case MenuDisplayTemplate.coffeeOrderPadWithCart:
        return const CoffeeOrderPadWithCartTemplate();
      case MenuDisplayTemplate.coffeeBaristaWithCheckout:
        return const CoffeeBaristaWithCheckoutTemplate();
    }
  }

  Widget _buildCartBar(CartState cartState) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray300, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${cartState.itemCount} ${cartState.itemCount == 1 ? 'item' : 'items'}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${cartState.total.toStringAsFixed(2)}',
                    style: AppTypography.h2.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 64,
              child: ElevatedButton(
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
                                      'priceAdjustment':
                                          m.modifier.priceAdjustment,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
