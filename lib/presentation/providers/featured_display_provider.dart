import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../kiosk/menu_template_config.dart';
import 'template_provider.dart';
import 'merchant_provider.dart';

/// Provider to control whether featured items should be hidden from regular menu
final hideFeaturedFromMenuProvider = StateProvider<bool>((ref) => false);

/// Provider to store featured items per template
/// Map<MenuDisplayTemplate, Map<categoryId, List<productId>>>
final templateFeaturedItemsProvider =
    StateProvider<Map<MenuDisplayTemplate, Map<String, List<String>>>>(
      (ref) => {},
    );

/// Provider to get featured product IDs for current template and category
final featuredProductIdsProvider = Provider.family<List<String>, String>((
  ref,
  categoryId,
) {
  final selectedTemplate = ref.watch(selectedTemplateProvider);
  final merchantState = ref.watch(merchantProvider);
  final currentTemplate = selectedTemplate ?? merchantState.menuDisplayTemplate;

  final allFeaturedItems = ref.watch(templateFeaturedItemsProvider);
  final templateItems = allFeaturedItems[currentTemplate] ?? {};

  return templateItems[categoryId] ?? [];
});
