import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../domain/entities/product.dart';
import '../../providers/menu_provider.dart';
import '../../providers/featured_display_provider.dart';
import '../product_details_screen.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Chef Specials Board
/// Editorial/restaurant style: "Chef's picks" + Category pages
class ChefSpecialsBoardTemplate extends ConsumerStatefulWidget {
  const ChefSpecialsBoardTemplate({super.key});

  @override
  ConsumerState<ChefSpecialsBoardTemplate> createState() =>
      _ChefSpecialsBoardTemplateState();
}

class _ChefSpecialsBoardTemplateState
    extends ConsumerState<ChefSpecialsBoardTemplate> {
  final Map<String, GlobalKey> _sectionKeys = {};
  final Map<String, GlobalKey> _navPillKeys = {};
  String _selectedCategoryId = 'board';

  ScrollController? _navScrollController;
  ScrollController? _mainScrollController;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _sectionKeys['board'] = GlobalKey();
    _navPillKeys['board'] = GlobalKey();
    _navScrollController = ScrollController();
    _mainScrollController = ScrollController();
    _mainScrollController?.addListener(_checkActiveSection);
  }

  @override
  void dispose() {
    _mainScrollController?.removeListener(_checkActiveSection);
    _mainScrollController?.dispose();
    _navScrollController?.dispose();
    super.dispose();
  }

  void _checkActiveSection() {
    if (_isProgrammaticScroll) return;

    final menuState = ref.read(menuProvider);
    final categories = menuState.sortedCategories;
    String? newActiveSection;

    // Check board
    final boardKey = _sectionKeys['board'];
    if (boardKey?.currentContext != null) {
      try {
        final renderBox =
            boardKey!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final position = renderBox.localToGlobal(Offset.zero);
          if (position.dy >= -200 && position.dy <= 300) {
            newActiveSection = 'board';
          }
        }
      } catch (_) {}
    }

    // Check categories
    if (newActiveSection == null) {
      for (var category in categories) {
        final key = _sectionKeys[category.id];
        if (key?.currentContext != null) {
          try {
            final renderBox =
                key!.currentContext!.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              final position = renderBox.localToGlobal(Offset.zero);
              if (position.dy >= -100 && position.dy <= 300) {
                newActiveSection = category.id;
                break;
              }
            }
          } catch (_) {}
        }
      }
    }

    // Update if changed
    if (newActiveSection != null && newActiveSection != _selectedCategoryId) {
      setState(() {
        _selectedCategoryId = newActiveSection!;
      });
      _scrollNavToActivePill(newActiveSection);
    }
  }

  void _scrollNavToActivePill(String categoryId) {
    final pillKey = _navPillKeys[categoryId];
    if (pillKey?.currentContext != null) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted && pillKey?.currentContext != null) {
          Scrollable.ensureVisible(
            pillKey!.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.5, // Center the pill
          );
        }
      });
    }
  }

  void _ensureKeys(List<dynamic> categories) {
    if (!_sectionKeys.containsKey('board')) {
      _sectionKeys['board'] = GlobalKey();
    }
    if (!_navPillKeys.containsKey('board')) {
      _navPillKeys['board'] = GlobalKey();
    }
    for (var category in categories) {
      if (!_sectionKeys.containsKey(category.id)) {
        _sectionKeys[category.id] = GlobalKey();
      }
      if (!_navPillKeys.containsKey(category.id)) {
        _navPillKeys[category.id] = GlobalKey();
      }
    }
  }

  void _scrollToSection(String id) {
    _isProgrammaticScroll = true;
    setState(() => _selectedCategoryId = id);

    final key = _sectionKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            alignment: 0.0,
          )
          .then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _isProgrammaticScroll = false;
              }
            });
          })
          .catchError((_) {
            // Re-enable even if scroll fails
            _isProgrammaticScroll = false;
          });
    } else {
      // If key not found, re-enable immediately
      _isProgrammaticScroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final categories = menuState.sortedCategories;

    // Get featured items from all categories using the new provider
    final List<Product> featured = [];
    for (final category in categories) {
      final featuredIds = ref.watch(featuredProductIdsProvider(category.id));
      final categoryProducts = menuState.getProductsByCategory(category.id);
      final categoryFeatured = categoryProducts
          .where((p) => featuredIds.contains(p.id))
          .toList();
      featured.addAll(categoryFeatured);
    }

    _ensureKeys(categories);

    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    // Check if we're on the last category (or board which counts as first)
    final isLastCategory =
        _selectedCategoryId != 'board' &&
        categories.isNotEmpty &&
        categories.last.id == _selectedCategoryId;

    return Column(
      children: [
        // Bento-style Nav Bar
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray300.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            height: 64,
            child: ListView(
              controller: _navScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                KioskExitButton(isVisible: isLastCategory),
                SizedBox(width: AppSpacing.sm),
                _NavPill(
                  key: _navPillKeys['board'],
                  label: "Chef's Board",
                  isSelected: _selectedCategoryId == 'board',
                  onTap: () => _scrollToSection('board'),
                ),
                VerticalDivider(
                  width: 32,
                  indent: 10,
                  endIndent: 10,
                  color: AppColors.gray300,
                ),
                ...categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: _NavPill(
                      key: _navPillKeys[category.id],
                      label: category.name,
                      isSelected: _selectedCategoryId == category.id,
                      onTap: () => _scrollToSection(category.id),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Continuous Scrollable Content
        Expanded(
          child: Container(
            color: AppColors.background,
            child: CustomScrollView(
              controller: _mainScrollController,
              slivers: [
                ..._buildBoardSection(featured),
                ...categories.expand((category) {
                  return _buildCategorySection(category);
                }),
                SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBoardSection(List<Product> featured) {
    return [
      // Anchor for scrolling
      SliverToBoxAdapter(
        key: _sectionKeys['board'],
        child: SizedBox(height: AppSpacing.sm),
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.black, AppColors.gray800],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chef's Selections",
                        style: AppTypography.h1.copyWith(
                          fontSize: 32,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Curated seasonal favorites and signature dishes selected just for you.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.gray600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
      if (featured.isNotEmpty) ...[
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          sliver: SliverToBoxAdapter(
            child: Text('Featured Highlights', style: AppTypography.h2),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5, // Wide cards
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _FeaturedCard(product: featured[index]);
            }, childCount: featured.length.clamp(0, 6)),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl * 2)),
      ],
    ];
  }

  List<Widget> _buildCategorySection(dynamic category) {
    final menuState = ref.watch(menuProvider);
    final hideFeatured = ref.watch(hideFeaturedFromMenuProvider);
    final products = menuState.getProductsByCategory(
      category.id,
      excludeFeatured: hideFeatured,
    );

    if (products.isEmpty) return [];

    return [
      // Anchor for scrolling - Invisible but necessary for ensureVisible
      SliverToBoxAdapter(
        key: _sectionKeys[category.id],
        child: SizedBox(height: AppSpacing.xl), // Spacing between categories
      ),

      // Category Title (Re-added per request)
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        sliver: SliverToBoxAdapter(
          child: Text(category.name, style: AppTypography.h2),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5, // Same wide card layout as Chef's Board
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return _FeaturedCard(product: products[index]);
          }, childCount: products.length),
        ),
      ),
    ];
  }
}

class _NavPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavPill({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: isSelected ? AppColors.white : AppColors.gray900,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Product product;

  const _FeaturedCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // Large fonts (approx 1.3x)
    final titleStyle = AppTypography.h3.copyWith(fontSize: 24); // Was 18
    final priceStyle = AppTypography.h3.copyWith(fontSize: 24); // Was 18

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsScreen(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // If no description, space out title and price to fill height better
                  mainAxisAlignment: product.description.isEmpty
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: titleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.description.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        product.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                    ],
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: priceStyle,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                  image: product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imageUrl == null
                    ? Center(
                        child: Icon(
                          Icons.restaurant,
                          color: AppColors.gray400,
                          size: 32,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
