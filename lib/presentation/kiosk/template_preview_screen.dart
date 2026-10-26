import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
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
import '../providers/menu_provider.dart';
import '../providers/template_provider.dart';
import '../providers/featured_display_provider.dart';

/// Preview screen for selected template
class TemplatePreviewScreen extends ConsumerStatefulWidget {
  final MenuDisplayTemplate template;
  final String templateName;
  final bool isOnboarding;
  final bool fromDashboard;

  const TemplatePreviewScreen({
    super.key,
    required this.template,
    required this.templateName,
    this.isOnboarding = false,
    this.fromDashboard = false,
  });

  @override
  ConsumerState<TemplatePreviewScreen> createState() =>
      _TemplatePreviewScreenState();
}

class _TemplatePreviewScreenState extends ConsumerState<TemplatePreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Load demo menu if not already loaded
    Future.microtask(() {
      final menuState = ref.read(menuProvider);
      if (menuState.categories.isEmpty) {
        ref.read(menuProvider.notifier).seedDemoMenu('cafe');
      }

      // Apply default featured items for specific templates
      _applyDefaultFeaturedItems();
    });

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.02), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  void _applyDefaultFeaturedItems() {
    final menuState = ref.read(menuProvider);
    final categories = menuState.sortedCategories;

    // Always apply defaults for preview
    if (categories.isEmpty) return;

    // Clear existing featured items for this template first
    final currentGlobal = ref.read(templateFeaturedItemsProvider);
    final cleared = Map<MenuDisplayTemplate, Map<String, List<String>>>.from(
      currentGlobal,
    );
    cleared[widget.template] = {};
    ref.read(templateFeaturedItemsProvider.notifier).state = cleared;

    final Map<String, List<String>> featuredMap = {};

    if (widget.template == MenuDisplayTemplate.coffeeBaristaFlow) {
      // Coffee Barista Flow: Default 4 featured items for first 2 categories
      final categoriesToUse = categories.take(2);
      for (final category in categoriesToUse) {
        final products = menuState.getProductsByCategory(category.id);
        if (products.isNotEmpty) {
          final count = products.length >= 4 ? 4 : products.length;
          featuredMap[category.id] = products
              .take(count)
              .map((p) => p.id)
              .toList();
        }
      }
    } else if (widget.template == MenuDisplayTemplate.chefSpecialsBoard) {
      // Chef's Special Board: Default 4 featured items per category
      for (final category in categories) {
        final products = menuState.getProductsByCategory(category.id);
        if (products.length >= 4) {
          featuredMap[category.id] = products.take(4).map((p) => p.id).toList();
        }
      }
    } else if (widget.template == MenuDisplayTemplate.bentoHighlights ||
        widget.template == MenuDisplayTemplate.bentoWithCartSidebar) {
      // Bento Highlights: Default 5 featured items per category
      for (final category in categories) {
        final products = menuState.getProductsByCategory(category.id);
        if (products.length >= 5) {
          featuredMap[category.id] = products.take(5).map((p) => p.id).toList();
        } else if (products.length >= 2) {
          // Minimum 2 for bento
          featuredMap[category.id] = products
              .take(products.length)
              .map((p) => p.id)
              .toList();
        }
      }
    }

    // Update the featured items provider
    if (featuredMap.isNotEmpty) {
      final currentGlobal = ref.read(templateFeaturedItemsProvider);
      final updated = Map<MenuDisplayTemplate, Map<String, List<String>>>.from(
        currentGlobal,
      );
      updated[widget.template] = Map.from(featuredMap);
      ref.read(templateFeaturedItemsProvider.notifier).state = updated;
    }

    // Apply featured items to products
    for (final category in categories) {
      final products = menuState.getProductsByCategory(category.id);
      final featuredIds = featuredMap[category.id] ?? [];

      for (final product in products) {
        final shouldBeFeatured = featuredIds.contains(product.id);
        final featuredIndex = featuredIds.indexOf(product.id);

        final newSortOrder = shouldBeFeatured
            ? 1000 + featuredIndex
            : product.sortOrder ?? 9999;

        if (product.isFeatured != shouldBeFeatured ||
            product.sortOrder != newSortOrder) {
          final updatedProduct = product.copyWith(
            isFeatured: shouldBeFeatured,
            sortOrder: newSortOrder,
          );
          ref.read(menuProvider.notifier).updateProduct(updatedProduct);
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Template Preview Content
          Column(
            children: [
              // Preview indicator banner with frosted glass effect
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            // Back button
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                                tooltip: 'Back to selection',
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            // Preview label
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.blue,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'PREVIEW MODE',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white,
                                                letterSpacing: 1,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Flexible(
                                        child: Text(
                                          widget.templateName,
                                          style: AppTypography.bodyLarge
                                              .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Explore the template with demo products',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.white.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            // Change Template button
                            OutlinedButton.icon(
                              onPressed: () => context.pop(),
                              icon: Icon(Icons.swap_horiz, size: 18),
                              label: Text('Change Template'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.white,
                                side: BorderSide(
                                  color: AppColors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            // Use Template button
                            ElevatedButton.icon(
                              onPressed: () {
                                // Save selected template
                                ref
                                    .read(selectedTemplateProvider.notifier)
                                    .selectTemplate(widget.template);
                                // Navigate based on context
                                if (widget.isOnboarding) {
                                  // Return to onboarding flow
                                  Navigator.pop(context);
                                } else if (widget.fromDashboard) {
                                  // Return to dashboard
                                  Navigator.pop(context);
                                } else {
                                  // Go to kiosk (default)
                                  context.go('/kiosk');
                                }
                              },
                              icon: const Icon(Icons.check_circle, size: 20),
                              label: const Text('Use This Template'),
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
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Template content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildTemplateContent(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateContent() {
    final menuState = ref.watch(menuProvider);

    if (menuState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text(
              'Loading preview...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    switch (widget.template) {
      case MenuDisplayTemplate.categorySidebar:
        return const CategorySidebarTemplate();
      case MenuDisplayTemplate.topTabList:
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
}
