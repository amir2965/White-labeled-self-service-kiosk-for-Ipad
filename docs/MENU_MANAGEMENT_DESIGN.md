# Menu Management UI/UX Design Guide

## Design Philosophy
**Minimal • Modern • Semi-Luxury • Touch-First**

Generous white space, subtle depth, and professional typography.

---

## Main Screen Layout

### Landscape Mode (Primary)
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ← Menu Management              Demo Cafe            [👁 Preview]  [✓ Save] │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌──────────────────────────────────────┬───────────────────────────────────┤
│  │ [Coffee 13] [Tea 5] [Food 8] [⚙️]   │  Live Preview                     │
│  ├──────────────────────────────────────┤                                   │
│  │                                      │  ┌─────────────────────────────┐  │
│  │  ┌────────┐ ┌────────┐ ┌────────┐  │  │ Demo Cafe             🛒    │  │
│  │  │[image] │ │[image] │ │[image] │  │  ├─────────────────────────────┤  │
│  │  │        │ │        │ │        │  │  │ [Coffee][Tea][Food]         │  │
│  │  │⋮⋮ ✓    │ │⋮⋮      │ │⋮⋮      │  │  ├─────────────────────────────┤  │
│  │  │        │ │        │ │        │  │  │                             │  │
│  │  │Latte   │ │Cappucc │ │America │  │  │  ┌───┐ ┌───┐ ┌───┐        │  │
│  │  │$4.50   │ │$4.50   │ │$3.75   │  │  │  │img│ │img│ │img│        │  │
│  │  └────────┘ └────────┘ └────────┘  │  │  │$$ │ │$$ │ │$$ │        │  │
│  │                                      │  │  └───┘ └───┘ └───┘        │  │
│  │  ┌────────┐ ┌────────┐ ┌────────┐  │  │                             │  │
│  │  │[image] │ │[image] │ │  [+]   │  │  │                             │  │
│  │  │        │ │        │ │        │  │  │                             │  │
│  │  │⋮⋮      │ │⋮⋮      │ │  Add   │  │  └─────────────────────────────┘  │
│  │  │        │ │        │ │  Item  │  │                                   │
│  │  │Espresso│ │Cold B. │ │        │  │  Click items in preview to       │
│  │  │$3.50   │ │$4.75   │ │        │  │  select and edit                 │
│  │  └────────┘ └────────┘ └────────┘  │                                   │
│  │                                      │                                   │
│  └──────────────────────────────────────┴───────────────────────────────────┤
└─────────────────────────────────────────────────────────────────────────────┘
```

### With Editor Panel Active
```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ← Menu Management              Demo Cafe            [Preview Off]  [✓ Save] │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌──────────────────────────────────────┬───────────────────────────────────┤
│  │ [Coffee 13] [Tea 5] [Food 8] [⚙️]   │  ✏️ Edit Item            🗑️      │
│  ├──────────────────────────────────────┼───────────────────────────────────┤
│  │                                      │                                   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐  │  ┌─────────────────────────────┐  │
│  │  │[image] │ │[image] │ │[image] │  │  │      Item Image             │  │
│  │  │        │ │        │ │        │  │  │  ┌─────────────────────┐    │  │
│  │  │⋮⋮ ✓    │ │⋮⋮      │ │⋮⋮      │  │  │  │                     │    │  │
│  │  │        │ │        │ │        │  │  │  │   [Product Photo]   │    │  │
│  │  │Latte   │ │Cappucc │ │America │  │  │  │   [Change Image]    │    │  │
│  │  │$4.50   │ │$4.50   │ │$3.75   │  │  │  │                     │    │  │
│  │  └────────┘ └────────┘ └────────┘  │  │  └─────────────────────┘    │  │
│  │    SELECTED                          │  │  [📷 Gallery][📸 Camera]   │  │
│  │  ┌────────┐ ┌────────┐ ┌────────┐  │  └─────────────────────────────┘  │
│  │  │[image] │ │[image] │ │  [+]   │  │                                   │
│  │  │        │ │        │ │        │  │  🏷️ Name                          │
│  │  │⋮⋮      │ │⋮⋮      │ │  Add   │  │  ┌─────────────────────────────┐  │
│  │  │        │ │        │ │  Item  │  │  │ Latte                       │  │
│  │  │Espresso│ │Cold B. │ │        │  │  └─────────────────────────────┘  │
│  │  │$3.50   │ │$4.75   │ │        │  │                                   │
│  │  └────────┘ └────────┘ └────────┘  │  📝 Description                   │
│  │                                      │  ┌─────────────────────────────┐  │
│  └──────────────────────────────────────┤  │ Smooth espresso with        │  │
                                             │ steamed milk and velvety    │  │
                                             │ microfoam                   │  │
                                             └─────────────────────────────┘  │
                                                                               │
                                             💰 Price                          │
                                             ┌─────────────────────────────┐  │
                                             │ 4.50                        │  │
                                             └─────────────────────────────┘  │
                                                                               │
                                             👁️ Availability                   │
                                             Visible to customers      [ON] │  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Component Details

### Product Card
```
┌──────────────────┐
│  ┌────────────┐  │  ← 140px height image
│  │            │  │
│  │  [Image]   │  │
│  │            │  │  ⋮⋮ = Drag handle (top right)
│  │    ⋮⋮      │  │  ✓ = Selected indicator (top left, blue)
│  │            │  │
│  └────────────┘  │
│                  │
│  Latte           │  ← 16px bold, 2 lines max
│  Smooth espresso │  ← 12px regular, gray, 2 lines
│  with steamed... │
│                  │
│  $4.50    Hidden │  ← Price (blue, bold) + Status badge
└──────────────────┘

States:
- Default: 1px gray border, subtle shadow
- Selected: 2px blue border, elevated shadow
- Hover: Border color darkens slightly
```

### Add Item Card
```
┌──────────────────┐
│                  │
│                  │
│      ┌───┐      │  ← Blue circle with +
│      │ + │      │
│      └───┘      │
│                  │
│    Add Item     │  ← Blue text
│                  │
│                  │
└──────────────────┘

Style:
- 2px dashed blue border
- Transparent background
- Centered content
- Same size as product cards
```

### Category Tabs
```
┌────────────────────────────────────────────────────────────┐
│  [Coffee 13] [Tea 5] [Food 8] [Pastries 5] [⚙️]           │
│   ^^^^^^^^                                                  │
│   SELECTED (blue bg, white text)                           │
│             ^^^^^^^^                                        │
│             DEFAULT (white bg, black text, gray border)    │
└────────────────────────────────────────────────────────────┘

Tab Style:
- 10px border radius
- 12px horizontal padding, 8px vertical
- Badge shows item count (6px padding, 6px radius)
- Gear icon for category management (settings button)
```

### Image Editor Dialog
```
┌───────────────────────────────────────────────┐
│  🖼️ Adjust Image                        ✕    │
├───────────────────────────────────────────────┤
│                                               │
│   ┌─────────────────────────────────────┐    │
│   │                                     │    │
│   │                                     │    │
│   │        [Product Photo]              │    │  ← Pinch & drag area
│   │     (pinch zoom, drag move)         │    │
│   │                                     │    │
│   │                                     │    │
│   └─────────────────────────────────────┘    │
│                                               │
│   🔍─ ────────────●────────── 🔍+            │  ← Zoom slider (1x to 4x)
│                                               │
│   Pinch to zoom • Drag to reposition         │  ← Instructions
│                                               │
│   [     Reset     ] [  Save Changes  ]       │  ← Action buttons
│                                               │
└───────────────────────────────────────────────┘
```

### Category Manager Dialog
```
┌──────────────────────────────────────────────┐
│  📁 Manage Categories                  ✕    │
├──────────────────────────────────────────────┤
│                                              │
│  ┌───────────────────────────┐ [+ Add]      │  ← Add category form
│  │ New category name...      │              │
│  └───────────────────────────┘              │
│                                              │
├──────────────────────────────────────────────┤
│                                              │
│  ⋮⋮ Coffee                       ✏️ 🗑️      │  ← Reorderable list
│     13 items                                 │
│                                              │
│  ⋮⋮ Tea                          ✏️ 🗑️      │
│     5 items                                  │
│                                              │
│  ⋮⋮ Food                         ✏️ 🗑️      │
│     8 items                                  │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Color Palette

### Primary Colors
```css
Blue:       #007AFF  /* Primary actions */
Black:      #000000  /* Text and icons */
White:      #FFFFFF  /* Cards and backgrounds */
```

### Neutral Grays
```css
Background: #F8F9FA  /* Page background */
Border:     rgba(0,0,0,0.15)  /* Default borders */
Gray Text:  #666666  /* Secondary text */
```

### Semantic Colors
```css
Success:    #34C759  /* Availability ON */
Warning:    #FF9500  /* Low stock */
Danger:     #FF3B30  /* Delete actions */
```

---

## Typography Scale

### Headers
```css
h1: 24px, Bold, -0.5px letter-spacing
h2: 20px, Bold, -0.3px letter-spacing  
h3: 18px, Bold, normal letter-spacing
```

### Body Text
```css
Large:  16px, Medium, normal line-height
Medium: 14px, Regular, 1.4 line-height
Small:  12px, Regular, 1.3 line-height
```

### Special
```css
Price:    16px, Bold, Blue color
Caption:  12px, Regular, Gray color
Badge:    10px, SemiBold, Uppercase
```

---

## Spacing System

### Base Unit: 8px
```
xs:  4px   (0.5 × base)
sm:  8px   (1   × base)
md:  16px  (2   × base)
lg:  24px  (3   × base)
xl:  32px  (4   × base)
xxl: 48px  (6   × base)
```

### Component Spacing
```
Card padding:     12px (md - 4px)
Grid gap:         12px
Section margin:   24px (lg)
Screen padding:   32px (xl)
```

---

## Shadows

### Elevation System
```css
/* Level 1 - Default cards */
shadow-sm: 0 2px 8px rgba(0,0,0,0.04)

/* Level 2 - Selected/Hover */
shadow-md: 0 4px 12px rgba(0,122,255,0.15)

/* Level 3 - Dialogs */
shadow-lg: 0 8px 24px rgba(0,0,0,0.12)
```

---

## Animations

### Transitions
```css
Fast:     150ms ease-out  /* Button press */
Standard: 250ms ease-out  /* State changes */
Slow:     350ms ease-out  /* Dialogs */
```

### Easing Curves
```css
ease-out:     cubic-bezier(0, 0, 0.2, 1)
ease-in-out:  cubic-bezier(0.4, 0, 0.2, 1)
spring:       cubic-bezier(0.34, 1.56, 0.64, 1)
```

---

## Touch Targets

### Minimum Sizes
```
Button:       48×48px
Icon button:  44×44px
Card:         Minimum 120px width
Drag handle:  32×32px hit area
```

### Feedback
- **Tap**: Opacity 0.7 for 150ms
- **Press**: Scale 0.98 with shadow increase
- **Drag**: Lift with elevated shadow
- **Selected**: Blue border + shadow

---

## Responsive Breakpoints

### Landscape (Primary)
```
Width:  1024px - 1366px (iPad Pro)
Layout: Split view 50/50
Grid:   3 columns
```

### Portrait (Secondary)
```
Width:  768px - 834px (iPad)
Layout: Stacked (items above, editor below)
Grid:   2 columns
```

---

## Accessibility

### Color Contrast
- Text on white: Minimum 4.5:1 ratio
- Blue on white: 7:1 ratio (WCAG AAA)
- Gray text: 3:1 ratio (large text only)

### Focus States
- Blue outline: 2px solid #007AFF
- Offset: 2px from element edge
- Visible on keyboard navigation

### Touch Areas
- Minimum: 44×44px (Apple HIG)
- Recommended: 48×48px (Material Design)
- Spacing: 8px between interactive elements

---

## State Indicators

### Product States
```
Available:    No indicator, full opacity
Unavailable:  "Hidden" badge, reduced opacity
Selected:     Blue border, checkmark icon
Dragging:     Elevated shadow, 0.95 opacity
```

### Loading States
```
Shimmer:     Gray gradient animation
Spinner:     Blue circular progress
Skeleton:    Placeholder boxes with pulse
```

### Error States
```
Border:      Red (#FF3B30)
Icon:        ⚠️ warning triangle
Message:     Below field, red text
```

---

## Best Practices

### DO ✅
- Use generous white space (24px minimum between sections)
- Keep actions visible and accessible
- Show clear visual feedback for all interactions
- Use consistent border radius (12px for cards, 8px for buttons)
- Maintain 3:1 contrast ratio minimum
- Provide undo for destructive actions

### DON'T ❌
- Overcrowd the interface with too many elements
- Hide critical actions behind menus
- Use more than 3 font sizes in one view
- Make touch targets smaller than 44px
- Use pure black (#000) for body text
- Auto-save without user confirmation

---

**Design System Version**: 1.0  
**Last Updated**: January 2026  
**Design Tool**: Figma (Future)
