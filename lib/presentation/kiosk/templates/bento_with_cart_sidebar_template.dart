import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/landscape_only_guard.dart';
import 'bento_highlights_template.dart';
import 'cart_sidebar_panel.dart';
import '../widgets/kiosk_exit_button.dart';

/// Template: Bento Highlights + Cart Sidebar
/// Bento highlight tiles and grid with an always-visible checkout sidebar on the right.
class BentoWithCartSidebarTemplate extends ConsumerWidget {
  const BentoWithCartSidebarTemplate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LandscapeOnlyGuard(
      templateName: 'Bento Highlights + Cart',
      child: Row(
        children: const [
          Expanded(child: BentoHighlightsTemplate()),
          CartSidebarPanel(),
        ],
      ),
    );
  }
}
