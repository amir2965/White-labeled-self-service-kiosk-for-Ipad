# Quick Start: Menu Management

## Setup Complete ✅

The complete menu management system is now ready to use!

## What Was Built

### 1. Main Screen (`menu_management_screen.dart`)
- Split-view layout with items grid and live preview
- Category tabs with item counts
- Drag-to-reorder grid (3 columns)
- Add item quick action
- Toggle between preview and editor modes

### 2. Item Editor (`menu_item_editor.dart`)  
- Name, description, price editing
- Image upload from gallery/camera
- Image adjustment dialog
- Availability toggle
- Modifiers section placeholder
- Delete with confirmation

### 3. Image Editor (`image_editor_dialog.dart`)
- Pinch-to-zoom (1x to 4x)
- Drag to reposition
- Zoom slider
- Reset and save actions

### 4. Category Manager (`category_manager.dart`)
- Add new categories
- Edit category names
- Delete with item count warning
- Drag-to-reorder categories

### 5. Template Preview (`template_preview_panel.dart`)
- Live preview at 70% scale
- Shows selected template
- Click items to select

### 6. Menu Provider Extensions
Added CRUD methods to `menu_provider.dart`:
- `addCategory()`, `updateCategory()`, `deleteCategory()`, `reorderCategories()`
- `addProduct()`, `updateProduct()`, `deleteProduct()`, `reorderProducts()`

### 7. Merchant Provider (NEW)
Created `merchant_provider.dart` for business settings

## How to Test

### 1. Run the App
```bash
flutter run -d chrome --web-port=8080
# OR
flutter run -d <your-device-id>
```

### 2. Navigate to Menu Management
1. App opens at Dashboard (`/dashboard`)
2. Click **"Menu & Items"** tile in admin actions
3. Menu Management screen opens

### 3. Try These Actions

#### Edit an Item
1. Click any product card in the grid
2. Editor panel appears on right
3. Change name → Updates instantly
4. Change price → Updates instantly
5. Toggle availability → Shows/hides item

#### Upload Image
1. Select an item
2. Click image area in editor
3. Choose "Gallery" or "Camera"
4. Click "Adjust" to reposition/zoom
5. Save changes

#### Reorder Products
1. Drag the ⋮⋮ handle on any card
2. Drop in new position
3. Order updates immediately

#### Add New Item
1. Click the **[+]** card at end of grid
2. New item appears with default name
3. Select and edit immediately

#### Manage Categories
1. Click the ⚙️ gear icon next to category tabs
2. Add new category or reorder existing
3. Delete category (shows item count warning)

#### Toggle Preview
1. Click **"Preview"** button in header
2. Preview panel shows live template view
3. Click items in preview to select them
4. Toggle off to show editor panel

### 4. Test Responsive Layouts

#### Landscape Mode
- Split view: 50% items, 50% preview
- 3-column grid
- Full navigation

#### Portrait Mode  
- Stacked: Items above, editor below
- 2-column grid
- Editor slides up when item selected

## Known Issues (Expected)

1. **Images not loading**: Using placeholder URLs from Unsplash
2. **Modifiers editor**: Shows list but full editor not implemented yet
3. **Save button**: Shows confirmation but doesn't persist (in-memory only)
4. **Template preview**: Shows default layout, not actual template

## Next Steps

### Immediate Improvements
- [ ] Connect to real backend API
- [ ] Implement image upload to cloud storage
- [ ] Add full modifier group editor
- [ ] Persist changes to database
- [ ] Add undo/redo functionality

### Future Enhancements
- [ ] Bulk edit mode
- [ ] Duplicate product
- [ ] Import/export CSV
- [ ] Search and filter
- [ ] Product variants

## File Structure

```
lib/presentation/menu_management/
├── menu_management_screen.dart       # Main controller
└── widgets/
    ├── menu_item_editor.dart        # Edit panel
    ├── image_editor_dialog.dart     # Image adjuster
    ├── category_manager.dart        # Category CRUD
    └── template_preview_panel.dart  # Live preview
```

## Dependencies Added

```yaml
reorderable_grid_view: ^2.2.8  # Drag-to-reorder
image_picker: ^1.0.7           # Camera/gallery
```

## Routes Added

```dart
GoRoute(
  path: '/menu-management',
  builder: (context, state) => const MenuManagementScreen(),
)
```

## Dashboard Integration

Updated `merchant_dashboard_screen.dart`:
```dart
case 'menu':
  context.push('/menu-management');  // ✅ Now routes to menu management
  break;
```

## Documentation

- **Full Guide**: `docs/MENU_MANAGEMENT.md`
- **Design System**: `docs/MENU_MANAGEMENT_DESIGN.md`

## Troubleshooting

### Build Errors
```bash
flutter pub get
flutter clean
flutter pub get
flutter run
```

### Dependencies Missing
```bash
flutter pub add reorderable_grid_view
flutter pub add image_picker
```

### Import Errors
All providers are now in `lib/presentation/providers/`:
- `menu_provider.dart`
- `merchant_provider.dart`

## Demo Flow

1. **Start**: Dashboard shows "Menu & Items" tile
2. **Click**: Opens Menu Management with demo products
3. **Select**: Click "Latte" card
4. **Edit**: Change name to "Vanilla Latte"
5. **Price**: Update price to $5.50
6. **Image**: Click image, choose "Adjust"
7. **Zoom**: Pinch or slide to 2x zoom
8. **Save**: Click "Save Changes" in image editor
9. **Reorder**: Drag Latte to first position
10. **Add**: Click [+] card, add "Matcha"
11. **Category**: Click ⚙️, add "Specials" category
12. **Preview**: Toggle preview to see in template
13. **Save**: Click "Save Changes" in header

---

**Everything is ready to test! 🚀**

Run the app and click "Menu & Items" from the dashboard to start exploring the menu management system.
