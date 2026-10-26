import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../kiosk/menu_template_config.dart';

/// Provider to store selected menu template
class SelectedTemplateNotifier extends StateNotifier<MenuDisplayTemplate?> {
  SelectedTemplateNotifier() : super(null);

  void selectTemplate(MenuDisplayTemplate template) {
    state = template;
  }

  void clearSelection() {
    state = null;
  }
}

final selectedTemplateProvider =
    StateNotifierProvider<SelectedTemplateNotifier, MenuDisplayTemplate?>(
      (ref) => SelectedTemplateNotifier(),
    );

/// Get template display name
String getTemplateName(MenuDisplayTemplate template) {
  switch (template) {
    case MenuDisplayTemplate.categorySidebar:
      return 'Category Sidebar';
    case MenuDisplayTemplate.topTabList:
      return 'Top Tab List (1 Column)';
    case MenuDisplayTemplate.topTabListOneColumn:
      return 'Top Tab List (1 Column)';
    case MenuDisplayTemplate.topTabListTwoColumn:
      return 'Top Tab List (2 Column)';
    case MenuDisplayTemplate.denseGrid:
      return 'Dense Grid';
    case MenuDisplayTemplate.featuredHero:
      return 'Featured Hero';

    case MenuDisplayTemplate.coffeeQuickOrder:
      return 'Coffee Quick Order';
    case MenuDisplayTemplate.chefSpecialsBoard:
      return "Chef's Specials Board";
    case MenuDisplayTemplate.menuWithCartSidebar:
      return 'Menu + Cart Sidebar';

    case MenuDisplayTemplate.promoBannerGrid:
      return 'Promo Banner Grid';
    case MenuDisplayTemplate.courseSectionsRail:
      return 'Course Sections Rail';
    case MenuDisplayTemplate.courseSectionsRetail1:
      return 'Course Sections Rail';
    case MenuDisplayTemplate.coffeeTiles:
      return 'Coffee Tiles';

    case MenuDisplayTemplate.restaurantMenuBoard:
      return 'Restaurant Menu Board';
    case MenuDisplayTemplate.categoryLanding:
      return 'Category Landing';
    case MenuDisplayTemplate.coffeeBaristaFlow:
      return 'Coffee Barista Flow';
    case MenuDisplayTemplate.bentoHighlights:
      return 'Bento Highlights';

    case MenuDisplayTemplate.restaurantMenuBoardWithCart:
      return 'Restaurant Menu Board + Cart';
    case MenuDisplayTemplate.bentoWithCartSidebar:
      return 'Bento Highlights + Cart';

    case MenuDisplayTemplate.restaurantCourseNavigatorWithCart:
      return 'Course Navigator + Cart';
    case MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage:
      return 'Course Navigator + Cart (Images)';
    case MenuDisplayTemplate.restaurantSpotlightWithCart:
      return 'Restaurant Spotlight + Cart';
    case MenuDisplayTemplate.coffeeOrderPadWithCart:
      return 'Coffee Order Pad + Cart';
    case MenuDisplayTemplate.coffeeBaristaWithCheckout:
      return 'Coffee Barista + Checkout';
  }
}

/// Get template description
String getTemplateDescription(MenuDisplayTemplate template) {
  switch (template) {
    case MenuDisplayTemplate.categorySidebar:
      return 'Left sidebar with product grid';
    case MenuDisplayTemplate.topTabList:
      return 'Horizontal tabs with detailed rows';
    case MenuDisplayTemplate.topTabListOneColumn:
      return 'Horizontal tabs with detailed rows';
    case MenuDisplayTemplate.topTabListTwoColumn:
      return 'Horizontal tabs with two columns';
    case MenuDisplayTemplate.denseGrid:
      return 'Maximum density with filter chips';
    case MenuDisplayTemplate.featuredHero:
      return 'Hero section with compact grid';

    case MenuDisplayTemplate.coffeeQuickOrder:
      return 'Fast ordering rail + browse grid (ideal for cafes)';
    case MenuDisplayTemplate.chefSpecialsBoard:
      return 'Editorial specials + sectioned categories (ideal for restaurants)';
    case MenuDisplayTemplate.menuWithCartSidebar:
      return 'Always-visible cart with 3-pane browsing (ideal for high-volume)';

    case MenuDisplayTemplate.promoBannerGrid:
      return 'Promo banner + category chips + spacious grid (ideal for modern venues)';
    case MenuDisplayTemplate.courseSectionsRail:
      return 'Restaurant-style course browsing with swipeable rails';
    case MenuDisplayTemplate.courseSectionsRetail1:
      return 'Modern retail-style with horizontal rails and multi-row layout';
    case MenuDisplayTemplate.coffeeTiles:
      return 'Large drink tiles + quick preferences + compact browse grid';

    case MenuDisplayTemplate.restaurantMenuBoard:
      return 'Typography-first restaurant menu list (classic, minimal)';
    case MenuDisplayTemplate.categoryLanding:
      return 'Category landing tiles → drill down into products';
    case MenuDisplayTemplate.coffeeBaristaFlow:
      return '3-column coffee flow with presets + upsell panel';
    case MenuDisplayTemplate.bentoHighlights:
      return 'Bento-style highlights (1 large + 2 small) then grid';

    case MenuDisplayTemplate.restaurantMenuBoardWithCart:
      return 'Classic menu board with always-visible checkout sidebar';
    case MenuDisplayTemplate.bentoWithCartSidebar:
      return 'Bento highlights + grid with always-visible checkout sidebar';

    case MenuDisplayTemplate.restaurantCourseNavigatorWithCart:
      return 'Left course navigator + fast-add list + always-visible checkout sidebar';
    case MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage:
      return 'Course navigator + large menu items with images + always-visible checkout sidebar';
    case MenuDisplayTemplate.restaurantSpotlightWithCart:
      return 'Spotlight hero + gallery layout with always-visible checkout sidebar';
    case MenuDisplayTemplate.coffeeOrderPadWithCart:
      return 'Order-pad preferences + favorites + browse grid with always-visible checkout sidebar';
    case MenuDisplayTemplate.coffeeBaristaWithCheckout:
      return '3-column coffee flow with presets + checkout bar (no upsell)';
  }
}
