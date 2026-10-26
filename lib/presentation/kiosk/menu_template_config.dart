/// Menu display template types for kiosk
enum MenuDisplayTemplate {
  categorySidebar, // Persistent left sidebar with categories
  topTabList, // Horizontal tabs with list view (deprecated - use topTabListOneColumn)
  topTabListOneColumn, // Horizontal tabs with single column list view
  topTabListTwoColumn, // Horizontal tabs with two column list view
  featuredHero, // Hero section with compact grid
  denseGrid, // Maximum density information grid
  // New distinct layouts
  coffeeQuickOrder, // Split quick-order rail + explore grid
  chefSpecialsBoard, // Editorial specials rail + sectioned menu
  menuWithCartSidebar, // 3-pane layout with always-visible cart
  // More distinct, modern layouts
  promoBannerGrid, // Promo banner + category chips + modern grid
  courseSectionsRail, // Vertical sections, each with horizontal rail
  courseSectionsRetail1, // Retail-style with horizontal rails and multi-row layout
  coffeeTiles, // Large drink tiles + quick preference chips
  // Even more distinct layouts
  restaurantMenuBoard, // Typography-first menu board list (no cards)
  categoryLanding, // Landing page of categories → drill-down into products
  coffeeBaristaFlow, // 3-column coffee flow with upsell panel
  bentoHighlights, // Bento-style highlight tiles + grid
  // With right checkout sidebar
  restaurantMenuBoardWithCart, // Menu board + cart sidebar
  bentoWithCartSidebar, // Bento highlights + cart sidebar
  // More right checkout sidebar templates (distinct layouts)
  restaurantCourseNavigatorWithCart, // Course navigator + menu list + cart
  restaurantCourseNavigatorWithCartImage, // Course navigator + menu list with images + cart
  restaurantSpotlightWithCart, // Spotlight hero + gallery + cart
  coffeeOrderPadWithCart, // Order pad + browse + cart
  coffeeBaristaWithCheckout, // 3-column coffee flow with checkout bar
}

/// Menu template configuration
class MenuTemplateConfig {
  final MenuDisplayTemplate template;
  final bool showProductImages;
  final bool showProductDescriptions;
  final int gridColumns;
  final bool enableQuickAdd; // Add without opening modal

  const MenuTemplateConfig({
    required this.template,
    this.showProductImages = true,
    this.showProductDescriptions = true,
    this.gridColumns = 3,
    this.enableQuickAdd = false,
  });

  MenuTemplateConfig copyWith({
    MenuDisplayTemplate? template,
    bool? showProductImages,
    bool? showProductDescriptions,
    int? gridColumns,
    bool? enableQuickAdd,
  }) {
    return MenuTemplateConfig(
      template: template ?? this.template,
      showProductImages: showProductImages ?? this.showProductImages,
      showProductDescriptions:
          showProductDescriptions ?? this.showProductDescriptions,
      gridColumns: gridColumns ?? this.gridColumns,
      enableQuickAdd: enableQuickAdd ?? this.enableQuickAdd,
    );
  }
}
