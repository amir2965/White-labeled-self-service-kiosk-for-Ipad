import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import 'cart_sidebar_panel.dart';
import 'restaurant_menu_board_template.dart';

/// Template: Restaurant Menu Board + Cart Sidebar
/// Classic menu-board browsing with an always-visible checkout sidebar on the right.
class RestaurantMenuBoardWithCartTemplate extends ConsumerWidget {
  const RestaurantMenuBoardWithCartTemplate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LandscapeOnlyGuard(
      templateName: 'Restaurant Menu Board + Cart',
      child: Row(
        children: const [
          Expanded(child: RestaurantMenuBoardTemplate()),
          CartSidebarPanel(),
        ],
      ),
    );
  }
}
