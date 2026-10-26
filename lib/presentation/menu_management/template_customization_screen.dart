import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/entities/product.dart';
import '../providers/menu_provider.dart';
import '../providers/merchant_provider.dart';
import '../providers/template_provider.dart';
import '../providers/featured_display_provider.dart';
import '../kiosk/menu_template_config.dart';
import '../kiosk/templates/category_sidebar_template.dart';
import '../kiosk/templates/category_landing_template.dart';
import '../kiosk/templates/bento_highlights_template.dart';
import '../kiosk/templates/coffee_barista_flow_template.dart';
import '../kiosk/templates/coffee_barista_with_checkout_template.dart';
import '../kiosk/templates/chef_specials_board_template.dart';
import '../kiosk/templates/coffee_quick_order_template.dart';
import '../kiosk/templates/coffee_tiles_template.dart';
import '../kiosk/templates/course_sections_rail_template.dart';
import '../kiosk/templates/course_sections_retail_1_template.dart';
import '../kiosk/templates/top_tab_list_one_column_template.dart';
import '../kiosk/templates/top_tab_list_two_column_template.dart';
import '../kiosk/templates/dense_grid_template.dart';
import '../kiosk/templates/featured_hero_template.dart';
import '../kiosk/templates/menu_with_cart_sidebar_template.dart';
import '../kiosk/templates/promo_banner_grid_template.dart';
import '../kiosk/templates/restaurant_menu_board_template.dart';
import '../kiosk/templates/restaurant_menu_board_with_cart_template.dart';
import '../kiosk/templates/bento_with_cart_sidebar_template.dart';
import '../kiosk/templates/restaurant_course_navigator_with_cart_template.dart';
import '../kiosk/templates/restaurant_course_navigator_with_cart_image_template.dart';
import '../kiosk/templates/restaurant_spotlight_with_cart_template.dart';
import '../kiosk/templates/coffee_order_pad_with_cart_template.dart';

/// Template Preview & Customization Screen
class TemplateCustomizationScreen extends ConsumerStatefulWidget {
  const TemplateCustomizationScreen({super.key});

  @override
  ConsumerState<TemplateCustomizationScreen> createState() =>
      _TemplateCustomizationScreenState();
}

class _TemplateCustomizationScreenState
    extends ConsumerState<TemplateCustomizationScreen>
    with SingleTickerProviderStateMixin {
  Map<String, List<String>> _featuredProductIds = {};
  bool _showCustomizationPanel = false;
  String? _selectedCategoryForCustomization;
  bool _hasLoadedFeaturedItems = false;
  bool _showAvailableItemsDrawer = false;
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerSlideAnimation;
  final ScrollController _drawerScrollController = ScrollController();
  String? _lastClickedProductId;

  // Store featured items per template
  Map<MenuDisplayTemplate, Map<String, List<String>>> _templateFeaturedItems =
      {};
  MenuDisplayTemplate? _lastLoadedTemplate;

  @override
  void initState() {
    super.initState();
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _drawerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _drawerAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    _drawerScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedFeaturedItems) {
      _loadCurrentFeaturedItems();
      _hasLoadedFeaturedItems = true;
    }
  }

  void _loadCurrentFeaturedItems() {
    final menuState = ref.read(menuProvider);
    final merchantState = ref.read(merchantProvider);
    final selectedTemplate = ref.read(selectedTemplateProvider);
    final actualTemplate =
        selectedTemplate ?? merchantState.menuDisplayTemplate;
    final categories = menuState.sortedCategories;

    // Check if we're switching templates
    final templateChanged =
        _lastLoadedTemplate != null && _lastLoadedTemplate != actualTemplate;
    _lastLoadedTemplate = actualTemplate;

    // ALWAYS load from template-specific storage, never from product flags
    Map<String, List<String>> featuredMap = {};

    // First, try to load from global provider (persisted state)
    final globalFeaturedItems = ref.read(templateFeaturedItemsProvider);
    if (globalFeaturedItems.containsKey(actualTemplate)) {
      featuredMap = Map.from(globalFeaturedItems[actualTemplate]!);
    } else if (_templateFeaturedItems.containsKey(actualTemplate)) {
      // Fallback to local state
      featuredMap = Map.from(_templateFeaturedItems[actualTemplate]!);
    } else {
      // First time loading this template - apply smart defaults
      if (categories.isNotEmpty &&
          _templateSupportsFeaturedSection(actualTemplate)) {
        featuredMap = _getDefaultFeaturedItems(
          actualTemplate,
          categories,
          menuState,
        );
      }
    }

    // Store featured items for this template (both local and global)
    _templateFeaturedItems[actualTemplate] = Map.from(featuredMap);

    // Delay provider modification to avoid modifying during build
    Future(() {
      final currentGlobal = ref.read(templateFeaturedItemsProvider);
      final updated = Map<MenuDisplayTemplate, Map<String, List<String>>>.from(
        currentGlobal,
      );
      updated[actualTemplate] = Map.from(featuredMap);
      ref.read(templateFeaturedItemsProvider.notifier).state = updated;
    });

    // Don't apply to products - featured items are read from provider

    setState(() {
      _featuredProductIds = featuredMap;
    });
  }

  Map<String, List<String>> _getDefaultFeaturedItems(
    MenuDisplayTemplate template,
    List categories,
    menuState,
  ) {
    final Map<String, List<String>> featuredMap = {};

    if (categories.isEmpty) return featuredMap;

    // Apply template-specific defaults
    if (template == MenuDisplayTemplate.chefSpecialsBoard) {
      // Chef's Specials: 4 items max (global) - ONLY first category
      final firstCategory = categories.first;
      final products = menuState.getProductsByCategory(firstCategory.id);
      if (products.isNotEmpty) {
        final count = products.length >= 4 ? 4 : products.length;
        featuredMap[firstCategory.id] = products
            .take(count)
            .map<String>((p) => p.id as String)
            .toList();
      }
    } else if (template == MenuDisplayTemplate.coffeeBaristaFlow) {
      // Coffee Barista Flow: 4 items max per category - ONLY first 2 categories
      final categoriesToUse = categories.take(2);
      for (final category in categoriesToUse) {
        final products = menuState.getProductsByCategory(category.id);
        if (products.isNotEmpty) {
          final count = products.length >= 4 ? 4 : products.length;
          featuredMap[category.id] = products
              .take(count)
              .map<String>((p) => p.id as String)
              .toList();
        }
      }
    } else if (template == MenuDisplayTemplate.bentoHighlights ||
        template == MenuDisplayTemplate.bentoWithCartSidebar) {
      // Bento Highlights: 5 items max, minimum 2 - ONLY first category
      final firstCategory = categories.first;
      final products = menuState.getProductsByCategory(firstCategory.id);
      if (products.length >= 2) {
        final count = products.length >= 5 ? 5 : products.length;
        featuredMap[firstCategory.id] = products
            .take(count)
            .map<String>((p) => p.id as String)
            .toList();
      }
    } else if (template == MenuDisplayTemplate.restaurantSpotlightWithCart) {
      // Restaurant Spotlight: 1 item only - ONLY first category
      final firstCategory = categories.first;
      final products = menuState.getProductsByCategory(firstCategory.id);
      if (products.isNotEmpty) {
        featuredMap[firstCategory.id] = [products.first.id as String];
      }
    } else {
      // Default for other templates: 3 items max - ONLY first category
      final firstCategory = categories.first;
      final products = menuState.getProductsByCategory(firstCategory.id);
      if (products.isNotEmpty) {
        final count = products.length >= 3 ? 3 : products.length;
        featuredMap[firstCategory.id] = products
            .take(count)
            .map<String>((p) => p.id as String)
            .toList();
      }
    }

    return featuredMap;
  }

  void _applyFeaturedItemsToProducts(Map<String, List<String>> featuredMap) {
    final menuState = ref.read(menuProvider);
    final merchantState = ref.read(merchantProvider);
    final selectedTemplate = ref.read(selectedTemplateProvider);
    final actualTemplate =
        selectedTemplate ?? merchantState.menuDisplayTemplate;
    final categories = menuState.sortedCategories;

    // CRITICAL: Update the provider so templates can read the featured items
    _templateFeaturedItems[actualTemplate] = Map.from(featuredMap);

    final currentGlobal = ref.read(templateFeaturedItemsProvider);
    final updated = Map<MenuDisplayTemplate, Map<String, List<String>>>.from(
      currentGlobal,
    );
    updated[actualTemplate] = Map.from(featuredMap);
    ref.read(templateFeaturedItemsProvider.notifier).state = updated;

    // Also update product flags for backward compatibility
    for (final category in categories) {
      final products = menuState.getProductsByCategory(category.id);
      final featuredIds = featuredMap[category.id] ?? [];

      for (final product in products) {
        final shouldBeFeatured = featuredIds.contains(product.id);

        // Only update if featured status changed
        if (product.isFeatured != shouldBeFeatured) {
          final updatedProduct = product.copyWith(isFeatured: shouldBeFeatured);
          ref.read(menuProvider.notifier).updateProduct(updatedProduct);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final merchantState = ref.watch(merchantProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final screenSize = MediaQuery.of(context).size;

    // Use selectedTemplateProvider if available, otherwise fall back to merchantState
    final actualTemplate =
        selectedTemplate ?? merchantState.menuDisplayTemplate;

    // Debug: Log the current template
    print(
      '🎨 Preview Template: $actualTemplate (selected: $selectedTemplate, merchant: ${merchantState.menuDisplayTemplate})',
    );

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildPreviewHeader(merchantState, actualTemplate),
          Expanded(
            child: Stack(
              children: [
                // Template Preview
                _buildTemplatePreview(menuState, merchantState, actualTemplate),
                // Customization Panel (Slide-in from right)
                if (_showCustomizationPanel)
                  _buildCustomizationPanel(menuState, actualTemplate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewHeader(
    MerchantState merchantState,
    MenuDisplayTemplate template,
  ) {
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
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Back to Menu',
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

            SizedBox(width: AppSpacing.lg),

            // Title & template info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Template Preview & Customization',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    _getTemplateName(merchantState.menuDisplayTemplate),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Customize button - only show for templates with featured sections
            if (_templateSupportsFeaturedSection(template))
              Material(
                color: _showCustomizationPanel ? AppColors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _showCustomizationPanel = !_showCustomizationPanel;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _showCustomizationPanel
                            ? AppColors.blue
                            : AppColors.textSecondary.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune,
                          size: 18,
                          color: _showCustomizationPanel
                              ? Colors.white
                              : AppColors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _showCustomizationPanel
                              ? 'Hide Customization'
                              : 'Customize',
                          style: AppTypography.bodyMedium.copyWith(
                            color: _showCustomizationPanel
                                ? Colors.white
                                : AppColors.black,
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

  Widget _buildTemplatePreview(
    MenuState menuState,
    MerchantState merchantState,
    MenuDisplayTemplate template,
  ) {
    // Debug: Check if we have data
    print('📱 Building preview for: $template');
    print('   Categories: ${menuState.sortedCategories.length}');

    return Container(
      margin: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if we have valid data to display
            if (menuState.sortedCategories.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: AppColors.textSecondary.withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No menu data available',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please add categories and products in Menu Management',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Provide explicit size constraints for the template
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: _buildActualTemplate(template),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActualTemplate(MenuDisplayTemplate template) {
    // Wrap template with error boundary
    try {
      switch (template) {
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
    } catch (e) {
      print('❌ Error building template $template: $e');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'Preview Error',
                style: AppTypography.h3.copyWith(color: Colors.red),
              ),
              SizedBox(height: 8),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildProductsPreviewGrid(
    MenuState menuState,
    List<Category> categories,
  ) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No products to preview',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final firstCategory = categories.first;
    final products = menuState.getProductsByCategory(firstCategory.id);
    final featuredIds = _featuredProductIds[firstCategory.id] ?? [];

    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.take(9).length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isFeatured = featuredIds.contains(product.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isFeatured
                  ? AppColors.blue
                  : AppColors.textSecondary.withOpacity(0.15),
              width: isFeatured ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isFeatured
                    ? AppColors.blue.withOpacity(0.15)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isFeatured ? 12 : 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with featured badge
              Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.05),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(13),
                      ),
                    ),
                    child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(13),
                            ),
                            child: Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_outlined,
                                color: AppColors.textSecondary.withOpacity(0.3),
                                size: 32,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: AppColors.textSecondary.withOpacity(0.3),
                            size: 32,
                          ),
                  ),
                  if (isFeatured)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Featured',
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomizationPanel(
    MenuState menuState,
    MenuDisplayTemplate template,
  ) {
    final categories = menuState.sortedCategories;

    // Ensure _selectedCategoryForCustomization is set
    if (_selectedCategoryForCustomization == null && categories.isNotEmpty) {
      _selectedCategoryForCustomization = categories.first.id;
    }

    final selectedCategory = _selectedCategoryForCustomization != null
        ? categories.firstWhere(
            (c) => c.id == _selectedCategoryForCustomization,
            orElse: () => categories.first,
          )
        : categories.first;

    final products = menuState.getProductsByCategory(selectedCategory.id);
    final featuredIds = _featuredProductIds[selectedCategory.id] ?? [];

    // Get template-specific description and limits
    final templateDescription = _getTemplateFeatureDescription(template);
    final maxFeatured = _getMaxFeaturedItems(template);

    // Check if we can add more based on limit type
    final bool canAddMore;
    if (maxFeatured == null) {
      canAddMore = true;
    } else if (_isPerCategoryLimit(template)) {
      // Per-category limit: check current category's count
      canAddMore = featuredIds.length < maxFeatured;
    } else {
      // Global limit: check total count across all categories
      final totalFeaturedCount = _getTotalFeaturedCount();
      canAddMore = totalFeaturedCount < maxFeatured;
    }

    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      width: 380,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(-4, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Panel Header
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
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.blue,
                              AppColors.blue.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.star, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Featured Items',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              templateDescription,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _showCustomizationPanel = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Featured Items Display Toggle
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hide from Regular Menu',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Show featured items only in highlight section',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: ref.watch(hideFeaturedFromMenuProvider),
                        activeColor: AppColors.blue,
                        onChanged: (value) {
                          ref
                                  .read(hideFeaturedFromMenuProvider.notifier)
                                  .state =
                              value;
                        },
                      ),
                    ],
                  ),
                ),

                // Category Selector
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Category',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: categories.map((category) {
                          final isSelected = category.id == selectedCategory.id;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategoryForCustomization = category.id;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.blue
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.blue
                                      : AppColors.textSecondary.withOpacity(
                                          0.2,
                                        ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                category.name,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1),

                // Products List
                Expanded(
                  child: Column(
                    children: [
                      // Featured Items Section (Drag to Reorder)
                      if (featuredIds.isNotEmpty) ...[
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
                              Icon(
                                Icons.drag_indicator,
                                size: 16,
                                color: AppColors.blue,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Featured Items (Drag to Reorder)',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  () {
                                    if (_isPerCategoryLimit(template)) {
                                      // Show per-category count
                                      return '${featuredIds.length}${maxFeatured != null ? " / $maxFeatured" : ""}';
                                    } else {
                                      // Show total count across all categories
                                      final totalCount =
                                          _getTotalFeaturedCount();
                                      return '${totalCount}${maxFeatured != null ? " / $maxFeatured" : ""}';
                                    }
                                  }(),
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: maxFeatured != null && maxFeatured! <= 2
                                ? 140
                                : 200,
                          ),
                          child: ReorderableListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            itemCount: featuredIds.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final item = featuredIds.removeAt(oldIndex);
                                featuredIds.insert(newIndex, item);
                                _featuredProductIds[selectedCategory.id] =
                                    featuredIds;
                              });
                            },
                            itemBuilder: (context, index) {
                              final productId = featuredIds[index];
                              final product = products.firstWhere(
                                (p) => p.id == productId,
                                orElse: () => products.first,
                              );

                              return Container(
                                key: ValueKey(product.id),
                                margin: EdgeInsets.only(bottom: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.blue.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: 6,
                                  ),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.drag_handle,
                                        color: AppColors.blue,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Stack(
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: AppColors.textSecondary
                                                  .withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            child: product.imageUrl != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          7,
                                                        ),
                                                    child: Image.network(
                                                      product.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) => Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 16,
                                                            color: AppColors
                                                                .textSecondary
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                          ),
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.image_outlined,
                                                    size: 16,
                                                    color: AppColors
                                                        .textSecondary
                                                        .withOpacity(0.3),
                                                  ),
                                          ),
                                          Positioned(
                                            right: -3,
                                            top: -3,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: AppColors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    product.name,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close, size: 16),
                                    color: AppColors.textSecondary,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _featuredProductIds[selectedCategory
                                                .id]!
                                            .remove(product.id);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(height: 1),
                      ],

                      // Available Items Section (only show when no featured items)
                      if (featuredIds.isEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Available Items',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textSecondary.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '${products.where((p) => !featuredIds.contains(p.id)).length}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final isFeatured = featuredIds.contains(
                                product.id,
                              );

                              // Don't show already featured items in this section
                              if (isFeatured) return SizedBox.shrink();

                              // Recalculate canAddMore for each item to ensure it's current
                              final currentFeaturedIds =
                                  _featuredProductIds[selectedCategory.id] ??
                                  [];
                              final bool itemCanAddMore;
                              if (maxFeatured == null) {
                                itemCanAddMore = true;
                              } else if (_isPerCategoryLimit(template)) {
                                // Per-category limit: check current category's count
                                itemCanAddMore =
                                    currentFeaturedIds.length < maxFeatured;
                              } else {
                                // Global limit: check total count across all categories
                                final totalFeaturedCount =
                                    _getTotalFeaturedCount();
                                itemCanAddMore =
                                    totalFeaturedCount < maxFeatured;
                              }

                              return Container(
                                margin: EdgeInsets.only(bottom: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.textSecondary.withOpacity(
                                      0.15,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(AppSpacing.sm),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: product.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              product.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Icon(
                                                    Icons.image_outlined,
                                                    size: 20,
                                                    color: AppColors
                                                        .textSecondary
                                                        .withOpacity(0.3),
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.image_outlined,
                                            size: 20,
                                            color: AppColors.textSecondary
                                                .withOpacity(0.3),
                                          ),
                                  ),
                                  title: Text(
                                    product.name,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add_circle, size: 24),
                                    color: itemCanAddMore
                                        ? AppColors.blue.withOpacity(0.5)
                                        : AppColors.textSecondary.withOpacity(
                                            0.3,
                                          ),
                                    onPressed: itemCanAddMore
                                        ? () {
                                            // Store product ID for scrolling
                                            _lastClickedProductId = product.id;

                                            final wasEmpty =
                                                (_featuredProductIds[selectedCategory
                                                            .id] ??
                                                        [])
                                                    .isEmpty;

                                            setState(() {
                                              if (!_featuredProductIds
                                                  .containsKey(
                                                    selectedCategory.id,
                                                  )) {
                                                _featuredProductIds[selectedCategory
                                                        .id] =
                                                    [];
                                              }

                                              // For templates with max 1, replace existing
                                              if (maxFeatured == 1 &&
                                                  featuredIds.isNotEmpty) {
                                                _featuredProductIds[selectedCategory
                                                        .id]!
                                                    .clear();
                                              }

                                              _featuredProductIds[selectedCategory
                                                      .id]!
                                                  .add(product.id);

                                              // Open drawer when first item is featured
                                              if (wasEmpty) {
                                                _showAvailableItemsDrawer =
                                                    true;
                                              }
                                            });

                                            // Animate drawer and scroll to item
                                            if (wasEmpty) {
                                              Future.delayed(
                                                Duration(milliseconds: 100),
                                                () {
                                                  if (mounted) {
                                                    _drawerAnimationController
                                                        .forward();
                                                    _scrollToClickedItem(
                                                      selectedCategory.id,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          }
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Save Button
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.textSecondary.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate minimum requirements for bento templates
                      final merchantState = ref.read(merchantProvider);
                      final selectedTemplate = ref.read(
                        selectedTemplateProvider,
                      );
                      final actualTemplate =
                          selectedTemplate ?? merchantState.menuDisplayTemplate;

                      if (actualTemplate ==
                              MenuDisplayTemplate.bentoHighlights ||
                          actualTemplate ==
                              MenuDisplayTemplate.bentoWithCartSidebar) {
                        // Check if any category has less than 2 featured items
                        final menuState = ref.read(menuProvider);
                        final categories = menuState.sortedCategories;

                        for (final category in categories) {
                          final featuredIds =
                              _featuredProductIds[category.id] ?? [];
                          if (featuredIds.isNotEmpty &&
                              featuredIds.length < 2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${category.name} needs at least 2 featured items',
                                ),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                        }
                      }

                      // Update all products with their featured status and order
                      _applyFeaturedItemsToProducts(_featuredProductIds);

                      setState(() {
                        _showCustomizationPanel = false;
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Featured items updated successfully!',
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Apply Changes',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Drawer Toggle Button (shown when featured items exist and drawer is closed)
            if (_selectedCategoryForCustomization != null &&
                (_featuredProductIds[_selectedCategoryForCustomization] ?? [])
                    .isNotEmpty &&
                !_showAvailableItemsDrawer)
              Positioned(
                left: 0,
                bottom: 100,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAvailableItemsDrawer = true;
                    });
                    _drawerAnimationController.forward();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.blue,
                          AppColors.blue.withOpacity(0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Add',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Slide-out Drawer Panel (Left Side)
            if (_showAvailableItemsDrawer &&
                _selectedCategoryForCustomization != null)
              Positioned(
                left: -380,
                top: MediaQuery.of(context).size.height * 0.25,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(1, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: _drawerAnimationController,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: Container(
                    width: 380,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                          offset: Offset(5, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Drawer Header
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
                              Icon(
                                Icons.add_circle_outline,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Available Items',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final menuState = ref.watch(menuProvider);
                                  final selectedCategory = menuState
                                      .sortedCategories
                                      .firstWhere(
                                        (c) =>
                                            c.id ==
                                            _selectedCategoryForCustomization,
                                      );
                                  final products = menuState
                                      .getProductsByCategory(
                                        selectedCategory.id,
                                      );
                                  final featuredIds =
                                      _featuredProductIds[selectedCategory
                                          .id] ??
                                      [];
                                  final availableCount = products
                                      .where((p) => !featuredIds.contains(p.id))
                                      .length;

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.textSecondary
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      '$availableCount',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.close, size: 20),
                                color: AppColors.textSecondary,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showAvailableItemsDrawer = false;
                                  });
                                  _drawerAnimationController.reverse();
                                },
                              ),
                            ],
                          ),
                        ),

                        // Vertical Product List
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final menuState = ref.watch(menuProvider);
                              final merchantState = ref.watch(merchantProvider);
                              final selectedTemplate = ref.watch(
                                selectedTemplateProvider,
                              );
                              final actualTemplate =
                                  selectedTemplate ??
                                  merchantState.menuDisplayTemplate;
                              final maxFeatured =
                                  _getMaxFeaturedItems(actualTemplate) ?? 999;

                              final selectedCategory = menuState
                                  .sortedCategories
                                  .firstWhere(
                                    (c) =>
                                        c.id ==
                                        _selectedCategoryForCustomization,
                                  );
                              final products = menuState.getProductsByCategory(
                                selectedCategory.id,
                              );
                              final featuredIds =
                                  _featuredProductIds[selectedCategory.id] ??
                                  [];

                              // Check if we can add more based on limit type
                              final bool canAddMore;
                              if (maxFeatured == 999) {
                                canAddMore = true;
                              } else if (_isPerCategoryLimit(actualTemplate)) {
                                // Per-category limit: check current category's count
                                canAddMore = featuredIds.length < maxFeatured;
                              } else {
                                // Global limit: check total count across all categories
                                final totalFeaturedCount =
                                    _getTotalFeaturedCount();
                                canAddMore = totalFeaturedCount < maxFeatured;
                              }

                              return ListView.builder(
                                controller: _drawerScrollController,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final isFeatured = featuredIds.contains(
                                    product.id,
                                  );

                                  return Container(
                                    margin: EdgeInsets.only(
                                      bottom: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFeatured
                                          ? AppColors.blue.withOpacity(0.08)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isFeatured
                                            ? AppColors.blue.withOpacity(0.3)
                                            : AppColors.textSecondary
                                                  .withOpacity(0.15),
                                        width: isFeatured ? 2 : 1,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(
                                        AppSpacing.sm,
                                      ),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.textSecondary
                                              .withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: product.imageUrl != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  product.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Icon(
                                                        Icons.image_outlined,
                                                        size: 20,
                                                        color: AppColors
                                                            .textSecondary
                                                            .withOpacity(0.3),
                                                      ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.image_outlined,
                                                size: 20,
                                                color: AppColors.textSecondary
                                                    .withOpacity(0.3),
                                              ),
                                      ),
                                      title: Text(
                                        product.name,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          isFeatured
                                              ? Icons.check_circle
                                              : Icons.add_circle,
                                          size: 24,
                                        ),
                                        color: isFeatured
                                            ? AppColors.blue
                                            : (canAddMore
                                                  ? AppColors.blue.withOpacity(
                                                      0.5,
                                                    )
                                                  : AppColors.textSecondary
                                                        .withOpacity(0.3)),
                                        onPressed: isFeatured
                                            ? () {
                                                // Remove from featured
                                                setState(() {
                                                  _featuredProductIds[selectedCategory
                                                          .id]!
                                                      .remove(product.id);
                                                });
                                              }
                                            : (canAddMore
                                                  ? () {
                                                      setState(() {
                                                        if (!_featuredProductIds
                                                            .containsKey(
                                                              selectedCategory
                                                                  .id,
                                                            )) {
                                                          _featuredProductIds[selectedCategory
                                                                  .id] =
                                                              [];
                                                        }

                                                        // For templates with max 1, replace existing
                                                        if (maxFeatured == 1 &&
                                                            featuredIds
                                                                .isNotEmpty) {
                                                          _featuredProductIds[selectedCategory
                                                                  .id]!
                                                              .clear();
                                                        }

                                                        _featuredProductIds[selectedCategory
                                                                .id]!
                                                            .add(product.id);
                                                      });
                                                    }
                                                  : null),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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

  void _scrollToClickedItem(String categoryId) {
    if (_lastClickedProductId == null) return;

    // Get products for the category
    final menuState = ref.read(menuProvider);
    final products = menuState.getProductsByCategory(categoryId);

    // Find index of clicked product
    final index = products.indexWhere((p) => p.id == _lastClickedProductId);

    if (index != -1 && _drawerScrollController.hasClients) {
      // Calculate scroll position (each item is roughly 82px tall including margin)
      final itemHeight = 82.0;
      final scrollPosition = index * itemHeight;

      // Jump to position without animation
      _drawerScrollController.jumpTo(
        scrollPosition.clamp(
          0.0,
          _drawerScrollController.position.maxScrollExtent,
        ),
      );
    }
  }

  String _getTemplateFeatureDescription(MenuDisplayTemplate template) {
    switch (template) {
      case MenuDisplayTemplate.chefSpecialsBoard:
        return 'Set featured highlights from any category (max 4 total across all categories)';
      case MenuDisplayTemplate.restaurantSpotlightWithCart:
        return 'Set ONE spotlight item per category (max 1 per category)';
      case MenuDisplayTemplate.coffeeBaristaFlow:
        return 'Set featured items from any category (max 4 per category)';
      case MenuDisplayTemplate.bentoHighlights:
      case MenuDisplayTemplate.bentoWithCartSidebar:
        return 'Set bento highlights for each category (max 5 per category)';
      case MenuDisplayTemplate.promoBannerGrid:
        return 'Set featured items shown on the right of each category';
      case MenuDisplayTemplate.featuredHero:
        return 'Set hero featured items for prominent display';
      case MenuDisplayTemplate.restaurantMenuBoard:
      case MenuDisplayTemplate.restaurantMenuBoardWithCart:
        return 'Mark special items with featured badge';
      default:
        return 'Highlight best sellers and popular items';
    }
  }

  bool _templateSupportsFeaturedSection(MenuDisplayTemplate template) {
    // Return true only for templates that have dedicated featured/spotlight sections
    switch (template) {
      case MenuDisplayTemplate.chefSpecialsBoard:
      case MenuDisplayTemplate.restaurantSpotlightWithCart:
      case MenuDisplayTemplate.coffeeBaristaFlow:
      case MenuDisplayTemplate.bentoHighlights:
      case MenuDisplayTemplate.bentoWithCartSidebar:
      case MenuDisplayTemplate.promoBannerGrid:
      case MenuDisplayTemplate.featuredHero:
      case MenuDisplayTemplate.coffeeBaristaWithCheckout:
      case MenuDisplayTemplate.courseSectionsRail:
      case MenuDisplayTemplate.coffeeTiles:
        return true;
      default:
        return false; // No dedicated featured section
    }
  }

  int? _getMaxFeaturedItems(MenuDisplayTemplate template) {
    switch (template) {
      case MenuDisplayTemplate.restaurantSpotlightWithCart:
        return 1; // Only 1 spotlight item per category
      case MenuDisplayTemplate.chefSpecialsBoard:
        return 4; // Maximum 4 featured items total (all categories)
      case MenuDisplayTemplate.coffeeBaristaFlow:
        return 4; // Maximum 4 featured items per category
      case MenuDisplayTemplate.bentoHighlights:
      case MenuDisplayTemplate.bentoWithCartSidebar:
        return 5; // Maximum 5 bento highlights per category
      default:
        return null; // No limit for other templates
    }
  }

  // Returns true if template has per-category limits (not global)
  bool _isPerCategoryLimit(MenuDisplayTemplate template) {
    switch (template) {
      case MenuDisplayTemplate.restaurantSpotlightWithCart:
      case MenuDisplayTemplate.bentoHighlights:
      case MenuDisplayTemplate.bentoWithCartSidebar:
      case MenuDisplayTemplate.coffeeBaristaFlow:
        return true; // Per-category limits
      case MenuDisplayTemplate.chefSpecialsBoard:
        return false; // Global limits across all categories
      default:
        return false;
    }
  }

  // Count total featured items across ALL categories
  int _getTotalFeaturedCount() {
    int total = 0;
    for (final featuredList in _featuredProductIds.values) {
      total += featuredList.length;
    }
    return total;
  }

  String _getTemplateName(MenuDisplayTemplate? template) {
    if (template == null) return 'Category Sidebar';
    return template
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }
}
