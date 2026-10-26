# Featured Items Issue - Diagnosis and Fix

## Issue Description
When opening the customization sidebar for any template, the featured items section displayed MORE items than the template's maximum allowed, typically showing 4 featured items from EVERY category regardless of the template's actual requirements.

## Root Causes

### 1. **Backward Compatibility Check Reading Polluted Data**
- The `_loadCurrentFeaturedItems()` method checked `product.isFeatured` flags for "backward compatibility"
- These flags contained featured items from OTHER templates that had been previously selected
- When switching between templates, the old featured flags contaminated the new template's featured items
- **Location**: Lines 121-135 in template_customization_screen.dart

### 2. **Applying Defaults to ALL Categories**
- The `_getDefaultFeaturedItems()` method looped through ALL categories and applied defaults to each one
- Most templates only feature items from ONE or TWO categories, not all of them
- This resulted in 3-4 featured items appearing in every single category
- **Location**: Original implementation looped `for (final category in categories)`

### 3. **Not Respecting Template-Specific Limits**
- The code didn't properly enforce the maximum number of featured items per template
- Templates like "Restaurant Spotlight" allow only 1 featured item, but defaults were applying 3-4 items
- The validation only happened on save, not on load

## The Professional Fix

### Changes Made

#### 1. Removed Backward Compatibility Check ✅
**File**: `template_customization_screen.dart` lines 95-145

**Before**:
```dart
// Check if products have featured flags (for backward compatibility)
bool hasAnyFeatured = false;
for (final category in categories) {
  final products = menuState.getProductsByCategory(category.id);
  final featured = products
      .where((p) => p.isFeatured)  // ❌ Reading polluted data
      .map((p) => p.id)
      .toList();
  if (featured.isNotEmpty && !templateChanged) {
    featuredMap[category.id] = featured;
    hasAnyFeatured = true;
  }
}
```

**After**:
```dart
// ALWAYS load from template-specific storage, never from product flags
Map<String, List<String>> featuredMap = {};

if (_templateFeaturedItems.containsKey(actualTemplate)) {
  // Load saved featured items for this template
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
```

#### 2. Smart Defaults - First Category Only ✅
**File**: `template_customization_screen.dart` lines 147-185

**Before**:
```dart
Map<String, List<String>> _getDefaultFeaturedItems(...) {
  final Map<String, List<String>> featuredMap = {};
  
  for (final category in categories) {  // ❌ ALL categories
    final products = menuState.getProductsByCategory(category.id);
    
    if (template == MenuDisplayTemplate.coffeeBaristaFlow) {
      if (products.length >= 4) {
        featuredMap[category.id] = products.take(4).map((p) => p.id).toList();
      }
    }
    // ... repeated for every category
  }
  
  return featuredMap;
}
```

**After**:
```dart
Map<String, List<String>> _getDefaultFeaturedItems(...) {
  final Map<String, List<String>> featuredMap = {};
  
  // Apply defaults ONLY for the first category to avoid overwhelming the user
  if (categories.isEmpty) return featuredMap;
  
  final firstCategory = categories.first;  // ✅ Only first category
  final products = menuState.getProductsByCategory(firstCategory.id);
  
  if (products.isEmpty) return featuredMap;
  
  // Apply template-specific defaults for FIRST CATEGORY ONLY
  if (template == MenuDisplayTemplate.coffeeBaristaFlow ||
      template == MenuDisplayTemplate.chefSpecialsBoard) {
    final count = products.length >= 4 ? 4 : products.length;  // ✅ Respect max
    featuredMap[firstCategory.id] = products.take(count).map((p) => p.id).toList();
  } else if (template == MenuDisplayTemplate.restaurantSpotlightWithCart) {
    featuredMap[firstCategory.id] = [products.first.id];  // ✅ Only 1 item
  } else {
    final count = products.length >= 3 ? 3 : products.length;
    featuredMap[firstCategory.id] = products.take(count).map((p) => p.id).toList();
  }
  
  return featuredMap;
}
```

#### 3. Restored Provider Infrastructure ✅
**File**: `featured_display_provider.dart`

The `templateFeaturedItemsProvider` was accidentally removed. Restored with:
```dart
/// Provider to store featured items per template
final templateFeaturedItemsProvider = StateProvider<Map<MenuDisplayTemplate, Map<String, List<String>>>>((ref) => {});

/// Provider to get featured product IDs for current template and category
final featuredProductIdsProvider = Provider.family<List<String>, String>((ref, categoryId) {
  final selectedTemplate = ref.watch(selectedTemplateProvider);
  final merchantState = ref.watch(merchantProvider);
  final currentTemplate = selectedTemplate ?? merchantState.menuDisplayTemplate;
  
  final allFeaturedItems = ref.watch(templateFeaturedItemsProvider);
  final templateItems = allFeaturedItems[currentTemplate] ?? {};
  
  return templateItems[categoryId] ?? [];
});
```

## Technical Benefits

### 1. **Template Isolation** 🔒
- Each template now has completely separate featured items storage
- Switching templates no longer pollutes featured item selections
- Clean separation of concerns

### 2. **Conservative Defaults** 🎯
- Only applies defaults to the FIRST category on initial load
- Users can add more featured items as needed
- Prevents overwhelming the UI with too many featured items

### 3. **Template-Specific Limits** ✅
- Coffee Barista Flow / Chef's Specials: max 4 items
- Bento Highlights: max 5 items, min 2 items
- Restaurant Spotlight: exactly 1 item
- Other templates: max 3 items

### 4. **No Product Pollution** 🧹
- Never writes to `product.isFeatured` flags
- All featured state managed through `templateFeaturedItemsProvider`
- Products remain clean and reusable across templates

## Testing Checklist

- [x] Open Coffee Barista Flow → Customize → Should show 4 items from first category only
- [x] Switch to Restaurant Spotlight → Should show 1 item from first category only
- [x] Add featured items to multiple categories → Should save per template
- [x] Switch back to Coffee Barista Flow → Should retain original selections
- [x] Switch to Category Sidebar → Should NOT show Coffee Barista Flow's featured items

## Future Improvements

1. **Template Migration**: Update all template files to read from `featuredProductIdsProvider` instead of `product.isFeatured`
2. **Cleanup Utility**: Add a button to clear all legacy `product.isFeatured` flags
3. **Visual Feedback**: Show which category has featured items in the customization panel
4. **Bulk Actions**: Allow users to clear all featured items for current template

## Files Modified

1. ✅ `lib/presentation/menu_management/template_customization_screen.dart`
   - Removed backward compatibility check (lines 95-145)
   - Updated `_getDefaultFeaturedItems()` to only use first category (lines 147-185)

2. ✅ `lib/presentation/providers/featured_display_provider.dart`
   - Restored `templateFeaturedItemsProvider`
   - Restored `featuredProductIdsProvider` family provider

## Summary

This fix ensures that:
- ✅ Featured items are isolated per template
- ✅ Defaults are conservative (first category only)
- ✅ Template limits are respected
- ✅ No cross-contamination between templates
- ✅ Clean, maintainable code structure

The customization sidebar will now show only the featured items that are actually configured for the current template, with sensible defaults applied only on first load.
