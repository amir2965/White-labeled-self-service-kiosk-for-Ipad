import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../demo/demo_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../kiosk/menu_template_config.dart';
import '../../kiosk/template_preview_screen.dart';

class TemplateSelectionStep extends ConsumerStatefulWidget {
  final String? selectedTemplateId;
  final void Function(String, MenuDisplayTemplate) onSelected;

  const TemplateSelectionStep({
    super.key,
    required this.selectedTemplateId,
    required this.onSelected,
  });

  @override
  ConsumerState<TemplateSelectionStep> createState() =>
      _TemplateSelectionStepState();
}

class _TemplateSelectionStepState extends ConsumerState<TemplateSelectionStep> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  double _maxScrollExtent = 1.0;
  bool _showScrollIndicator = false;

  MenuDisplayTemplate? _selectedTemplate;

  final _templates = const [
    _TemplateOption(
      id: 'category-sidebar',
      template: MenuDisplayTemplate.categorySidebar,
      name: 'Category Sidebar',
      description: 'Persistent left sidebar with categories and product grid',
      bestFor: 'Cafés with diverse menus (30+ products, 5-12 categories)',
      icon: Icons.view_sidebar,
      isRecommended: true,
    ),
    _TemplateOption(
      id: 'coffee-barista-flow',
      template: MenuDisplayTemplate.coffeeBaristaFlow,
      name: 'Coffee Barista Flow',
      description: '3-column flow with presets + big buttons + upsell panel',
      bestFor: 'Cafés that want fast, guided ordering',
      icon: Icons.coffee_maker,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'chefs-specials-board',
      template: MenuDisplayTemplate.chefSpecialsBoard,
      name: "Chef's Specials Board",
      description:
          'Editorial layout with a featured rail + sectioned categories',
      bestFor: 'Restaurants with rotating specials and curated menus',
      icon: Icons.restaurant_menu,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'menu-with-cart-sidebar',
      template: MenuDisplayTemplate.menuWithCartSidebar,
      name: 'Menu + Cart Sidebar',
      description: '3-pane layout with an always-visible cart and checkout',
      bestFor: 'High-volume venues where speed matters',
      icon: Icons.shopping_cart_checkout,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'restaurant-course-navigator-with-cart',
      template: MenuDisplayTemplate.restaurantCourseNavigatorWithCart,
      name: 'Course Navigator + Cart',
      description: 'Left course navigator + fast-add list + cart on right',
      bestFor: 'Full-service restaurants with clear courses and quick ordering',
      icon: Icons.menu_book,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'restaurant-course-navigator-with-cart-image',
      template: MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage,
      name: 'Course Navigator + Cart (Images)',
      description: 'Course navigator + large menu items with images + cart',
      bestFor: 'Restaurants showcasing dishes with professional photography',
      icon: Icons.photo_library,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'restaurant-spotlight-with-cart',
      template: MenuDisplayTemplate.restaurantSpotlightWithCart,
      name: 'Restaurant Spotlight + Cart',
      description: 'Hero spotlight + gallery grid + cart on right',
      bestFor: 'Restaurants that want a premium, editorial menu feel',
      icon: Icons.star_outline,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'restaurant-menu-board-with-cart',
      template: MenuDisplayTemplate.restaurantMenuBoardWithCart,
      name: 'Restaurant Menu Board + Cart',
      description: 'Classic menu board list + always-visible cart on right',
      bestFor: 'Restaurants that want minimal browsing + fast checkout',
      icon: Icons.receipt_long,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'bento-highlights-with-cart',
      template: MenuDisplayTemplate.bentoWithCartSidebar,
      name: 'Bento Highlights + Cart',
      description: 'Bento highlights + grid + always-visible cart on right',
      bestFor: 'Highlight-driven restaurants with quick checkout',
      icon: Icons.dashboard_customize,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'coffee-barista-with-checkout',
      template: MenuDisplayTemplate.coffeeBaristaWithCheckout,
      name: 'Coffee Barista + Checkout',
      description: '3-column flow with presets + big buttons + checkout bar',
      bestFor: 'Cafés that want fast ordering with visible checkout',
      icon: Icons.shopping_basket,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'course-sections-retail-1',
      template: MenuDisplayTemplate.courseSectionsRetail1,
      name: 'Course Sections Rail',
      description:
          'Modern retail-style with horizontal rails and multi-row layout',
      bestFor: 'Retail and boutique stores with diverse product categories',
      icon: Icons.store,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'restaurant-menu-board',
      template: MenuDisplayTemplate.restaurantMenuBoard,
      name: 'Restaurant Menu Board',
      description: 'Typography-first menu board list (no cards)',
      bestFor: 'Upscale, classic, or minimal restaurant menus',
      icon: Icons.receipt_long,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'bento-highlights',
      template: MenuDisplayTemplate.bentoHighlights,
      name: 'Bento Highlights',
      description: 'Bento highlight tiles + modern grid',
      bestFor: 'Restaurants that promote specials and best sellers',
      icon: Icons.dashboard_customize,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'category-landing',
      template: MenuDisplayTemplate.categoryLanding,
      name: 'Category Landing',
      description: 'Start with category tiles → drill down into products',
      bestFor: 'New customers, large menus, and simple browsing',
      icon: Icons.space_dashboard,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'promo-banner-grid',
      template: MenuDisplayTemplate.promoBannerGrid,
      name: 'Promo Banner Grid',
      description: 'Promo banner + category chips + spacious grid',
      bestFor: 'Modern venues with daily specials or promos',
      icon: Icons.local_offer,
      isRecommended: false,
    ),

    _TemplateOption(
      id: 'top-tabs-1-col',
      template: MenuDisplayTemplate.topTabListOneColumn,
      name: 'Top Tabs (1 Column)',
      description: 'Horizontal category tabs with detailed rows',
      bestFor: 'Smaller menus that benefit from descriptions',
      icon: Icons.view_week,
      isRecommended: false,
    ),
    _TemplateOption(
      id: 'top-tabs-2-col',
      template: MenuDisplayTemplate.topTabListTwoColumn,
      name: 'Top Tabs (2 Column)',
      description: 'Horizontal category tabs with a denser two-column layout',
      bestFor: 'Medium menus that need more items above the fold',
      icon: Icons.table_rows,
      isRecommended: false,
    ),
  ];

  // The web demo leaves out layouts that do not add anything to a short walkthrough.
  List<_TemplateOption> get _visibleTemplates => DemoConfig.enabled
      ? _templates
            .where(
              (t) => t.template != MenuDisplayTemplate.coffeeBaristaWithCheckout,
            )
            .toList()
      : _templates;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize with selected template if available
    if (widget.selectedTemplateId != null) {
      final matchedTemplate = _templates
          .where((t) => t.id == widget.selectedTemplateId)
          .firstOrNull;
      if (matchedTemplate != null) {
        _selectedTemplate = matchedTemplate.template;
      }
    }

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && _scrollController.hasClients) {
        setState(() {
          _maxScrollExtent = _scrollController.position.maxScrollExtent;
          _showScrollIndicator = _maxScrollExtent > 50;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController.offset;
        _maxScrollExtent = _scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent && _scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final target = (_scrollController.offset + event.scrollDelta.dy)
              .clamp(0.0, maxScroll);
          _scrollController.jumpTo(target);
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 48.0 : AppSpacing.screenPadding,
              vertical: AppSpacing.lg,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet
                      ? (DemoConfig.enabled ? 1000.0 : 900.0)
                      : screenWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your menu display style',
                      style: AppTypography.h2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select the layout that best fits your business type and customer flow',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // Template cards (two columns in the wide web demo)
                    if (DemoConfig.enabled && screenWidth >= 900)
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: _visibleTemplates
                            .map(
                              (template) => SizedBox(
                                width:
                                    (math.min(screenWidth - 96, 1000.0) -
                                        AppSpacing.md) /
                                    2,
                                child: _buildTemplateCard(template),
                              ),
                            )
                            .toList(),
                      )
                    else
                      ..._visibleTemplates.map(
                        (template) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md),
                          child: _buildTemplateCard(template),
                        ),
                      ),

                    SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),

          if (_showScrollIndicator && _maxScrollExtent > 50)
            _buildScrollIndicator(isTablet),
        ],
      ),
    );
  }

  void _openPreview(_TemplateOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplatePreviewScreen(
          template: option.template,
          templateName: option.name,
          isOnboarding: true,
        ),
      ),
    );
  }

  Widget _buildTemplateCard(_TemplateOption option) {
    final isSelected = _selectedTemplate == option.template;

    return GestureDetector(
      onTap: () {
        // Web demo: tapping the highlighted card again opens its preview
        if (DemoConfig.enabled && isSelected) {
          _openPreview(option);
          return;
        }
        setState(() {
          _selectedTemplate = option.template;
        });
        widget.onSelected(option.id, option.template);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.blue.withOpacity(0.1)
                    : AppColors.gray300.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                option.icon,
                size: 32,
                color: isSelected ? AppColors.blue : AppColors.gray600,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.name,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (option.isRecommended) ...[
                        SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'RECOMMENDED',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    option.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.gray900,
                    ),
                  ),
                  if (!DemoConfig.enabled) ...[
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: AppColors.gray600,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            option.bestFor,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Preview button for selected
                  if (isSelected && DemoConfig.enabled) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm + 2,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 16,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Tap to preview',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (isSelected) ...[
                    SizedBox(height: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TemplatePreviewScreen(
                              template: _selectedTemplate!,
                              templateName: option.name,
                              isOnboarding: true,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.visibility_outlined, size: 16),
                      label: Text('Preview Template'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.gray600,
                  width: 2,
                ),
                color: isSelected ? AppColors.blue : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollIndicator(bool isTablet) {
    final screenHeight = MediaQuery.of(context).size.height;
    final indicatorHeight = isTablet ? 120.0 : 80.0;
    final trackHeight = screenHeight * 0.6;

    double thumbPosition = 0.0;
    if (_maxScrollExtent > 0) {
      thumbPosition =
          (_scrollOffset / _maxScrollExtent) * (trackHeight - indicatorHeight);
      thumbPosition = thumbPosition.clamp(0.0, trackHeight - indicatorHeight);
    }

    return Positioned(
      right: isTablet ? 16 : 8,
      top: screenHeight * 0.2,
      child: AnimatedOpacity(
        opacity: _scrollOffset > 20 ? 1.0 : 0.3,
        duration: Duration(milliseconds: 200),
        child: Container(
          width: isTablet ? 6 : 4,
          height: trackHeight,
          decoration: BoxDecoration(
            color: AppColors.gray200.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                top: thumbPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withOpacity(0.8),
                        AppColors.blue.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateOption {
  final String id;
  final MenuDisplayTemplate template;
  final String name;
  final String description;
  final String bestFor;
  final IconData icon;
  final bool isRecommended;

  const _TemplateOption({
    required this.id,
    required this.template,
    required this.name,
    required this.description,
    required this.bestFor,
    required this.icon,
    required this.isRecommended,
  });
}
