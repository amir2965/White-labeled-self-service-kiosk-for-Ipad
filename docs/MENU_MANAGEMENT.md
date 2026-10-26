# Menu Management System

## Overview
Complete menu management interface with live template preview, inline editing, and drag-to-reorder functionality optimized for iPad.

## Features

### 🎯 Core Capabilities
- **Split View Layout**: Menu items grid on left, live preview or editor on right
- **Live Template Preview**: See changes in your chosen template in real-time
- **Inline Editing**: Click any item to edit name, description, price, and availability
- **Image Management**: Upload from gallery/camera, adjust position and zoom
- **Drag-to-Reorder**: Reorder products within categories and categories themselves
- **Add/Remove Items**: Quick add button on grid, delete confirmation dialogs
- **Category Management**: Add, edit, delete, and reorder categories

### 🎨 Design Highlights
- **Minimal & Modern**: Clean interface
- **Semi-Luxury Feel**: Subtle shadows, smooth animations, premium spacing
- **Responsive**: Optimized for iPad landscape and portrait modes
- **Touch-Optimized**: Large hit areas, clear visual feedback

## Navigation

### From Dashboard
Click **"Menu & Items"** in the admin action grid → Opens Menu Management Screen

### Route
`/menu-management`

## User Flow

### 1. View Menu Items
```
┌─────────────────────────────────────────────────────────┐
│  Menu Management                          [Preview] [Save] │
├────────────────────┬───────────────────────────────────────┤
│ [Coffee] [Tea]     │                                       │
│ [Food] [+]         │  Live Template Preview                │
│                    │                                       │
│ ┌─────┬─────┬─────┤  Shows menu in selected template     │
│ │Item │Item │Item │  Click items in preview to select     │
│ │$4.50│$3.75│$5.00│                                       │
│ └─────┴─────┴─────┤                                       │
│                    │                                       │
└────────────────────┴───────────────────────────────────────┘
```

### 2. Edit Item
- Click any product card in the grid
- Editor panel appears on right side
- Edit fields update product instantly
- Changes reflect in preview panel

### 3. Manage Images
- **Upload**: Click image area → Choose gallery/camera
- **Adjust**: Click "Adjust" → Pinch to zoom, drag to reposition
- **Remove**: Long press image → Remove option

### 4. Reorder Items
- Drag the drag handle icon (⋮⋮) on any product card
- Drop in new position
- Order updates immediately

### 5. Add/Remove
- **Add Item**: Click the "+" card at end of grid
- **Remove Item**: Select item → Click trash icon in editor
- **Add Category**: Click gear icon next to category tabs
- **Manage Categories**: Reorder, edit names, or delete

## Components

### Main Screen
**File**: `menu_management_screen.dart`
- Split view controller
- Category tabs with item counts
- Reorderable grid with 3 columns
- Toggle between preview and editor modes

### Item Editor
**File**: `menu_item_editor.dart`
- Name, description, price fields
- Image upload and management
- Availability toggle
- Modifier groups section
- Delete confirmation

### Image Editor
**File**: `image_editor_dialog.dart`
- Pinch to zoom (1x to 4x)
- Drag to reposition
- Zoom slider control
- Reset and save actions

### Category Manager
**File**: `category_manager.dart`
- Add new categories
- Rename existing ones
- Delete with item count warning
- Drag-to-reorder list

### Template Preview
**File**: `template_preview_panel.dart`
- Live preview at 70% scale
- Shows current template layout
- Click items to select
- Category navigation

## Menu Provider Methods

### Categories
```dart
void addCategory(String name)
void updateCategory(String categoryId, String newName)
void deleteCategory(String categoryId)
void reorderCategories(int oldIndex, int newIndex)
```

### Products
```dart
void addProduct({String categoryId, String name, double price})
void updateProduct(Product updatedProduct)
void deleteProduct(String productId)
void reorderProducts(String categoryId, int oldIndex, int newIndex)
```

## State Management

### Product Updates
- Updates flow through MenuNotifier
- State changes trigger UI rebuild
- Preview panel reflects changes instantly
- All edits local until "Save Changes" clicked

### Persistence
Currently in-memory only. Production implementation should:
1. Debounce updates to reduce API calls
2. Show unsaved changes indicator
3. Sync to backend on "Save Changes"
4. Handle offline editing with queue

## Responsive Behavior

### Landscape Mode (iPad)
- 50/50 split: Items grid | Preview/Editor
- 3-column product grid
- Full-width category tabs

### Portrait Mode (iPad)
- Stacked layout: Items grid above
- Editor slides up from bottom when item selected
- 2-column product grid

## Design Tokens

### Colors
- Primary: `#007AFF` (Blue)
- Background: `#F8F9FA` (Light Gray)
- Cards: `#FFFFFF` (White)
- Selected Border: `#007AFF` with 2px width
- Default Border: `rgba(0,0,0,0.15)` with 1px width

### Spacing
- Grid gaps: `12px`
- Card padding: `12px`
- Section padding: `16px`
- Large padding: `24px`

### Shadows
- Default: `rgba(0,0,0,0.04)` blur `8px` offset `(0,2)`
- Selected: `rgba(0,122,255,0.15)` blur `12px` offset `(0,4)`

### Typography
- Headers: `18px` bold
- Body: `14px` medium
- Captions: `12px` regular
- Font: System default (San Francisco on iOS)

## Touch Interactions

### Product Cards
- **Tap**: Select for editing
- **Drag**: Reorder within category
- Visual feedback: Border color change, shadow elevation

### Image Area
- **Tap**: Open image options menu
- **Pinch**: Zoom in editor dialog
- **Drag**: Reposition in editor dialog

### Category Tabs
- **Tap**: Switch category
- **Horizontal Scroll**: Access more categories
- Selected state: Blue background, white text

## Future Enhancements

### Phase 2 Features
- [ ] Bulk edit mode (select multiple items)
- [ ] Duplicate product function
- [ ] Import/export menu CSV
- [ ] Advanced modifier builder with nested groups
- [ ] Image cropping with preset aspect ratios
- [ ] Undo/redo stack
- [ ] Search and filter products
- [ ] Product variants (sizes, colors)

### Phase 3 Features
- [ ] AI-powered image background removal
- [ ] Automatic product suggestions
- [ ] Menu analytics (popular items, slow movers)
- [ ] Schedule-based availability
- [ ] Multi-location menu sync
- [ ] Version history and rollback

## Dependencies

```yaml
reorderable_grid_view: ^2.2.8  # Drag-to-reorder grid
image_picker: ^1.0.7           # Camera/gallery access
```

## Testing Checklist

- [ ] Add product to empty category
- [ ] Edit product name, description, price
- [ ] Upload image from gallery
- [ ] Upload image from camera
- [ ] Adjust image position and zoom
- [ ] Remove image
- [ ] Toggle product availability
- [ ] Reorder products within category
- [ ] Reorder across 3+ items (edge cases)
- [ ] Delete product with confirmation
- [ ] Add new category
- [ ] Rename category
- [ ] Delete category with items
- [ ] Reorder categories
- [ ] Switch between categories
- [ ] Toggle preview mode on/off
- [ ] Click items in preview to select
- [ ] Save changes (shows confirmation)
- [ ] Landscape to portrait rotation
- [ ] Navigate back to dashboard

## Known Limitations

1. **Image Storage**: Currently uses local paths. Production needs cloud storage (AWS S3, Cloudflare R2).
2. **Offline Mode**: No offline queue yet. Changes lost if app closes before save.
3. **Modifiers**: Editor shows list but full modifier management dialog not implemented.
4. **Undo/Redo**: No action history stack.
5. **Image Cropping**: Zoom and pan only, no crop tool.

## Production Integration

### Backend API Requirements
```typescript
// Products
POST   /api/merchants/{id}/products
PUT    /api/merchants/{id}/products/{productId}
DELETE /api/merchants/{id}/products/{productId}
PATCH  /api/merchants/{id}/products/reorder

// Categories
POST   /api/merchants/{id}/categories
PUT    /api/merchants/{id}/categories/{categoryId}
DELETE /api/merchants/{id}/categories/{categoryId}
PATCH  /api/merchants/{id}/categories/reorder

// Images
POST   /api/merchants/{id}/images/upload
```

### Image Upload Flow
1. User selects image → `image_picker` returns XFile
2. Compress image (max 1024px, 85% quality)
3. Upload to storage service → Get CDN URL
4. Update product with `imageUrl`
5. Show optimized thumbnail in grid

### State Persistence
```dart
// On save
final changes = ref.read(menuProvider.notifier).getChanges();
await api.syncMenu(merchantId, changes);
ref.read(menuProvider.notifier).markSaved();

// On load
final menu = await api.getMenu(merchantId);
ref.read(menuProvider.notifier).loadFromServer(menu);
```

## Accessibility

- [ ] Semantic labels on all interactive elements
- [ ] Keyboard navigation support (for desktop web)
- [ ] High contrast mode compatibility
- [ ] Screen reader announcements for state changes
- [ ] Focus indicators on selected items

---

**Version**: 1.0.0  
**Last Updated**: January 2026  
**Platform**: Flutter 3.8+, iPad/Android Tablets
