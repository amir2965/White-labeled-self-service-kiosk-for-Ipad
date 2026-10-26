import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'menu_template_config.dart';
import 'template_preview_screen.dart';
import 'kiosk_welcome_screen.dart';
import '../providers/template_provider.dart';

/// Template selector screen for choosing menu layout
class TemplateSelectorScreen extends ConsumerStatefulWidget {
  final bool fromDashboard;

  const TemplateSelectorScreen({super.key, this.fromDashboard = false});

  @override
  ConsumerState<TemplateSelectorScreen> createState() =>
      _TemplateSelectorScreenState();
}

class _TemplateSelectorScreenState
    extends ConsumerState<TemplateSelectorScreen> {
  MenuDisplayTemplate? _selectedTemplate;

  final _templates = [
    _TemplateOption(
      template: MenuDisplayTemplate.categorySidebar,
      name: 'Category Sidebar',
      description: 'Persistent left sidebar with categories and product grid',
      bestFor: 'Cafés with diverse menus (30+ products, 5-12 categories)',
      icon: Icons.view_sidebar,
      isRecommended: true,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.coffeeBaristaFlow,
      name: 'Coffee Barista Flow',
      description: '3-column flow with presets + big buttons + upsell panel',
      bestFor: 'Cafés that want fast, guided ordering',
      icon: Icons.coffee_maker,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.chefSpecialsBoard,
      name: "Chef's Specials Board",
      description:
          'Editorial layout with a featured rail + sectioned categories',
      bestFor: 'Restaurants with rotating specials and curated menus',
      icon: Icons.restaurant_menu,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.menuWithCartSidebar,
      name: 'Menu + Cart Sidebar',
      description: '3-pane layout with an always-visible cart and checkout',
      bestFor: 'High-volume venues where speed matters',
      icon: Icons.shopping_cart_checkout,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.restaurantCourseNavigatorWithCart,
      name: 'Course Navigator + Cart',
      description: 'Left course navigator + fast-add list + cart on right',
      bestFor: 'Full-service restaurants with clear courses and quick ordering',
      icon: Icons.menu_book,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.restaurantCourseNavigatorWithCartImage,
      name: 'Course Navigator + Cart (Images)',
      description: 'Course navigator + large menu items with images + cart',
      bestFor: 'Restaurants showcasing dishes with professional photography',
      icon: Icons.photo_library,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.restaurantSpotlightWithCart,
      name: 'Restaurant Spotlight + Cart',
      description: 'Hero spotlight + gallery grid + cart on right',
      bestFor: 'Restaurants that want a premium, editorial menu feel',
      icon: Icons.star_outline,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.restaurantMenuBoardWithCart,
      name: 'Restaurant Menu Board + Cart',
      description: 'Classic menu board list with always-visible cart on right',
      bestFor: 'Restaurants that want a minimal menu + fast checkout',
      icon: Icons.receipt_long,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.bentoWithCartSidebar,
      name: 'Bento Highlights + Cart',
      description: 'Bento highlights + grid with always-visible cart on right',
      bestFor:
          'Restaurants promoting highlights while keeping checkout visible',
      icon: Icons.dashboard_customize,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.coffeeBaristaWithCheckout,
      name: 'Coffee Barista + Checkout',
      description: '3-column flow with presets + big buttons + checkout bar',
      bestFor: 'Cafés that want fast ordering with visible checkout',
      icon: Icons.shopping_basket,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.courseSectionsRetail1,
      name: 'Course Sections Rail',
      description:
          'Modern retail-style with horizontal rails and multi-row layout',
      bestFor: 'Retail and boutique stores with diverse product categories',
      icon: Icons.store,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.restaurantMenuBoard,
      name: 'Restaurant Menu Board',
      description: 'Typography-first menu board list (no cards)',
      bestFor: 'Upscale, classic, or minimal restaurant menus',
      icon: Icons.receipt_long,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.bentoHighlights,
      name: 'Bento Highlights',
      description: 'Bento highlight tiles + modern grid',
      bestFor: 'Restaurants that promote specials and best sellers',
      icon: Icons.dashboard_customize,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.categoryLanding,
      name: 'Category Landing',
      description: 'Start with category tiles → drill down into products',
      bestFor: 'New customers, large menus, and simple browsing',
      icon: Icons.space_dashboard,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.promoBannerGrid,
      name: 'Promo Banner Grid',
      description: 'Promo banner + category chips + spacious grid',
      bestFor: 'Modern venues with daily specials or promos',
      icon: Icons.local_offer,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.coffeeTiles,
      name: 'Coffee Tiles',
      description: 'Large drink tiles + quick preferences + compact grid',
      bestFor: 'Cafés that want fast, visual ordering',
      icon: Icons.coffee,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.topTabListOneColumn,
      name: 'Top Tab List (1 Column)',
      description: 'Horizontal tabs with detailed single column product rows',
      bestFor: 'Fast food and QSR - emphasize product descriptions',
      icon: Icons.view_stream,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.topTabListTwoColumn,
      name: 'Top Tab List (2 Column)',
      description: 'Horizontal tabs with two column product layout',
      bestFor: 'Fast food and QSR - show more products at once',
      icon: Icons.view_agenda,
      isRecommended: false,
    ),
    _TemplateOption(
      template: MenuDisplayTemplate.featuredHero,
      name: 'Featured Hero',
      description: 'Large hero section with compact product grid',
      bestFor: 'Menus with “popular items” and seasonal highlights',
      icon: Icons.view_carousel,
      isRecommended: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Load the saved template selection in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedTemplate = ref.read(selectedTemplateProvider);
      if (savedTemplate != null && mounted) {
        setState(() {
          _selectedTemplate = savedTemplate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Menu Template'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your menu display style',
                  style: AppTypography.h2.copyWith(fontSize: 20),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Choose the layout that best fits your business type and customer flow',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                final isSelected = _selectedTemplate == template.template;

                return _TemplateCard(
                  option: template,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedTemplate = template.template;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(color: AppColors.gray300, width: 1),
              ),
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
                  // Preview button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _selectedTemplate == null
                            ? null
                            : () {
                                final selectedOption = _templates.firstWhere(
                                  (t) => t.template == _selectedTemplate,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TemplatePreviewScreen(
                                      template: _selectedTemplate!,
                                      templateName: selectedOption.name,
                                      fromDashboard: widget.fromDashboard,
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.visibility, size: 20),
                        label: const Text(
                          'Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _selectedTemplate == null
                              ? AppColors.gray600
                              : AppColors.black,
                          side: BorderSide(
                            color: _selectedTemplate == null
                                ? AppColors.gray300
                                : AppColors.gray400,
                            width: 2,
                          ),
                          disabledForegroundColor: AppColors.gray400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  // Continue button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _selectedTemplate == null
                            ? null
                            : () {
                                // Save selected template
                                ref
                                    .read(selectedTemplateProvider.notifier)
                                    .selectTemplate(_selectedTemplate!);
                                // Navigate based on context
                                if (widget.fromDashboard) {
                                  // Return to dashboard
                                  Navigator.pop(context);
                                } else {
                                  // Navigate to welcome screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KioskWelcomeScreen(),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.arrow_forward, size: 20),
                        label: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.gray300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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

class _TemplateOption {
  final MenuDisplayTemplate template;
  final String name;
  final String description;
  final String bestFor;
  final IconData icon;
  final bool isRecommended;

  const _TemplateOption({
    required this.template,
    required this.name,
    required this.description,
    required this.bestFor,
    required this.icon,
    required this.isRecommended,
  });
}

class _TemplateCard extends StatelessWidget {
  final _TemplateOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppSpacing.md),
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
                  // Selected hint
                  if (isSelected) ...[
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: AppColors.blue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Tap Preview to see this template in action',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
}
